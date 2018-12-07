export function yonderInputBinding() {
  this.find = function(scope) {
    return scope.querySelectorAll(`${ this.Selector.SELF }[id]`);
  };

  this.getId = function(el) {
    return el.id;
  };

  this.getType = function(el) {
    return this.Type ? this.Type : false;
  };

  // may not be worth it to have this method already created
  this.getValue = function(el) {
    if (!this.hasSelector("SELECTED")) {
      return null;
    }

    let selected = el.querySelectorAll(this.Selector.SELECTED);

    if (!selected.length) {
      return null;
    }

    return Array.prototype.map.call(
      selected,
      s => s.getAttribute("data-value") || s.value
    );
  };

  this.subscribe = function(el, callback) {
    if (this.isFormElement(el)) {
      $(el).closest(".yonder-form[id]").on("submit", e => callback());
      return;
    }

    if (this.Events === undefined || !this.Events.length) {
      return;
    }

    for (const event of (this.Events || [])) {
      $(el).on(`${ event.type }.yonder`, (event.selector || null), (e) => {
        if (event.callback) {
          if (event.callback(el, event.selector && e.target || undefined, this) === false) {
            e.preventDefault();
            return;
          }
        }
        callback(event.debounce || false);
      });
    }
  };

  this.unsubscribe = function(el) {
    $(el).off("yonder");
  };

  this._update = (el, data) => {
    console.warn("no _update method");
  };

  this._enable = (el, data) => {
    console.warn("no _enable method");
  };

  this._disable = (el, data) => {
    console.warn("no _disable method");
  };

  this._invalidate = function(el, data) {
    if (!this.hasSelector("VALIDATE")) {
      console.warn("no _invalidate method");
      return;
    }

    let input = el.querySelector(this.Selector.VALIDATE);

    input.classList.remove("is-valid");
    input.classList.add("is-invalid");

    let feedback = el.querySelector(".invalid-feedback");
    if (feedback !== null) {
      feedback.innerHTML = data.message;
    }
  };

  this._validate = function(el, data) {
    if (!this.hasSelector("VALIDATE")) {
      console.warn("no _validate method");
      return;
    }

    let input = el.querySelector(this.Selector.VALIDATE);

    input.classList.remove("is-invalid");

    let feedback = el.querySelector(".invalid-feedback");
    if (feedback !== null) {
      feedback.innerHTML = "";
    }
  };

  this.receiveMessage = function(el, msg) {
    if (!msg.type || msg.data === undefined) {
      return false;
    }

    let [action, type = null] = msg.type.split(":");

    switch (action) {
      case "update":
        let choices = msg.data.choices;
        let values = msg.data.values;
        let selected = msg.data.selected;

        if (!choices && values && this.Selector.CHOICE) {
          choices = Array.prototype.slice.call(
            el.querySelectorAll(this.Selector.CHOICE),
            0,
            values.length
          );
        } else if (choices && !values && this.Selector.VALUE) {
          values = Array.prototype.slice.call(
            el.querySelectorAll(this.Selector.VALUE),
            0,
            choices.length
          );
        }

        this._update(el, {
          "choices": choices,
          "values": values,
          "selected": selected
        });

        break;

      case "enable":
        this._enable(el, msg.data);
        break;

      case "disable":
        this._disable(el, msg.data);
        break;

      case "invalidate":
        this._invalidate(el, msg.data);
        break;

      case "validate":
        this._validate(el, msg.data);
        break;
    }

    return false;
  };

  this.hasSelector = function(key) {
    return this.Selector !== undefined && this.Selector[key] !== undefined;
  };

  this.isFormElement = function(el) {
    return $(el).parents(".yonder-form[id]").length > 0;
  };
}

if (Shiny !== undefined) {
  yonderInputBinding.call(Shiny.InputBinding.prototype);
}
