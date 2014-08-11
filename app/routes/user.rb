# User listing and editing routes.

module MvwIntern
  module Routes
    def self.registered(app)
      
      app.get '/user' do
        @users = Models::User.all
        slim :user_list
      end

    end
  end
end
