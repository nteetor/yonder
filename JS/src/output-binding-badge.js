var badgeOutputBinding = new Shiny.OutputBinding();

$.extend(badgeOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-badge[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
    var $el = $(el);
    $el.text(data.value);

    if (data.context) {
      var conClass = "badge-" + data.context;

      if (!$el.hasClass(conClass)) {
        this._removeContextClasses(el);
        $el.addClass(conClass);
      }
    }

    return false;
  },
/*  renderError: function(el, err) {
    var $el = $(el);
    this._removeContextClasses(el);

    $el.addClass("badge-danger");
    this.prevText = $el.text();
    $el.text("*");

    return false;
  },
  clearError: function(el) {
    var $el = $(el);
    $el.removeClass("badge-danger");
    $el.addClass("badge-default");
    $el.text(this.prevText);
    this.prevText = null;

    return false;
  },*/
  _removeContextClasses: function(el) {
    var $el = $(el);
    $el.attr("class", function(i, c) {
      return c.replace(
        /badge-(default|primary|success|info|warning|danger)/g,
        ""
      );
    });
  }
});

Shiny.outputBindings.register(badgeOutputBinding, "dull.badgeOutput");
