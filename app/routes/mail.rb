# Mailinglist archive

module MvwIntern
  module Routes
    module Mail
      def self.registered(app)
        
        app.get '/mail' do
          @messages = get_maildir_contents
            .reverse
          slim :mail
        end

        app.get '/mail/*' do
          msg = maildir.get(params[:splat].first)
          halt 404 if msg.nil?
          @mail = msg.data
          @body = extract_mail_body msg.data
          slim :mail_show
        end

      end

    end
  end
end
