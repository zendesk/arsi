require "test_helper"

class SqlTest < ActiveSupport::TestCase
  fixtures :users

  context "SQL updates" do
    should "fail without an account_id" do
      assert_raise RuntimeError do
        assert User.delete_all(:title => 'hello')
      end

      assert_raise RuntimeError do
        assert User.update_all(:title => 'hello')
      end
    end

    should "not fail with an account_id" do
      assert User.update_all({ :title => 'hello' }, :account_id => 1)
      assert User.delete_all(:account_id => 1)
    end

    should "not fail with an id" do
      assert entries(:ponies).update_attributes(:title => 'hello')
      assert entries(:ponies).destroy
    end

    should "not fail with without_id_check" do
      assert User.without_id_check.update_all(:title => 'hello')
      assert User.without_id_check.delete_all(:title => 'hello')
    end
  end
end
