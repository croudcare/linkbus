require 'linkedcare/bus'

def expect_subscriber(subscriber, pattern, handler, queue)
  expect(subscriber.key).to eql(pattern)
  expect(subscriber.handler.call).to eql(handler.call)
  expect(subscriber.queue).to eql(queue)
end

def expected_rails_env(config)
  expect(config.vhost).to eql('/vhost_rails')
  expect(config.user).to eql('rails')
  expect(config.password).to eql('rails')
  expect(config.host).to eql('192.168.0.1')
  expect(config.port).to eql(9999)
  expect(config.bus).to eql('my_rails_bus')
end

def expected_test_env(config)
  expect(config.vhost).to eql('/vhost')
  expect(config.user).to eql('name')
  expect(config.password).to eql('password')
  expect(config.host).to eql('192.168.0.2')
  expect(config.port).to eql(9998)
  expect(config.bus).to eql('mybus')
end

def disable_log
  Linkedcare::Logging.setup("/dev/null")
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.mock_framework = :mocha

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before { disable_log }
    
  config.before(:each) do
    Linkedcare::Bus::Configurable.instance_eval do
      @config = nil
    end

    Linkedcare::Bus::Subscribers.instance_eval do
      @manager = nil
    end
  end
end

