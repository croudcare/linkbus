require 'spec_helper'

describe Linkedcare::Configuration do

  before do
    @config_file = File.expand_path('../fixtures/config/config.yml', File.dirname(__FILE__))
  end

  it 'loads from file' do
    config = subject.setup(:environment => 'test', :config_file => @config_file)
    expected_test_env(config.amqp)
  end

  it 'returns the same configuration' do
    expected = subject.setup(:environment => 'default', :config_file =>@config_file)
    actual   = subject.setup(:environment => 'default', :config_file => @config_file)
    expect(actual).to eql(expected)
  end

  it 'returns the options as hash' do
    config = subject.setup(:environment => 'test', :config_file =>@config_file)
    options = subject.amqp_options

    expect(options[:host]).to eql('192.168.0.2')
    expect(options[:port]).to eql(9998)
    expect(options[:user]).to eql("name")
    expect(options[:password]).to eql("password")
    expect(options[:vhost]).to eql("/vhost")
    expect(options[:bus]).to eql("mybus")
  end

end