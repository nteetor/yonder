var alertInputBinding = new Shiny.InputBinding();

$(() => $("body").append(
  $("<div class='dull-alert-container' id='alert-container'></div>")
));

$.extend(alertInputBinding, {
  Selector: {
    SELF: ".dull-alert-container"
  },
  Alerts: [],
  getValue: function(el) {
    return null;
  },
  subscribe: function(el, callback) {

  },
  unsubscribe: function(el) {

  },
  receiveMessage: function(el, data) {
    let alertAttrs = data.attrs || {};
    let alertClass = data.color ? `alert-${ data.color }` : "";

    let $alert = $(`<div class="alert ${ alertClass } fade show dull-alert" role="alert">${ data.text }</div>`);

    if (data.action) {
      $alert.append($(`<button class="btn btn-link alert-action">${ data.action }</button>`));
      $alert.on("click", ".alert-action", (e) => {
        Shiny.onInputChange(data.action, true);
      });
    }

    Object.entries(alertAttrs).forEach((item) => {
      item[0] == "class" ? $alert.addClass(item[1]) : $alert.attr(...item);
    });

    this.Alerts.push({ el: $alert, action: data.action });

    $alert.appendTo($(this.Selector.SELF))
      .velocity(
        { top: 0, opacity: 1 },
        { duration: 300, easing: "easeOutCubic", queue: false }
      );

    setTimeout(
      () => {
        let item = this.Alerts.shift();

        if (data.action) {
          Shiny.onInputChange(item.action, null);
        }

        item.el.remove()
      },
      data.duration
    );
  }
});

Shiny.inputBindings.register(alertInputBinding, "dull.alertInput");
