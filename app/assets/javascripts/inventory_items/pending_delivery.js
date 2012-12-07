(function(){
  CB.inventory_items.pending_delivery = function() {
    new CB.helpers.InventoryContentExpander('product-details');
    new CB.helpers.InventoryContentExpander('delivery-info');
  };
})();
