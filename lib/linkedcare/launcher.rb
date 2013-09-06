module Linkedcare
  module Launcher
    include Linkedcare::Logging

    def start
      from_cli
    end

    private

    def from_cli
      log_info("Launching Linkbus EM")
      EM.run do 
        options = Linkedcare::Configuration.amqp.symbolize_options
        log_info("Connecting with #{ options }")
        AMQP.connect(options) do |connection|
          connection_handler(connection)
        end
      end
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