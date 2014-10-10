require_relative "helper"

describe ActiveRecord::Relation do
  def table(names)
    stub(columns: names.map { |name| stub(name: name) })
  end

  let(:relation) { ActiveRecord::Relation.new(nil, nil) }

  %w(account_id id guid uuid uid id).each do |column_name|
    it "knows that #{column_name} is a scopeable column" do
      relation.stubs(:table => table(['foo', column_name, 'bar']))
      assert relation.send(:arsi_scopeable?)
    end
  end

  %w(android ggguid).each do |column_name|
    it "knows that #{column_name} is not a scopeable column" do
      relation.stubs(:table => table(['foo', column_name, 'bar']))
      refute relation.send(:arsi_scopeable?)
    end
  end
end
