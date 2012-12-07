(function(){

  // Helper class to initialize product details expander
  //
  // Assumes a few things
  //    1. There is an element classed 'expander-container' that the expanded
  //       class should be applied to.
  //    2. There is a show-{class_suffix} link to expand the hidden content
  //    3. There is a hide-{class_suffix} link to hide the hidden content
  //    4. There will be a expanded-{class_suffix} class that is either
  //       applied to or removed from the container when the content is
  //       hidden or shown.
  //
  //    EX: show-product-details, hide-product-details, expanded-product-details
  //
  var Expander = CB.helpers.InventoryContentExpander = function(class_suffix){
    this.showClass = 'show-' + class_suffix;
    this.hideClass = 'hide-' + class_suffix;
    this.expandedClass = 'expanded-' + class_suffix;

    this.bindEvents();
  };

  Expander.prototype.bindEvents = function(){
    var self = this;
    $('.' + self.showClass).on('click', function(e){
      e.preventDefault();
      var $container = self.$containerForLink(this);
      $container.addClass(self.expandedClass);

      // remove all "other" expanded classes (e.g. if the same
      // block can have two different types of expanded content)
      _.each($container.attr('class').split(' '), function(container_class){
        if ( container_class.match(/^expanded\-/) && container_class != self.expandedClass ) {
          $container.removeClass(container_class);
        }
      });
    });
    $('.' + self.hideClass).on('click', function(e){
      e.preventDefault();
      self.$containerForLink(this).removeClass(self.expandedClass);
    });
  };

  Expander.prototype.$containerForLink = function(link){
    return $(link).closest('.expander-container');
  };

})();
