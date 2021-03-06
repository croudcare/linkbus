module Linkedcare
  class SubscriberManager
    include Linkedcare::Logging
    
    attr_reader :subscribers
    def initialize
      @subscribers = { }
    end

    def empty?
      @subscribers.empty?
    end

    def handle(routing_key, handler, queue_name = nil)
      subscriber = Subscriber.new(routing_key, handler, queue_name)
      add(subscriber)
    end

    private

    def add(subscriber)
      log_info("Add subscriber Routing Key: [ #{subscriber.key} ], Queue: [ #{subscriber.queue} ], Handler Class: [#{subscriber.handler.class} ]")
      handlers = @subscribers[subscriber.queue] || []
      handlers.push(subscriber)
      @subscribers[subscriber.queue] = handlers
    end

  end

  module Subscribers

    def self.manager
      @manager ||= SubscriberManager.new
    end

    def [](val)
      @manager.subscribers[val]
    end

    def empty?
      @manager.empty?
    end

    def self.register(&block)
      raise 'Must pass block' unless block_given?
      block.call(self.manager)
    end

    extend self
  end

end