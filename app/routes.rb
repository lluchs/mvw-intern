# Require everything from the `routes` directory.
Dir[File.dirname(__FILE__) + '/routes/*.rb'].each { |file| require file }

module MvwIntern
  module Routes
    def self.registered(app)
      app.register Auth
      app.register User
    end
  end
end
