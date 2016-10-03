# User listing and editing routes.

module MvwIntern
  module Routes
    module User
      def self.registered(app)

        app.get '/user' do
          @users = Models::User.where(active: true).order(:name)
          @inactive_users = Models::User.where(active: false).order(:name)
          slim :user_list
        end

        app.post '/user' do
          halt 403 unless current_user.admin

          user = Models::User.new

          update_user_params(user, params)
          user.save

          redirect '/user'
        end

        app.put '/user' do
          halt 403 unless current_user.admin

          user = Models::User[params[:id]]
          halt 404 if user.nil?

          update_user_params(user, params)
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

        app.get '/settings' do
          slim :user_settings
        end

        app.post '/settings' do
          user = current_user
          if user.verify_password(params[:old_password])
            user.password = params[:password]
            user.save
            @message = 'Passwort geändert.'
          else
            @message = 'Altes Passwort ungültig.'
          end
          slim :user_settings
        end

      end
    end
  end
end
