module Arsi::ArelTreeManager
  def failed_id_check?
    return false unless Rails.env.test?

    attrs = @ctx.wheres.flat_map do |where|
      get_all_where_attributes(where)
    end

    attrs.none? {|attr| attr == true || attr.to_s.end_with?('id', '_id')}
  end

  private

  def get_all_where_attributes(ast)
    if ast.is_a?(Arel::Nodes::Equality)
      ast.left.name
    elsif ast.respond_to?(:children)
      ast.children.flat_map do |child|
        get_all_where_attributes(child)
      end
    elsif ast.respond_to?(:expr)
      get_all_where_attributes(ast.expr)
    elsif ast.is_a?(String)
      !!(ast =~ /`?_?id`? (=|<>|IN|IS)/i)
    end
  end

end
