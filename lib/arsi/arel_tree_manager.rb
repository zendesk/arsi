module Arsi
  module ArelTreeManager
    # This is from Arel::SelectManager which inherits from Arel::TreeManager.
    # We need where_sql on both Arel::UpdateManager and Arel::DeleteManager so we add it to the parent class.
    def where_sql
      return if @ctx.wheres.empty?
      viz = Arel::Visitors::WhereSql.new @engine.connection
      Arel::Nodes::SqlLiteral.new viz.accept @ctx
    end
  end
end
