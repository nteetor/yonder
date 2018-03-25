(function() {
  this.find = function(scope) {
    return $(scope).find(`${ this.Selector.SELF }[id]`);
  };

  this.getType = function(el) {
    if ($(el).parents(".dull-form-input[id]").length) {
      return "dull.form.element";
    }
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

  this.receiveMessage = function(el, msg) {
    if (!msg.type) {
      return;
    }

    let [action, type = null] = msg.type.split(":");

    if (action === "update") {
      if (!type || msg.data === undefined) {
        throw "Invalid update message"
      }

      if (type === "choices") {
        this.updateChoices(el, msg.data);
      }

      if (type === "values") {
        this.updateValues(el, msg.data);
      }
    }
  };
}).call(Shiny.InputBinding.prototype);
