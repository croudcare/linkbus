#subscribers
require 'linkedcare/logging'
require 'linkedcare/options/setup'

require 'linkedcare/sub/manager'
require 'linkedcare/sub/subscriber'
require 'linkedcare/connection/handler'

if !!$LINKBUS_CLI
  puts "TO FIX"
  configuration = Linkedcare::Configuration.setup
  Linkedcare::Logging.setup(configuration.log_file, configuration.log_level)
end