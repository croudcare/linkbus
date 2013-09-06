require 'spec_helper'

describe Linkedcare::Subscribers do

  # teardown
  after(:each) do
    subject.instance_eval do
      @manager = nil
    end
  end

  it 'responds to manager' do
    expect(Linkedcare::Subscribers).to respond_to(:manager)
  end

  it 'responds to register' do
    expect(Linkedcare::Subscribers).to respond_to(:register)
  end

  it 'returns manager of type Linkedcare::SubscriberManager' do
    expect(Linkedcare::Subscribers.manager).to be_an(Linkedcare::SubscriberManager)
  end

  it 'registers subscribers' do
    subject.register do |subscriber|
      subscriber.handle 'pattern', Proc.new { }
    end
    expect(subject.empty?).to be_false
  end

  it 'retrieves subscriber' do
    subject.register do |subscriber|
      subscriber.handle 'pattern', Proc.new { 'xxx' }
    end
    subscribers = subject['pattern']
    consumer = subscribers.first
    expect(subscribers.length).to eql(1)
    expect_subscriber(consumer, 'pattern', Proc.new { 'xxx' }, 'pattern')
  end

  it 'registers many subscriber with the same binding' do
    subject.register do |subscriber|
      subscriber.handle 'pattern', Proc.new { 'xxx' }
      subscriber.handle 'pattern', Proc.new { 'yyy' }
    end

    subscribers = subject['pattern']
    expect(subscribers.length).to eql(2)
  end

  context "when different bindings" do 
    before do
      subject.register do |subscriber|
        subscriber.handle 'pattern', Proc.new { 'xxx' }
        subscriber.handle 'different.pattern', Proc.new { 'yyy' }
      end
    end

    it 'registers only one entry for "pattern"' do
      subscribers = subject['pattern']
      expect(subscribers.length).to eql(1)
    end

    it 'registers another entry for "different.pattern' do
      subscribers = subject['different.pattern']
      expect(subscribers.length).to eql(1)
    end
  end

end