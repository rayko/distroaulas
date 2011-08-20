require 'test_helper'

class SpaceTypeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert SpaceType.new.valid?
  end
end
