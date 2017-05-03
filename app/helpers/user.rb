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
      user.active     = params[:active] == 'on'
      user.admin      = params[:admin]

      # Update groups from <select multiple>
      current_groups = user.groups
      wanted_groups = Models::Group.where(id: params[:groups]).all
      (current_groups - wanted_groups).each do |g|
        user.remove_group(g)
      end
      (wanted_groups - current_groups).each do |g|
        user.add_group(g)
      end

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
