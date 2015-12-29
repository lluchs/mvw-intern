# Authentication helpers
module MvwIntern
  module Helpers
  
    def login?
      !session[:email].nil?
    end

    def current_user
      if login?
        Models::User[email: session[:email]]
      end
    end

    def user_is_admin?
      login? && current_user.admin
    end
  
  end
end
