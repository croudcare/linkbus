module Linkedcare
  module Launcher
    
    def start

      EM.run do 
        AMQP.connect(Linkedcare::Bus::Configurable.amqp_options) do |connection|
          Linkedcare::Bus::ConnectionHandler.new(connection).setup
        end
      end

    end

    def stop
      EventMachine.stop
    end

    extend self
  end
end