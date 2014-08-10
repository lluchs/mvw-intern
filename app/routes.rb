# Require everything from the `routes` directory.
Dir[File.dirname(__FILE__) + '/routes/*.rb'].each { |file| require file }
