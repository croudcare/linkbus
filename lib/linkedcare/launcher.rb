module Linkedcare
  module Launcher
    
    def start
      AMQP.start(Linkedcare::Bus::Configurable.amqp_options) do |connection|
        Linkedcare::Bus::ConnectionHandler.new(connection).setup
        Signal.trap("INT")  { puts "INT" ; AMQP.stop { puts "INT EM"; EventMachine.stop }  }
      end
    end

    extend self
  end
end