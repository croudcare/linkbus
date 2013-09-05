require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'
require 'singleton'

module Linkedcare
  module Configurable

    class AMQPConfig       
      attr_accessor :host, :port, :user, :password, :vhost, :bus, :heartbeat
      def initialize(options = {})
          options = options.with_indifferent_access
          @host       = options[:host]      || '127.0.0.1'
          @port       = options[:port]      ||  5672
          @user       = options[:user]      || 'guest'
          @password   = options[:password]  || 'guest'
          @vhost      = options[:vhost]     || '/'
          @bus        = options[:bus]       || 'bus'
          @heartbeat  = options[:heartbeat] || 20
      end

      def to_s
        "host: [ #{host}], port: [ #{port} ], user: [ #{user} ], password: [ #{password} ], vhost: [ #{vhost} ], bus: [ #{bus} ], heartbeat: [ #{heartbeat} ]"
      end

      def to_hash
        hash = {}
        hash[:host] = @host
        hash[:port] = @port
        hash[:user] = @user
        hash[:password] = @password
        hash[:vhost] = @vhost
        hash[:bus] = @bus
        hash[:heartbeat] = @heartbeat
        hash
      end
    end

    class LinkBusConfig
      include Singleton

      attr_accessor :config_file, :app_dir, :amqp, :log_file, :log_level, :environment
      def initialize(options = { })
        @config = setup(options.with_indifferent_access)
      end

      def to_s
        "{ config_file: [ #{config_file} ], app_dir: [ #{app_dir} ], log_file: [ #{log_file} ], amqp: { #{amqp.to_s}  } }"
      end

      def setup(options)
        @config_file  = options[:config_file] || "config/linkbus.yml"
        @app_dir      = options[:app_dir]     || "."
        @log_file     = options[:log_file]    || "log/linkbus.log"
        @log_level    = options[:log_level]   || Logger::DEBUG
        @environment  = options[:environment] || "development"
        @amqp         = AMQPConfig.new(options[:amqp] || { })
      end

    end

    def self.amqp
      config.amqp
    end

    def self.amqp_options
      amqp.to_hash
    end

    def self.config(environment = 'development', path = nil)
      @config ||=  setup( { :environment => environment, :config_file => path } )
    end

    def self.setup(options = {})   
      result = build_options(options)
      LinkBusConfig.instance.setup(result)
      @config = LinkBusConfig.instance
    end

    private

    def self.build_options(options)
      default_environment = LinkBusConfig.instance.environment
      default_config_file = LinkBusConfig.instance.config_file

      file_yaml_options  = load( options[:environment] || default_environment, options[:config_file] || default_config_file ).with_indifferent_access
      final_result       = file_yaml_options.merge(options.with_indifferent_access)
      final_result
    end

    def self.load(env, path)
      raise 'Missing Config File' if path.nil?
      config_file_options = ::YAML::load_file(path)
      options = ( config_file_options[env] || {} ) rescue {}
      raise "Environment [ #{env} ] not found in [ #{path} ] " if options.empty?
      options
    end
  end

end