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

    let values = $(el).find(`${ this.Selector.SELECTED }`)
        .map((i, e) => {
          let $e = $(e);

          if ($e.is("[data-value]")) {
            return $e.data("value");
          }

          if ($e.is("input")) {
            return $e.val();
          }

          return $e.text();
        })
        .get();

    return values === undefined ? null : values;
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

  this._invalidate = function(el, data) {
    if (!this.hasSelector("VALIDATE")) {
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

    if (action === "update") {
      if (this._update === undefined) {
        console.warn("_update method not defined");
        return false;
      }

      this._update(el, msg.data);

      return true;
    }

    if (action === "enable")  {
      if (this._enable === undefined) {
        console.warn("_enable method not defined");
        return false;
      }

      this._enable(el, msg.data);

      return true;
    }

    if (action === "disable") {
      if (this._disable === undefined) {
        console.warn("_disable method not defined");
        return false;
      }

      this._disable(el, msg.data);

      return true;
    }

    if (action === "invalidate") {
      if (this._invalidate === undefined) {
        console.warn("_invalidate method not defined");
        return false;
      }

      this._invalidate(el, msg.data);

      return true;
    }

    if (action === "validate") {
      if (this._validate === undefined) {
        console.warn("_validate method not defined");
        return false;
      }

      this._validate(el, msg.data);

      return true;
    }
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
