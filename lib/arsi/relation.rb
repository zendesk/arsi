module Arsi
  module Relation
    attr_accessor :without_arsi

    def without_arsi
      dup.tap(&:without_arsi!)
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

    def self.prepended(base)
      base.class_eval do
        alias_method :update_all_without_arsi, :update_all
        def update_all(*args)
          with_relation_in_connection { update_all_without_arsi(*args) }
        end
      end
    end

    private

    def arsi_scopeable?
      table.columns.map(&:name).any? { |c| c =~ Arsi::SCOPEABLE_REGEX }
    end

    def with_relation_in_connection
      @klass.connection.arsi_relation = self
      yield
    ensure
      @klass.connection.arsi_relation = nil
    end
  end
end
