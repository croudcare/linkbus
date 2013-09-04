module Linkedcare
  module Bus
    class Publisher

      def self.publish(message, key)
        new.publish(message, key)
      end
      
      def initialize
        @config = Linkedcare::Bus::Configurable.amqp
      end

      def publish(message, key)
        raise ArgumentError, "key cannot be nil" if key.nil?
        with_exchange do |topic| 
          topic.publish(message, :routing_key => key)
        end
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







