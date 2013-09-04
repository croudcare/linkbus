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
        
        attr_accessor :config_file, :app_dir, :verbose, :amqp
        def initialize(options = { })
          @amqp = AMQPConfig.new(options['amqp'])
          @config = parse(options)
        end

        private
        def parse(options)
          @config_file  = options[:config_file]
          @app_dir      = options[:app_dir]
          @verbose      = options[:verbose]
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
        config_file_options = ::YAML::load_file(path)
        LinkBusConfig.new(config_file_options[env])
      end
    end

  end
end