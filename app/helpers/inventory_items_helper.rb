module InventoryItemsHelper
  def user_inventory_groups
    current_user.inventory_groups
  end

  def user_inventory_group_options
    options_with_none(current_user.inventory_groups.map { |g| [g.name, g.id] })
  end
end
