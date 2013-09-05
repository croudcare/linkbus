module Linkedcare
  module Launcher
    
    def start
      Linkedcare::Logging.info("Launching Linkbus EM")
      EM.run do 
        AMQP.connect(Linkedcare::Configurable.amqp_options) do |connection|
          connection_handler(connection)
        end
      end
    end

    def setup(options = { })
      setup_linkedcare_bus(options)
      @setup = true
    end

    def setup?
      @setup || false
    end

    private

    def connection_handler(connection)
      Linkedcare::Logging.info("Connection stabilished with Broker")
      Linkedcare::Bus::ConnectionHandler.new(connection).setup
      register_signals(connection)
    end

    def register_signals(connection)
      Signal.trap("INT")  do
        Linkedcare::Logging.info("Disconnecting from Broker")
        connection.disconnect do
          Linkedcare::Logging.info("Disconnected") 
          EventMachine.stop
        end  
      end
    end

    def setup_logging(file, level)
      Linkedcare::Logging.setup(file, level)
    end

    def setup_linkedcare_bus(options)
      Linkedcare::Configurable.setup(options)
      setup_logging( Linkedcare::Configurable.config.log_file, Linkedcare::Configurable.config.log_level )
      Linkedcare::Logging.logger.info("Setting up Linkedcare Bus [ DONE ]")
    end

    extend self
  end
end