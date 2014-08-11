# User listing and editing routes.

module MvwIntern
  module Routes
    module User
      def self.registered(app)
        
        app.get '/user' do
          @users = Models::User.all
          slim :user_list
        end

        app.post '/user' do
          halt 403 unless current_user.admin

          user = Models::User.new

          user.name       = params[:name]
          user.email      = params[:email]
          user.instrument = params[:instrument]
          user.admin      = params[:admin]

          user.save

          redirect '/user'
        end

        app.put '/user' do
          halt 403 unless current_user.admin

          user = Models::User[params[:id]]
          halt 404 if user.nil?

          user.name       = params[:name]
          user.email      = params[:email]
          user.instrument = params[:instrument]
          user.admin      = params[:admin]

          user.save

          redirect '/user'
        end

        app.get '/user/add' do
          halt 403 unless current_user.admin
          @user = Models::User.new
          slim :user_add
        end

        app.get '/user/:id/edit' do
          halt 403 unless current_user.admin
          @user = Models::User[params[:id]]
          halt 404 if @user.nil?
          slim :user_edit
        end

      end
    end
  end
end
