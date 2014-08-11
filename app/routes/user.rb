# User listing and editing routes.

module MvwIntern
  module Routes
    def self.registered(app)
      
      app.get '/user' do
        @users = Models::User.all
        slim :user_list
      end

      app.post '/user' do
        user = Models::User.new

        user.name       = params[:name]
        user.email      = params[:email]
        user.instrument = params[:instrument]
        user.admin      = params[:admin]

        user.save

        redirect '/user'
      end

      app.get '/user/add' do
        halt 403 unless current_user.admin
        slim :user_add
      end

    end
  end
end
