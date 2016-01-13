# Maildir helpers

require 'mail'
require 'maildir'
require 'sanitize'

module MvwIntern
  module Helpers
  
    def maildir
      if @maildir.nil?
        @maildir = Maildir.new(settings.maildir, false)
        @maildir.serializer = Maildir::Serializer::Mail.new
      end
      @maildir
    end

    def get_maildir_contents
      maildir.list(:new)
    end

    # Sanitizes the given mail body.
    def sanitize_mail(mail)
      if mail.content_type.start_with? 'text/html'
        html = mail.body.decoded.encode('utf-8', mail.charset)
        Sanitize.fragment(html, Sanitize::Config.merge(Sanitize::Config::BASIC,
          remove_contents: ['style']
        ))
      else
        Rack::Utils.escape_html(mail.body.decoded)
      end
    end

    # Tries to find mail parts in the given order.
    def find_mail_part(mail, types)
      types.each do |type|
        part = mail.parts.find { |p| p.content_type.start_with? type }
        return part unless part.nil?
      end
      # No part found.
      nil
    end

    # Tries to extract a body from the given mail, preferring HTML.
    def extract_mail_body(mail)
      if mail.multipart?
        # Try to find an HTML part.
        part = find_mail_part(mail, ['text/html', 'text/plain'])
        if part.nil?
          '<em>Nachricht kann leider nicht angezeigt werden.</em>'
        else
          sanitize_mail part
        end
      else
        sanitize_mail mail
      end
    end
  
  end
end
