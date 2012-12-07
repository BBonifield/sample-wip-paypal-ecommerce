(function(){
  CB.inventory_items.index = function() {
    new InventoryForm();
  };


  var InventoryForm = function() {
    this.init();
    this.bindEvents();
  };

  InventoryForm.prototype.init = function(){
    this.disableLowQuantityDecrementLinks();
  };

  InventoryForm.prototype.bindEvents = function(){
    var self = this;
    $('.increment-quantity, .decrement-quantity').on('click', function(e){
      e.preventDefault();
      self.processQuantityUpdateForLink(this);
    });
  };


  // Disable all decrement links that relate to products that
  // currently have a qty of 1
  InventoryForm.prototype.disableLowQuantityDecrementLinks = function(){
    var self = this;
    $('.decrement-quantity').each(function(){
      if ( self.currentQuantityForLink(this) <= 1 ) {
        $(this).addClass('disabled');
      }
    });
  };


  InventoryForm.prototype.processQuantityUpdateForLink = function(link){
    var $link = $(link);

    // Skip clicks on disabled links
    if ( !$(link).is('.disabled') ) {
      var self = this,
          def = $.post($link.attr('href')),
          $qty_label = this.quantityLabelForLink(link);

      def.done(function(json){
        var new_quantity = json.new_quantity;
        $qty_label.text( new_quantity );

        if ( new_quantity <= 1 ) {
          // Link is a decrement link
          $link.addClass('disabled');
        } else {
          // link may or may not be a decrement link
          self.decrementLinkForLink(link).removeClass('disabled');
        }
      });

      def.fail(function(resp){
        alert('Error processing quantity change.')
      });
    }
  }

  InventoryForm.prototype.quantityLabelForLink = function(link) {
    return $(link).closest('.inventory-item').find('.current-quantity');
  };

  InventoryForm.prototype.decrementLinkForLink = function(link) {
    return $(link).closest('.inventory-item').find('.decrement-quantity');
  };

  InventoryForm.prototype.currentQuantityForLink = function(link) {
    return parseInt( this.quantityLabelForLink(link).text(), 10);
  };

})();
