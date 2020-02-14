require 'arel'

module Arsi
  module ArelTreeManager
    # This is from Arel::SelectManager which inherits from Arel::TreeManager.
    # We need where_sql on both Arel::UpdateManager and Arel::DeleteManager so we add it to the parent class.
    def where_sql(provided_engine = :none)
      return if @ctx.wheres.empty?

      selected_engine = provided_engine
      if selected_engine == :none
        # Arel 9 has no engine reader
        selected_engine = if self.respond_to?(:engine)
          self.engine || Arel::Table.engine
        else
          Arel::Table.engine
        end
      end

      viz = if ::Arel::Visitors::WhereSql.instance_method(:initialize).arity == 1
        ::Arel::Visitors::WhereSql.new selected_engine.connection
      else
        ::Arel::Visitors::WhereSql.new(selected_engine.connection.visitor, selected_engine.connection)
      end
      ::Arel::Nodes::SqlLiteral.new viz.accept(@ctx, ::Arel::Collectors::SQLString.new).value
    end
  end
end
