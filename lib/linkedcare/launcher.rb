module Linkedcare
  module Launcher
    
    def start
      Linkedcare::Logging.info("Launching Linkbus")
      AMQP.start(Linkedcare::Bus::Configurable.amqp_options) do |connection|
        
        Linkedcare::Logging.info("Connection stabilished with Broker")
        Linkedcare::Bus::ConnectionHandler.new(connection).setup
        
        Signal.trap("INT")  do
          Linkedcare::Logging.info("Disconnecting from Broker")
          AMQP.stop do
            Linkedcare::Logging.info("Disconnected") 
            EventMachine.stop
          end  
        end

      end
    end

    extend self
  end
end