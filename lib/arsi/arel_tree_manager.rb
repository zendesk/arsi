require 'arel'

module Arsi
  module ArelTreeManager
    # This is inspired from Arel::SelectManager, a subclass of Arel::TreeManager
    # just like Arel::UpdateManager and Arel::DeleteManager.
    def where_sql(engine = ::Arel::Table.engine)
      return if @ast.wheres.empty?

      ::Arel::Nodes::SqlLiteral.new("WHERE #{::Arel::Nodes::And.new(@ast.wheres).to_sql(engine)}")
    end
  end
end
