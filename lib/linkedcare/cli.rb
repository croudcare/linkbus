require 'yaml'
require 'singleton'
require 'optparse'
require 'rails'
require 'logger'

require 'linkedcare/bus'

module Linkedcare
  
  class CLI
    include Singleton

    def parse(args = ARGV)
      options = parse_options(args)
      Linkedcare::Launcher.setup(options)
      info("Booting your application with configuration: #{Linkedcare::Configurable.config}")
      boot_system(options)
    end

    def info(message)  
      Linkedcare::Logging.info(message)
    end

    def run
      Linkedcare::Launcher.start
    end

    def boot_system(options)
      ENV['RACK_ENV'] = ENV['RAILS_ENV'] = options[:environment]
      app_dir = Linkedcare::Configurable.config.app_dir
      raise ArgumentError, "#{app_dir} does not exist" unless File.exist?(app_dir)

      require File.expand_path("#{app_dir}/config/environment.rb")
      ::Rails.application.eager_load!
    end

    def parse_options(argv)
      opts = {}

      @parser = OptionParser.new do |o|
        o.on '-e', '--environment ENV', "Application environment" do |arg|
          opts[:environment] = arg
        end

        o.on '-a', '--app [PATH|DIR]', "Location of Rails application" do |arg|
          opts[:app_dir] = arg
        end

        o.on '-c', '--config PATH', "path to YAML config file" do |arg|
          opts[:config_file] = arg
        end

        o.on '-l', '--log PATH', "path to log file" do |arg|
          opts[:log_file] = arg
        end

        o.on '-V', '--version', "Print version and exit" do |arg|
          puts "Linkbus #{Linkedcare::Bus::VERSION}"
          exit(0)
        end
      end

      @parser.banner = "linkbus [options]"
      @parser.on_tail "-h", "--help", "Show help" do
        logger.info @parser
        exit(1)
      end
      @parser.parse!(argv)
      opts
    end
  end
end