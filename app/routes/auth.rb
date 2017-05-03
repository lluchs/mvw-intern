# Persona authentication routes

require 'json'
require 'jwt'

module MvwIntern
  module Routes
    module Auth
      def self.registered(app)

        app.post "/auth/login" do
          email = params[:email]
          password = params[:password]

          user = Models::User.by_email(email)

          if user.nil?
            [403, {status: "error", message: 'Es gibt keinen Nutzer mit dieser E-Mail-Adresse.'}.to_json]
          elsif not user.verify_password password
            [403, {status: "error", message: 'Ungültiges Passwort.'}.to_json]
          else
            session[:email] = user.email
            [200, {status: "success"}.to_json]
          end
        end

        app.post "/auth/logout" do
           session[:email] = nil
           204 # No Content
        end

        # JWT endpoint
        app.get "/jwt" do
          # Validate the application.
          app = params[:app]
          url = case app
                when "mvnv2"
                  "https://nv2.mvwuermersheim.de/login"
                else
                  halt 400, slim(:index)
                  return
                end

          user = Models::User.by_email(session[:email])
          groups = user.groups.map(&:name)
          payload = {
            sub: user.email,
            exp: Time.now.to_i + 12 * 3600,
            aud: app,
            groups: groups,
          }
          token = JWT.encode payload, settings.hmac_secret, 'HS256'
          redirect "#{url}##{token}"
        end

      end
    end
  end
end
