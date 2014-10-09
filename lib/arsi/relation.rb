module Arsi
  module Relation
    attr_accessor :without_arsi

    def without_arsi
      dup = self.dup
      dup.without_arsi!
      dup
    end

    def without_arsi!
      @without_arsi = true
    end

    def without_arsi?
      @without_arsi || !arsi_scopeable?
    end

    def delete_all(*)
      with_relation_in_connection { super }
    end

    def update_all(*)
      with_relation_in_connection { super }
    end

    private
    SCOPEABLE_REGEX = /(^|_)(gu|uu|u)?id$/i # see http://rubular.com/r/hPVpG9jyoC
    def arsi_scopeable?
      arsi_column_names.any? { |c| c =~ SCOPEABLE_REGEX }
    end

    def arsi_column_names
      table.columns.map(&:name)
    end

    def with_relation_in_connection
      @klass.connection.arsi_relation = self
      yield
    ensure
      @klass.connection.arsi_relation = nil
    end
  end
end
