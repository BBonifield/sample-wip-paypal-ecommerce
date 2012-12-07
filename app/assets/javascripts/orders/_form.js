(function(){
  var Form = CB.orders.Form = function(){
    this.init();
    this.bindEvents();
  };

  Form.prototype.init = function(){
    // Utilize an additional helper for the inventory block
    new CB.helpers.InventoryContentExpander('product-details');

    this.$addressSelect = $('#order_shipping_address_id');
    this.$addressPreview = $('.address-preview');
    this.$addressName = $('.address-name');
    this.$addressLines = $('.address-lines');
    this.$addressForm = $('.address-form');
    this.$addAddressModal = $('.address-form-modal');
  };

  Form.prototype.bindEvents = function(){
    var self = this;

    self.$addressSelect.on('change', function(e){
      self.updateAddressPreview();
    });
    // trigger change on load to setup UI if address selected on load
    self.$addressSelect.trigger('change');

    // open address form
    $('.add-new-address').on('click', function(e){
      e.preventDefault();
      self.showAddAddressModal();
    });

    // create addresses
    this.$addressForm.on('submit', function(e){
      e.preventDefault();
      self.createAddress();
    });

    // prevent double submission
    $('#paypal_checkout').on('click', function(e){
      if ( $(this).is('.disabled') ) {
        e.preventDefault();
      } else {
        $(this).addClass('disabled');
      }
    });
  };

  Form.prototype.updateAddressPreview = function(){
    var address_id = this.$addressSelect.val();

    if ( address_id ) {
      var self = this,
          def = $.getJSON('/account/addresses/' + address_id);

      def.done(function(resp){
        self.$addressName.html( resp.name );
        self.$addressLines.html( resp.address_lines.join("<br/>") );
        self.$addressPreview.show();
      });
      def.fail(function(){
        alert('Failed to retrieve address data.');
      });
    }
  };


  Form.prototype.showAddAddressModal = function(){
    this.$addAddressModal.modal('show');
  };

  Form.prototype.hideAddAddressModal = function(){
    this.$addAddressModal.modal('hide');
  };


  Form.prototype.createAddress = function(){
    var target = this.$addressForm.attr('action'),
        data = this.$addressForm.serialize(),
        self = this;

    var def = $.post(target, data, { dataType: "JSON" });

    def.done(function(resp){
      self.addAddressToListAndSelect(resp.name, resp.id);
      self.hideAddAddressModal();
    });
    def.fail(function(resp){
      self.handleAddressErrors(resp);
    });
  };

  Form.prototype.addAddressToListAndSelect = function(name, id){
    var new_option = $('<option/>', { value: id }).text(name);
    this.$addressSelect
      .append( new_option ).val( id )
      .trigger('change');
  };

  Form.prototype.handleAddressErrors = function(resp){
    var errors;
    try {
      errors = JSON.parse(resp.responseText);
    } catch(e) {
      errors = ['Failed to decode errors']
    }

    alert( "Unable to save address:\n - " + errors.join("\n - ") );
  };

})();
