require 'linkedcare/logging'
require 'linkedcare/options/setup'

require 'linkedcare/pub/publisher'

if !$LINKBUS_CLI
  configuration = Linkedcare::Configuration.setup
  Linkedcare::Logging.setup(configuration.log_file, configuration.log_level)
end
