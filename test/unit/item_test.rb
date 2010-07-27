require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "parse_from_url" do
    mash = Item.parse_from_url
    assert_not_nil(mash)
  end
end
