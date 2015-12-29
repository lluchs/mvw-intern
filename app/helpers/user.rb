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
  
    def update_user_params(user, params)
      user.name       = params[:name]
      user.email      = params[:email]
      user.instrument = params[:instrument]
      user.birthday   = params[:birthday]
      user.admin      = params[:admin]
    end

  end
end
