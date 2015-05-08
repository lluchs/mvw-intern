require 'sequel'

# Enable model.to_json
Sequel::Model.plugin :json_serializer

# Use DateTime as it formats to ISO8601
Sequel.datetime_class = DateTime

require './app/models/user'
require './app/models/event'
