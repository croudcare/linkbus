module Linkedcare
  module Configurable

    DEFAULT_LINKBUS_OPTIONS = {
        :app_dir => '.',
        :environment => 'development',
        :log_file => "log/linkbus.log",
        :log_level => Logger::DEBUG, 
        :config_file => "config/linkbus.yml",
        :amqp => { 
            :host     => '127.0.0.1',
            :port     => 5672,
            :bus      => 'linkbus_default',
            :vhost    => '/',
            :user     => 'guest',
            :password => 'guest'
        } 
     }

    def self.default_linkbus_options
      DEFAULT_LINKBUS_OPTIONS.dup
    end

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

      
      attr_accessor :config_file, :app_dir, :amqp, :log_file, :log_level
      def initialize(options = { })
        @config = parse(DEFAULT_LINKBUS_OPTIONS.merge(options))
      end

      def to_s
        "{ config_file: [ #{config_file} ], app_dir: [ #{app_dir} ], log_file: [ #{log_file} ], amqp: { #{amqp.to_s}  } }"
      end

      private

      def parse(options)
        @config_file  = options['config_file']
        @app_dir      = options['app_dir']
        @log_file     = options['log_file']
        @log_level    = options['log_level']
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
      config_file_options = ::YAML::load_file(path)
      options = ( config_file_options[env] || {} ) rescue {}
      raise "Environment [ #{env} ] not found in [ #{path} ] " if options.empty?
      LinkBusConfig.new(options)
    end
  end

end