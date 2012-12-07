(function(){
  var Form = CB.seller_orders.Form = function() {
    this.init();
    this.bindEvents();
  }

  Form.prototype.init = function() {
    this.$sendShippingNotificationCheckbox = $('.send-shipping-notification');
    this.$formContainer = $('#shipping-notification-form-container');
    this.$submitButton = this.$formContainer.closest('form').find(':submit');

    this.showHideNotificationForm();
  }

  Form.prototype.bindEvents = function() {
    var self = this;
    self.$sendShippingNotificationCheckbox.on('change', function(){
      self.showHideNotificationForm();
    });
  };

  Form.prototype.showHideNotificationForm = function() {
    var action, new_text;
    if ( this.$sendShippingNotificationCheckbox.is(':checked') ) {
      action = 'show';
      new_text = this.$submitButton.data('send-notification-text');
    } else {
      action = 'hide';
      new_text = this.$submitButton.data('no-notification-text');
    }
    this.$formContainer[action]('fast');
    this.$submitButton.text( new_text );
  };

})();
