require 'pry'

module Linkedcare

  module Bus
    module Configurable

      AMQP_DEFAULT_OPTIONS = { 
          :host => '127.0.0.1',
          :port => 5672,
          :bus => 'linkbus_default',
          :vhost => '/',
          :user => 'guest',
          :password => 'guest'
      }

      AMQP_DEFAULT_OPTIONS.freeze

      class AMQPConfig
        
        attr_accessor :host, :port, :user, :password, :vhost, :bus, :heartbeat
        def initialize(options = {})
            @host       = options['host']      || '127.0.0.1'
            @port       = options['port']      ||  5672
            @user       = options['user']      || 'guest'
            @password   = options['password']  || 'guest'
            @vhost      = options['vhost']     || '/'
            @bus        = options['bus']       || 'bus'
            @heartbeat  = options['heartbeat'] || 20
        end

        def to_s
          "host: [ #{host}], port: [ #{port} ], user: [ #{user} ], password: [ #{password} ], vhost: [ #{vhost} ], bus: [ #{bus} ], heartbeat: [ #{heartbeat} ]"
        end

        def options
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
        
        attr_accessor :config_file, :app_dir, :amqp, :log_file
        def initialize(options = { })
          @config = parse(options)
        end

        def to_s
          "{ config_file: [ #{config_file} ], app_dir: [ #{app_dir} ], log_file: [ #{log_file} ], amqp: { #{amqp.to_s}  } }"
        end

        private

        def parse(options)
          @config_file  = options['config_file']
          @app_dir      = options['app_dir']
          @log_file     = options['log_file']
          @amqp         = AMQPConfig.new(options['amqp'])
        end

      end

      def self.amqp
        config.amqp
      end

      def self.amqp_options
        amqp.options
      end

      def self.config(environment = 'development', path = nil)
        @config ||=  load(environment, path)
      end

      private
      def self.load(env, path)
        raise 'Missing Config File' if path.nil?
        Linkedcare::Logging.info("Loading linkbus configuration '#{path}' for environment '#{env}'")
        config_file_options = ::YAML::load_file(path)
        options = config_file_options[env] rescue {}
        raise "Environment [ #{env} ] not found in [ #{path} ] " if options.empty?
        LinkBusConfig.new(options)
      end
    end

  end
end