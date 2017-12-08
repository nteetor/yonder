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
        $el.children().first().before(data.items);
      } else {
        $el.html(data.items);
      }
    }

    if (data.disable) {
      if (data.disable === true) {
        $el.find(".list-group-item").each(function(i, e) {
          $(e).prop("disabled", true);
        });
      } else {
        $.each(data.disable, function(i, v) {
          $el.find(".list-group-item[data-value=\"" + v + "\"]")
            .prop("disabled", true);
        });
      }
    }

    if (data.enable) {
      if (data.enable === true) {
        $el.find(".list-group-item").each(function(i, e) {
          $(e).prop("disabled", false);
        });
      } else {
        $.each(data.enable, function(i, v) {
          $el.find(".list-group-item[data-value=\"" + v + "\"]")
            .prop("disabled", false);
        });
      }
    }

    if (data.increment) {
      if (data.increment === true) {
        var $badge = $el.find(".list-group-item .badge");

        if ($badge.length !== 0) {
          $badge.each(function(i, e) {
            $(e).text(parseInt($(e).text(), 10) + 1);
          });
        }
      } else {
        $.each(data.increment, function(i, v) {
          var $badge = $el.find(".list-group-item[data-value=\"" + v + "\"] .badge");

          if ($badge.length !== 0) {
            $badge.text(parseInt($badge.text(), 10) + 1);
          }
        });
      }
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(listGroupInputBinding, "dull.listGroupInput");
