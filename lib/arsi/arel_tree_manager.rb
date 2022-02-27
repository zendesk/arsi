require 'arel'

module Arsi
  module ArelTreeManager
    AREL_WHERE_SQL_ARITY_1 = ::Arel::VERSION[0].to_i < 7
    AREL_WHERE_SQL_ENGINE_ACCESSOR = ::Arel::VERSION[0].to_i < 9

    # This is from Arel::SelectManager which inherits from Arel::TreeManager.
    # We need where_sql on both Arel::UpdateManager and Arel::DeleteManager so we add it to the parent class.
    def where_sql(provided_engine)
      return if @ctx.wheres.empty?

      selected_engine = provided_engine
      if selected_engine.nil?
        selected_engine = if AREL_WHERE_SQL_ENGINE_ACCESSOR
          self.engine || ::Arel::Table.engine
        else
          Arel::Table.engine
        end
      end

      viz = if AREL_WHERE_SQL_ARITY_1
        ::Arel::Visitors::WhereSql.new selected_engine.connection
      else
        ::Arel::Visitors::WhereSql.new(selected_engine.connection.visitor, selected_engine.connection)
      end
      ::Arel::Nodes::SqlLiteral.new viz.accept(@ctx, ::Arel::Collectors::SQLString.new).value
    end
  end
end
