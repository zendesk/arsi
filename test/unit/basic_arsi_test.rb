require_relative '../helper'
class BasicArsiTest < ActiveSupport::TestCase

  def test_user_count
    assert_equal 4, User.count
  end

end

