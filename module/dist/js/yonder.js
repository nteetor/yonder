(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (factory());
}(this, (function () { 'use strict';

  function yonderInputBinding() {
    this.Selector = {};
    this.Events = [];

    this.find = function (scope) {
      return scope.querySelectorAll(this.Selector.SELF + "[id]");
    };

    this.getId = function (el) {
      return el.id;
    };

    this.getType = function (el) {
      return this.Type || false;
    };

    this.getValue = function (el) {
      if (!this.Selector.hasOwnProperty("SELECTED")) {
        return null;
      }

      var selected = Array.prototype.slice.call(el.querySelectorAll(this.Selector.SELECTED));

      if (!selected.length) {
        return null;
      }

      return selected.map(function (s) {
        var value = s.getAttribute("data-value") || s.value;
        return value === undefined ? null : value;
      });
    };

    this.getState = function (el, data) {
      return {
        value: this.getValue(el)
      };
    };

    this.attachHandler = function (el, type, selector, handler, callback, debounce) {
      var _this = this;

      $(el).on(type + ".yonder", selector || null, function (e) {
        if (handler) {
          handler(el, e, _this);
        }

        if (callback) {
          callback(debounce || false);
        }
      });
    };

    this.subscribe = function (el, callback) {
      var _this2 = this;

      var $el = $(el);
      var formElement = false;

      if ($el.parent().closest(".yonder-form[id]").length) {
        $el.on("submission.yonder", function (e) {
          return callback();
        });
        formElement = true;
      }

      this.Events.forEach(function (event) {
        _this2.attachHandler(el, event.type, event.selector, event.callback, formElement ? null : callback, event.debounce);
      });
    };

    this.unsubscribe = function (el) {
      $(el).off("yonder");
    };

    this._update = function (el, data) {
      console.warn("no _update method");
    };

    this._enable = function (el, data) {
      console.warn("no _enable method");
    };

    this._disable = function (el, data) {
      console.warn("no _disable method");
    };

    this._invalidate = function (el, data) {
      if (!this.Selector.hasOwnProperty("VALIDATE")) {
        console.warn("input does not support invalidation");
        return;
      }

      var input = el.querySelector(this.Selector.VALIDATE);
      input.classList.remove("is-valid");
      input.classList.add("is-invalid");
      var feedback = el.querySelector(".invalid-feedback");

      if (feedback !== null) {
        feedback.innerHTML = data.message;
      }
    };

    this._validate = function (el, data) {
      if (!this.Selector.hasOwnProperty("VALIDATE")) {
        console.warn("input does not support validation");
        return;
      }

      var input = el.querySelector(this.Selector.VALIDATE);
      input.classList.remove("is-invalid");
      var feedback = el.querySelector(".invalid-feedback");

      if (feedback !== null) {
        feedback.innerHTML = "";
      }
    };

    this.receiveMessage = function (el, msg) {
      if (!msg.type || msg.data === undefined) {
        return false;
      }

      switch (msg.type) {
        case "update":
          this._update(el, msg.data);

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

  if (typeof Shiny !== "undefined") {
    yonderInputBinding.call(Shiny.InputBinding.prototype);
  }

  var buttonGroupInputBinding = new Shiny.InputBinding();
  $.extend(buttonGroupInputBinding, {
    Selector: {
      SELF: ".yonder-button-group"
    },
    Events: [{
      type: "click",
      selector: "button",
      callback: function callback(el, e, self) {
        self._VALUES[el.id] = e.currentTarget.value;
      }
    }],
    _VALUES: {},
    getType: function getType(el) {
      return "yonder.buttonGroup";
    },
    initialize: function initialize(el) {
      this._VALUES[el.id] = null;
    },
    getValue: function getValue(el) {
      return {
        force: Date.now(),
        value: this._VALUES[el.id]
      };
    },
    _update: function _update(el, data) {
      var template = el.querySelector("button").cloneNode();
      template.removeAttribute("disabled");
      el.innerHTML = "";
      data.choices.forEach(function (choice, i) {
        var child = template.cloneNode();
        child.innerHTML = choice;
        child.value = data.values[i];
        el.appendChild(child);
      });
    },
    _enable: function _enable(el, data) {
      var values = data.values;
      el.querySelectorAll("button").forEach(function (button) {
        var enable = !values.length || values.indexOf(button.value) > -1;

        if (enable !== data.invert) {
          button.removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      var values = data.values;
      el.querySelectorAll("button").forEach(function (button) {
        var disable = !values.length || values.indexOf(button.value) > -1;

        if (data.reset) {
          button.removeAttribute("disabled");
        }

        if (disable !== data.invert) {
          button.setAttribute("disabled", "");
        }
      });
    }
  });
  Shiny.inputBindings.register(buttonGroupInputBinding, "yonder.buttonGroupInput");

  var buttonInputBinding = new Shiny.InputBinding();
  $.extend(buttonInputBinding, {
    Selector: {
      SELF: ".yonder-button"
    },
    Events: [{
      type: "click",
      callback: function callback(el) {
        return el.value = +el.value + 1;
      }
    }],
    initialize: function initialize(el) {
      el.value = 0;
    },
    getValue: function getValue(el) {
      return +el.value > 0 ? +el.value : null;
    },
    _update: function _update(el, data) {
      el.innerHTML = data.choices[0];

      if (data.choices !== data.values) {
        el.value = parseInt(data.values[0], 10) || 0;
      }
    },
    _enable: function _enable(el, data) {
      if (!data.invert) {
        el.classList.remove("disabled");
      }
    },
    _disable: function _disable(el, data) {
      if (!data.invert) {
        el.classList.add("disabled");
      }
    }
  });
  Shiny.inputBindings.register(buttonInputBinding, "yonder.buttonInput");

  var checkbarInputBinding = new Shiny.InputBinding();
  $.extend(checkbarInputBinding, {
    Selector: {
      SELF: ".yonder-checkbar",
      SELECTED: "input:checked"
    },
    Events: [{
      type: "change",
      selector: ".btn"
    }],
    _update: function _update(el, data) {
      var template = el.querySelector(".btn").cloneNode(true);
      template.classList.remove("active");
      template.classList.remove("disabled");
      template.children[0].removeAttribute("disabled");
      var input = template.children[0].cloneNode();
      template.innerHTML = "";
      template.appendChild(input);
      el.innerHTML = "";
      data.choices.forEach(function (choice, i) {
        var child = template.cloneNode(true);
        child.insertAdjacentHTML("beforeend", choice);
        child.children[0].value = data.values[i];

        if (data.selected.indexOf(data.values[i]) > -1) {
          child.classList.add("active");
          child.children[0].checked = true;
        }

        el.appendChild(child);
      });
    },
    _select: function _select(el, data) {
      el.querySelectAll(".btn").forEach(function (child) {
        var value = child.children[0].value;

        if (data.reset) {
          child.classList.remove("active");
          child.children[0].checked = false;
        }

        var match = data.fixed ? data.pattern.indexOf(value) > -1 : RegExp(data.pattern, "i").test(value);

        if (match !== data.invert) {
          child.classList.add("active");
          child.children[0].checked = true;
        }
      });
    },
    _enable: function _enable(el, data) {
      var values = data.values;
      el.querySelectorAll(".btn").forEach(function (btn) {
        var enable = !values.length || values.indexOf(btn.children[0].value) > -1;

        if (enable !== data.invert) {
          btn.classList.remove("disabled");
          btn.children[0].removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      var values = data.values;
      el.querySelectorAll(".btn").forEach(function (btn) {
        var disable = !values.length || values.indexOf(btn.children[0].value) > -1;

        if (data.reset) {
          btn.classList.remove("disabled");
          btn.children[0].removeAttribute("disabled");
        }

        if (disable !== data.invert) {
          btn.classList.add("disabled");
          btn.children[0].setAttribute("disabled", "");
        }
      });
    }
  });
  Shiny.inputBindings.register(checkbarInputBinding, "yonder.checkbarInput");

  var checkboxInputBinding = new Shiny.InputBinding();
  $.extend(checkboxInputBinding, {
    Selector: {
      SELF: ".yonder-checkbox",
      SELECTED: ".custom-control-input:checked:not(:disabled)",
      VALIDATE: ".custom-control-input"
    },
    Events: [{
      type: "change"
    }],
    _update: function _update(el, data) {
      var template = el.querySelector(".custom-checkbox").cloneNode(true);
      template.children[0].checked = false;
      el.innerHTML = "";
      data.choices.forEach(function (choice, i) {
        var child = template.cloneNode(true);
        child.children[0].value = data.values[i];
        child.children[1].innerHTML = choice;

        if (data.selected.indexOf(data.values[i]) > -1) {
          child.children[0].checked = true;
        }

        el.appendChild(child);
      });
    },
    _select: function _select(el, data) {
      el.querySelectorAll(".custom-checkbox").forEach(function (child) {
        var value = child.children[0].value;

        if (data.reset) {
          child.children[0].checked = false;
        }

        var match = data.fixed ? data.pattern.indexOf(value) > -1 : RegExp(data.pattern, "i").test(value);

        if (match !== data.invert) {
          child.children[0].checked = true;
        }
      });
    },
    _enable: function _enable(el, data) {
      el.querySelectorAll("input").forEach(function (input) {
        var enable = !data.values.length && data.values.indexOf(input.value) > -1;

        if (enable !== data.invert) {
          input.removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      el.querySelectorAll("input").forEach(function (input) {
        var disable = !data.values.length && data.values.indexOf(input.value) > -1;

        if (data.reset) {
          input.removeAttribute("disabled");
        }

        if (disable !== data.invert) {
          input.setAttribute("disabled", "");
        }
      });
    }
  });
  Shiny.inputBindings.register(checkboxInputBinding, "yonder.checkboxInput");

  var chipInputBinding = new Shiny.InputBinding();
  $.extend(chipInputBinding, {
    Selector: {
      SELF: ".yonder-chip",
      SELECTED: ".active"
    },
    Events: [{
      type: "input",
      callback: function callback(el, event, self) {
        var value = event.currentTarget.value;
        self.filterItems(el, value);

        if (self.visibleItems(el) === 0) {
          $(el.querySelector("input[data-toggle='dropdown']")).dropdown("hide");
        } else {
          $(el.querySelector("input[data-toggle='dropdown']")).dropdown("show");
        }
      }
    }, {
      type: "input change",
      callback: function callback(el, event, self) {
        el.querySelector("input[data-toggle='dropdown']").dropdown("update");
      }
    }, {
      type: "hide.bs.dropdown",
      callback: function callback(el, event, self) {
        if (el.querySelector("input:focus") === null) {
          el.querySelector("input").value = "";
          self.filterItems(el, "");
        }
      }
    }, {
      type: "click",
      selector: ".dropdown-item",
      callback: function callback(el, event, self) {
        event.stopPropagation();
        var item = event.currentTarget;
        var label = item.innerText;
        var value = item.value;
        var input = el.querySelector("input");
        var max = +el.getAttribute("data-max");
        item.classList.add("selected");
        el.querySelectorAll(".chip[value=\"" + value + "\"]").forEach(function (chip) {
          return chip.classList.add("active");
        });

        if (self.visibleItems(el) === 0) {
          input.dropdown("hide");
        }

        input.focus();

        if (max === -1 || self.selectedItems(el) < max) {
          self.enableToggle(el);
        }
      }
    }, {
      type: "click",
      selector: ".chip",
      callback: function callback(el, event, self) {
        var chip = event.currentTarget;
        var value = chip.value;
        var max = +el.getAttribute("data-max");
        chip.classList.remove("active");
        el.querySelectorAll(".dropdown-item[value='" + value + "']").forEach(function (item) {
          return item.classList.remove("selected");
        });
        $(el.querySelector("input[data-toggle='dropdown']")).dropdown("update");

        if (max === -1 || self.selectedItems(el) < max) {
          self.enableToggle(el);
        }
      }
    }],
    enableToggle: function enableToggle(el) {
      var input = el.querySelector("input");
      input.removeAttribute("disabled");
      input.classList.remove("disabled");
    },
    disableToggle: function disableToggle(el) {
      var input = el.querySelector("input");
      input.setAttribute("disabled", "");
      input.classList.add("disabled");
    },
    filterItems: function filterItems(el, value) {
      el.querySelectorAll(".dropdown-item").forEach(function (item) {
        var match = item.innerText.toLowerCase().indexOf(value) !== -1;

        if (match) {
          item.classList.remove("filtered");
        } else {
          item.classList.add("filtered");
        }
      });
    },
    visibleItems: function visibleItems(el) {
      return el.querySelectorAll(":not(.selected), :not(.filtered)").length;
    },
    selectedItems: function selectedItems(el) {
      return el.querySelectorAll(".selected").length;
    }
  });
  Shiny.inputBindings.register(chipInputBinding, "yonder.chipInput");

  var fileInputBinding = new Shiny.InputBinding();
  $.extend(fileInputBinding, {
    Selector: {
      SELF: ".yonder-file",
      VALIDATE: "input[type='file']"
    },
    Events: [{
      type: "change",
      callback: function callback(el, _, self) {
        if (el.querySelector("button") !== null) return;

        self._doUpload(el);
      }
    }, {
      type: "click",
      selector: "button",
      callback: function callback(el, _, self) {
        return self._doUpload(el);
      }
    }, {
      type: "dragover",
      callback: function callback(_, e) {
        e.stopPropagation();
        e.preventDefault();
      }
    }, {
      type: "dragcenter",
      callback: function callback(_, e) {
        e.stopPropagation();
        e.preventDefault();
      }
    }, {
      type: "drop",
      callback: function callback(el, e, self) {
        e.stopPropagation();
        e.preventDefault();

        self._doUpload(el, e.originalEvent.dataTransfer.files);
      }
    }],
    getValue: function getValue(el) {
      return null;
    },
    _value: function _value() {
      return null;
    },
    _choice: function _choice() {
      return null;
    },
    _select: function _select() {
      return null;
    },
    _clear: function _clear() {
      return null;
    },
    _enable: function _enable(el, data) {
      el.querySelector("input[type='file']").removeAttribute("disabled");
    },
    _disable: function _disable(el, data) {
      el.querySelector("input[type='file']").setAttribute("disabled", "");
    },
    _sendFile: function _sendFile(uri, job, file, final, el) {
      var xhr = new XMLHttpRequest();
      xhr.open("POST", uri, true);
      xhr.setRequestHeader("Content-Type", "application/octet-stream");

      xhr.onreadystatechange = function () {
        if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200 && final) {
          Shiny.shinyapp.makeRequest("uploadEnd", [job, el.id], function (res) {
            el.querySelector("input[type='file']").value = "";
          }, function (err) {
            console.error("uploadEnd request failed for " + el.id + ": " + err);
          });
        }
      };

      xhr.send(file);
    },
    _doUpload: function _doUpload(el, files) {
      var _this = this;

      var input = el.querySelector("input[type='file']");

      if (files === undefined) {
        files = input.files;
      }

      if (!files) {
        return;
      }

      if (!input.hasAttribute("multiple")) {
        files = Array.prototype.slice.call(files, 0, 1);
      } else {
        files = Array.prototype.slice.call(files);
      }

      var info = files.map(function (f) {
        return {
          name: f.name,
          size: f.size,
          type: f.type
        };
      });
      Shiny.shinyapp.makeRequest("uploadInit", [info], function (res) {
        var job = res.jobId;
        var uri = res.uploadUrl;

        for (var i = 0; i < files.length; i++) {
          _this._sendFile(uri, job, files[i], i === files.length - 1, el);
        }
      }, function (err) {
        console.error("uploadInit request failed for " + el.id + ": " + err);
      });
    }
  });
  Shiny.inputBindings.register(fileInputBinding, "yonder.fileInput");

  var formInputBinding = new Shiny.InputBinding();
  $.extend(formInputBinding, {
    Events: [{
      type: "click",
      selector: ".yonder-submit",
      callback: function callback(el, e, self) {
        self._VALUES[el.id] = e.currentTarget.value;
        $(el.querySelectorAll(".shiny-bound-input")).trigger("submission.yonder");
      }
    }],
    Type: "yonder.form",
    _VALUES: {},
    find: function find(scope) {
      var forms = Array.prototype.slice.call(scope.querySelectorAll(".yonder-form[id]"));
      return forms.filter(function (f) {
        return f.querySelector(".yonder-submit") !== null;
      });
    },
    initialize: function initialize(el) {
      this._VALUES[el.id] = null;
    },
    getValue: function getValue(el) {
      return {
        force: Date.now(),
        value: this._VALUES[el.id]
      };
    },
    _value: function _value() {
      return null;
    },
    _choice: function _choice() {
      return null;
    },
    _select: function _select() {
      return null;
    },
    _clear: function _clear() {
      return null;
    },
    _enable: function _enable() {
      return null;
    },
    _disable: function _disable() {
      return null;
    }
  });
  Shiny.inputBindings.register(formInputBinding, "yonder.formInput");

  var groupInputBinding = new Shiny.InputBinding();
  $.extend(groupInputBinding, {
    Selector: {
      SELF: ".yonder-group[id]",
      SELECTED: ".input-group-prepend .input-group-text, input, .input-group-append .input-group-text",
      VALIDATE: "input"
    },
    Events: [{
      type: "input",
      debounce: true
    }, {
      type: "change",
      debounce: true
    }],
    Type: "yonder.group",
    getValue: function getValue(el) {
      return Array.prototype.slice.call(el.querySelectorAll(this.Selector.SELECTED)).map(function (s) {
        return /^(DIV|SPAN)$/.test(s.tagName) ? s.innerText : s.value || null;
      }).filter(function (value) {
        return value !== null;
      });
    },
    _update: function _update(el, data) {
      el.querySelector("input").value = data.values[0];
    },
    _enable: function _enable(el, data) {
      el.querySelector("input").removeAttribute("disabled");
    },
    _disable: function _disable(el, data) {
      el.querySelector("input").setAttribute("disabled", "");
    }
  });
  Shiny.inputBindings.register(groupInputBinding, "yonder.groupInput");

  var linkInputBinding = new Shiny.InputBinding();
  $.extend(linkInputBinding, {
    Selector: {
      SELF: ".yonder-link[id]"
    },
    Events: [{
      type: "click",
      callback: function callback(el) {
        return el.value = +el.value + 1;
      }
    }],
    initialize: function initialize(el) {
      el.value = 0;
    },
    getValue: function getValue(el) {
      return +el.value > 0 ? +el.value : null;
    },
    _update: function _update(el, data) {
      el.value = data.values[0];
      el.innerText = data.choices[0];
    },
    _disable: function _disable(el, data) {
      el.classList.add("disabled");
      el.setAttribute("disabled", "");
    },
    _enable: function _enable(el, data) {
      el.classList.remove("disabled");
      el.removeAttribute("disabled");
    }
  });
  Shiny.inputBindings.register(linkInputBinding, "yonder.linkInput");

  var listGroupInputBinding = new Shiny.InputBinding();
  $.extend(listGroupInputBinding, {
    Selector: {
      SELF: ".yonder-list-group",
      SELECTED: ".active:not(.disabled)"
    },
    Events: [{
      type: "click",
      selector: ".list-group-item-action:not(.active):not(.disabled)",
      callback: function callback(el, event, _) {
        el.querySelectorAll(".active").forEach(function (item) {
          return item.classList.remove("active");
        });
        event.currentTarget.classList.add("active");
      }
    }, {
      type: "click",
      selector: ".active:not(.disabled)",
      callback: function callback(el, event, _) {
        event.currentTarget.classList.remove("active");
      }
    }],
    _update: function _update(el, data) {
      var template = el.querySelector(".list-group-item").cloneNode();
      template.classList.remove("active");
      template.classList.remove("disabled");
      el.innerHTML = "";
      data.choices.forEach(function (choice, i) {
        var item = template.cloneNode();
        item.innerHTML = choice;
        item.value = data.values[i];

        if (data.selected.indexOf(data.values[i]) > -1) {
          item.classList.add("active");
        }

        el.appendChild(item);
      });
    },
    _select: function _select(el, data) {
      el.querySelectorAll(".list-group-item").forEach(function (item) {
        var value = item.value;

        if (data.reset) {
          item.classList.remove("active");
        }

        var match = data.fixed ? data.pattern.indexOf(value) > -1 : RegExp(data.pattern, "i").test(value);

        if (match !== data.invert) {
          item.classList.add("active");
        }
      });
    },
    _enable: function _enable(el, data) {
      var values = data.values;
      el.querySelectorAll(".list-group-item").forEach(function (item) {
        var enable = !values.length || values.indexOf(item.value) > -1;

        if (enable !== data.invert) {
          item.classList.remove("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      var values = data.values;
      el.querySelectorAll(".list-group-item").forEach(function (item) {
        var disable = !values.length || values.indexOf(item.value) > -1;

        if (data.reset) {
          item.classList.remove("disabled");
        }

        if (disable !== data.invert) {
          item.classList.add("disabled");
        }
      });
    }
  });
  Shiny.inputBindings.register(listGroupInputBinding, "yonder.listGroupInput");

  var menuInputBinding = new Shiny.InputBinding();
  $.extend(menuInputBinding, {
    Selector: {
      SELF: ".yonder-menu",
      SELECTED: ".dropdown-item.active"
    },
    Events: [{
      type: "click",
      selector: ".dropdown-item:not(.disabled)",
      callback: function callback(el, e) {
        var active = el.querySelector(".dropdown-item.active");

        if (active !== null) {
          active.classList.remove("active");
        }

        e.currentTarget.classList.add("active");
      }
    }, {
      type: "nav.reset",
      callback: function callback(el) {
        var active = el.querySelector(".dropdown-item.active");

        if (active !== null) {
          active.classList.remove("active");
        }
      }
    }],
    _update: function _update(el, data) {
      var template = el.querySelector(".dropdown-item").cloneNode();
      template.removeClass("disabled");
      template.removeClass("active");
      el.innerHTML = "";
      data.choices.forEach(function (choice, i) {
        var child = template.cloneNode();
        child.innerHTML = choice;
        child.value = data.values[i];

        if (data.selected.indexOf(data.values[i]) > -1) {
          child.classList.add("active");
        }

        el.appendChild(child);
      });
    },
    _select: function _select(el, data) {
      el.querySelectorAll(".dropdown-item").forEach(function (child) {
        var value = child.value;

        if (data.reset) {
          child.classList.remove("active");
        }

        var match = data.fixed ? data.pattern.indexOf(value) > -1 : RegExp(data.pattern, "i").test(value);

        if (match !== data.inverted) {
          child.classList.add("active");
        }
      });
    },
    _enable: function _enable(el, data) {
      el.querySelectorAll(".dropdown-item").forEach(function (di) {
        var enable = !data.values.length || data.values.indexOf(di.value) > -1;

        if (enable !== data.invert) {
          di.classList.remove("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      el.querySelectorAll(".dropdown-item").forEach(function (di) {
        var disable = !data.values.length || data.values.indexOf(di.value) > -1;

        if (data.reset) {
          di.classList.remove("disabled");
        }

        if (disable !== data.invert) {
          di.classList.add("disabled");
        }
      });
    }
  });
  Shiny.inputBindings.register(menuInputBinding, "yonder.menuInput");

  var navInputBinding = new Shiny.InputBinding();
  $.extend(navInputBinding, {
    Selector: {
      SELF: ".yonder-nav",
      SELECTED: ".nav-link.active:not(.disabled)"
    },
    Events: [{
      type: "click",
      selector: ".nav-link:not(.dropdown-toggle):not(.disabled)",
      callback: function callback(el, e) {
        var activeItem = el.querySelector(".dropdown-item.active");

        if (activeItem !== null) {
          // trigger reset on menu input
          $(activeItem.parentNode.parentNode).trigger("nav.reset");
        }

        el.querySelectorAll(".nav-link.active").forEach(function (a) {
          a.classList.remove("active");
        });
        e.currentTarget.classList.add("active");
      }
    }, {
      type: "click",
      selector: ".dropdown-item:not(.disabled)",
      callback: function callback(el, e) {
        el.querySelectorAll(".active").forEach(function (a) {
          a.classList.remove("active");
        });
        e.currentTarget.parentNode.parentNode.children[0].classList.add("active");
        e.currentTarget.classList.add("active");
      }
    }],
    _update: function _update(el, data) {
      var template = el.querySelector(".nav-item").cloneNode(true);
      template.children[0].classList.remove("active");
      template.children[0].classList.remove("disabled");
      el.innerHTML = "";
      data.choices.forEach(function (choice, i) {
        var child = template.cloneNode(true);
        child.children[0].innerHTML = choice;
        child.children[0].value = data.values[i];

        if (data.selected.indexOf(data.values[i]) > -1) {
          child.children[0].classList.add("active");
        }

        el.appendChild(child);
      });
    },
    _select: function _select(el, data) {
      el.querySelectorAll(".nav-link").forEach(function (child) {
        var value = child.value;

        if (data.reset) {
          child.classList.remove("active");
        }

        var match = data.fixed ? data.pattern.indexOf(value) > -1 : RegExp(data.pattern, "i").test(value);

        if (match !== data.invert) {
          child.classList.add("active");
        }
      });
    },
    _disable: function _disable(el, data) {
      el.querySelectorAll(".nav-link").forEach(function (nl) {
        var disabled = !data.values.length || data.values.indexOf(nl.value) > -1;

        if (data.reset) {
          nl.classList.remove("disabled");
        }

        if (disabled !== data.invert) {
          nl.classList.add("disabled");
        }
      });
    },
    _enable: function _enable(el, data) {
      el.querySelectorAll(".nav-link").forEach(function (nl) {
        var enable = !data.values.length || data.values.indexOf(nl.value) > -1;

        if (enable !== data.invert) {
          nl.classList.remove("disabled");
        }
      });
    }
  });
  Shiny.inputBindings.register(navInputBinding, "yonder.navInput");
  Shiny.addCustomMessageHandler("yonder:pane", function (msg) {
    var _show = function _show(pane) {
      if (pane === null || !pane.parentElement.classList.contains("tab-content")) {
        return;
      }

      var previous = pane.parentElement.querySelector(".active");

      var complete = function complete() {
        var hiddenEvent = $.Event("hidden.bs.tab", {
          relatedTarget: pane
        });
        var shownEvent = $.Event("shown.bs.tab", {
          relatedTarget: previous
        });
        $(previous).trigger(hiddenEvent);
        $(pane).trigger(shownEvent);
      };

      bootstrap.Tab.prototype._activate(pane, pane.parentElement, complete);
    }; // let _hide = function(pane) {
    //   let current = pane.parent
    // };


    if (msg.type === undefined || msg.data === undefined || msg.data.target === undefined) {
      return;
    }

    if (msg.type === "show") {
      _show(document.getElementById(msg.data.target));
    }
  });

  var radioInputBinding = new Shiny.InputBinding();
  $.extend(radioInputBinding, {
    Selector: {
      SELF: ".yonder-radio[id]",
      SELECTED: ".custom-control-input:checked:not(:disabled)",
      VALIDATE: ".custom-control-input"
    },
    Events: [{
      type: "change"
    }],
    _update: function _update(el, data) {
      var template = el.querySelector(".custom-radio").cloneNode(true);
      template.children[0].removeAttribute("checked");
      el.innerHTML = "";
      data.chocies.forEach(function (choice, i) {
        var child = template.cloneNode(true);
        child.children[1].innerHTML = choice;
        child.children[0].value = data.values[i];

        if (data.selected.indexOf(data.values[i]) > -1) {
          child.children[0].setAttribute("checked", "");
        }

        el.appendChild(child);
      });
    },
    _select: function _select(el, data) {
      el.querySelectorAll(".custom-control-input").forEach(function (child) {
        var value = child.value;

        if (data.reset) {
          child.removeAttribute("checked");
        }

        var match = data.fixed ? data.pattern.indexOf(value) > -1 : RegExp(data.pattern, "i").test(value);

        if (match !== data.invert) {
          child.setAttribute("checked", "");
        }
      });
    },
    _enable: function _enable(el, data) {
      el.querySelectorAll(".custom-control-input").forEach(function (input) {
        var enable = !data.values.length || data.values.indexOf(input.value) > -1;

        if (enable !== data.invert) {
          input.removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      el.querySelectorAll(".custom-control-input").forEach(function (input) {
        var disable = !data.values.length || data.values.indexOf(input.value) > -1;

        if (data.reset) {
          input.removeAttribute("disabled");
        }

        if (disable !== data.invert) {
          input.setAttribute("disabled", "");
        }
      });
    }
  });
  Shiny.inputBindings.register(radioInputBinding, "yonder.radioInput");

  var radiobarInputBinding = new Shiny.InputBinding();
  $.extend(radiobarInputBinding, {
    Selector: {
      SELF: ".yonder-radiobar[id]",
      SELECTED: "input:checked:not(:disabled)"
    },
    Events: [{
      type: "click"
    }, {
      type: "change"
    }],
    _update: function _update(el, data) {
      var template = el.querySelector(".btn").cloneNode(true);
      template.classList.remove("active");
      template.classList.remove("disabled");
      var input = template.children[0].cloneNode();
      input.removeAttribute("checked");
      template.innerHTML = "";
      template.appendNode(input);
      el.innerHTML = "";
      data.choices.forEach(function (choice, i) {
        var child = template.cloneNode(true);
        child.insertAdjacentHTML("beforeend", choice);
        child.children[0].value = data.values[i];

        if (data.selected.indexOf(data.values[i]) > -1) {
          child.classList.add("active");
          child.children[0].setAttribute("checked", "");
        }

        el.appendChild(child);
      });
    },
    _select: function _select(el, data) {
      el.querySelectorAll(".btn").forEach(function (child) {
        var value = child.children[0].value;

        if (data.reset) {
          child.classList.remove("active");
          child.children[0].removeAttribute("checked");
        }

        var match = data.fixed ? data.pattern.indexOf(value) > -1 : RegExp(data.pattern, "i").test(value);

        if (match !== data.invert) {
          child.classList.add("active");
          child.children[0].setAttribute("checked", "");
        }
      });
    },
    _enable: function _enable(el, data) {
      var values = data.values;
      el.querySelectorAll("input").forEach(function (input) {
        var enable = !values.length || values.indexOf(input.value) > -1;

        if (enable !== data.invert) {
          input.parentNode.classList.remove("disabled");
          input.removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      var values = data.values;
      el.querySelectorAll("input").forEach(function (input) {
        var disable = !values.length || values.indexOf(input.value) > -1;

        if (data.reset) {
          input.parentNode.classList.remove("disabled");
          input.removeAttribute("disabled");
        }

        if (disable !== data.invert) {
          input.parentNode.classList.add("disabled");
          input.setAttribute("disabled", "");
        }
      });
    }
  });
  Shiny.inputBindings.register(radiobarInputBinding, "yonder.radiobarInput");

  var rangeInputBinding = new Shiny.InputBinding();
  $.extend(rangeInputBinding, {
    Selector: {
      SELF: ".yonder-range[id]"
    },
    Events: [{
      type: "change"
    }],
    initialize: function initialize(el) {
      $(el.querySelector("input")).ionRangeSlider();
    },
    getId: function getId(el) {
      return el.id;
    },
    getValue: function getValue(el) {
      var $input = $("input[type='text']", el);
      var data = $input.data("ionRangeSlider");

      if ($input.data("type") === "double") {
        return [data.result.from, data.result.to];
      } else if ($input.data("type") === "single") {
        if (data.result.from_value !== null) {
          return data.result.from_value.replace("&#44;", ",");
        } else {
          return data.result.from;
        }
      } else {
        return null;
      }
    },
    getState: function getState(el, data) {
      return {
        value: this.getValue(el)
      };
    },
    _update: function _update(el, data) {
      $(el.querySelector(".irs-hidden-input")).data("ionRangeSlider").update({
        values: data.values
      });
    },
    _select: function _select(el, data) {
      $(el.querySelector(".irs-hidden-input")).data("ionRangeSlider"); // need to check if input is a numeric range input or choices slider
    },
    dispose: function dispose(el) {
      $(el.querySelector(".irs-hidden-input")).data("ionRangeSlider").destroy();
    }
  });
  Shiny.inputBindings.register(rangeInputBinding, "yonder.rangeInput");

  var selectInputBinding = new Shiny.InputBinding();
  $.extend(selectInputBinding, {
    Selector: {
      SELF: ".yonder-select",
      SELECTED: "option:checked:not(:disabled)",
      VALIDATE: "select"
    },
    Events: [{
      type: "change"
    }],
    _update: function _update(el, data) {
      var template = el.querySelector("option").cloneNode();
      template.removeAttribute("selected");
      template.removeAttribute("disabled");
      el.innerHTML = "";
      data.choices.forEach(function (choice, i) {
        var child = template.cloneNode();
        child.innerText = choice;
        child.value = data.values[i];

        if (data.selected.indexOf(data.values[i]) > -1) {
          el.querySelector("select").value = child.value;
        }

        el.appendChild(child);
      });
    },
    _select: function _select(el, data) {
      el.querySelectorAll("option").forEach(function (child) {
        var value = child.value;

        if (data.reset === true) {
          child.removeAttribute("selected");
        }

        var match = data.fixed ? data.pattern.indexOf(value) : RegExp(data.pattern, "i").test(value);

        if (match !== data.invert) {
          el.querySelector("select").value = value;
        }
      });
    },
    _enable: function _enable(el, data) {
      el.querySelectorAll("option").forEach(function (opt) {
        var enable = !data.values.length || data.values.indexOf(opt.value);

        if (enable !== data.invert) {
          opt.removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      el.querySelectorAll("option").forEach(function (opt) {
        var disable = !data.values.length || data.values.indexOf(opt.value);

        if (data.reset) {
          opt.removeAttribute("disabled");
        }

        if (disable !== data.invert) {
          opt.setAttribute("disabled", "");
        }
      });
    }
  });
  Shiny.inputBindings.register(selectInputBinding, "yonder.selectInput");

  var textualInputBinding = new Shiny.InputBinding();
  $.extend(textualInputBinding, {
    Selector: {
      SELF: ".yonder-textual",
      VALIDATE: "input"
    },
    Events: [{
      type: "change",
      debounce: true
    }, {
      type: "input",
      debounce: true
    }],
    getValue: function getValue(el) {
      var input = el.children[0];
      return input.type === "number" ? parseInt(input.value, 10) : input.value;
    },
    getRatePolicy: function getRatePolicy() {
      return {
        policy: "debounce",
        delay: 250
      };
    },
    _update: function _update(el, data) {
      el.children[0].value = data.values[0];
    },
    _disable: function _disable(el, data) {
      el.children[0].setAttribute("disabled", "");
    },
    _enable: function _enable(el, data) {
      el.children[0].removeAttribute("disabled");
    }
  });
  Shiny.inputBindings.register(textualInputBinding, "yonder.textualInput");

  var badgeOutputBinding = new Shiny.OutputBinding();
  $.extend(badgeOutputBinding, {
    find: function find(scope) {
      return $(scope).find(".yonder-badge[id]");
    },
    getId: function getId(el) {
      return el.id;
    },
    renderValue: function renderValue(el, msg) {
      if (msg.data !== undefined) {
        el.innerHTML = msg.data;
      }
    },
    renderError: function renderError(el, data) {},
    clearError: function clearError(el) {}
  });
  Shiny.outputBindings.register(badgeOutputBinding, "yonder.badgeOutput");

  $.extend(Shiny.progressHandlers, {
    "yonder-progress": function yonderProgress(msg) {
      if (!msg.type || !msg.data.outlet) {
        return false;
      }

      var $outlet = $("#" + msg.data.outlet);

      if (msg.type === "show") {
        var $bar = $(msg.data.content);

        if ($bar[0].id && $outlet.find("#" + $bar[0].id).length) {
          $outlet.find("#" + $bar[0].id).replaceWith($bar);
        } else {
          $outlet.append($bar);
        }

        return true;
      }

      return false;
    }
  });

  var tableInputBinding = new Shiny.InputBinding();
  $.extend(tableInputBinding, {
    Selector: {
      SELF: ".yonder-table[id]"
    },
    Type: "yonder.table",
    Events: [{
      type: "chabudai:select"
    }, {
      type: "chabudai:edited"
    }],
    getValue: function getValue(el) {
      return JSON.stringify($(el).table("selected"));
    },
    receiveMessage: function receiveMessage(el, msg) {
      return;
    }
  });
  var tableOutputBinding = new Shiny.OutputBinding();
  $.extend(tableOutputBinding, {
    find: function find(scope) {
      return $(scope).find(".yonder-table[id]");
    },
    renderValue: function renderValue(el, msg) {
      if (msg.data) {
        $(el).table({
          "data": msg.data
        });
      }
    }
  });
  Shiny.inputBindings.register(tableInputBinding, "yonder.tableInput");
  Shiny.outputBindings.register(tableOutputBinding, "yonder.tableOutput");

  Shiny.addCustomMessageHandler("yonder:collapse", function (msg) {
    if (msg.type === undefined || msg.data === undefined || msg.data.target === undefined) {
      return false;
    }

    if (msg.type === "show" || msg.type === "hide" || msg.type === "toggle") {
      var target = document.getElementById(msg.data.target);

      if (target === null) {
        return false;
      }

      $(target).collapse(msg.type);
      return true;
    }

    return false;
  });

  Shiny.addCustomMessageHandler("yonder:element", function (msg) {
    var _render = function _render(data) {
      if (data.dependencies) {
        Shiny.renderDependencies(data.dependencies);
      }

      var container = document.getElementById(data.target);

      if (container === null) {
        return;
      }

      Shiny.unbindAll(container);
      container.innerHTML = data.content;
      Shiny.initializeInputs(container);
      Shiny.bindAll(container);
    };

    var _remove = function _remove(data) {
      var container = document.getElementById(data.target);

      if (container === null) {
        return;
      }

      Shiny.unbindAll(container);
      container.innerHTML = "";
    };

    if (!msg.type) {
      return;
    }

    if (msg.type === "render") {
      _render(msg.data);
    } else if (msg.type === "remove") {
      _remove(msg.data);
    } else {
      console.warn("no element " + msg.type + " method");
    }
  });

  $(function () {
    $(document).on("hidden.bs.modal", ".modal", function (e) {
      Shiny.unbindAll(e.currentTarget);
    });
  });
  Shiny.addCustomMessageHandler("yonder:modal", function (msg) {
    if (msg.type === undefined) {
      return false;
    }

    var _show = function _show(data) {
      $(document.getElementById(data.id)).modal("show");
    };

    var _register = function _register(data) {
      var modal = document.createElement("div");
      modal.classList.add("modal");
      modal.classList.add("fade");
      modal.setAttribute("tabindex", -1);
      modal.setAttribute("role", "dialog");
      modal.setAttribute("id", data.id);

      if (data.dependencies !== undefined) {
        Shiny.renderDependencies(data.dependencies);
      }

      document.body.appendChild(modal);
      modal.insertAdjacentHTML("afterbegin", data.content);
      Shiny.initializeInputs(modal);
      Shiny.bindAll(modal);
    };

    if (msg.type === "hide") {
      _close(msg.data);
    } else if (msg.type === "show") {
      _show(msg.data);
    } else if (msg.type === "register") {
      _register(msg.data);
    } else {
      console.warn("no modal " + msg.type + " method");
    }
  });

  $(function () {
    document.body.insertAdjacentHTML("beforeend", "<div class='toasts'></div>");
    $(".toasts").on("hidden.bs.toast", ".toast", function (e) {
      if (e.currentTarget.hasAttribute("data-action")) {
        var action = e.currentTarget.getAttribute("data-action");
        Shiny.onInputChange(action, true);
        setTimeout(function () {
          return Shiny.onInputChange(action, null);
        }, 100);
      }

      e.delegateTarget.removeChild(e.currentTarget);
    });
  });
  Shiny.addCustomMessageHandler("yonder:toast", function (msg) {
    var _show = function _show(data) {
      document.querySelector(".toasts").insertAdjacentHTML("beforeend", data.content);
      $(".toasts > .toast:last-child").toast("show");
    };

    var _close = function _close(data) {
      var toasts = document.querySelectorAll(".toasts .toast");

      if (toasts.length) {
        $(toasts).toast("hide");
      }
    };

    if (!msg.type) {
      return;
    }

    if (msg.type === "show") {
      _show(msg.data);
    } else if (msg.type === "close") {
      _close(msg.data);
    } else {
      console.warn("no toast " + msg.type + " method");
    }
  });

  $(function () {
    $("[data-toggle=\"tooltip\"]").tooltip();
    $("[data-toggle=\"popover\"]").popover();
    $(document).on("shiny:connected", function () {
      $(".yonder-submit[data-type=\"submit\"]").attr("type", "submit");
    });
    Shiny.addCustomMessageHandler("yonder:popover", function (msg) {
      if (msg.data.target === undefined) {
        return;
      }

      if (msg.type == "show") {
        var data = msg.data;
        var target = "#" + data.target;
        $(target).popover({
          title: function title() {
            return undefined;
          },
          content: function content() {
            return undefined;
          },
          template: data.content,
          placement: data.placement,
          trigger: "manual"
        });

        if (data.duration) {
          setTimeout(function () {
            return $(target).popover("hide");
          }, data.duration);
        }

        $(target).popover("show");
        return;
      }

      if (msg.type == "close") {
        $("#" + msg.data.id).popover("hide");
        return;
      }
    });
    Shiny.addCustomMessageHandler("yonder:download", function (msg) {
      if (!(msg.filename && msg.token && msg.key)) {
        throw "invalid download event";
      }

      var uri = "/session/" + msg.token + "/download/" + msg.key;
      var agent = window.navigator.userAgent;
      var ie = ua.indexOf("MSIE ");

      if (ie > 0) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", uri);
        xhr.responseType = "blob";

        xhr.onload = function () {
          return saveAs(xhr.response, msg.filename);
        };

        xhr.send();
      } else {
        fetch(uri).then(function (res) {
          return res.blob();
        }).then(function (blob) {
          saveAs(blob, msg.filename);
        });
      }
    });
  });

})));
//# sourceMappingURL=yonder.js.map
