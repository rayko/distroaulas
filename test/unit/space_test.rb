require 'test_helper'

class SpaceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Space.new.valid?
  end
end
