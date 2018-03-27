(function() {
  this.find = function(scope) {
    return $(scope).find(`${ this.Selector.SELF }[id]`);
  };

  this.getId = function(el) {
    return el.id;
  }

  this.getType = function(el) {
    return false;
  };

  // may not be worth it to have this method already created
  this.getValue = function(el) {
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
      $(el).closest(".dull-form-input[id]").on("submit", e => callback());
    } else {
      for (const event of (this.Events || [])) {
        console.log(event);
        $(el).on(`${ event.type }.dull`, (e) => {
          callback(event.debounce || false);
        });
      }
    }
  };

  this.unsubscribe = function(el) {
    $(el).off("dull");
  };

  this.updateChoices = function(el, map) {
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
  }

  this.updateValues = function(el, map) {
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
  }

  this.markValid = function(el, data) {
    let $input = $(el).find(this.Selector.VALIDATE);
    $input.removeClass("is-invalid").addClass("is-valid");
    let $feedback = $(el).find(".valid-feedback");
    if ($feedback.length) {
      $feedback.text(data.msg);
    }
  }

  this.markInvalid = function(el, data) {
    let $input = $(el).find(this.Selector.VALIDATE);
    $input.removeClass("is-valid").addClass("is-invalid");
    let $feedback = $(el).find(".invalid-feedback");
    if ($feedback) {
      $feedback.text(data.msg);
    }
  }

  this.receiveMessage = function(el, msg) {
    console.log("receiveMessage: " + JSON.stringify(msg));

    if (!msg.type) {
      return;
    }

    let [action, type = null] = msg.type.split(":");

    if (action === "update") {
      if (this.Selector.VALIDATE === undefined) {
        return;
      }

      if (!type || msg.data === undefined) {
        throw "Invalid update message"
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
      if (type === "valid") {
        this.markValid(el, msg.data);
      }

      if (type === "invalid") {
        this.markInvalid(el, msg.data);
      }

      return;
    }
  };

  this.isFormElement = function(el) {
    return $(el).parents(".dull-form-input[id]").length > 0;
  }
}).call(Shiny.InputBinding.prototype);
