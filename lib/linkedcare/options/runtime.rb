module Linkedcare
  
  class Options::Runtime < Linkedcare::Options

    defaults do
      config_file "config/linkbus.yml"
      log_file    "log/linkbus.log"
      log_level    0 
      environment "development"
    end

    def to_s
      "{ config_file: [ #{config_file} ], log_file: [ #{log_file} ], environment [ #{environment}], log_level [ #{log_level} ] } }"
    end

    def amqp
      Options::AMQP.new(options[:amqp].with_indifferent_access)
    end

  end #linkbus class
end #linkbus module