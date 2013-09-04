require 'logger'
require 'date'

module Linkedcare
  module Logging
    
    class Beauty < Logger::Formatter
      def call(severity, time, app, message)
        "[linkbus] #{Time.now.utc} #{Process.pid} #{severity}: #{message}\n"
      end
    end

    def self.setup(file, level = Logger::INFO)
      close_logger
      initialize_logger(file, level)
    end


    def self.logger
      @logger ||= setup(STDOUT)
    end

    def self.close_logger
      @logger.close if @logger && !$TESTING
    end

    def self.initialize_logger(file, level)
      @logger = Logger.new(file)
      @logger.level = level
      @logger.formatter = Beauty.new
      @logger
    end

  end
end