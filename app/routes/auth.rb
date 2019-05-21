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

        # Discourse SSO endpoint
        app.get "/sso" do
          sso = params['sso']
          sig = params['sig']
          if sso.nil? || sig.nil? || OpenSSL::HMAC.hexdigest("sha256", settings.hmac_secret, sso) != sig
            halt 400, "Invalid SSO payload"
            return
          else
            base64_sso = URI.unescape(sso)
            decoded_sso = Base64.decode64(base64_sso)
            params = Rack::Utils.parse_nested_query(decoded_sso)
            nonce = params['nonce']
            return_sso_url = URI(params['return_sso_url'])

            user = Models::User.by_email(session[:email])
            groups = user.groups.map(&:name)
            payload = {
              "nonce" => nonce,
              "name" => user.name,
              "external_id" => user.id,
              "email" => user.email,
              "username" => user.name,
              "groups" => groups.join(','),
            }

            payload["admin"] = true if user.admin

            payload = Rack::Utils.build_query(payload)
            base64_payload = Base64.strict_encode64(payload)
            encoded_payload = URI.escape(base64_payload)
            new_sig = OpenSSL::HMAC.hexdigest("sha256", settings.hmac_secret, base64_payload)
            q = "sso=#{encoded_payload}&sig=#{new_sig}"
            if return_sso_url.query.nil?
              return_sso_url.query = q
            else
              return_sso_url.query += "&#{q}"
            end
            redirect return_sso_url.to_s
          end
        end

      end
    end
  end
end
