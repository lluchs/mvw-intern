module MvwIntern
  module Models
    class Event < Sequel::Model
      plugin :validation_helpers

      def validate
        super
        validates_schema_types [:start]
      end

      # Returns the n next events in the future.
      def self.future(n)
        with_sql('SELECT * FROM events WHERE (start + duration) > NOW() ORDER BY start ASC LIMIT ?', n).all
      end

    end
  end
end
