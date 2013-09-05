describe Linkedcare::Bus::Publisher do

  before(:each) do
    config_file = File.expand_path('../fixtures/config/connection_config.yml', File.dirname(__FILE__))
    @options = Linkedcare::Configurable.config('test', config_file).amqp.options
  end

  it "publishes messages to specific routing key" do
    topic = mock
    topic.expects(:publish).with('message', :routing_key => 'key').once
    described_class.any_instance.expects(:with_exchange).yields(topic)
    described_class.publish('message', 'key')
  end

  context "Invalid key" do 
    it "returns false when try to send message with nil key" do
      expect(described_class.publish('message', nil)).to be_false
    end

    it "add to errors the cause" do
      expect(described_class.publish('message', nil)).to be_false
    end
  end
  
  pending "Verify if connection close with success."

end