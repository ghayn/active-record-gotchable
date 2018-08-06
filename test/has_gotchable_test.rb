require 'test_helper'

class HasGotchableTest < ActiveSupport::TestCase
  def test_respond_to_gotcha
    assert_equal true, Author.respond_to?(:gotcha)
  end
end
