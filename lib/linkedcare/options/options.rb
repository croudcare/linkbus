module Linkedcare

  class OptionsBuilder

    def self.defaults(block)
      me = new
      me.instance_eval &block
      me.options
    end
    
    attr_reader :options
    def initialize
      @options = {}
    end

    def method_missing(method, *args, &block)
      @options[method.to_sym] = argument(args)
    end

    private
    # Right now we only use one arguments
    # and the argument is a String.
    # When some other kinds of argument be necessary
    # build here
    def argument(args)
      args.first.to_s
    end

  end

  class Options
    
    def self.defaults(&block)
      @options = OptionsBuilder.defaults(block) if block_given?
    end

    def self.default_options
      @options || {}
    end 

    def method_missing(method, *args, &block)
      if (position = method.to_s.index('?'))
        method_name = method[0...position]
        options[method_name.to_sym] ? true : false
      else
        options[method]
      end
    end

    def merge(values)
      options.merge(values)
    end

    attr_accessor :options
    def initialize(options = {})
      @options = parse(options.with_indifferent_access)
    end

    def parse(options)
      opt = defaults.merge(options)
      @options = to_parse(opt)
    end

    def defaults
      self.class.default_options.with_indifferent_access
    end

    protected
    def to_parse(options); options;  end
  end
end