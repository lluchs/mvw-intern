require 'argon2'

module MvwIntern
  module Models
    class User < Sequel::Model

      # Get user by case-insensitive email.
      def self.by_email(email)
        where('lower(email) = lower(?)', email).first
      end

      def verify_password(password)
        # Users without password may not log in. This is useful for accounts
        # which receive mail, but may not access the website.
        if password.nil?
          false
        else
          hash = self.password
          # Add a version identifier to old password hashes.
          upgrade = false
          if hash.sub! /^\$argon2i\$(?!v=)/, '\0v=16$'
            upgrade = true
          end
          result = Argon2::Password.verify_password(password, hash)
          if upgrade && result
            # This will hash the password with the newer argon2 version.
            self.password = password
            self.save
          end
          result
        end
      end

      def password=(password)
        # Allow deleting a password.
        if password.nil?
          super nil
        else
          super Argon2::Password.create(password)
        end
      end

    end
  end
end
