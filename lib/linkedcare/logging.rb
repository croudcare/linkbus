require 'logger'
require 'date'
require 'pry'

module Linkedcare
  module Logging
    
    class Beauty < Logger::Formatter
      def call(severity, time, app, message)
        "[linkbus] #{Time.now.utc} #{Process.pid} #{severity}: #{message}\n"
      end
    end

    def self.setup(file, level = Logger::INFO)
      close_logger(initialize_logger(file, level))
    end

    def self.info(message) 
      logger.info(message)
    end

    def self.debug(message)
      logger.debug(message)
    end

    def self.fatal(message, exception)
      msg = [ message, exception.backtrace ].join(" ")
      logger.fatal(msg)
    end

    def self.logger
      @logger ||= setup(STDOUT)
    end

    def self.close_logger(to_close)
     to_close.close if to_close && !$TESTING
    end

    def self.initialize_logger(file, level)
      old = @logger
      @logger = Logger.new(file)
      @logger.level = Logger::INFO
      @logger.formatter = Beauty.new
      old
    end

  end
end