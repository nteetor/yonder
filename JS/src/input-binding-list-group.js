$(document).ready(function() {
  $(".dull-list-group-input[id]").on("click", ".list-group-item:not(.disabled)", function(e) {
    e.preventDefault();

    var $this = $(this);
    $this.toggleClass("active");
    $this.trigger("change");
  });
});

var listGroupInputBinding = new Shiny.InputBinding();

$.extend(listGroupInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-list-group-input[id]");
  },
  getValue: function(el) {
    var $val = $(el)
      .children(".list-group-item.active:not(:disabled)")
      .map(function(i, e) {
        return $(e).data("value");
      })
      .get();
    return $val === undefined ? null : $val;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.listGroupInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".listGroupInputBinding");
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

    if (data.items !== undefined) {
      $el.find(".list-group-item").remove();
      if ($el.children().length !== 0) {
        $el.children().first().prepend(data.items);
      } else {
        $el.html(data.items);
      }
    }

    if (data.state !== undefined) {
      var state = data.state === "valid" ? null : "list-group-item-" + data.state;

      if (data.filter !== null) {
        $.each(data.filter, function(i, v) {
          $el.find(".list-group-item[data-value=\"" + v + "\"]")
            .attr("class", function(i, c) {
              return c.replace(/list-group-item-(success|info|warning|danger)/g, "");
            })
            .addClass(state);
        });
      } else {
        $el.find(".list-group-item")
          .attr("class", function(i, c) {
            return c.replace(/list-group-item-(success|info|warning|danger)/g, "");
          })
          .addClass(state);
      }
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(listGroupInputBinding, "dull.listGroupInput");
