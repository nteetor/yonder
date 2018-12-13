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
          var result = handler(el, selector && e.target || undefined, _this);

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
      "SELF": ".yonder-button-group",
      "CHOICE": ".btn",
      "VALUE": ".btn"
    },
    Events: [{
      "type": "click",
      "selector": "button",
      "callback": function callback(el, target, self) {
        return self._VALUES[el.id] = target.getAttribute("data-value");
      }
    }],
    _VALUES: {},
    getType: function getType(el) {
      return "yonder.buttonGroup";
    },
    getValue: function getValue(el) {
      return {
        "force": Date.now(),
        "value": this._VALUES[el.id]
      };
    },
    _update: function _update(el, data) {
      if (data.choices) {
        var children = document.querySelectorAll(".btn");
        children.forEach(function (child, i) {
          child.innerHTML = data.choices[i];
          child.setAttribute("data-value", data.values[i]);
        });
      } // can't "select"

    },
    _enable: function _enable(el, data) {
      var _this = this;

      var children = el.querySelectorAll(this.Selector.CHILD);
      children.forEach(function (child) {
        var value = child.querySelector(_this.Selector.VALUE).getAttribute("data-value");
        var index = data.values ? data.values.indexOf(value) : 0;

        if (index > -1 === !data.invert) {
          child.classList.remove("disabled");
          child.querySelector(_this.Selector.VALUE).removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      var _this2 = this;

      var children = el.querySelectorAll(this.Selector.CHILD);
      children.forEach(function (child) {
        var value = child.querySelector(_this2.Selector.VALUE).getAttribute("data-value");
        var index = data.values ? data.values.indexOf(value) : 0;

        if (index > -1 === !data.invert) {
          child.classList.add("disabled");
          child.querySelector(_this2.Selector.VALUE).setAttribute("disabled", "");
        } else if (data.reset) {
          child.classList.remove("disabled");
          child.querySelector(_this2.Selector.VALUE).removeAttribute("disabled");
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
      return el.value > 0 ? +el.value : null;
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
      } else {
        var possibles = el.querySelectorAll("input");

        if (index < possibles.length) {
          possibles[index].parentNode.classList.add("active");
          possibles[index].setAttribute("selected", "");
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

        if (enable && !data.invert) {
          btn.classList.remove("disabled");
          btn.children[0].removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      var values = data.values;
      el.querySelectorAll(".btn").forEach(function (btn) {
        var disable = !values.length || values.indexOf(btn.children[0].value) > -1;

        if (disable && !data.invert) {
          btn.classList.add("disabled");
          btn.children[0].setAttribute("disabled", "");
        } else if (data.reset) {
          btn.classList.remove("disabled");
          btn.children[0].removeAttribute("disabled");
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

        if (enable && !data.invert) {
          input.removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      el.querySelectorAll("input").forEach(function (input) {
        var disable = !data.values.length && data.values.indexOf(input.value) > -1;

        if (disable && !data.invert) {
          input.setAttribute("disabled", "");
        } else if (data.reset) {
          input.removeAttribute("disabled");
        }
      });
    }
  });
  Shiny.inputBindings.register(checkboxInputBinding, "yonder.checkboxInput");

  var dateInputBinding = new Shiny.InputBinding();
  $.extend(dateInputBinding, {
    Selector: {
      SELF: ".yonder-date"
    },
    Events: [{
      type: "dateinput:close"
    }],
    Type: "yonder.date",
    initialize: function initialize(el) {
      var data = $(el).data();
      var config = {
        onClose: function onClose(selected, str, inst) {
          return $(el).trigger("dateinput:close");
        }
      };

      if (data.mode === "multiple" && data.altFormat === "alt-format") {
        config.altFormat = "M j, Y";
        config.conjunction = "; ";
      }

      if (data.defaultDate && (data.mode === "range" || data.mode === "multiple")) {
        config.defaultDate = data.defaultDate.split("\\,");
        el.removeAttribute("data-default-date");
      }

      if (data.enable) {
        config.enable = data.enable.split("\\,");
        el.removeAttribute("data-enable");
      }

      flatpickr(el, config);
    },
    getValue: function getValue(el) {
      return el._flatpickr.selectedDates;
    },
    _update: function _update(el, data) {
      if (data.selected) {
        el._flatpickr.setDate(data.selected, true);
      }
    },
    _enable: function _enable(el, data) {
      el._flatpickr.set("enable", data.values);
    },
    _disable: function _disable(el, data) {
      el._flatpickr.set("disable", data.values);
    }
  });
  Shiny.inputBindings.register(dateInputBinding, "yonder.dateInput");

  var fileInputBinding = new Shiny.InputBinding();
  $.extend(fileInputBinding, {
    Selector: {
      SELF: ".yonder-file[id]",
      VALIDATE: "input[type='file']"
    },
    getValue: function getValue(el) {
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
            var $input = $(el).find("input[type='file']");
            $input.val("");
            $input.text("Choose file");
          }, function (err) {
            console.error("uploadEnd request failed for " + el.id + ": " + err);
          });
        }
      };

      xhr.send(file);
    },
    _doUpload: function _doUpload(el, files) {
      var _this = this;

      if (!files) {
        return;
      }

      var info = Array.prototype.map.call(files, function (f) {
        return {
          "name": f.name,
          "size": f.size,
          "type": f.type
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
    },
    subscribe: function subscribe(el, callback) {
      var _this2 = this;

      var $el = $(el);
      var input = el.querySelector("input[type='file']");
      $el.on("click.yonder", ".input-group-prepend, .input-group-append", function (e) {
        input.click();
      });

      if (el.querySelector("button") !== null) {
        $el.on("click.yonder", "button", function (e) {
          _this2._doUpload(el, input.files);
        });
      } else {
        $el.on("change.yonder", function (e) {
          _this2._doUpload(el, input.files);
        });
      }

      $el.on("dragover.yonder", function (e) {
        e.stopPropagation();
        e.preventDefault();
      });
      $el.on("dragenter.yonder", function (e) {
        e.stopPropagation();
        e.preventDefault();
      });
      $el.on("drop.yonder", function (e) {
        e.stopPropagation();
        e.preventDefault();

        if (input.hasAttribute("multiple")) {
          _this2._doUpload(el, e.originalEvent.dataTransfer.files);
        } else {
          _this2._doUpload(el, e.originalEvent.dataTransfer.files[0]);
        }
      });
    }
  });
  Shiny.inputBindings.register(fileInputBinding, "yonder.fileInput");

  var formInputBinding = new Shiny.InputBinding();
  $.extend(formInputBinding, {
    Events: [{
      type: "click",
      selector: ".yonder-submit",
      callback: function callback(el, target, self) {
        self._VALUES[el.id] = target.value;
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
    }
  });
  Shiny.inputBindings.register(formInputBinding, "yonder.formInput");

  var groupInputBinding = new Shiny.InputBinding();
  $.extend(groupInputBinding, {
    Selector: {
      SELF: ".yonder-group[id]",
      VALUE: "input",
      SELECTED: ".input-group-prepend .input-group-text, input, .input-group-append .input-group-text"
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
      if (data.values) {
        var input = el.querySelector("input");
        input.value = data.values[0];
      }
    },
    _enable: function _enable(el, data) {
      el.querySelector("input").removeAttribute("disabled");
    },
    _disable: function _disable(el, data) {
      el.querySelector("input").setAttribute("disabled", "");
    },
    _validate: function _validate(el, data) {
      el.querySelector("input").classList.remove("is-invalid");
    },
    _invalidate: function _invalidate(el, data) {
      el.querySelector("input").classList.add("is-invalid");
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
      return {
        value: +el.value,
        id: el.id
      };
    },
    _update: function _update(el, data) {
      if (data.choices.length) {
        el.innerHTML = data.choices[0];
      }

      if (data.values.length) {
        el.value = data.values[0];
      }
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
      VALUE: ".list-group-item-action:not(.disabled)",
      SELECTED: ".list-group-item-action.active:not(.disabled)"
    },
    Events: [{
      type: "click",
      selector: ".list-group-item-action:not(.disabled)",
      callback: function callback(el, target, self) {
        if (el.getAttribute("data-multiple") === "false") {
          el.querySelectorAll(self.Selector.VALUE).forEach(function (child) {
            child.classList.remove("active");
          });
        }

        target.classList.toggle("active");
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
      callback: function callback(el, target) {
        var active = el.querySelector(".dropdown-item.active");

        if (active) {
          active.classList.remove("active");
        }

        target.classList.add("active");
      }
    }, {
      type: "change",
      selector: ".dropdown-item:not(.disabled)"
    }],
    Type: "yonder.menu",
    find: function find(scope) {
      return scope.querySelectorAll(":not(.nav) > " + this.Selector.SELF + "[id]");
    },
    getValue: function getValue(el) {
      var selected = el.querySelector(".dropdown-item.active");
      return {
        force: Date.now(),
        value: selected && selected.value
      };
    },
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
      var children = el.querySelectorAll(".dropdown-item");
      children.forEach(function (child) {
        var enable = !data.values.length || data.values.indexOf(child.value) > -1;

        if (enable && !data.invert) {
          child.classList.remove("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      var children = el.querySelectorAll(".dropdown-item");
      children.forEach(function (child) {
        var disable = !data.values.length || data.values.indexOf(child.value) > -1;

        if (disable && !data.invert) {
          child.classList.add("disabled");
        } else if (data.reset) {
          child.classList.remove("disabled");
        }
      });
    }
  });
  Shiny.inputBindings.register(menuInputBinding, "yonder.menuInput");

  var navInputBinding = new Shiny.InputBinding();
  $.extend(navInputBinding, {
    Selector: {
      SELF: ".yonder-nav[id]",
      SELECTED: ".nav-link.active:not(.disabled)"
    },
    Events: [{
      type: "click",
      selector: "a",
      callback: function callback(el) {
        return false;
      }
    }, {
      type: "click",
      selector: ".nav-link:not(.dropdown-toggle):not(.disabled)",
      callback: function callback(el, target) {
        el.querySelectorAll(".active").forEach(function (a) {
          return a.classList.remove("active");
        });
        target.classList.add("active");
      }
    }, {
      type: "click",
      selector: ".dropdown-item:not(.disabled)",
      callback: function callback(el, target) {
        el.querySelectorAll(".active").forEach(function (a) {
          return a.classList.remove("active");
        });
        target.parentNode.parentNode.firstElementChild.classList.add("active");
        target.classList.add("active");
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
      el.querySelectorAll("[data-value]").forEach(function (child) {
        var value = child.getAttribute("data-value");
        var index = data.values ? data.values.indexOf(value) : 0;

        if (index > -1 === !data.invert) {
          child.classList.add("disabled");
        } else if (data.reset) {
          child.classList.remove("disabled");
        }
      });
    },
    _enable: function _enable(el, data) {
      el.querySelectorAll("[data-value]").forEach(function (child) {
        var value = child.getAttribute("data-value");
        var index = data.values ? data.values.indexOf(value) : 0;

        if (index > -1 === !data.invert) {
          child.classList.remove("disabled");
        }
      });
    }
  });
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
  Shiny.inputBindings.register(navInputBinding, "yonder.navInput");

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
      var children = el.querySelectorAll(".custom-control-input");
      children.forEach(function (child) {
        var enable = !data.values.length || data.values.indexOf(child.value) > -1;

        if (enable && !data.invert) {
          child.classList.removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      var children = el.querySelectorAll(".custom-control-input");
      children.forEach(function (child) {
        var disable = !data.values.length || data.values.indexOf(child.value) > -1;

        if (disable && !data.invert) {
          child.setAttribute("disabled", "");
        } else if (data.reset) {
          child.removeAttribute("disabled");
        }
      });
    }
  });
  Shiny.inputBindings.register(radioInputBinding, "yonder.radioInput");

  var radiobarInputBinding = new Shiny.InputBinding();
  $.extend(radiobarInputBinding, {
    Selector: {
      SELF: ".yonder-radiobar[id]",
      VALUE: ".btn input",
      LABEL: ".btn > span",
      SELECTED: ".btn input:checked"
    },
    Events: [{
      type: "click"
    }, {
      type: "change"
    }],
    getState: function getState(el, data) {
      return {
        value: this.getValue(el)
      };
    },
    _update: function _update(el, data) {
      var children = el.querySelectorAll(".btn");

      if (data.choices) {
        children.forEach(function (child, i) {
          child.querySelector("span").innerHTML = data.choices[i];
          child.querySelector("input").setAttribute("data-value", data.values[i]);
        });
      }

      if (data.selected) {
        el.querySelector(".active").classList.remove("active");
        el.querySelector("input[data-value=" + data.selected + "]").parentNode.classList.add("active");
      }
    },
    _enable: function _enable(el, data) {
      var children = el.querySelectorAll(".btn");
      children.forEach(function (child) {
        var input = child.querySelector("input");
        var value = input.getAttribute("data-value");
        var index = data.values ? data.values.indexOf(value) : 0;

        if (index > -1 === !data.invert) {
          child.classList.remove("disabled");
          input.removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      var children = el.querySelectorAll(".btn");
      children.forEach(function (child) {
        var input = child.querySelector("input");
        var value = input.getAttribute("data-value");
        var index = data.values ? data.values.indexOf(value) : 0;

        if (index > -1 === !data.invert) {
          child.classList.add("disabled");
          input.setAttribute("disabled", "");
        } else if (data.reset) {
          child.classList.remove("disabled");
          input.removeAttribute("disabled");
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

        if (enable && !data.invert) {
          opt.removeAttribute("disabled");
        }
      });
    },
    _disable: function _disable(el, data) {
      el.querySelectorAll("option").forEach(function (opt) {
        var disable = !data.values.length || data.values.indexOf(opt.value);

        if (disable && !data.invert) {
          opt.setAttribute("disabled", "");
        } else if (data.reset) {
          opt.removeAttribute("disabled");
        }
      });
    }
  });
  Shiny.inputBindings.register(selectInputBinding, "yonder.selectInput");

  var textualInputBinding = new Shiny.InputBinding();
  $.extend(textualInputBinding, {
    Selector: {
      SELF: ".yonder-textual[id]",
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
      var input = el.querySelector("input");
      var value = input.value;

      if (input.type === "number") {
        return parseInt(value, 10);
      }

      return value;
    },
    getState: function getState(el, data) {
      return {
        value: this.getValue(el)
      };
    },
    getRatePolicy: function getRatePolicy() {
      return {
        policy: "debounce",
        delay: 250
      };
    },
    _update: function _update(el, data) {
      data.values && (el.querySelector("input").value = data.values[0]);
    },
    _disable: function _disable(el, data) {
      el.querySelector("input").setAttribute("disabled", "");
    },
    _enable: function _enable(el, data) {
      el.querySelector("input").removeAttribute("disabled");
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

    console.log(msg);

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
