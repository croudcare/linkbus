require 'pry'

module Linkedcare
  module Launcher
    
    def start
      Linkedcare::Logging.info("Launching Linkbus")
      AMQP.start(Linkedcare::Configurable.amqp_options) do |connection|
        
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

    def setup(options = { })
      opt = apply_default_values(options)
      setup_linkedcare_bus(opt)
      @setup = true
    end

    def setup?
      @setup || false
    end

    private

    def apply_default_values(options)
      Linkedcare::Configurable.default_linkbus_options.merge!(options)
    end

    def setup_logging(file, level)
      Linkedcare::Logging.setup(file, level)
    end

    def setup_linkedcare_bus(options)
      Linkedcare::Configurable.config(options[:environment], options[:config_file])
      setup_logging( Linkedcare::Configurable.config.log_file, Linkedcare::Configurable.config.log_level )
      Linkedcare::Logging.logger.info("Setting up Linkedcare Bus [ DONE ]")
    end

    extend self
  end
end