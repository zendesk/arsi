require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  should "have 4 users" do
    assert_equal 4, User.count
  end
end
