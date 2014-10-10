module MvwIntern
  module Models
    class Event < Sequel::Model
      plugin :validation_helpers

      def validate
        super
        validates_schema_types [:start, :end]
        errors.add(:end, 'must be after start') if self.end < self.start
      end

    end
  end
end
