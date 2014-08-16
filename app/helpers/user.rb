# User helpers
module MvwIntern
  module Helpers

    # Tries to convert the given email to a username.
    def email_to_name(email)
      user = Models::User[email: email]
      if user.nil?
        email
      else
        user.name
      end
    end
  
  end
end
