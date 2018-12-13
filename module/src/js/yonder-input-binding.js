export function yonderInputBinding() {
  this.Selector = {};
  this.Events = [];

  this.find = function(scope) {
    return scope.querySelectorAll(`${ this.Selector.SELF }[id]`);
  };

  this.getId = function(el) {
    return el.id;
  };

  this.getType = function(el) {
    return this.Type || false;
  };

  this.getValue = function(el) {
    if (!this.Selector.hasOwnProperty("SELECTED")) {
      return null;
    }

    let selected = Array.prototype.slice.call(el.querySelectorAll(this.Selector.SELECTED));

    if (!selected.length) {
      return null;
    }

    return selected.map(s => {
      let value = s.getAttribute("data-value") || s.value;
      return value === undefined ? null : value;
    });
  };

  this.getState = function(el, data) {
    return { value: this.getValue(el) };
  };

  this.attachHandler = function(el, type, selector, handler, callback, debounce) {
    $(el).on(`${ type }.yonder`, (selector || null), (e) => {
      if (handler) {
        let result = handler(el, selector && e.target || undefined, this);

        if (result === false) {
          e.preventDefault();
          return;
        }
      }

      if (callback) {
        callback(debounce || false);
      }
    });
  };

  this.subscribe = function(el, callback) {
    let $el = $(el);

    let formElement = false;
    if ($el.parent().closest(".yonder-form[id]").length) {
      $el.on("submission.yonder", e => callback());
      formElement = true;
    }

    this.Events.forEach(event => {
      this.attachHandler(
        el,
        event.type, event.selector, event.callback,
        formElement ? null : callback, event.debounce
      );
    });
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
    if (!this.Selector.hasOwnProperty("VALIDATE")) {
      console.warn("input does not support invalidation");
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
    if (!this.Selector.hasOwnProperty("VALIDATE")) {
      console.warn("input does not support validation");
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

    switch (msg.type) {
    case "update":
      let values = msg.data.values;
      let choices = msg.data.choices;
      let selected = msg.data.selected;

      if (values || choices || selected) {
        this._clear(el);
      }

      if (values) {
        values.forEach(([value, current], i) => {
          this._value(el, value, current, i);
        });
      }

      if (choices) {
        choices.forEach(([value, current], i) => {
          this._choice(el, value, current, i);
        });
      }

      if (selected) {
        selected.forEach(value => {
          this._select(el, value);
        });
      }

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
}

if (Shiny) {
  yonderInputBinding.call(Shiny.InputBinding.prototype);
}
