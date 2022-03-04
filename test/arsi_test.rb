require_relative "helper"
SingleCov.covered! uncovered: 2

describe Arsi do
  def with_arsi_disabled
    Arsi.disable!
    yield
  ensure
    Arsi.enable!
  end

  it "works with has_one relationship" do
    user = User.create!(name: "Benjamin")
    user.create_head!

    # Change an attribute on the has_one relation and then save it
    user.head.nose_count = 1
    user.head.save!
  end

  it "fail without an account_id" do
    assert_raises Arsi::UnscopedSQL do
      assert User.where(:password => 'hello').delete_all
    end

    assert_raises Arsi::UnscopedSQL do
      assert User.update_all(:password => 'hello')
    end
  end

  it "not fail with an account_id" do
    assert User.where(account_id: 1).update_all(:password => 'hello' )
    assert User.where(account_id: 1).delete_all
  end

  it "not fail with an id" do
    e = Entry.create!(:title => 'test')
    assert e.update_attributes(:title => 'hello')
    assert e.destroy
  end

  it "not fail with without_arsi" do
    assert User.without_arsi.update_all(:password => 'hello')
    assert User.without_arsi.where(:password => 'hello').delete_all
  end

  it "does not modify relations with without_arsi" do
    relation = User.where("1=1")
    relation.without_arsi

    refute relation.without_arsi?
  end

  it "does not allow columns ending with id" do
    assert_raises Arsi::UnscopedSQL do
      assert User.where(:android => 5).delete_all
    end
  end

  it "does not allow a simple delete ending with id" do
    assert_raises Arsi::UnscopedSQL do
      assert User.connection.delete("delete from users where android = 5")
    end
  end

  it "allows a unqouted id column" do
    assert User.where("id = -1").delete_all
  end

  it "allows a simple delete with an id" do
    assert User.connection.delete("delete from users where id = -1")
  end

  it "allows guid column" do
    assert User.where(:guid => 5).delete_all
  end

  it "allows uuid columns" do
    assert User.where(:uuid => 5).delete_all
  end

  it "allows uid columns" do
    assert User.where(:uid => 5).delete_all
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

  it "does not call sql_check if disabled" do
    with_arsi_disabled do
      Arsi::UnscopedSQL.expects(:sql_check!).never
      assert User.where(:password => 'hello').delete_all
    end
  end

  it "can be disabled in a block" do
    Arsi.disable do
      assert User.where(:password => 'hello').delete_all
    end
    assert Arsi.enabled
  end

  it "can be enabled in a block" do
    with_arsi_disabled do
      Arsi.enable do
        assert User.where(id: 1, :password => 'hello').delete_all
      end
      refute Arsi.enabled
    end
  end

  it "ignores tables without a scopeable column" do
    assert Migration.delete_all
  end

  it "prevents frustration when using without_arsi" do
    assert_raises(RuntimeError) { User.without_arsi { User.delete_all } }
  end

  # it "should not use update values as scoping columns" do
  #   assert_raises Arsi::UnscopedSQL do
  #     assert User.where("1=0").update_all(:account_id => 5)
  #   end
  # end

  def assert_with_violations_callback(&block)
    old, Arsi.violation_callback = Arsi.violation_callback, block
    assert User.where(:password => 'hello').delete_all
  ensure
    Arsi.violation_callback = old
  end
end
