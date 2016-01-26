# User helpers
module MvwIntern
  module Helpers

    # Tries to convert the given email to a username.
    def email_to_name(email)
      user = Models::User.by_email(email)
      if user.nil?
        email
      else
        user.name
      end
    end
  
    # Updates a user object from form parameters.
    def update_user_params(user, params)
      user.name       = params[:name]
      user.email      = params[:email]
      user.instrument = params[:instrument]
      user.birthday   = params[:birthday]
      user.admin      = params[:admin]

      if params[:reset_password] == 'on'
        reset_user_password(user)
      end
    end

    # Resets a user's password to their birthday.
    def reset_user_password(user)
      if user.birthday.nil?
        # No birthday => delete password
        user.password = nil
      else
        user.password = user.birthday.strftime('%d.%m.%Y')
      end
    end

  end
end
