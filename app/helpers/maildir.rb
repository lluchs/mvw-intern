# Maildir helpers

require 'mail'
require 'maildir'

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
  
  end
end
