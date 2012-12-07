(function(){
  CB.orders.purchase_complete = function(){
    $('#print-receipt').on('click', function(e){
      e.preventDefault();
      window.print();
    });

    new CB.helpers.InventoryContentExpander('product-details');
  };
})();
