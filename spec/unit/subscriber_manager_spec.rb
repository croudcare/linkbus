require 'spec_helper'

describe Linkedcare::SubscriberManager do

  let(:pattern) { 'pattern.*' }
  let(:queue) { 'queue_name' }
  let(:handler) { Proc.new { 'val' } }

  let(:handler_two) { Proc.new { 'val 2' } }

  let(:subscriber) { Linkedcare::Subscriber.new(pattern, handler, queue ) }
  let(:subscriber_two) { Linkedcare::Subscriber.new(pattern, handler_two, queue ) }

  before(:each) do
    @manager =  Linkedcare::SubscriberManager.new
  end

  it 'adds subscribers' do
    @manager.handle(pattern, handler, queue)
    subscribers = @manager.subscribers[subscriber.queue]
    expect(@manager.empty?).to be_false
    expect(subscribers).to be_an(Array)
    expect_subscriber(subscribers.first, pattern, handler, queue)
  end

  it 'subscribes many for same pattern' do
    @manager.handle(pattern, handler, queue)
    @manager.handle(pattern, handler_two, queue)

    subscribers = @manager.subscribers[subscriber.queue]
    second   = subscribers.pop
    first  = subscribers.pop
    expect(first.queue).to eql(second.queue)

    expect(first.key).to eql(second.key)
    expect(first.handler).to_not eql(second.handler)
    expect(first.handler.call).to eql('val')
    expect(second.handler.call).to eql('val 2')

  end

end