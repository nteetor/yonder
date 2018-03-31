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
    // let action = "<button class='btn btn-teal alert-action'>Undo</button>";
    console.log(data);

    let alertClass = data.color ? `alert-${ data.color }` : "";

    $(`<div class="alert ${ alertClass } fade show dull-alert" role="alert">${ data.text }</div>`)
      .attr(data.attrs || {})
      .appendTo($(this.Selector.SELF))
      .velocity(
        { top: 0, opacity: 1 },
        { duration: 300, easing: "easeOutCubic", queue: false }
      );

    setTimeout(
      () => $(this.Selector.SELF).children(".dull-alert:first-child").alert("close"),
      data.duration
    );
  }
});

Shiny.inputBindings.register(alertInputBinding, "dull.alertInput");
