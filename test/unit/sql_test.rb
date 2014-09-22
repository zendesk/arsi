require_relative "../helper"

class SqlTest < ActiveSupport::TestCase
  class RestrictedUser < User
    #arsi(:require => :account_id, /account_id/)
  end

  def setup
  end

  def teardown
    User
  end

  def test_sql_updates_should_fail_without_an_account_id
    assert_raise RuntimeError do
      assert RestrictedUser.delete_all(:title => 'hello')
    end

    assert_raise RuntimeError do
      assert RestrictedUser.update_all(:title => 'hello')
    end
  end

  def test_sql_updates_should_not_fail_with_an_account_id
    assert RestrictedUser.update_all({ :title => 'hello' }, :account_id => 1)
    assert RestrictedUser.delete_all(:account_id => 1)
  end

  def test_sql_update_should_not_fail_with_an_account_id
    assert entries(:ponies).update_attributes(:title => 'hello')
    assert entries(:ponies).destroy
  end

  def test_should_not_fail_with_without_id_check
    assert RestrictedUser.without_id_check.update_all(:title => 'hello')
    assert RestrictedUser.without_id_check.delete_all(:title => 'hello')
  end
end
