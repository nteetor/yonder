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
      var _this3 = this;

      if (!msg.type || msg.data === undefined) {
        return false;
      }

      switch (msg.type) {
        case "update":
          var values = msg.data.values;
          var choices = msg.data.choices;
          var selected = msg.data.selected;

          if (values || choices || selected) {
            this._clear(el);
          }

          if (values) {
            values.forEach(function (_ref, i) {
              var value = _ref[0],
                  current = _ref[1];

              _this3._value(el, value, current, i);
            });
          }

          if (choices) {
            choices.forEach(function (_ref2, i) {
              var value = _ref2[0],
                  current = _ref2[1];

              _this3._choice(el, value, current, i);
            });
          }

          if (selected) {
            selected.forEach(function (value) {
              _this3._select(el, value);
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
    _choice: function _choice(el, newLabel, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector("button[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.innerHTML = newLabel;
        }
      } else {
        var buttons = el.querySelectorAll("button");

        if (index < buttons.length) {
          buttons[index].innerHTML = newLabel;
        }
      }
    },
    _value: function _value(el, newValue, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector("button[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.value = newValue;
        }
      } else {
        var buttons = el.querySelectorAll("button");

        if (index < buttons.length) {
          buttons[index].value = newValue;
        }
      }
    },
    _select: function _select() {
      return null;
    },
    _clear: function _clear() {
      return null;
    },
    _enable: function _enable(el, data) {
      var values = data.values;
      el.querySelectorAll("button").forEach(function (button) {
        var enable = !values.length || values.indexOf(button.value) > -1;

        if (enable !== data.invert) {
          button.classList.remove("disabled");
          button.removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      var values = data.values;
      el.querySelectorAll("button").forEach(function (button) {
        var disable = !values.length || values.indexOf(button.value) > -1;

        if (data.reset) {
          button.classList.remove("disabled");
          button.removeAttribute("disabled");
        }

        if (disable !== data.invert) {
          button.classList.add("disabled");
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
    _choice: function _choice(el, newLabel, currentValue, index) {
      el.innerHTML = newLabel;
    },
    _value: function _value(el, newValue, currentValue, index) {
      if (+newValue === +newValue) {
        el.value = newValue;
      }
    },
    _select: function _select(el, currentValue, index) {// cannot select
    },
    _clear: function _clear(el) {// no need to do anything
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
    _value: function _value(el, newValue, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector("input[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.value = newValue;
        }
      } else {
        var possibles = el.querySelectorAll("input");

        if (index < possibles.length) {
          possibles[index].value = newValue;
        }
      }
    },
    _choice: function _choice(el, newLabel, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector("input[value=\"" + currentValue + "\"]");

        if (target !== null) {
          var btn = target.parentNode;
          var input = target.cloneNode();
          btn.innerHTML = "";
          btn.appendChild(input);
          btn.insertAdjacentText("beforeend", newLabel);
        }
      } else {
        var possibles = el.querySelectorAll("input");

        if (index < possibles.length) {
          var _btn = possibles[index].parentNode;

          var _input = possibles[index].cloneNode();

          _btn.innerHTML = "";

          _btn.appendChild(_input);

          _btn.insertAdjacentText("beforeend", newLabel);
        }
      }
    },
    _select: function _select(el, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector("input[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.parentNode.classList.add("active");
          target.setAttribute("selected", "");
        }
      }
    },
    _clear: function _clear(el) {
      el.querySelectorAll(".btn").forEach(function (btn) {
        btn.classList.remove("active");
        btn.children[0].setAttribute("selected", "");
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
    _value: function _value(el, newValue, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector("input[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.value = newValue;
        }
      } else {
        var possibles = el.querySelectorAll("input");

        if (index < possibles.length) {
          possibles[index].value = newValue;
        }
      }
    },
    _choice: function _choice(el, newLabel, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector("input[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.parentNode.children[1].innerHTML = newLabel;
        }
      } else {
        var possibles = el.querySelectorAll("input");

        if (index < possibles.length) {
          possibles[index].parentNode.children[1].innerHTML = newLabel;
        }
      }
    },
    _select: function _select(el, currentValue) {
      if (currentValue !== null) {
        var target = el.querySelector("input[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.checked = true;
        }
      }
    },
    _clear: function _clear(el) {
      el.querySelectorAll("input").forEach(function (input) {
        input.checked = false;
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
    _value: function _value(el, newValue, currentValue, index) {
      el.querySelector("input").value = newValue;
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
    Type: "yonder.link",
    initialize: function initialize(el) {
      el.value = 0;
    },
    getValue: function getValue(el) {
      return +el.value > 0 ? +el.value : null;
    },
    _value: function _value(el, newValue, currentValue, index) {
      el.value = newValue;
    },
    _choice: function _choice(el, newLabel, currentValue, index) {
      el.innerHTML = newLabel;
    },
    _select: function _select() {
      return null;
    },
    _clear: function _clear() {
      return null;
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
      SELECTED: ".list-group-item-action.active:not(.disabled)"
    },
    Events: [{
      type: "click",
      selector: ".list-group-item-action:not(.disabled)",
      callback: function callback(el, e, self) {
        if (el.getAttribute("data-multiple") === "false") {
          el.querySelectorAll(".list-group-item-action:not(.disabled)").forEach(function (li) {
            return li.classList.remove("active");
          });
        }

        e.currentTarget.classList.toggle("active");
      }
    }],
    _value: function _value(el, newValue, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector(".list-group-item[data-value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.setAttribute("data-value", newValue);
        }
      } else {
        var possibles = el.querySelectorAll(".list-group-item");

        if (index < possibles.length) {
          possibles[index].setAttribute("data-value", newValue);
        }
      }
    },
    _choice: function _choice(el, newLabel, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector(".list-group-item[data-value\"" + currentValue + "\"]");

        if (target !== null) {
          target.innerHTML = newLabel;
        }
      } else {
        var possibles = el.querySelectorAll(".list-group-item");

        if (index < possibles.length) {
          possibles[index].innerHTML = newLabel;
        }
      }
    },
    _select: function _select(el, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector(".list-group-item[data-value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.classList.add("active");
        }
      } else {
        var possibles = el.querySelectorAll(".list-group-item");

        if (index < possibles.length) {
          possibles[index].classList.add("active");
        }
      }
    },
    _clear: function _clear(el) {
      el.querySelectorAll(".list-group-item").forEach(function (li) {
        return li.classList.remove("active");
      });
    },
    _enable: function _enable(el, data) {
      var values = data.values;
      el.querySelectorAll(".list-group-item").forEach(function (li) {
        var enable = !values.length || values.indexOf(li.getAttribute("data-value")) > -1;

        if (enable !== data.invert) {
          li.classList.remove("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      var values = data.values;
      el.querySelectorAll(".list-group-item").forEach(function (li) {
        var disable = !values.length || values.indexOf(li.getAttribute("data-value")) > -1;

        if (data.reset) {
          li.classList.remove("disabled");
        }

        if (disable !== data.invert) {
          li.classList.add("disabled");
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
    _value: function _value(el, newValue, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector(".dropdown-item[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.value = newValue;
        }
      } else {
        var possibles = el.querySelectorAll(".dropdown-item");

        if (index < possibles.length) {
          possibles[index].value = newValue;
        }
      }
    },
    _choice: function _choice(el, newLabel, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector(".dropdown-item[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.innerHTML = newLabel;
        }
      } else {
        var possibles = el.querySelectorAll(".dropdown-item");

        if (index < possibles.length) {
          possibles[index].innerHTML = newLabel;
        }
      }
    },
    _select: function _select(el, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector(".dropdown-item[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.classList.add("active");
        }
      } else {
        var possibles = el.querySelectorAll(".dropdown-item");

        if (index < possibles.length) {
          possibles[index].classList.add("active");
        }
      }
    },
    _clear: function _clear(el) {
      el.querySelectorAll(".dropdown-item.active").forEach(function (di) {
        return di.classList.remove("active");
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
    _value: function _value(el, newValue, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector(".nav-link[data-value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.setAttribute("data-value", newValue);
        }
      } else {
        var possibles = el.querySelectorAll(".nav-link");

        if (index < possibles.length) {
          possibles[index].setAttribute("data-value", newValue);
        }
      }
    },
    _choice: function _choice(el, newLabel, currentValue, index) {
      if (currentValue !== null) {
        var child = el.querySelector(".nav-link[data-value=\"" + currentValue + "\"]");

        if (child !== null) {
          child.innerHTML = newLabel;
        }
      } else {
        var possibles = el.querySelectorAll(".nav-link");

        if (index < possibles.length) {
          possibles[index].innerHTML = newLabel;
        }
      }
    },
    _select: function _select(el, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector(".nav-link[data-value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.classList.add("active");
        }
      } else {
        var children = el.querySelectorAll(".nav-link");

        if (index < children.length) {
          children[index].classList.add("active");
        }
      }
    },
    _clear: function _clear(el) {
      el.querySelectorAll(".nav-link.active").forEach(function (nl) {
        return nl.classList.remove("active");
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
    _value: function _value(el, newValue, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector(".custom-control-input[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.value = newValue;
        }
      } else {
        var possibles = el.querySelectorAll(".custom-control-input");

        if (index < possibles.length) {
          possibles[index].value = newValue;
        }
      }
    },
    _choice: function _choice(el, newLabel, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector(".custom-control-input[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.nextElementSibling.innerHTML = newLabel;
        }
      } else {
        var possibles = el.querySelectorAll(".custom-control-label");

        if (index < possibles.length) {
          possibles[index].innerHTML = newLabel;
        }
      }
    },
    _select: function _select(el, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector(".custom-control-input[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.setAttribute("checked", "");
        }
      } else {
        var possibles = el.querySelectorAll(".custom-control-input");

        if (index < possibles.length) {
          possibles[index].setAttribute("checked", "");
        }
      }
    },
    _clear: function _clear(el) {
      el.querySelector(this.Selector.SELECTED).removeAttribute("checked");
    },
    _enable: function _enable(el, data) {
      el.querySelectorAll(".custom-control-input").forEach(function (input) {
        var enable = !data.values.length || data.values.indexOf(input.value) > -1;

        if (enable !== data.invert) {
          input.classList.removeAttribute("disabled");
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
    _value: function _value(el, newValue, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector("input[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.value = newValue;
        }
      } else {
        var inputs = el.querySelectorAll("input");

        if (index < inputs.length) {
          inputs[index].value = newValue;
        }
      }
    },
    _choice: function _choice(el, newLabel, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector("input[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.parentNode.children[1].innerHTML = newLabel;
        }
      } else {
        var inputs = el.querySelectorAll("input");

        if (index < inputs.length) {
          inputs[index].parentNode.children[1].innerHTML = newLabel;
        }
      }
    },
    _select: function _select(el, currentValue) {
      if (currentValue !== null) {
        var target = el.querySelector("input[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.checked = true;
          target.parentNode.classList.add("active");
        }
      }
    },
    _clear: function _clear(el) {
      el.querySelectorAll("input:checked").forEach(function (input) {
        input.checked = false;
        input.parentNode.classList.remove("active");
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
      var $el = $(el);
      var $input = $el.find("input[type='text']");
      $input.ionRangeSlider();
      var bgclasses = $el.attr("class").split(/\s+/).filter(function (c) {
        return /^bg-[a-z-]+$/.test(c);
      }).join(" ");

      if (bgclasses) {
        $el.find(".irs-slider,.irs-bar,.irs-bar-edge,.irs-to,.irs-from,.irs-single,.irs-slider").addClass(bgclasses);
        $el.removeClass(bgclasses);
      }

      if ($input.data("no-fill")) {
        $el.find(".irs-bar,.irs-bar-edge").addClass("no-fill");
      }
    },
    getId: function getId(el) {
      return el.id;
    },
    getValue: function getValue(el) {
      var $input = $("input[type='text']", el);
      var data = $input.data("ionRangeSlider");

      if ($input.data("type") == "double") {
        return [data.result.from, data.result.to];
      } else if ($input.data("type") == "single") {
        if (data.result.from_value !== null) {
          return data.result.from_value.replace("&#44;", ",");
        } else {
          return data.result.from;
        }
      }
    },
    getState: function getState(el, data) {
      return {
        value: this.getValue(el)
      };
    },
    receiveMessage: function receiveMessage(el, msg) {
      console.error("receiveMessage: not implemented for range input");
      return;
    },
    dispose: function dispose(el) {
      var $input = $("input[type='text']", el);
      $input.data("ionRangeSlider").destroy();
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
    _value: function _value(el, newValue, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector("option[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.value = newValue;
        }
      } else {
        var possibles = el.querySelectorAll("option");

        if (index < possibles.length) {
          possibles[index].value = newValue;
        }
      }
    },
    _choice: function _choice(el, newLabel, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector("option[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.innerHTML = newLabel;
        }
      } else {
        var possibles = el.querySelectorAll("option");

        if (index < possibles.length) {
          possibles[index].innerHTML = newLabel;
        }
      }
    },
    _select: function _select(el, currentValue, index) {
      if (currentValue !== null) {
        var target = el.querySelector("option[value=\"" + currentValue + "\"]");

        if (target !== null) {
          target.setAttribute("selected", "");
        }
      } else {
        var possibles = el.querySelectorAll("option");

        if (index < possibles.length) {
          possibles[index].setAttribute("selected", "");
        }
      }
    },
    _clear: function _clear(el) {
      el.querySelectorAll("option").forEach(function (op) {
        return op.removeAttribute("selected");
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
      return input.type === "number" ? parseInput(input.value, 10) : input.value;
    },
    getRatePolicy: function getRatePolicy() {
      return {
        policy: "debounce",
        delay: 250
      };
    },
    _value: function _value(el, newValue, currentValue, index) {
      el.children[0].value = newValue;
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

  var alertInputBinding = new Shiny.InputBinding();
  $(function () {
    $(document.body).append($("<div class='yonder-alert-container' id='alert-container'></div>"));
  });
  $.extend(alertInputBinding, {
    Selector: {
      SELF: ".yonder-alert-container"
    },
    Alerts: [],
    getValue: function getValue(el) {
      return null;
    },
    receiveMessage: function receiveMessage(el, msg) {
      var _this = this;

      if (msg.type === undefined) {
        return;
      }

      if (msg.type === "show") {
        var data = msg.data;
        var $alert = $(data.content);

        if (data.action) {
          $alert.append($("<button class=\"btn btn-link alert-link alert-action\">" + data.action + "</button>"));
          $alert.on("click", ".alert-action", function (e) {
            Shiny.onInputChange(data.action, true);
          });
        }

        this.Alerts.push({
          el: $alert,
          action: data.action
        });
        $alert.appendTo($(this.Selector.SELF)).velocity({
          top: 0,
          opacity: 1
        }, {
          duration: 300,
          easing: "easeOutCubic",
          queue: false
        });

        if (data.duration !== null) {
          setTimeout(function () {
            if (_this.Alerts.length === 0) {
              return;
            }

            var item = _this.Alerts.shift();

            if (item.action) {
              Shiny.onInputChange(item.action, null);
            }

            item.el.remove();
          }, data.duration);
        }

        return;
      }

      if (msg.type === "close") {
        if (this.Alerts.length === 0) {
          return;
        }

        var _data = msg.data;
        var indeces = typeof _data.index === "number" ? [_data.index] : _data.index;
        var text = typeof _data.text === "string" ? [_data.text] : _data.text;
        var selector = Object.entries(_data.attrs).map(function (item) {
          return "[" + item[0] + (item[1] ? (item[0] === "class" ? "*=" : "=") + item[1] : "") + "]";
        }).join("");
        this.Alerts = this.Alerts.filter(function (alert, index) {
          var $el = $(alert.el);

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
      console.warn("no element method _" + msg.type);
    }
  });

  Shiny.addCustomMessageHandler("yonder:modal", function (msg) {
    if (msg.type === undefined) {
      return false;
    }

    if (msg.type === "close") {
      var modal = document.body.querySelector(".modal");

      if (modal === null) {
        return false;
      }

      Shiny.unbindAll(modal);
      $(modal).modal("hide");
      return true;
    }

    if (msg.type === "show") {
      var _modal = document.body.querySelector(".modal");

      if (_modal !== null) {
        _modal.innerHTML = msg.data.content;
      } else {
        $(document.body).append($("<div class=\"modal fade\" tabindex=-1 role=\"dialog\">" + msg.data.content + "</div>"));
        _modal = document.body.querySelector(".modal");
      }

      if (msg.data.dependencies !== undefined) {
        Shiny.renderDependencies(msg.data.dependencies);
      }

      Shiny.initializeInputs(_modal);
      Shiny.bindAll(_modal);
      $(_modal).modal("show");
      return true;
    }

    return false;
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
