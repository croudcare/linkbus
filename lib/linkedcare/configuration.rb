require 'yaml'

module Linkedcare
  module Configuration
  
    def self.amqp
      @amqp_config
    end

    def self.amqp_options
      amqp.options
    end

    def self.runtime
      @runtime
    end

    def self.environment
      runtime.environment
    end

    def self.config_file
      runtime.config_file
    end

    def self.log_file
      runtime.log_file
    end

    def self.log_level
      runtime.log_level
    end

    def self.setup(options = { })
      options = options.with_indifferent_access
      load_runtime_options(options)
      @setup = true
      self
    end

    def self.setup?
      !!@setup
    end

    private
    def self.load_runtime_options(options)
      @runtime = Linkedcare::Options::Runtime.new(options)
      options = load_file(@runtime.environment, @runtime.config_file)
      load_amqp_configurations(options)
    end

    def self.load_amqp_configurations(options)
      @amqp_config =  Linkedcare::Options::AMQP.new(options[:amqp])
    end

    def self.load_file(env, path)
      raise 'Missing Config File' if path.nil?
      config_file_options = ::YAML::load_file(path)
      options = ( config_file_options[env] || { } ) rescue nil
      raise "Environment [ #{env} ] not found in [ #{path} ] " if options.nil? || options.empty?
      options.with_indifferent_access
    end
  end

end