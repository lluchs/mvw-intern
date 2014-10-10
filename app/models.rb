require 'sequel'

# Enable model.to_json
Sequel::Model.plugin :json_serializer

require './app/models/user'
require './app/models/event'
