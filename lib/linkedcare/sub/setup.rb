#subscribers
require 'linkedcare/logging'
require 'linkedcare/options/setup'

require 'linkedcare/sub/manager'
require 'linkedcare/sub/subscriber'
require 'linkedcare/connection/handler'

puts "X #{$LINKBUS_CLI}"

if !$LINKBUS_CLI
  puts "YEAH"
  configuration = Linkedcare::Configuration.setup
  Linkedcare::Logging.setup(configuration.log_file, configuration.log_level)
end