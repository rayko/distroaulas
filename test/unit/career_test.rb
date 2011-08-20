require 'test_helper'

class CareerTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Career.new.valid?
  end
end
