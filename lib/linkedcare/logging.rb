require 'logger'
require 'date'

module Linkedcare
  module Logging

    def self.included(base)
      base.send(:include, SugarLogging)
    end

    module SugarLogging
      
      def log_info(message)
        Linkedcare::Logging.info(message)
      end
      
      def log_error(message, exception = nil)
        exception = Exception.new("") if exception.nil?
        Linkedcare::Logging.fatal(message, exception)
      end

      def log_debug
        Linkedcare::Logging.debug(message)
      end

    end
    
    class Beauty < Logger::Formatter
      def call(severity, time, app, message)
        "[linkbus] #{Time.now.utc} #{Process.pid} #{severity}: #{message}\n"
      end
    end

    module MySelf

      def info(message) 
        logger.info(message)
      end

      def debug(message)
        logger.debug(message)
      end

      def fatal(message, exception)
        msg = [ message, exception.backtrace ].join(" ")
        logger.fatal(msg)
      end

      def logger
        @logger ||= setup(STDOUT)
      end

      def setup(file, level = Logger::INFO)
        close_logger(initialize_logger(file, level))
      end

      def close_logger(to_close)
       to_close.close if to_close && !$TESTING
      end

      def initialize_logger(file, level)
        old = @logger
        @logger = Logger.new(file)
        @logger.level = Logger::INFO
        @logger.formatter = Beauty.new
        old
      end
    end

    extend MySelf
    
  end
end