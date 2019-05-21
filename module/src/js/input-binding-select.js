export let selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  find: (scope) => {
    return scope.querySelectorAll(".yonder-select[id]");
  },
  initialize: (el) => {
    let $el = $(el);

    $el.on("click", ".dropdown-item", (e) => {
      $el[0].querySelector("input").placeholder = e.currentTarget.innerText;

      let prev = $el[0].querySelector(".active");
      if (prev) {
        prev.classList.remove("active");
      }

      e.currentTarget.classList.add("active");
    });

    let $input = $(el.querySelector("input"));
    $el.on("input change", "input", (e) => {
      let pattern = $input[0].value.toLowerCase();

      el.querySelectorAll(".dropdown-item").forEach(item => {
        if (item.innerText.toLowerCase().indexOf(pattern) === -1) {
          item.classList.add("filtered");
        } else {
          item.classList.remove("filtered");
        }
      });

      $input.dropdown("update");
    });

    $el.on("hide.bs.dropdown", (e) => {
      $input[0].value = "";
      el.querySelectorAll(".filtered").forEach(f => {
        f.classList.remove("filtered");
      });
    });
  },
  getValue: (el) => {
    let selected = el.querySelectorAll(".dropdown-item.active:not(.disabled");

    if (selected.length === 0) {
      return null;
    }

    return Array.prototype.slice.call(selected).map(o => o.value);
  },
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("click.yonder", ".dropdown-item", (e) => callback());
    $el.on("select.select.yonder", (e) => callback()); // ha.
  },
  unsubscribe: (el) => {
    $(el).off(".yonder");
  },
  receiveMessage: (el, msg) => {
    if (msg.content) {
      el.querySelector(".dropdown-menu").innerHTML = msg.content;
    }

    if (msg.selected) {
      el.querySelectorAll(".dropdown-item").forEach(item => {
        if (msg.selected === true || msg.selected.indexOf(item.value) > -1) {
          item.classList.add("active");
          el.querySelector("input").placeholder = item.innerText;
        } else {
          item.classList.remove("active");
        }
      });

      $(el).trigger("select.select.yonder");
    }

    if (msg.enable) {
      let enable = msg.enable;

      if (enable === true) {
        el.querySelector("input").removeAttribute("disabled");
      } else {
        el.querySelectorAll(".dropdown-item").forEach(item => {
          if (enable.indexOf(item.value) > -1) {
            item.classList.remove("disabled");
          }
        });
      }
    }

    if (msg.disable) {
      let disable = msg.disable;

      if (disable === true) {
        el.querySelector("input").setAttribute("disabled", "");
      } else {
        el.querySelectorAll(".dropdown-item").forEach(item => {
          if (disable.indexOf(item.value) > -1) {
            item.classList.add("disabled");
          }
        });
      }
    }

    if (msg.valid) {
      el.querySelector("input").classList.add("is-valid");
      el.querySelector(".valid-feedback").innerHTML = msg.valid;
    }

    if (msg.invalid) {
      el.querySelector("input").classList.add("is-invalid");
      el.querySelector(".invalid-feedback").innerHTML = msg.invalid;
    }

    if (!msg.valid && !msg.invalid) {
      let input = el.querySelector("input");
      input.classList.remove("is-valid");
      input.classList.remove("is-invalid");

      el.querySelector(".valid-feedback").innerHTML = "";
      el.querySelector(".invalid-feedback").innerHTML = "";
    }
  }
});

Shiny.inputBindings.register(selectInputBinding, "yonder.selectInput");

export let groupSelectInputBinding = new Shiny.InputBinding();

$.extend(groupSelectInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-group-select[id]"),
  getValue: (el) => {
    let inputs = el.querySelectorAll(".input-group-prepend .input-group-text, select, .input-group-append .input-group-text");

    return Array.prototype.slice.call(inputs)
      .map(i => /^(DIV|SPAN)$/.test(i.tagName) ? i.innerText : (i.value || null))
      .filter(value => value !== null);
  },
  getType: () => "yonder.group.select",
  subscribe: (el, callback) => {
    let $el = $(el);

    if (el.querySelectorAll(".btn").length > 0) {
      $el.on("click", ".dropdown-item", (e) => callback());
    } else {
      $el.on("change", (e) => callback());
      $el.on("groupselect.select.yonder", (e) => callback());
    }
  },
  receiveMessage: (el, msg) => {
    let select = el.querySelector("input[data-toggle='dropdown']");

    if (msg.content) {
      select.innerHTML = msg.content;
    }

    if (msg.selected) {
      select.querySelectorAll("option").forEach(option => {
        if (msg.selected.indexOf(option.value) > -1) {
          option.setAttribute("selected", "");
        } else {
          option.removeAttribute("selected");
        }
      });

      $(el).trigger("groupselect.select.yonder");
    }

    if (msg.enable) {
      let enable = msg.enable;

      if (enable === true) {
        select.removeAttribute("disabled");
      } else {
        select.querySelectorAll("option").forEach(option => {
          option.removeAttribute("disabled");
        });
      }
    }

    if (msg.disable) {
      let disable = msg.disable;

      if (disable) {
        select.setAttribute("disabled", "");
      } else {
        select.querySelectorAll("option").forEach(option => {
          option.setAttribute("disabled", "");
        });
      }
    }

    if (msg.valid) {
      el.querySelector("valid-feedback").innerHTML = msg.valid;

      select.classList.remove("is-invalid");
      select.classList.add("is-valid");
    }

    if (msg.invalid) {
      el.querySelector("invalid-feedback").innerHTML = msg.invalid;

      select.classList.remove("is-valid");
      select.classList.add("is-invalid");
    }

    if (!msg.valid && !msg.invalid) {
      select.classList.remove("is-valid");
      select.classList.remove("is-invalid");

      el.querySelector("invalid-feedback").innerHTML = "";
      el.querySelector("valid-feedback").innerHTML = "";
    }

  }
});

Shiny.inputBindings.register(groupSelectInputBinding, "yonder.groupSelectInputBinding");
