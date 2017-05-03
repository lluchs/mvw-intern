require 'sequel'

# Enable model.to_json
Sequel::Model.plugin :json_serializer

# Use DateTime as it formats to ISO8601
Sequel.datetime_class = DateTime

# Monkey patch DateTime to fix Date output.
class DateTime
  def to_json(opts)
    %Q["#{strftime('%FT%T')}"]
  end
end

require './app/models/user'
require './app/models/group'
require './app/models/event'
