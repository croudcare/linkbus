require 'yaml'
require 'singleton'
require 'optparse'
require 'rails'
require 'logger'

require 'linkedcare/bus'

module Linkedcare
  
  class CLI
    include Singleton

    DEFAULTS_CLI_OPTIONS = {
      :app_dir => '.',
      :environment => 'development',
      :log_file => STDOUT,
      :log_level => Logger::DEBUG, 
      :config_file => "config/linkbus.yml"
    }

    DEFAULTS_CLI_OPTIONS.freeze 

    def default_options
      DEFAULTS_CLI_OPTIONS.dup 
    end
    
    def parse(args=ARGV)
      options = setup_options(args)
      setup_logging(options[:log_file], options[:log_level])
      setup_linkedcare_bus(options)
      boot_system(options)
    end

    def run
      Linkedcare::Launcher.start
    end

    def setup_logging(file, level)
      Linkedcare::Logging.setup(file, level)
    end

    def setup_linkedcare_bus(options)
      Linkedcare::Logging.logger.info("Setup Linkedcare Bus")
      Linkedcare::Bus::Configurable.config(options[:environment], options[:config_file])
    end

    def setup_options(args)
      cli_options = parse_options(args)
      default_options.merge(cli_options)
    end

    def boot_system(options)
      ENV['RACK_ENV'] = ENV['RAILS_ENV'] = options[:environment]
      raise ArgumentError, "#{options[:app_dir]} does not exist" unless File.exist?(options[:app_dir])
      require File.expand_path("#{options[:app_dir]}/config/environment.rb")
      ::Rails.application.eager_load!
    end

    def parse_options(argv)
      opts = { }

      @parser = OptionParser.new do |o|
        o.on '-e', '--environment ENV', "Application environment" do |arg|
          opts[:environment] = arg
        end

        o.on '-a', '--app [PATH|DIR]', "Location of Rails application" do |arg|
          opts[:app_dir] = arg
        end

        o.on "-v", "--verbose", "Print more verbose output" do |arg|
          opts[:verbose] = arg
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