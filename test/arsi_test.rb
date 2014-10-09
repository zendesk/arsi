require_relative "helper"

describe Arsi do
  it "fail without an account_id" do
    assert_raises Arsi::UnscopedSQL do
      assert User.delete_all(:password => 'hello')
    end

    assert_raises Arsi::UnscopedSQL do
      assert User.update_all(:password => 'hello')
    end
  end

  it "not fail with an account_id" do
    assert User.where(account_id: 1).update_all(:password => 'hello' )
    assert User.delete_all(account_id: 1)
  end

  it "not fail with an id" do
    e = Entry.create!(:title => 'test')
    assert e.update_attributes(:title => 'hello')
    assert e.destroy
  end

  it "not fail with without_arsi" do
    assert User.without_arsi.update_all(:password => 'hello')
    assert User.without_arsi.delete_all(:password => 'hello')
  end

  it "does not modify relations with without_arsi" do
    relation = User.where("1=1")
    relation.without_arsi

    refute relation.without_arsi?
  end

  it "does not allow columns ending with id" do
    assert_raises Arsi::UnscopedSQL do
      assert User.delete_all(:android => 5)
    end
  end

  it "does not allow a simple delete ending with id" do
    assert_raises Arsi::UnscopedSQL do
      assert User.connection.delete("delete from users where android = 5")
    end
  end

  it "allows a unqouted id column" do
    assert User.delete_all("id = -1")
  end

  it "allows a simple delete with an id" do
    assert User.connection.delete("delete from users where id = -1")
  end

  it "allows guid column" do
    assert User.delete_all(:guid => 5)
  end

  it "allows uuid columns" do
    assert User.delete_all(:uuid => 5)
  end

  it "allows uid columns" do
    assert User.delete_all(:uid => 5)
  end

  it "does not persist changes to the connection" do
    assert User.without_arsi.update_all(:password => 'hello')
    assert_raises Arsi::UnscopedSQL do
      assert User.connection.delete("delete from users where false;")
    end
  end

  it "allows ActiveRecord::Base#columns" do
    assert User.columns
  end

  it "has info in the violations callback" do
    assert_with_violations_callback do |sql, relation|
      assert sql
      assert relation
    end
  end

  it "can be disabled" do
    Arsi.disable do
      assert User.delete_all(:password => 'hello')
    end
  end

  it "ignores tables without a scopeable column" do
    assert Migration.delete_all
  end

  # it "should not use update values as scoping columns" do
  #   assert_raises Arsi::UnscopedSQL do
  #     assert User.where("1=0").update_all(:account_id => 5)
  #   end
  # end

  def assert_with_violations_callback(&block)
    old, Arsi.violation_callback = Arsi.violation_callback, block
    assert User.delete_all(:password => 'hello')
  ensure
    Arsi.violation_callback = old
  end
end
