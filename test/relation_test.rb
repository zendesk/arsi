require_relative "helper"
SingleCov.covered! file: 'lib/arsi/relation.rb', uncovered: 1

describe ActiveRecord::Relation do
  let(:relation) {
    ActiveRecord::Relation.new(klass, table: stub, predicate_builder: stub)
  }
  let(:klass) { stub(name: 'Klass') }

  %w(account_id id guid uuid uid id).each do |column_name|
    it "knows that #{column_name} is a scopeable column" do
      klass.stubs(columns: [stub(name: column_name)])
      assert relation.send(:arsi_scopeable?)
    end
  end

  %w(android ggguid).each do |column_name|
    it "knows that #{column_name} is not a scopeable column" do
      klass.stubs(columns: [stub(name: column_name)])
      refute relation.send(:arsi_scopeable?)
    end
  end
end
