require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "frontpage_items" do
    items = Item.frontpage_items
    assert_not_nil(items)
  end
end
