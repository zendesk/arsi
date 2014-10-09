require_relative "helper"

describe ActiveRecord::Relation do
  let(:relation) { ActiveRecord::Relation.new(nil, nil) }
  before do

  end
  %w(account_id id guid uuid uid id).each do |column_name|
    it "knows that #{column_name} is a scopeable column" do
      relation.stubs(:arsi_column_names => ['foo', column_name, 'bar'])
      assert relation.send(:arsi_scopeable?)
    end
  end

  %w(android ggguid).each do |column_name|
    it "knows that #{column_name} is not a scopeable column" do
      relation.stubs(:arsi_column_names => ['foo', column_name, 'bar'])
      refute relation.send(:arsi_scopeable?)
    end
  end
end
