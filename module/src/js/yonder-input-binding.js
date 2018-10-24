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
          if (event.callback(el, event.selector && e.target || undefined) === false) {
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

  this.updateChoices = function(el, map) {
    if (!this.hasSelector("VALUE") || !this.hasSelector("LABEL")) {
      return;
    }

    if (this.Selector.VALUE === this.Selector.SELF) {
      let value = map[$(el).data("value")];

      if (value !== undefined) {
        $(el).html(value);
      }

      return;
    }

    let $inputs = $(el).find(`${ this.Selector.VALUE }`);
    let $labels = $(el).find(`${ this.Selector.LABEL }`);

    if ($inputs.length != $labels.length) {
      console.error("updateChoices: mismatched number of inputs and labels");
      return;
    }

    $inputs.each((index, input) => {
      let $input = $(input);
      let $label = $($labels.get(index));

      let value = map[$input.data("value")];

      if (value !== undefined) {
        $label.html(value);
      }
    });
  };

  this.updateValues = function(el, map) {
    if (!this.hasSelector("VALUE")) {
      return;
    }

    if (typeof map == "string" || Array.isArray(map)) {
      let $inputs = $(el).find(`${ this.Selector.VALUE }`);
      let value = typeof map == "string" ? [map] : map;

      if ($inputs.has(":not(input[type='text'])").length) {
        console.error("updateValues: expecting all inputs to be text if new values are unnamed");
        return;
      }

      if ($inputs.length != value.length) {
        console.error("updateValues: mismatched number of inputs and values");
        return;
      }

      $inputs.each((index, input) => {
        let $input = $(input);
        $input.val(value[index]);
        $input.trigger("change");
      });

      return;
    }

    if (this.Selector.VALUE === this.Selector.SELF) {
      let value = map[$input.data("value")];

      if (value !== undefined) {
        $input.data("value", value);
      }

      return;
    }

    let $inputs = $(el).find(`${ this.Selector.VALUE }`);

    $inputs.each((index, input) => {
      let $input = $(input);

      let value = map[$input.data("value")];

      if (value !== undefined) {
        $input.data("value", value);
      }
    });
  };

  this.markValid = function(el, data) {
    if (!this.hasSelector("VALIDATE")) {
      return;
    }

    let $input = $(el).find(this.Selector.VALIDATE);
    $input.removeClass("is-invalid").addClass("is-valid");
    let $feedback = $(el).find(".valid-feedback");
    if ($feedback.length) {
      $feedback.text(data.msg);
    }
  };

  this.markInvalid = function(el, data) {
    if (!this.hasSelector("VALIDATE")) {
      return;
    }

    let $input = $(el).find(this.Selector.VALIDATE);
    $input.removeClass("is-valid").addClass("is-invalid");
    let $feedback = $(el).find(".invalid-feedback");
    if ($feedback.length) {
      $feedback.text(data.msg);
    }
  };

  this.receiveMessage = function(el, msg) {
    if (!msg.type) {
      return;
    }

    let [action, type = null] = msg.type.split(":");

    if (action === "update") {
      if (!type || msg.data === undefined) {
        return;
      }

      if (type === "choices") {
        this.updateChoices(el, msg.data);
      }

      if (type === "values") {
        this.updateValues(el, msg.data);
      }

      return;
    }

    if (action === "mark") {
      if (!type) {
        return;
      }

      if (type === "valid") {
        this.markValid(el, msg.data);
      }

      if (type === "invalid") {
        this.markInvalid(el, msg.data);
      }

      return;
    }
  };

  this.hasSelector = function(key) {
    return this.Selector !== undefined && this.Selector[key] !== undefined;
  };

  this.isFormElement = function(el) {
    return $(el).parents(".yonder-form[id]").length > 0;
  };
}

//.call(Shiny.InputBinding.prototype);
