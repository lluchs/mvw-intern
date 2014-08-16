# Mailinglist archive

module MvwIntern
  module Routes
    module Mail
      def self.registered(app)
        
        app.get '/mail' do
          @mails = get_maildir_contents
            .map { |mail| mail.data }
            .reverse
          slim :mail
        end

      end
    end
  end
end
