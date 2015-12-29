require 'argon2'

module MvwIntern
  module Models
    class User < Sequel::Model

      def verify_password(password)
        # Users without password may not log in. This is useful for accounts
        # which receive mail, but may not access the website.
        if password.nil?
          false
        else
          Argon2::Password.verify_password(password, self.password)
        end
      end

      def password=(password)
        # Allow deleting a password.
        if password.nil?
          super nil
        else
          super Argon2::Password.hash(password)
        end
      end

    end
  end
end
