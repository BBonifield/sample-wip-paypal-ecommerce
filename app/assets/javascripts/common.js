(function(){

  CB.common.init = function() {
    new SearchHeader();
    new PrimaryNavigation();
    new InventorySidebar();
  };


  /**
   * Site header search functionality
   */
  function SearchHeader(){
    this.events();
  }

  SearchHeader.prototype.events = function(){
    var self = this;
    $('#search-header .dropdown-menu a').on('click', function(e){
      e.preventDefault();
      self.updateSearchCategory(this);
    });
  };
  SearchHeader.prototype.updateSearchCategory = function(category_link){
    var $category_link = $(category_link),
        $dropdown_button = $category_link.closest('.btn-group').find('.dropdown-toggle');

    $dropdown_button.html( this.dropdownHtmlForLink($category_link) );
  };
  SearchHeader.prototype.dropdownHtmlForLink = function($link){
    return $link.text() + ' <span class="caret"></span>';
  };


  /**
   * Primary navigation dropdowns
   */
  function PrimaryNavigation(){
    this.events();
  }

  PrimaryNavigation.prototype.events = function(){
    var self = this;
    // handle togglable navigation dropdowns
    $('#primary-navigation li > a[data-toggle]').on('click', function(e){
      e.preventDefault();
      self.toggleDropdown( this );
    });

    // hide togglable dropdowns on resize
    $(window).on('resize', _.throttle(self.closeAllDropdowns, 100));
  };

  PrimaryNavigation.prototype.toggleDropdown = function(nav_link){
    var $nav_link = $(nav_link),
        dropdown_selector = $nav_link.data('toggle'),
        $dropdown = $(dropdown_selector);

    if ( $dropdown.is(':visible') ) {
      $dropdown.hide();
    } else {
      // lock the top of the dropdown to the bottom of the navbar-inner
      var $navbar_inner = $nav_link.closest('.navbar-inner');
      var dropdown_top = $navbar_inner.offset().top + $navbar_inner.height();

      // decide whether the block should be locked left or locked right
      var nav_link_is_right_aligned = $nav_link.closest('li').is('.pull-right'),
          nav_link_left = $nav_link.offset().left,
          dropdown_width = $dropdown.width(),
          dropdown_left = 0;

      if ( nav_link_is_right_aligned ) {
        // lock to the right
        nav_link_width = $nav_link.innerWidth();
        dropdown_left = nav_link_left - dropdown_width + nav_link_width;
      } else {
        // lock to the left
        dropdown_left = nav_link_left;
      }

      $dropdown.css({ top: dropdown_top, left: dropdown_left }).show();
    }
  };

  PrimaryNavigation.prototype.closeAllDropdowns = function(){
    $('.navigation-dropdown:visible').hide();
  };


  /**
   * Inventory Groups Sidebar
   */
  function InventorySidebar(){
    this.init();
    this.events();
  }

  InventorySidebar.prototype.init = function(){
    this.$new_inventory_group_link = $('#new_inventory_group_link')
    this.$new_inventory_group_link_container = this.$new_inventory_group_link.parent();
  };

  InventorySidebar.prototype.events = function(){
    var self = this;
    self.$new_inventory_group_link.on('click', function(e){
      e.preventDefault();
      self.showAddNewInventoryGroupBlock();
    });
  };

  InventorySidebar.prototype.showAddNewInventoryGroupBlock = function(){
    var self = this;

    // hide the new link while the new form is open
    self.$new_inventory_group_link_container.hide();

    // show the new form
    self.$new_inventory_group_link_container.after( JST['inventory_groups/new']() );
    $('#new_inventory_group_form').on('submit', function(e){
      e.preventDefault();
      self.createNewInventoryGroup(this);
    });
  };

  InventorySidebar.prototype.createNewInventoryGroup = function(new_form){
    var data = { inventory_group: { name: $('input[name=name]', new_form).val() } },
        url = this.$new_inventory_group_link.data('create-url'),
        self = this;

    $.post(url, data).success(function(response_data){
      // group saved
      self.addInventoryGroupRow(response_data);
      self.inventoryGroupAdditionComplete();
    }).error(function(resp){
      var response_data = JSON.parse(resp.responseText);
      alert(response_data.errors.join("\n"));
    });
  };

  InventorySidebar.prototype.addInventoryGroupRow = function(group_data){
    var group_row = JST['inventory_groups/show'](group_data);
    this.$new_inventory_group_link_container.before(group_row);
  };

  InventorySidebar.prototype.inventoryGroupAdditionComplete = function(){
    // remove the form row
    $('#new_inventory_group_form').parent().remove();
    // show the add row
    this.$new_inventory_group_link_container.show();
  };


})();
