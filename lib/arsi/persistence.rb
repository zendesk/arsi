module Arsi
  module Persistence
    def self.prepended(klass)
      klass.singleton_class.prepend(ClassMethods)
    end

    module ClassMethods
      def _update_record(*)
        with_relation_in_connection { super }
      end

      def _delete_record(*)
        with_relation_in_connection { super }
      end

      private

      def with_relation_in_connection
        connection.arsi_relation = self.unscoped
        yield
      ensure
        connection.arsi_relation = nil
      end
    end
  end
end
