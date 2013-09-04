module Linkedcare
  module Bus
    
  end
end

require 'eventmachine'
require 'bunny'
require 'amqp'
require 'yaml'

require 'linkedcare/bus/version'
require 'linkedcare/launcher'
require 'linkedcare/config/configuration'
require 'linkedcare/subscribers/manager'
require 'linkedcare/subscribers/subscriber'
require 'linkedcare/publishers/publisher'
require 'linkedcare/bus/connection_handler'
