module Linkedcare
  module Launcher
    
    def start

      EM.run do 
        connection = AMQP.connect(Linkedcare::Bus::Configurable.amqp_options) do |connection|
          Linkedcare::Bus::ConnectionHandler.new(connection).setup
        end

        Signal.trap("INT")  { AMQP.stop { EventMachine.stop }  }
        Signal.trap("TERM") { AMQP.stop { EventMachine.stop }  }
        
      end

    end

    extend self
  end
end