module Linkedcare
  module Launcher
    include Linkedcare::Logging

    def start
      if (!!$LINKBUS_CLI) from_cli
      else from_app
    end

    private

    def from_cli
      log_info("Launching Linkbus EM")
      EM.run do 
        AMQP.connect(Linkedcare::Configuration.amqp_options) do |connection|
          connection_handler(connection)
        end
      end
    end

    def from_app
      configuration = Linkedcare::Configuration.setup
      Linkedcare::Logging.setup(configuration.log_file, configuration.log_level) 
    end

    def connection_handler(connection)
      log_info("Connection estabilished with Broker")
      Linkedcare::Connection::Handler.new(connection).setup
      register_signals(connection)
    end

    def register_signals(connection)
      Signal.trap("INT")  do
        log_info("Disconnecting from Broker")
        connection.disconnect do
          log_info("Disconnected [ DONE ]") 
          EventMachine.stop
        end  
      end
    end

    extend self
  end
end