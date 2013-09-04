module Linkedcare
  module Bus

    class ConnectionHandler

      attr_accessor :connection
      
      def initialize(session)
        @connection = session
        @bus = Linkedcare::Bus::Configurable.amqp.bus
      end

      def setup
        register_subscribers
      end

      private
      def register_subscribers
        manager = Linkedcare::Bus::Subscribers.manager
        manager.subscribers.each do |key, val|
          val.each do |subscriber|
            register(::AMQP::Channel.new(connection), subscriber)
          end
        end
      end

      def register(channel, subscriber)
        exchange = channel.topic(@bus, :durable => true)
        
        channel.queue(subscriber.queue, :durable => true) do |queue|
          bind(queue,exchange, subscriber.key)
          subscribe(queue, subscriber)
        end
      end

      def bind(queue, exchange, key)
        queue.bind(exchange, :routing_key => key)
      end

      def subscribe(queue, subscriber)
        queue.subscribe(:ack => true) do |meta, data|
          subscriber.handler.call(meta, data)
          meta.ack
        end
      end
    end
  end
end