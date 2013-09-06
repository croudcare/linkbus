module Linkedcare
  module Launcher
    include Linkedcare::Logging

    def start
      log_info("Launching Linkbus EM")
      EM.run do 
        AMQP.connect(Linkedcare::Configuration.amqp_options) do |connection|
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
      log_info("Connection stabilished with Broker")
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