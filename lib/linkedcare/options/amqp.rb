module Linkedcare

  class Options::AMQP < Linkedcare::Options
    
    defaults do

      host     '127.0.0.1'
      port      5672
      user     'guest'
      password 'guest'
      vhost    '/'
      bus      'bus'
      heartbeat 60 # 1 min to avoid NAT/Firewalls close connection for innactivity.
    
    end

    def symbolize_options
      result = { }
      options.each do |key, value|
        result[key.to_sym] = value
      end
      result
    end

    def to_s
      "host: [ #{host}], port: [ #{port} ], user: [ #{user} ], password: [ #{password} ], vhost: [ #{vhost} ], bus: [ #{bus} ], heartbeat: [ #{heartbeat} ]"
    end

  end
end