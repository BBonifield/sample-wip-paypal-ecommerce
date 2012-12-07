object @inventory_group
attributes :id, :name

node :url do |group|
  group_filtered_inventory_items_path(group)
end
