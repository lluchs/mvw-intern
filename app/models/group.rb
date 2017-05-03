
module MvwIntern
  module Models
    class Group < Sequel::Model

      many_to_many :users

    end
  end
end
