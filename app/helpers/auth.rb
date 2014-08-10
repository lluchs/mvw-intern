# Authentication helpers
module MvwIntern
  module Helpers
  
    def login?
      !session[:email].nil?
    end
  
  end
end
