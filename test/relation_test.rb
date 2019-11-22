require_relative "helper"

describe ActiveRecord::Relation do
  let(:relation) {
    if ActiveRecord.gem_version >= Gem::Version.new("5.2")
      ActiveRecord::Relation.new(klass, table: stub, predicate_builder: stub)
    elsif ActiveRecord::VERSION::MAJOR > 4
      ActiveRecord::Relation.new(klass, stub, stub)
    else
      ActiveRecord::Relation.new(klass, stub)
    end
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
