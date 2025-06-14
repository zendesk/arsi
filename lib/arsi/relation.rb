require 'active_record'

module Arsi
  module Relation
    attr_writer  :without_arsi

    def without_arsi
      if block_given?
        raise "Use without_arsi in a chain. Don't pass it a block"
      end
      dup.tap(&:without_arsi!)
    end

    def without_arsi!
      @without_arsi = true
    end

    def without_arsi?
      return @without_arsi if defined?(@without_arsi) && @without_arsi
      !arsi_scopeable?
    end

    def delete_all(*)
      with_relation_in_connection { super }
    end

    def update_all(*)
      with_relation_in_connection { super }
    end

    private

    if ActiveRecord.gem_version >= Gem::Version.new("8.0")
      def arsi_scopeable?
        @model.columns.any? { |c| Arsi::SCOPEABLE_REGEX.match?(c.name) }
      end

      def with_relation_in_connection
        @model.connection.arsi_relation = self
        yield
      ensure
        @model.connection.arsi_relation = nil
      end
    else
      def arsi_scopeable?
        @klass.columns.any? { |c| Arsi::SCOPEABLE_REGEX.match?(c.name) }
      end

      def with_relation_in_connection
        @klass.connection.arsi_relation = self
        yield
      ensure
        @klass.connection.arsi_relation = nil
      end
    end
  end
end
