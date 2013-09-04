module Linkedcare
  module Bus
    class Subscriber
      attr_reader :key, :handler

      def initialize(key, handler, queue_name = nil)
        raise 'Invalid Key' if blank(key)
        raise 'Invalid Handler' if handler.nil? || !handler.respond_to?(:call)
        @key        = key
        @handler    = handler
        @queue_name = normalize(queue_name)
      end

      def queue
        @queue_name || ( @queue_name =  normalize(@key) )
      end

      private

      def blank(val)
        val.nil? || val.empty?
      end

      def normalize(key)
        return nil if blank(key)
        sanitize(key.downcase)
      end

      def sanitize(key)
        key.encode(Encoding.find('ASCII'), { :invalid => :replace, :undef => :replace, :replace => '' })
      end

    end
  end
end