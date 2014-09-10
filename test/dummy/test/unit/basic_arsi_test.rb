require 'test_helper'

class BasicArisiTest < ActiveSupport::TestCase
  should "have 4 users" do
    assert_equal 4, User.count
  end
end
