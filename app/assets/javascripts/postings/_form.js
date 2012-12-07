(function(){
  var Form = CB.postings.Form = function() {
    this.bindEvents();
  }

  Form.prototype.bindEvents = function() {
    var self = this;
    $('input[type=file]').on('change', function(){
      self.generatePreview(this);
    });
  }

  Form.prototype.generatePreview = function(file_input) {
    if (file_input.files && file_input.files[0]) {
      try {
        var reader = new FileReader();

        reader.onload = function (e) {
          $('#posting-image')
              .attr('src', e.target.result)
              .width(200);
        };

        reader.readAsDataURL(file_input.files[0]);
      } catch(e) {}
    }
  }

})();
