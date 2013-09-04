module Linkedcare
  module Launcher
    
    def start

      EM.run do 
        connection = AMQP.connect(Linkedcare::Bus::Configurable.amqp_options) do |connection|
          Linkedcare::Bus::ConnectionHandler.new(connection).setup
        end

        Signal.trap("INT")  { puts "int"; connection.close { EventMachine.stop } }
        Signal.trap("TERM") { puts "TERM"; connection.close { EventMachine.stop } }
        
      end

    end

    def stop
      EventMachine.stop
    end

    extend self
  end
end