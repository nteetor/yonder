(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (factory());
}(this, (function () { 'use strict';

  // IE 11, ensure querySelectorAll + forEach works
  if (window.NodeList && !NodeList.prototype.forEach) {
    NodeList.prototype.forEach = Array.prototype.forEach;
  }

  var buttonGroupInputBinding = new Shiny.InputBinding();
  $.extend(buttonGroupInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-button-group[id]");
    },
    getType: function getType(el) {
      return "yonder.button.group";
    },
    initialize: function initialize(el) {
      $(el).on("click", "button", function (e) {
        el.setAttribute("data-value", e.currentTarget.value);
      });
    },
    getValue: function getValue(el) {
      var value = el.getAttribute("data-value");

      if (value === undefined) {
        value = null;
      }

      return {
        force: Date.now(),
        value: value
      };
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("click.yonder", "button", function (e) {
        return callback();
      });
      $el.on("buttongroup.value.yonder", function (e) {
        return callback();
      });
    },
    unsubscribe: function unsubscribe(el) {
      return $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.content) {
        el.innerHTML = msg.content;
      }

      if (msg.value) {
        el.setAttribute("data-value", msg.value);
      }

      if (msg.enable) {
        el.querySelectorAll("button").forEach(function (btn) {
          if (msg.enable === true || msg.enable.indexOf(btn.value) > -1) {
            btn.classList.remove("disabled");
            btn.removeAttribute("disabled");
          }
        });
      }

      if (msg.disable) {
        el.querySelectorAll("button").forEach(function (btn) {
          if (msg.disable === true || msg.disable.indexOf(btn.value) > -1) {
            btn.classList.add("disabled");
            btn.setAttribute("disabled", "");
          }
        });
      }
    }
  });
  Shiny.inputBindings.register(buttonGroupInputBinding, "yonder.buttonGroupInput");

  var buttonInputBinding = new Shiny.InputBinding();
  $.extend(buttonInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-button[id]");
    },
    initialize: function initialize(el) {
      $(el).on("click", function (e) {
        return el.value = +el.value + 1;
      });
      el.value = 0;
    },
    getValue: function getValue(el) {
      return +el.value > 0 ? +el.value : null;
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("click.yonder", function (e) {
        return callback();
      });
      $el.on("button.value.yonder", function (e) {
        return callback();
      });
    },
    unsubscribe: function unsubscribe(el, callback) {
      return $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.content) {
        el.innerHTML = msg.content;
      }

      if (msg.value !== null && msg.value !== undefined) {
        el.value = msg.value;
        $(el).trigger("button.value.yonder");
      }

      if (msg.enable) {
        el.classList.remove("disabled");
        el.removeAttribute("disabled");
      }

      if (msg.disable) {
        el.classList.add("disabled");
        el.setAttribute("disabled", "");
      }

      if (msg.tooltip !== null) {
        el.setAttribute("data-animation", msg.tooltip.fade);
        el.setAttribute("data-html", "true");
        el.setAttribute("data-placement", msg.tooltip.placement);
        el.setAttribute("data-toggle", "tooltip");
        el.setAttribute("title", msg.tooltip.title);
        el.setAttribute("data-original-title", msg.tooltip.title);
        $(el).tooltip();

        if (el.matches(":hover")) {
          $(el).tooltip("show");
        }
      }
    }
  });
  Shiny.inputBindings.register(buttonInputBinding, "yonder.buttonInput");

  var checkbarInputBinding = new Shiny.InputBinding();
  $.extend(checkbarInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-checkbar[id]");
    },
    getValue: function getValue(el) {
      var checked = el.querySelectorAll("input:checked:not(:disabled)");

      if (checked.length === 0) {
        return null;
      }

      return Array.prototype.map.call(checked, function (c) {
        return c.value;
      });
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("click.yonder", function (e) {
        return callback();
      });
      $el.on("change.yonder", function (e) {
        return callback();
      });
      $el.on("checkbar.select.yonder", function (e) {
        return callback();
      });
    },
    unsubscribe: function unsubscribe(el) {
      return $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.content) {
        el.querySelectorAll(".btn").forEach(function (btn) {
          el.removeChild(btn);
        });
        el.insertAdjacentHTML("afterbegin", msg.content);
      }

      if (msg.selected) {
        if (msg.selected !== true) {
          el.querySelectorAll("input:checked").forEach(function (input) {
            input.checked = false;
            input.parentNode.classList.remove("active");
          });
        }

        el.querySelectorAll("input").forEach(function (input) {
          if (msg.selected === true || msg.selected.indexOf(input.value) > -1) {
            input.checked = true;
            input.parentNode.classList.add("active");
          }
        });
        $(el).trigger("checkbar.select.yonder");
      }

      if (msg.enable) {
        var enable = msg.enable;

        if (enable === true) {
          el.querySelectorAll(".btn").forEach(function (btn) {
            btn.classList.remove("disabled");
            btn.children[0].removeAttribute("disabled");
          });
        } else {
          el.querySelectorAll(".btn").forEach(function (btn) {
            if (enable.indexOf(btn.value) > -1) {
              btn.classList.remove("disabled");
              btn.children[0].removeAttribute("disabled");
            }
          });
        }
      }

      if (msg.disable) {
        var disable = msg.disable;

        if (disable === true) {
          el.querySelectorAll(".btn").forEach(function (btn) {
            btn.classList.add("disabled");
            btn.children[0].setAttribute("disabled", "");
          });
        } else {
          el.querySelectorAll(".btn").forEach(function (btn) {
            if (disable.indexOf(btn.value) > -1) {
              btn.classList.add("disabled");
              btn.children[0].setAttribute("disabled", "");
            }
          });
        }
      }
    }
  });
  Shiny.inputBindings.register(checkbarInputBinding, "yonder.checkbarInput");

  var checkboxInputBinding = new Shiny.InputBinding();
  $.extend(checkboxInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-checkbox[id]");
    },
    getValue: function getValue(el) {
      var checked = el.querySelectorAll("input:checked:not(:disabled)");

      if (checked.length === 0) {
        return null;
      }

      return Array.prototype.map.call(checked, function (c) {
        return c.value;
      });
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("change.yonder", function (e) {
        return callback();
      });
      $el.on("checkbox.select.yonder", function (e) {
        return callback();
      });
    },
    unsubscribe: function unsubscribe(el) {
      return $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.content) {
        el.querySelectorAll(".custom-checkbox").forEach(function (box) {
          el.removeChild(box);
        });
        el.insertAdjacentHTML("afterbegin", msg.content);
      }

      if (msg.selected) {
        el.querySelectorAll("input:checked").forEach(function (input) {
          input.checked = false;
        });
        el.querySelectorAll("input").forEach(function (input) {
          if (msg.selected === true || msg.selected.indexOf(input.value) > -1) {
            input.checked = true;
          }
        });
        $(el).trigger("checkbox.select.yonder");
      }

      if (msg.enable) {
        var enable = msg.enable;

        if (enable === true) {
          el.querySelectorAll("input").forEach(function (input) {
            input.removeAttribute("disabled");
          });
        } else {
          el.querySelectorAll("input").forEach(function (input) {
            if (enable.indexOf(input.value) > -1) {
              input.removeAttribute("disabled");
            }
          });
        }
      }

      if (msg.disable) {
        var disable = msg.disable;

        if (disable === true) {
          el.querySelectorAll("input").forEach(function (input) {
            input.setAttribute("disabled", "");
          });
        } else {
          el.querySelectorAll("input").forEach(function (input) {
            if (disable.indexOf(input.value) > -1) {
              input.setAttribute("disabled", "");
            }
          });
        }
      }

      if (msg.valid) {
        el.querySelector(".invalid-feedback").innerHTML = "";
        el.querySelector(".valid-feedback").innerHTML = msg.valid;
        el.querySelectorAll("input").forEach(function (input) {
          input.classList.remove("is-invalid");
          input.classList.add("is-valid");
        });
      }

      if (msg.invalid) {
        el.querySelector(".valid-feedback").innerHTML = "";
        el.querySelector(".inavlid-feedback").innerHTML = msg.invalid;
        el.querySelectorAll("input").forEach(function (input) {
          input.classList.remove("is-valid");
          input.classList.add("is-invalid");
        });
      }

      if (!msg.valid && !msg.invalid) {
        el.querySelectorAll(".valid-feedback").forEach(function (vf) {
          return vf.innerHTML = "";
        });
        el.querySelectorAll(".invalid-feedback").forEach(function (ivf) {
          return ivf.innerHTML = "";
        });
        el.querySelectorAll("input").forEach(function (input) {
          input.classList.remove("is-valid");
          input.classList.remove("is-invalid");
        });
      }
    }
  });
  Shiny.inputBindings.register(checkboxInputBinding, "yonder.checkboxInput");

  var chipInputBinding = new Shiny.InputBinding();
  $.extend(chipInputBinding, {
    selectorActive: ".active",
    selectorToggle: "input[data-toggle='dropdown']",
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-chip[id]");
    },
    initialize: function initialize(el) {
      var $el = $(el);
      var $toggle = $(el.querySelector(chipInputBinding.selectorToggle));
      $el.on("input", function (e) {
        var value = $toggle[0].value;

        chipInputBinding._filter(el, value);

        if (chipInputBinding._visible(el).length === 0) {
          $toggle.dropdown("hide");
        } else {
          $toggle.dropdown("show");
        }
      });
      $el.on("input change", function (e) {
        $toggle.dropdown("update");
      });
      $el.on("hide.bs.dropdown", function (e) {
        if (el.querySelector("input:focus") === null) {
          el.querySelector("input").value = "";

          chipInputBinding._filter(el, "");
        }
      });
      $el.on("click", ".dropdown-item", function (e) {
        e.stopPropagation();

        chipInputBinding._add(el, e.currentTarget.value);

        $toggle[0].focus();
      });
      $el.on("click", ".chip", function (e) {
        chipInputBinding._remove(el, e.currentTarget.value);
      });
      var max = +el.getAttribute("data-max");

      if (max !== -1 && chipInputBinding._selected(el).length >= max) {
        chipInputBinding._disable(el);
      }
    },
    getValue: function getValue(el) {
      var selected = el.querySelectorAll(".active");

      if (selected.length === 0) {
        return null;
      }

      return Array.prototype.map.call(selected, function (s) {
        return s.value;
      });
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("click.yonder", ".dropdown-item,.chip", function (e) {
        return callback();
      });
      $el.on("chip.select.yonder", function (e) {
        return callback();
      });
    },
    unsubscribe: function unsubscribe(el) {
      return $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      var $el = $(el);

      if (msg.items && msg.chips) {
        el.querySelector(".dropdown-menu").innerHTML = msg.items;
        el.querySelector(".chips").innerHTML = msg.chips;
      }

      if (msg.selected) {
        if (msg.selected === true) {
          el.querySelectorAll(".dropdown-item").forEach(function (item) {
            chipInputBinding._add(el, item.value);
          });
        } else {
          msg.selected.reverse();

          chipInputBinding._selected(el).forEach(function (item) {
            chipInputBinding._remove(el, item.value);
          });

          msg.selected.forEach(function (value) {
            chipInputBinding._add(el, value);
          });
        }

        $el.trigger("chip.select.yonder");
      }

      if (msg.max !== undefined && msg.max !== null) {
        el.setAttribute("data-max", msg.max);
      }

      if (msg.enable) {
        var enable = msg.enable;

        if (enable === true) {
          chipInputBinding._enable(el); // el.querySelector("input").removeAttribute("disabled");

        } else {
          el.querySelectorAll(".dropdown-item,.chip").forEach(function (item) {
            if (enable.indexOf(item.value) > -1) {
              item.removeAttribute("disabled");
              item.classList.remove("disabled");
            }
          });
        }
      }

      if (msg.disable) {
        var disable = msg.disable;

        if (disable === true) {
          chipInputBinding._disable(el); // el.querySelector("input").setAttribute("disabled", "");

        } else {
          el.querySelectorAll(".dropdown-item,.chip").forEach(function (item) {
            if (disable.indexOf(item.value) > -1) {
              item.setAttribute("disabled", "");
              item.classList.add("disabled");
            }
          });
        }
      }
    },
    _visible: function _visible(el) {
      return el.querySelectorAll(":not(.selected),:not(.filtered)");
    },
    _selected: function _selected(el) {
      return el.querySelectorAll(".selected");
    },
    _items: function _items(el, value) {
      return Array.prototype.filter.call(el.querySelectorAll(".dropdown-item"), function (chip) {
        return chip.value === value;
      });
    },
    _chips: function _chips(el, value) {
      return Array.prototype.filter.call(el.querySelectorAll(".chip"), function (chip) {
        return chip.value === value;
      });
    },
    _enable: function _enable(el) {
      var input = el.querySelector("input");
      input.removeAttribute("disabled");
      input.classList.remove("disabled");
    },
    _disable: function _disable(el) {
      var input = el.querySelector("input");
      input.setAttribute("disabled", "");
      input.classList.add("disabled");
    },
    _filter: function _filter(el, value) {
      value = value.toLowerCase();
      el.querySelectorAll(".dropdown-item").forEach(function (item) {
        var match = item.innerText.toLowerCase().indexOf(value) !== -1;

        if (match) {
          item.classList.remove("filtered");
        } else {
          item.classList.add("filtered");
        }
      });
    },
    _add: function _add(el, value) {
      var $toggle = $(el.querySelector(chipInputBinding.selectorToggle));
      var sort = el.getAttribute("data-sort");

      chipInputBinding._items(el, value).forEach(function (item) {
        item.classList.add("selected");
      });

      var chips = el.querySelector(".chips");

      chipInputBinding._chips(el, value).forEach(function (chip) {
        if (sort === "stack") {
          chips.insertBefore(chips.removeChild(chip), chips.firstChild);
        } else if (sort === "queue") {
          chips.appendChild(chips.removeChild(chip));
        }

        chip.classList.add("active");
      });

      if (chipInputBinding._visible(el).length === 0) {
        $toggle.dropdown("hide");
      }

      var max = +el.getAttribute("data-max");

      if (max === -1 || chipInputBinding._selected(el).length < max) {
        $toggle.dropdown("update");
      } else {
        $toggle.dropdown("hide");

        chipInputBinding._disable(el);
      }
    },
    _remove: function _remove(el, value) {
      var max = +el.getAttribute("data-max");

      chipInputBinding._chips(el, value).forEach(function (chip) {
        chip.classList.remove("active");
      });

      chipInputBinding._items(el, value).forEach(function (item) {
        item.classList.remove("selected");
      });

      if (max === -1 || chipInputBinding._selected(el).length < max) {
        chipInputBinding._enable(el);
      }
    }
  });
  Shiny.inputBindings.register(chipInputBinding, "yonder.chipInput");

  var fileInputBinding = new Shiny.InputBinding();
  $.extend(fileInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-file[id]");
    },
    initialize: function initialize(el) {
      var $el = $(el);
      $el.on("dragover", function (e) {
        e.stopPropagation();
        e.preventDefault();
      });
      $el.on("dragcenter", function (e) {
        e.stopPropagation();
        e.preventDefault();
      });
      $el.on("drop", function (e) {
        e.stopPropagation();
        e.preventDefault();

        fileInputBinding._upload(el, e.originalEvent.dataTransfer.files);
      });
      $el.on("change", function (e) {
        fileInputBinding._upload(el);
      });
    },
    getValue: function getValue(el) {
      return null;
    },
    receiveMessage: function receiveMessage(el, msg) {
      var input = el.querySelector("input");

      if (msg.enable) {
        input.removeAttribute("disabled");
      }

      if (msg.disable) {
        input.setAttribute("disabled", "");
      }

      if (msg.valid) {
        el.querySelector(".valid-feedback").innerHTML = msg.valid;
        input.classList.add("is-valid");
      }

      if (msg.invalid) {
        el.querySelector(".invalid-feedback").innerHTML = msg.invalid;
        input.classList.remove("is-invalid");
      }

      if (!msg.valid && !msg.invalid) {
        el.querySelector(".valid-feedback").innerHTML = "";
        el.querySelector(".invalid-feedback").innerHTML = "";
        input.classList.remove("is-valid");
        input.classList.remove("is-invalid");
      }
    },
    _post: function _post(uri, job, file, final, el) {
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
    _upload: function _upload(el, files) {
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
          _this._post(uri, job, files[i], i === files.length - 1, el);
        }
      }, function (err) {
        console.error("uploadInit request failed for " + el.id + ": " + err);
      });
    }
  });
  document.addEventListener("DOMContentLoaded", function () {
    bsCustomFileInput.init(".yonder-file[id] input[type='file']");
  });
  Shiny.inputBindings.register(fileInputBinding, "yonder.fileInput");

  var formInputBinding = new Shiny.InputBinding();
  $.extend(formInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-form[id]");
    },
    initialize: function initialize(el) {
      var $document = $(document);
      var $el = $(el);
      var store = {};
      var value = null;
      el.querySelectorAll(".yonder-form-submit").forEach(function (s) {
        s.setAttribute("type", "submit");
      });
      $document.on("shiny:inputchanged.yonder", function (e) {
        if (!e.el || e.priority === "event") {
          return;
        }

        if (e.el.id === el.id) {
          Shiny.onInputChange(el.id, value, {
            priority: "event"
          });
          e.preventDefault();
          return;
        }

        if (el.contains(e.el)) {
          store[e.name] = e.value;
          e.preventDefault();
        }
      });
      $el.on("click.yonder", ".yonder-form-submit", function (e) {
        value = e.currentTarget.value;
      });
      $el.on("submit.yonder", function (e, v) {
        e.preventDefault();

        if (v !== undefined) {
          value = v;
        }

        Object.keys(store).forEach(function (key) {
          Shiny.onInputChange(key, store[key], {
            priority: "event"
          });
        });
      });
    },
    getValue: function getValue(el) {
      return null;
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("submit.yonder", function (e) {
        return callback();
      });
    },
    unsubscribe: function unsubscribe(el) {
      $(el).off(".yonder");
      $(document).off("shiny:inputchanged.yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.submit !== undefined && msg.submit !== null) {
        $(el).trigger("submit.yonder", msg.submit);
      }
    }
  });
  Shiny.inputBindings.register(formInputBinding, "yonder.formInput");

  var linkInputBinding = new Shiny.InputBinding();
  $.extend(linkInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-link[id]");
    },
    initialize: function initialize(el) {
      $(el).on("click", function (e) {
        return el.value = +el.value + 1;
      });
      el.value = 0;
    },
    getValue: function getValue(el) {
      return +el.value > 0 ? +el.value : null;
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("click.yonder", function (e) {
        return callback();
      });
      $el.on("link.value.yonder", function (e) {
        return callback();
      });
    },
    unsubscribe: function unsubscribe(el) {
      return $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.content) {
        el.innerHTML = msg.content;
      }

      if (msg.value !== null && msg.value !== undefined) {
        el.value = msg.value;
        $(el).trigger("link.value.yonder");
      }

      if (msg.enable) {
        el.classList.remove("disabled");
        el.removeAttribute("disabled");
      }

      if (msg.disable) {
        el.classList.add("disabled");
        el.setAttribute("disabled", "");
      }
    }
  });
  Shiny.inputBindings.register(linkInputBinding, "yonder.linkInput");

  var listGroupInputBinding = new Shiny.InputBinding();
  $.extend(listGroupInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-list-group[id]");
    },
    initialize: function initialize(el) {
      var $el = $(el);
      $el.on("click", ".list-group-item-action:not(.active):not(.disabled)", function (e) {
        el.querySelectorAll(".active").forEach(function (item) {
          item.classList.remove("active");
        });
        e.currentTarget.classList.add("active");
      });
      $el.on("click", ".list-group-item-action.active:not(.disabled)", function (e) {
        e.currentTarget.classList.remove("active");
      });
    },
    getValue: function getValue(el) {
      var items = el.querySelectorAll(".list-group-item-action.active:not(.disabled)");

      if (items.length === 0) {
        return null;
      }

      return Array.prototype.slice.call(items).map(function (i) {
        return i.value;
      });
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("click.yonder", function (e) {
        return callback();
      });
      $el.on("listgroup.select.yonder", function (e) {
        return callback();
      });
    },
    unsubcribe: function unsubcribe(el) {
      return $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.content) {
        el.querySelectorAll(".list-group-item").forEach(function (item) {
          el.removeChild(item);
        });
        el.insertAdjacentHTML("afterbegin", msg.content);
      }

      if (msg.selected) {
        if (msg.selected !== true) {
          el.querySelectorAll(".list-group-item.active").forEach(function (item) {
            item.classList.remove("active");
          });
        }

        el.querySelectorAll(".list-group-item").forEach(function (item) {
          if (msg.selected === true || msg.selected.indexOf(item.value) > -1) {
            item.classList.add("active");
          }
        });
        $(el).trigger("listgroup.select.yonder");
      }

      if (msg.enable) {
        var enable = msg.enable;

        if (enable === true) {
          el.querySelectorAll(".list-group-item").forEach(function (item) {
            item.classList.remove("disabled");
          });
        } else {
          el.querySelectorAll(".list-group-item").forEach(function (item) {
            if (enable.indexOf(item.value) > -1) {
              item.classList.remove("disabled");
            }
          });
        }
      }

      if (msg.disable) {
        var disable = msg.disable;

        if (disable === true) {
          el.querySelectorAll(".list-group-item").forEach(function (item) {
            item.classList.add("disabled");
          });
        } else {
          el.querySelectorAll(".list-group-item").forEach(function (item) {
            if (disable.indexOf(item.value) > -1) {
              item.classList.add("disabled");
            }
          });
        }
      }
    }
  });
  Shiny.inputBindings.register(listGroupInputBinding, "yonder.listGroupInput");

  var menuInputBinding = new Shiny.InputBinding();
  $.extend(menuInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-menu[id]");
    },
    initialize: function initialize(el) {
      var $el = $(el);
      $el.on("click", ".dropdown-item:not(.disabled)", function (e) {
        var active = el.querySelector(".dropdown-item.active");

        if (active !== null) {
          active.classList.remove("active");
        }

        e.currentTarget.classList.add("active");
      });
      $el.on("nav.reset", function (e) {
        var active = el.querySelector(".dropdown-item.active");

        if (active !== null) {
          active.classList.remove("active");
        }
      });
    },
    getValue: function getValue(el) {
      var active = el.querySelector(".dropdown-item.active:not(.disabled)");

      if (active === null) {
        return null;
      }

      return active.value;
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("click.yonder", function (e) {
        return callback();
      });
      $el.on("menu.select.yonder", function (e) {
        return callback();
      });
    },
    unsubscribe: function unsubscribe(el) {
      return $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.content) {
        el.querySelector(".dropdown-menu").innerHTML = msg.content;
      }

      if (msg.label) {
        var toggle = el.querySelector(".dropdown-toggle");
        toggle.innerHTML = msg.label;
      }

      if (msg.selected) {
        el.querySelectorAll(".dropdown-item").forEach(function (item) {
          if (msg.selected.indexOf(item.value) > -1) {
            item.classList.add("active");
          } else {
            item.classList.remove("active");
          }
        });
        $(el).trigger("menu.select.yonder");
      }

      if (msg.enable) {
        var enable = msg.enable;

        if (enable === true) {
          el.querySelector(".dropdown-toggle").classList.remove("disabled");
        } else {
          el.querySelectorAll(".dropdown-item").forEach(function (item) {
            if (enable.indexOf(item.value) > -1) {
              item.classList.remove("disabled");
            }
          });
        }
      }

      if (msg.disable) {
        var disable = msg.disable;

        if (disable === true) {
          el.querySelector(".dropdown-toggle").classList.add("disabled");
        } else {
          el.querySelectorAll(".dropdown-item").forEach(function (item) {
            if (disable.indexOf(item.value) > -1) {
              item.classList.add("disabled");
            }
          });
        }
      }
    }
  });
  Shiny.inputBindings.register(menuInputBinding, "yonder.menuInput");

  var navInputBinding = new Shiny.InputBinding();
  $.extend(navInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-nav[id]");
    },
    initialize: function initialize(el) {
      var $el = $(el);
      $el.on("click", ".nav-link:not(.dropdown-toggle):not(.disabled)", function (e) {
        var active = el.querySelector(".dropdown-item.active");

        if (active !== null) {
          // trigger reset on menu input
          $(active.parentNode.parentNode).trigger("nav.reset");
        }

        el.querySelectorAll(".active").forEach(function (a) {
          return a.classList.remove("active");
        });
        e.currentTarget.classList.add("active");
      });
      $el.on("click", ".dropdown-item:not(.disabled)", function (e) {
        el.querySelectorAll(".active").forEach(function (a) {
          return a.classList.remove("active");
        });
        e.currentTarget.parentNode.parentNode.children[0].classList.add("active");
        e.currentTarget.classList.add("active");
      });
    },
    getValue: function getValue(el) {
      var active = el.querySelector(".nav-link.active:not(.disabled)");

      if (active === null) {
        return null;
      }

      return active.value;
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("click.yonder", ".dropdown-item", function (e) {
        return callback();
      });
      $el.on("click.yonder", ".nav-link:not(.dropdown-toggle)", function (e) {
        return callback();
      });
      $el.on("nav.select.yonder", function (e) {
        return callback();
      });
    },
    unsubscribe: function unsubscribe(el) {
      return $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.content) {
        el.querySelectorAll(".nav-item").forEach(function (item) {
          return el.removeChild(item);
        });
        el.insertAdjacentHTML("afterbegin", msg.content);
      }

      if (msg.selected) {
        el.querySelectorAll(".nav-link").forEach(function (link) {
          if (msg.selected.indexOf(link.value) > -1) {
            link.classList.add("active");
          } else {
            link.classList.remove("active");
          }
        });
        $(el).trigger("nav.select.yonder");
      }

      if (msg.enable) {
        var enable = msg.enable;

        if (enable === true) {
          el.querySelectorAll(".nav-link").forEach(function (link) {
            link.classList.remove("disabled");
          });
        } else {
          el.querySelectorAll(".nav-link").forEach(function (link) {
            if (enable.indexOf(link.value) > -1) {
              link.classList.remove("disabled");
            }
          });
        }
      }

      if (msg.disable) {
        var disable = msg.disable;

        if (disable === true) {
          el.querySelectorAll(".nav-link").forEach(function (link) {
            link.classList.add("disabled");
          });
        } else {
          el.querySelectorAll(".nav-link").forEach(function (link) {
            if (disable.indexOf(link.value) > -1) {
              link.classList.add("disabled");
            }
          });
        }
      }
    }
  });
  Shiny.inputBindings.register(navInputBinding, "yonder.navInput");
  Shiny.addCustomMessageHandler("yonder:pane", function (msg) {
    var _show = function _show(pane) {
      if (pane === null || pane.classList.contains("show")) {
        return;
      }

      if (!pane.parentElement.classList.contains("tab-content")) {
        console.warn("nav pane " + pane.id + " is missing a nav content parent element");
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
    };

    var _hide = function _hide(pane) {
      if (pane === null || !pane.classList.contains("show")) {
        return;
      }

      if (!pane.parentElement.classList.contains("tab-content")) {
        console.warn("nav pane " + pane.id + " is missing a nav content parent element");
        return;
      }

      var complete = function complete() {
        var hiddenEvent = $.Event("hidden.bs.tab", {
          relatedTarget: pane
        });
        $(pane).trigger(hiddenEvent);
      };

      var dummy = document.createElement("div");

      bootstrap.Tab.prototype._activate(dummy, pane.parentElement, complete);
    };

    if (msg.type === undefined || msg.data === undefined || msg.data.target === undefined) {
      return;
    }

    var target = document.getElementById(msg.data.target);

    if (target === null) {
      return;
    }

    if (msg.type === "show") {
      _show(target);
    } else if (msg.type === "hide") {
      _hide(target);
    }
  });

  var radioInputBinding = new Shiny.InputBinding();
  $.extend(radioInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-radio[id]");
    },
    getValue: function getValue(el) {
      var radios = el.querySelectorAll(".custom-radio > input:checked:not(:disabled)");

      if (radios.length === 0) {
        return null;
      }

      return Array.prototype.slice.call(radios).map(function (r) {
        return r.value;
      });
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("change.yonder", function (e) {
        return callback();
      });
      $el.on("radio.select.yonder", function (e) {
        return callback();
      });
    },
    unsubscribe: function unsubscribe(el) {
      $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.content) {
        el.querySelectorAll(".custom-radio").forEach(function (radio) {
          el.removeChild(radio);
        });
        el.insertAdjacentHTML("afterbegin", msg.content);
      }

      if (msg.selected) {
        el.querySelectorAll("input").forEach(function (input) {
          if (msg.selected.indexOf(input.value) > -1) {
            input.checked = true;
          } else {
            input.checked = false;
          }
        });
        $(el).trigger("radio.select.yonder");
      }

      if (msg.enable) {
        var enable = msg.enable;

        if (enable === true) {
          el.querySelectorAll(".custom-radio > input").forEach(function (input) {
            input.removeAttribute("disabled");
          });
        } else {
          el.querySelectorAll(".custom-radio > input").forEach(function (input) {
            if (enable.indexOf(input.value) > -1) {
              input.removeAttribute("disabled");
            }
          });
        }
      }

      if (msg.disable) {
        var disable = msg.disable;

        if (disable === true) {
          el.querySelectorAll(".custom-radio > input").forEach(function (input) {
            input.setAttribute("disabled", "");
          });
        } else {
          el.querySelectorAll(".custom-radio > input").forEach(function (input) {
            if (disable.indexOf(input.value) > -1) {
              input.setAttribute("disabled", "");
            }
          });
        }
      }

      if (msg.valid) {
        el.querySelector(".valid-feedback").innerHTML = msg.valid;
        el.querySelectorAll(".custom-control-input").forEach(function (radio) {
          radio.classList.add("is-valid");
        });
      }

      if (msg.invalid) {
        el.querySelector(".invalid-feedback").innerHTML = msg.invalid;
        el.querySelectorAll(".custom-control-input").forEach(function (radio) {
          radio.classList.add("is-invalid");
        });
      }

      if (!msg.valid && !msg.invalid) {
        el.querySelectorAll(".valid-feedback").forEach(function (vf) {
          return vf.innerHTML = "";
        });
        el.querySelectorAll(".invalid-feedback").forEach(function (ivf) {
          return ivf.innerHTML = "";
        });
        el.querySelectorAll(".custom-control-input").forEach(function (radio) {
          radio.classList.remove("is-valid");
          radio.classList.remove("is-invalid");
        });
      }
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
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-radiobar[id]");
    },
    getValue: function getValue(el) {
      var radios = el.querySelectorAll("input:checked:not(:disabled)");

      if (radios.length === 0) {
        return null;
      }

      return Array.prototype.slice.call(radios).map(function (r) {
        return r.value;
      });
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("click.yonder", function (e) {
        return callback();
      });
      $el.on("change.yonder", function (e) {
        return callback();
      });
    },
    unsubscribe: function unsubscribe(el) {
      $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.content) {
        el.innerHTML = msg.content;
      }

      if (msg.selected) {
        el.querySelectorAll("input").forEach(function (input) {
          if (msg.selected.indexOf(input.value) > -1) {
            input.checked = true;
            input.parentNode.classList.add("active");
          } else {
            input.checked = false;
            input.parentNode.classList.remove("active");
          }
        });
        $(el).trigger("radiobar.select.yonder");
      }

      if (msg.enable) {
        var enable = msg.enable;

        if (enable === true) {
          el.querySelectorAll(".btn").forEach(function (btn) {
            btn.classList.remove("disabled");
            btn.children[0].removeAttribute("disabled");
          });
        } else {
          el.querySelectorAll("input").forEach(function (input) {
            if (enable.indexOf(input.value) > -1) {
              input.parentNode.classList.remove("disabled");
              input.removeAttribute("disabled");
            }
          });
        }
      }

      if (msg.disable) {
        var disable = msg.disable;

        if (disable === true) {
          el.querySelectorAll(".btn").forEach(function (btn) {
            btn.classList.add("disabled");
            btn.children[0].setAttribute("disabled", "");
          });
        } else {
          el.querySelectorAll("input").forEach(function (input) {
            if (disable.indexOf(input.value) > -1) {
              input.parentNode.classList.add("disabled");
              input.setAttribute("disabled", "");
            }
          });
        }
      }
    }
  });
  Shiny.inputBindings.register(radiobarInputBinding, "yonder.radiobarInput");

  var rangeInputBinding = new Shiny.InputBinding();
  $.extend(rangeInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-range[id]");
    },
    getId: function getId(el) {
      return el.id;
    },
    getValue: function getValue(el) {
      return +el.children[0].value;
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("input.yonder", callback(true));
      $el.on("range.value.yonder");
    },
    unsubscribe: function unsubscribe(el) {
      return $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      var input = el.children[0];

      if (msg.value) {
        input.value = msg.value;
      }

      if (msg.enable) {
        input.removeAttribute("disabled");
      }

      if (msg.disable) {
        input.setAttribute("disabled", "");
      }
    }
  });
  Shiny.inputBindings.register(rangeInputBinding, "yonder.rangeInput");

  var selectInputBinding = new Shiny.InputBinding();
  $.extend(selectInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-select[id]");
    },
    initialize: function initialize(el) {
      var $el = $(el);
      $el.on("click", ".dropdown-item", function (e) {
        $el[0].querySelector("input").placeholder = e.currentTarget.innerText;
        var prev = $el[0].querySelector(".active");

        if (prev) {
          prev.classList.remove("active");
        }

        e.currentTarget.classList.add("active");
      });
      var $input = $(el.querySelector("input"));
      $el.on("input change", "input", function (e) {
        var pattern = $input[0].value.toLowerCase();
        el.querySelectorAll(".dropdown-item").forEach(function (item) {
          if (item.innerText.toLowerCase().indexOf(pattern) === -1) {
            item.classList.add("filtered");
          } else {
            item.classList.remove("filtered");
          }
        });
        $input.dropdown("update");
      });
      $el.on("hide.bs.dropdown", function (e) {
        $input[0].value = "";
        el.querySelectorAll(".filtered").forEach(function (f) {
          f.classList.remove("filtered");
        });
      });
    },
    getValue: function getValue(el) {
      var selected = el.querySelectorAll(".dropdown-item.active:not(.disabled)");

      if (selected.length === 0) {
        return null;
      }

      return Array.prototype.slice.call(selected).map(function (o) {
        return o.value;
      });
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("click.yonder", ".dropdown-item", function (e) {
        return callback();
      });
      $el.on("select.select.yonder", function (e) {
        return callback();
      }); // ha.
    },
    unsubscribe: function unsubscribe(el) {
      $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.content) {
        el.querySelector(".dropdown-menu").innerHTML = msg.content;
        var input = el.querySelector("input");
        input.placeholder = input.getAttribute("data-original-placeholder") || "";
      }

      if (msg.selected) {
        el.querySelectorAll(".dropdown-item").forEach(function (item) {
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
        var enable = msg.enable;

        if (enable === true) {
          el.querySelector("input").removeAttribute("disabled");
        } else {
          el.querySelectorAll(".dropdown-item").forEach(function (item) {
            if (enable.indexOf(item.value) > -1) {
              item.classList.remove("disabled");
            }
          });
        }
      }

      if (msg.disable) {
        var disable = msg.disable;

        if (disable === true) {
          el.querySelector("input").setAttribute("disabled", "");
        } else {
          el.querySelectorAll(".dropdown-item").forEach(function (item) {
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
        var _input = el.querySelector("input");

        _input.classList.remove("is-valid");

        _input.classList.remove("is-invalid");

        el.querySelector(".valid-feedback").innerHTML = "";
        el.querySelector(".invalid-feedback").innerHTML = "";
      }
    }
  });
  Shiny.inputBindings.register(selectInputBinding, "yonder.selectInput");
  var groupSelectInputBinding = new Shiny.InputBinding();
  $.extend(groupSelectInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-group-select[id]");
    },
    getValue: function getValue(el) {
      var inputs = el.querySelectorAll(".input-group-prepend .input-group-text, select, .input-group-append .input-group-text");
      return Array.prototype.slice.call(inputs).map(function (i) {
        return /^(DIV|SPAN)$/.test(i.tagName) ? i.innerText : i.value || null;
      }).filter(function (value) {
        return value !== null;
      });
    },
    getType: function getType() {
      return "yonder.group.select";
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);

      if (el.querySelectorAll(".btn").length > 0) {
        $el.on("click", ".dropdown-item", function (e) {
          return callback();
        });
      } else {
        $el.on("change", function (e) {
          return callback();
        });
        $el.on("groupselect.select.yonder", function (e) {
          return callback();
        });
      }
    },
    receiveMessage: function receiveMessage(el, msg) {
      var select = el.querySelector("input[data-toggle='dropdown']");

      if (msg.content) {
        select.innerHTML = msg.content;
      }

      if (msg.selected) {
        select.querySelectorAll("option").forEach(function (option) {
          if (msg.selected.indexOf(option.value) > -1) {
            option.setAttribute("selected", "");
          } else {
            option.removeAttribute("selected");
          }
        });
        $(el).trigger("groupselect.select.yonder");
      }

      if (msg.enable) {
        var enable = msg.enable;

        if (enable === true) {
          select.removeAttribute("disabled");
        } else {
          select.querySelectorAll("option").forEach(function (option) {
            option.removeAttribute("disabled");
          });
        }
      }

      if (msg.disable) {
        var disable = msg.disable;

        if (disable) {
          select.setAttribute("disabled", "");
        } else {
          select.querySelectorAll("option").forEach(function (option) {
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

  var textualInputBinding = new Shiny.InputBinding();
  $.extend(textualInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-textual[id]");
    },
    getValue: function getValue(el) {
      var input = el.children[0];

      if (input.value === "") {
        return null;
      }

      return input.type === "number" ? Number(input.value) : input.value;
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);
      $el.on("change.yonder", function (e) {
        return callback(true);
      });
      $el.on("input.yonder", function (e) {
        return callback(true);
      });
      $el.on("textual.value.yonder", function (e) {
        return callback(true);
      });
    },
    unsubscribe: function unsubscribe(el) {
      return $(el).off(".yonder");
    },
    getRatePolicy: function getRatePolicy() {
      return {
        policy: "debounce",
        delay: 250
      };
    },
    receiveMessage: function receiveMessage(el, msg) {
      if (msg.value !== null) {
        el.querySelector("input").value = msg.value;
        $(el).trigger("textual.value.yonder");
      }

      if (msg.enable) {
        el.children[0].removeAttribute("disabled");
      }

      if (msg.disable) {
        el.children[0].setAttribute("disabled", "");
      }

      var input = el.querySelector("input");

      if (msg.valid) {
        el.querySelector(".valid-feedback").innerHTML = msg.valid;
        input.classList.remove("is-invalid");
        input.classList.add("is-valid");
      }

      if (msg.invalid) {
        el.querySelector(".invalid-feedback").innerHTML = msg.invalid;
        input.classList.remove("is-valid");
        input.classList.add("is-invalid");
      }

      if (!msg.valid && !msg.invalid) {
        el.querySelector(".valid-feedback").innerHTML = "";
        el.querySelector(".invalid-feedback").innerHTML = "";
        input.classList.remove("is-valid");
        input.classList.remove("is-invalid");
      }
    }
  });
  Shiny.inputBindings.register(textualInputBinding, "yonder.textualInput");
  var groupTextInputBinding = new Shiny.InputBinding();
  $.extend(groupTextInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-group-text[id]");
    },
    getValue: function getValue(el) {
      var inputs = el.querySelectorAll(".input-group-prepend .input-group-text, input, .input-group-append .input-group-text");
      return Array.prototype.slice.call(inputs).map(function (i) {
        return /^(DIV|SPAN)$/.test(i.tagName) ? i.innerText : i.value || null;
      }).filter(function (value) {
        return value !== null;
      });
    },
    getType: function getType() {
      return "yonder.group.text";
    },
    getRatePolicy: function getRatePolicy(el) {
      return {
        policy: "debounce",
        delay: 250
      };
    },
    subscribe: function subscribe(el, callback) {
      var $el = $(el);

      if (el.querySelectorAll(".btn").length > 0) {
        $el.on("click.yonder", ".dropdown-item", function (e) {
          return callback();
        });
        $el.on("click.yonder", ".btn:not(.dropdown-toggle", function (e) {
          return callback();
        });
      } else {
        $el.on("input.yonder", function (e) {
          return callback(true);
        });
        $el.on("change.yonder", function (e) {
          return callback(true);
        });
        $el.on("textual.value.yonder", function (e) {
          return callback();
        });
      }
    },
    unsubscribe: function unsubscribe(el) {
      return $(el).off(".yonder");
    },
    receiveMessage: function receiveMessage(el, msg) {
      var input = el.querySelector("input");

      if (msg.value) {
        input.value = msg.value;
        $(el).trigger("textual.value.yonder");
      }

      if (msg.enable) {
        input.removeAttribute("disabled");
      }

      if (msg.disable) {
        input.setAttribute("disabled", "");
      }

      if (msg.valid) {
        el.querySelector("valid-feedback").innerHTML = msg.valid;
        input.classList.remove("is-invalid");
        input.classList.add("is-valid");
      }

      if (msg.invalid) {
        el.querySelector("invalid-feedback").innerHTML = msg.invalid;
        input.classList.remove("is-valid");
        input.classList.add("is-invalid");
      }

      if (!msg.valid && !msg.invalid) {
        input.classList.remove("is-valid");
        input.classList.remove("is-invalid");
        el.querySelector("invalid-feedback").innerHTML = "";
        el.querySelector("valid-feedback").innerHTML = "";
      }
    }
  });
  Shiny.inputBindings.register(groupTextInputBinding, "yonder.groupTextInput");

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

  Shiny.addCustomMessageHandler("yonder:download", function (msg) {
    if (!(msg.filename && msg.token && msg.key)) {
      throw "invalid download event";
    }

    var uri = "/session/" + msg.token + "/download/" + msg.key;
    var agent = window.navigator.userAgent;
    var ie = /MSIE/.test(agent);

    if (ie === true) {
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

  Shiny.addCustomMessageHandler("yonder:content", function (msg) {
    var _replace = function _replace(data) {
      if (!data.id) {
        return;
      }

      var target = document.getElementById(data.id);

      if (!target) {
        return;
      }

      if (data.dependencies) {
        Shiny.renderDependencies(data.dependencies);
      }

      if (data.content) {
        Shiny.unbindAll(target);
        target.innerHTML = data.content;
        Shiny.initializeInputs(target);
        Shiny.bindAll(target);
      }

      if (data.attrs) {
        Object.keys(data.attrs).forEach(function (key) {
          target.setAttribute(key, data.attrs[key]);
        });
      }
    };

    var _remove = function _remove(data) {
      if (!data.id) {
        return;
      }

      var target = document.getElementById(data.id);

      if (!target) {
        return;
      }

      Shiny.unbindAll(target);
      target.innerHTML = "";
    };

    if (!msg.type) {
      return;
    }

    if (msg.type === "replace") {
      _replace(msg.data);
    } else if (msg.type === "remove") {
      _remove(msg.data);
    } else {
      console.warn("no content \"" + msg.type + "\" method");
    }
  });

  $(function () {
    document.body.insertAdjacentHTML("beforeend", "<div class='yonder-modals'></div>");
  });
  Shiny.addCustomMessageHandler("yonder:modal", function (msg) {
    if (msg.type === undefined) {
      return false;
    }

    var _close = function _close(data) {
      var modals = document.querySelector(".yonder-modals").childNodes;

      if (modals.length === 0) {
        return;
      }

      if (data.id) {
        modals = Array.prototype.filter.call(modals, function (m) {
          return m.id === data.id;
        });
      }

      modals.forEach(function (modal) {
        if (!modal.classList.contains("yonder-modal")) {
          return;
        }

        $(modal).modal("hide");
      });
    };

    var _show = function _show(data) {
      if (data.id) {
        var possible = document.getElementById(data.id);

        if (possible && possible.classList.contains("yonder-modal")) {
          console.warn("ignoring modal with duplicate id");
          return;
        }
      }

      if (data.dependencies) {
        Shiny.renderDependencies(data.dependencies);
      }

      var container = document.querySelector(".yonder-modals");
      container.insertAdjacentHTML("beforeend", data.content);
      var modal = container.querySelector(".yonder-modal:last-child");
      Shiny.initializeInputs(modal);
      Shiny.bindAll(modal);
      var $modal = $(modal);
      $modal.one("hidden.bs.modal", function (e) {
        if (modal.id) {
          Shiny.onInputChange(modal.id, true);
          setTimeout(function () {
            return Shiny.onInputChange(modal.id, null);
          }, 100);
        }

        Shiny.unbindAll(modal);
        container.removeChild(modal);
      });
      $(modal).modal("show");
    };

    if (msg.type === "close") {
      _close(msg.data);
    } else if (msg.type === "show") {
      _show(msg.data);
    } else {
      console.warn("no modal " + msg.type + " method");
    }
  });

  Shiny.addCustomMessageHandler("yonder:popover", function (msg) {
    if (!msg.data.id || !document.getElementById(msg.data.id)) {
      return;
    }

    var _show = function _show(data) {
      var $target = $(document.getElementById(data.id));
      $target.popover({
        content: function content() {
          return undefined;
        },
        placement: data.placement,
        template: data.content,
        title: function title() {
          return undefined;
        },
        trigger: "manual"
      });

      if (data.duration) {
        setTimeout(function () {
          return $target.popover("hide");
        }, data.duration);
      }

      $target.popover("show");
    };

    var _close = function _close(data) {
      var target = document.getElementById(data.id);

      if (!target) {
        return;
      }

      $(target).popover("hide");
    };

    if (msg.type === "show") {
      _show(msg.data);
    } else if (msg.type === "close") {
      _close(msg.data);
    } else {
      console.warn("no \"" + msg.type + "\" popover method");
    }
  });

  $(function () {
    document.body.insertAdjacentHTML("beforeend", "<div class='yonder-toasts'></div>");
    $(".yonder-toasts").on("hidden.bs.toast", ".toast", function (e) {
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
      document.querySelector(".yonder-toasts").insertAdjacentHTML("beforeend", data.content);
      $(".yonder-toasts > .toast:last-child").toast("show");
    };

    var _close = function _close(data) {
      var toasts = document.querySelectorAll(".yonder-toasts .toast");

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
    return $("[data-toggle=\"tooltip\"]").tooltip();
  });

})));
//# sourceMappingURL=yonder.js.map
