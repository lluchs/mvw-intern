# Persona authentication routes

require 'json'
require 'rest-client'

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

      end
    end
  end
end
