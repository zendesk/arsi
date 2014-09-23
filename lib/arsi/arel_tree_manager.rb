module Arsi::ArelTreeManager
  # copied from Arel::SelectManager
  def where_sql
    return if @ctx.wheres.empty?
    viz = Arel::Visitors::WhereSql.new @engine.connection
    Arel::Nodes::SqlLiteral.new viz.accept @ctx
  end
end
