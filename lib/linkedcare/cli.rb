require 'yaml'
require 'singleton'
require 'optparse'
require 'rails'
require 'singleton'
require 'linkedcare/cli/setup'

module Linkedcare
  
  class CLI
    include Singleton
    include Linkedcare::Logging

    def parse(args = ARGV)
      configuration = Linkedcare::Configuration.setup(parse_options(args))
      Linkedcare::Logging.setup(configuration.log_file, configuration.log_level)      
      log_info("Booting your application with configuration: #{Linkedcare::Configuration.runtime} --- #{Linkedcare::Configuration.amqp}")
      booting_the_fOcking_system #ow yeah
    end

    def run
      Linkedcare::Launcher.start
    end

    def booting_the_fOcking_system
      ENV['RACK_ENV'] = ENV['RAILS_ENV'] = Linkedcare::Configuration.environment
      # app_dir = Linkedcare::Configuration.config.app_dir
      # raise ArgumentError, "#{app_dir} does not exist" unless File.exist?(app_dir)
      app_dir = '.'
      require File.expand_path("#{app_dir}/config/environment.rb")
      ::Rails.application.eager_load!
    end

    def parse_options(argv)
      opts = {}

      @parser = OptionParser.new do |o|
        o.on '-e', '--environment ENV', "Application environment" do |arg|
          opts[:environment] = arg
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
        log_info @parser
        exit(1)
      end
      @parser.parse!(argv)
      opts
    end
  end
end