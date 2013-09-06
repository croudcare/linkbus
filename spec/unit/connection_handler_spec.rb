require 'spec_helper'

describe Linkedcare::Bus::ConnectionHandler do

  module AMQP
    class Channel
      def initialize(*)
      end
    end
  end

  before(:each) do
    config_file = File.expand_path('../fixtures/config/connection_config.yml', File.dirname(__FILE__))
    @options = Linkedcare::Configuration.config('test', config_file).amqp.options
  end

  it "register one subscribers" do
    Linkedcare::Bus::Subscribers.register do |subscriber|
      subscriber.handle 'pattern.#', Proc.new { 'xxx' }
    end
    
    exchange  = stub
    queue     = mock
    queue.expects(:bind).with(exchange, :routing_key => 'pattern.#')

    queue.expects(:subscribe)

    AMQP::Channel.any_instance.expects(:topic).returns(exchange)
    AMQP::Channel.any_instance.expects(:queue).yields(queue)

    described_class.new(Object.new).setup
  end

  it "register two subscribers" do
    Linkedcare::Bus::Subscribers.register do |subscriber|
      subscriber.handle 'first.#', Proc.new { 'xxx' }
      subscriber.handle 'second.#', Proc.new { 'xxx' }
    end

    exchange  = stub
    queue     = mock
    queue.expects(:bind).twice
    queue.expects(:subscribe).twice

    AMQP::Channel.any_instance.expects(:topic).twice.returns(exchange)
    AMQP::Channel.any_instance.expects(:queue).twice.yields(queue)

    described_class.new(Object.new).setup
  end
end