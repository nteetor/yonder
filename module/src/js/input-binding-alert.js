export let alertInputBinding = new Shiny.InputBinding();

$(() => {
  $(document.body).append(
    $("<div class='yonder-alert-container' id='alert-container'></div>")
  );
});

$.extend(alertInputBinding, {
  Selector: {
    SELF: ".yonder-alert-container"
  },
  Alerts: [],
  getValue: function(el) {
    return null;
  },
  receiveMessage: function(el, msg) {
    if (msg.type === undefined) {
      return;
    }

    if (msg.type === "show") {
      let data = msg.data;

      let $alert = $(data.content);

      if (data.action) {
        $alert.append($(`<button class="btn btn-link alert-link alert-action">${ data.action }</button>`));
        $alert.on("click", ".alert-action", (e) => {
          Shiny.onInputChange(data.action, true);
        });
      }

      this.Alerts.push({ el: $alert, action: data.action });

      $alert.appendTo($(this.Selector.SELF))
        .velocity(
          { top: 0, opacity: 1 },
          { duration: 300, easing: "easeOutCubic", queue: false }
        );

      if (data.duration !== null) {
        setTimeout(
          () => {
            if (this.Alerts.length === 0) {
              return;
            }

            let item = this.Alerts.shift();

            if (item.action) {
              Shiny.onInputChange(item.action, null);
            }

            item.el.remove();
          },
          data.duration
        );
      }

      return;
    }

    if (msg.type === "close") {
      if (this.Alerts.length === 0) {
        return;
      }

      let data = msg.data;

      let indeces = typeof data.index === "number" ? [data.index] : data.index;
      let text = typeof data.text === "string" ? [data.text] : data.text;

      let selector = Object.entries(data.attrs)
          .map(item => {
            return `[${ item[0] }${ item[1] ? (item[0] === "class" ? "*=" : "=") + item[1] : "" }]`;
          })
          .join("");

      this.Alerts = this.Alerts.filter((alert, index) => {
        let $el = $(alert.el);

        if (indeces.includes(index) || text.includes($el.text()) || $el.is(selector)) {
          if (alert.action) {
            Shiny.onInputChange(alert.action, null);
          }

          $el.remove();

          return false;
        }

        return true;
      });
    }
  }
});

Shiny.inputBindings.register(alertInputBinding, "yonder.alertInput");
