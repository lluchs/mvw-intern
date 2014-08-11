# Persona authentication routes

require 'json'
require 'rest-client'

module MvwIntern
  module Routes
    def self.registered(app)

      app.post "/auth/login" do
        # check assertion with a request to the verifier
        response = nil
        if params[:assertion]
          restclient_url = "https://verifier.login.persona.org/verify"
          restclient_params = {
            :assertion => params["assertion"],
            :audience  => settings.persona_audience,
          }
          response = JSON.parse(RestClient::Resource.new(restclient_url, :verify_ssl => true).post(restclient_params))
        end

        # create a session if assertion is valid
        if response["status"] == "okay"
          # Check whether we have a user with the given email address.
          email = response["email"]
          if Models::User[email: email].nil?
            [403, {status: "error", message: 'Es gibt keinen Nutzer mit dieser E-Mail-Adresse.'}.to_json]
          else
            session[:email] = email
            response.to_json
          end
        else
          [403, response.to_json]
        end
      end

      app.post "/auth/logout" do
         session[:email] = nil
         204 # No Content
      end

    end
  end
end
