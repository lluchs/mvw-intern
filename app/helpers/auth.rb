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
  
  end
end
