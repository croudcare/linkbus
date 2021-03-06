module Linkedcare
  module Bus
    class Publisher
      include Linkedcare::Logging

      def self.publish(message, key)
        new.publish(message, key)
      end
      
      attr_accessor :errors
      def initialize
        Linkedcare::Configuration.setup?
        @config = Linkedcare::Configuration.amqp
        @errors = []
      end

      def publish(message, key)
        log_info("Publishing message [ #{message} ], key: [ #{key} ]")
        raise ArgumentError, "key cannot be nil" if key.nil?
        with_exchange do |topic| 
          topic.publish(message, :routing_key => key)
        end
        return true
        rescue StandardError => e
          errors.push(e)
          log_fatal("Publishing message [ #{message} ], key: [ #{key} ]", e )
          return false
      end

      private

      def with_exchange(&block)
        connection = Bunny.new(:host => @config.host, :user => @config.user, :password => @config.password, :vhost => @config.vhost)
        connection.start
        block.call( topic(connection) ) if block_given?
      ensure
        connection.close
      end

      def topic(connection)
        channel  = connection.create_channel
        exchange = channel.topic(@config.bus, :durable => true)
      end
    end
  end
end







