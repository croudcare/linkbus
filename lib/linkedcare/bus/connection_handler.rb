module Linkedcare
  module Bus

    class ConnectionHandler

      attr_accessor :connection
      
      def initialize(session)
        @connection = session
        @bus = Linkedcare::Configurable.amqp.bus
      end

      def setup
        Linkedcare::Logging.info("Setting up subscribers")
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
        Linkedcare::Logging.info("Registering subscriber to Topic Exchange [ #{@bus} ], Subscriber #{subscriber}")
        
        channel.queue(subscriber.queue, :durable => true) do | queue |
          bind(queue,exchange, subscriber.key)
          subscribe(queue, subscriber)
        end
      end

      def bind(queue, exchange, key)
        queue.bind(exchange, :routing_key => key)
      end

      def subscribe(queue, subscriber)
        queue.subscribe(:ack => true) do |meta, data|
          Linkedcare::Logging.info("Message Received: [ #{ message } ], Meta: [ #{ meta } ], Subscriber: #{ subscriber }")
          subscriber.handler.call(meta, data)
          meta.ack
        end
      end
    end
  end
end