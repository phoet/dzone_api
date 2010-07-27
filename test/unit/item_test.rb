require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "parse_from_url" do
    items = Item.parse_from_url
    assert_not_nil(items)
  end
end
