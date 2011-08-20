require 'test_helper'

class MatterTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Matter.new.valid?
  end
end
