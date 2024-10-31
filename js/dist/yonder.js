(function (factory) {
  typeof define === 'function' && define.amd ? define(factory) :
  factory();
})((function () { 'use strict';

  // IE 11, ensure querySelectorAll + forEach works
  if (window.NodeList && !NodeList.prototype.forEach) {
    NodeList.prototype.forEach = Array.prototype.forEach;
  }

  let buttonGroupInputBinding = new Shiny.InputBinding();
  $.extend(buttonGroupInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-button-group[id]"),
    getType: el => "yonder.button.group",
    initialize: el => {
      $(el).on("click", "button", e => {
        el.setAttribute("data-value", e.currentTarget.value);
      });
    },
    getValue: el => {
      let value = el.getAttribute("data-value");
      if (value === undefined) {
        value = null;
      }
      return {
        force: Date.now(),
        value: value
      };
    },
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("click.yonder", "button", e => callback());
      $el.on("buttongroup.value.yonder", e => callback());
    },
    unsubscribe: el => $(el).off(".yonder"),
    receiveMessage: (el, msg) => {
      if (msg.content) {
        el.innerHTML = msg.content;
      }
      if (msg.value) {
        el.setAttribute("data-value", msg.value);
      }
      if (msg.enable) {
        el.querySelectorAll("button").forEach(btn => {
          if (msg.enable === true || msg.enable.indexOf(btn.value) > -1) {
            btn.classList.remove("disabled");
            btn.removeAttribute("disabled");
          }
        });
      }
      if (msg.disable) {
        el.querySelectorAll("button").forEach(btn => {
          if (msg.disable === true || msg.disable.indexOf(btn.value) > -1) {
            btn.classList.add("disabled");
            btn.setAttribute("disabled", "");
          }
        });
      }
    }
  });
  Shiny.inputBindings.register(buttonGroupInputBinding, "yonder.buttonGroupInput");

  let buttonInputBinding = new Shiny.InputBinding();
  $.extend(buttonInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-button[id]"),
    initialize: el => {
      $(el).on("click", e => el.value = +el.value + 1);
      el.value = 0;
    },
    getValue: el => +el.value > 0 ? +el.value : null,
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("click.yonder", e => callback());
      $el.on("button.value.yonder", e => callback());
    },
    unsubscribe: (el, callback) => $(el).off(".yonder"),
    receiveMessage: (el, msg) => {
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

  let checkbarInputBinding = new Shiny.InputBinding();
  $.extend(checkbarInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-checkbar[id]"),
    getValue: el => {
      let checked = el.querySelectorAll("input:checked:not(:disabled)");
      if (checked.length === 0) {
        return null;
      }
      return Array.prototype.map.call(checked, c => c.value);
    },
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("click.yonder", e => callback());
      $el.on("change.yonder", e => callback());
      $el.on("checkbar.select.yonder", e => callback());
    },
    unsubscribe: el => $(el).off(".yonder"),
    receiveMessage: (el, msg) => {
      if (msg.content) {
        el.querySelectorAll(".btn").forEach(btn => {
          el.removeChild(btn);
        });
        el.insertAdjacentHTML("afterbegin", msg.content);
      }
      if (msg.selected) {
        if (msg.selected !== true) {
          el.querySelectorAll("input:checked").forEach(input => {
            input.checked = false;
            input.parentNode.classList.remove("active");
          });
        }
        el.querySelectorAll("input").forEach(input => {
          if (msg.selected === true || msg.selected.indexOf(input.value) > -1) {
            input.checked = true;
            input.parentNode.classList.add("active");
          }
        });
        $(el).trigger("checkbar.select.yonder");
      }
      if (msg.enable) {
        let enable = msg.enable;
        if (enable === true) {
          el.querySelectorAll(".btn").forEach(btn => {
            btn.classList.remove("disabled");
            btn.children[0].removeAttribute("disabled");
          });
        } else {
          el.querySelectorAll(".btn").forEach(btn => {
            if (enable.indexOf(btn.value) > -1) {
              btn.classList.remove("disabled");
              btn.children[0].removeAttribute("disabled");
            }
          });
        }
      }
      if (msg.disable) {
        let disable = msg.disable;
        if (disable === true) {
          el.querySelectorAll(".btn").forEach(btn => {
            btn.classList.add("disabled");
            btn.children[0].setAttribute("disabled", "");
          });
        } else {
          el.querySelectorAll(".btn").forEach(btn => {
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

  let checkboxInputBinding = new Shiny.InputBinding();
  $.extend(checkboxInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-checkbox[id]"),
    getValue: el => {
      let checked = el.querySelectorAll("input:checked:not(:disabled)");
      if (checked.length === 0) {
        return null;
      }
      return Array.prototype.map.call(checked, c => c.value);
    },
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("change.yonder", e => callback());
      $el.on("checkbox.select.yonder", e => callback());
    },
    unsubscribe: el => $(el).off(".yonder"),
    receiveMessage: (el, msg) => {
      if (msg.content) {
        el.querySelectorAll(".custom-checkbox").forEach(box => {
          el.removeChild(box);
        });
        el.insertAdjacentHTML("afterbegin", msg.content);
      }
      if (msg.selected) {
        el.querySelectorAll("input:checked").forEach(input => {
          input.checked = false;
        });
        el.querySelectorAll("input").forEach(input => {
          if (msg.selected === true || msg.selected.indexOf(input.value) > -1) {
            input.checked = true;
          }
        });
        $(el).trigger("checkbox.select.yonder");
      }
      if (msg.enable) {
        let enable = msg.enable;
        if (enable === true) {
          el.querySelectorAll("input").forEach(input => {
            input.removeAttribute("disabled");
          });
        } else {
          el.querySelectorAll("input").forEach(input => {
            if (enable.indexOf(input.value) > -1) {
              input.removeAttribute("disabled");
            }
          });
        }
      }
      if (msg.disable) {
        let disable = msg.disable;
        if (disable === true) {
          el.querySelectorAll("input").forEach(input => {
            input.setAttribute("disabled", "");
          });
        } else {
          el.querySelectorAll("input").forEach(input => {
            if (disable.indexOf(input.value) > -1) {
              input.setAttribute("disabled", "");
            }
          });
        }
      }
      if (msg.valid) {
        el.querySelector(".invalid-feedback").innerHTML = "";
        el.querySelector(".valid-feedback").innerHTML = msg.valid;
        el.querySelectorAll("input").forEach(input => {
          input.classList.remove("is-invalid");
          input.classList.add("is-valid");
        });
      }
      if (msg.invalid) {
        el.querySelector(".valid-feedback").innerHTML = "";
        el.querySelector(".inavlid-feedback").innerHTML = msg.invalid;
        el.querySelectorAll("input").forEach(input => {
          input.classList.remove("is-valid");
          input.classList.add("is-invalid");
        });
      }
      if (!msg.valid && !msg.invalid) {
        el.querySelectorAll(".valid-feedback").forEach(vf => vf.innerHTML = "");
        el.querySelectorAll(".invalid-feedback").forEach(ivf => ivf.innerHTML = "");
        el.querySelectorAll("input").forEach(input => {
          input.classList.remove("is-valid");
          input.classList.remove("is-invalid");
        });
      }
    }
  });
  Shiny.inputBindings.register(checkboxInputBinding, "yonder.checkboxInput");

  let chipInputBinding = new Shiny.InputBinding();
  $.extend(chipInputBinding, {
    selectorActive: ".active",
    selectorToggle: "input[data-toggle='dropdown']",
    find: scope => scope.querySelectorAll(".yonder-chip[id]"),
    initialize: el => {
      let $el = $(el);
      let $toggle = $(el.querySelector(chipInputBinding.selectorToggle));
      $el.on("input", e => {
        let value = $toggle[0].value;
        chipInputBinding._filter(el, value);
        if (chipInputBinding._visible(el).length === 0) {
          $toggle.dropdown("hide");
        } else {
          $toggle.dropdown("show");
        }
      });
      $el.on("input change", e => {
        $toggle.dropdown("update");
      });
      $el.on("hide.bs.dropdown", e => {
        if (el.querySelector("input:focus") === null) {
          el.querySelector("input").value = "";
          chipInputBinding._filter(el, "");
        }
      });
      $el.on("click", ".dropdown-item", e => {
        e.stopPropagation();
        chipInputBinding._add(el, e.currentTarget.value);
        $toggle[0].focus();
      });
      $el.on("click", ".chip", e => {
        chipInputBinding._remove(el, e.currentTarget.value);
      });
      let max = +el.getAttribute("data-max");
      if (max !== -1 && chipInputBinding._selected(el).length >= max) {
        chipInputBinding._disable(el);
      }
    },
    getValue: el => {
      let selected = el.querySelectorAll(".active");
      if (selected.length === 0) {
        return null;
      }
      return Array.prototype.map.call(selected, s => s.value);
    },
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("click.yonder", ".dropdown-item,.chip", e => callback());
      $el.on("chip.select.yonder", e => callback());
    },
    unsubscribe: el => $(el).off(".yonder"),
    receiveMessage: (el, msg) => {
      let $el = $(el);
      if (msg.items && msg.chips) {
        el.querySelector(".dropdown-menu").innerHTML = msg.items;
        el.querySelector(".chips").innerHTML = msg.chips;
      }
      if (msg.selected) {
        if (msg.selected === true) {
          el.querySelectorAll(".dropdown-item").forEach(item => {
            chipInputBinding._add(el, item.value);
          });
        } else {
          msg.selected.reverse();
          chipInputBinding._selected(el).forEach(item => {
            chipInputBinding._remove(el, item.value);
          });
          msg.selected.forEach(value => {
            chipInputBinding._add(el, value);
          });
        }
        $el.trigger("chip.select.yonder");
      }
      if (msg.max !== undefined && msg.max !== null) {
        el.setAttribute("data-max", msg.max);
      }
      if (msg.enable) {
        let enable = msg.enable;
        if (enable === true) {
          chipInputBinding._enable(el);
          // el.querySelector("input").removeAttribute("disabled");
        } else {
          el.querySelectorAll(".dropdown-item,.chip").forEach(item => {
            if (enable.indexOf(item.value) > -1) {
              item.removeAttribute("disabled");
              item.classList.remove("disabled");
            }
          });
        }
      }
      if (msg.disable) {
        let disable = msg.disable;
        if (disable === true) {
          chipInputBinding._disable(el);
          // el.querySelector("input").setAttribute("disabled", "");
        } else {
          el.querySelectorAll(".dropdown-item,.chip").forEach(item => {
            if (disable.indexOf(item.value) > -1) {
              item.setAttribute("disabled", "");
              item.classList.add("disabled");
            }
          });
        }
      }
    },
    _visible: el => {
      return el.querySelectorAll(":not(.selected),:not(.filtered)");
    },
    _selected: el => {
      return el.querySelectorAll(".selected");
    },
    _items: (el, value) => {
      return Array.prototype.filter.call(el.querySelectorAll(".dropdown-item"), chip => chip.value === value);
    },
    _chips: (el, value) => {
      return Array.prototype.filter.call(el.querySelectorAll(".chip"), chip => chip.value === value);
    },
    _enable: el => {
      let input = el.querySelector("input");
      input.removeAttribute("disabled");
      input.classList.remove("disabled");
    },
    _disable: el => {
      let input = el.querySelector("input");
      input.setAttribute("disabled", "");
      input.classList.add("disabled");
    },
    _filter: (el, value) => {
      value = value.toLowerCase();
      el.querySelectorAll(".dropdown-item").forEach(item => {
        let match = item.innerText.toLowerCase().indexOf(value) !== -1;
        if (match) {
          item.classList.remove("filtered");
        } else {
          item.classList.add("filtered");
        }
      });
    },
    _add: (el, value) => {
      let $toggle = $(el.querySelector(chipInputBinding.selectorToggle));
      let sort = el.getAttribute("data-sort");
      chipInputBinding._items(el, value).forEach(item => {
        item.classList.add("selected");
      });
      let chips = el.querySelector(".chips");
      chipInputBinding._chips(el, value).forEach(chip => {
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
      let max = +el.getAttribute("data-max");
      if (max === -1 || chipInputBinding._selected(el).length < max) {
        $toggle.dropdown("update");
      } else {
        $toggle.dropdown("hide");
        chipInputBinding._disable(el);
      }
    },
    _remove: (el, value) => {
      let max = +el.getAttribute("data-max");
      chipInputBinding._chips(el, value).forEach(chip => {
        chip.classList.remove("active");
      });
      chipInputBinding._items(el, value).forEach(item => {
        item.classList.remove("selected");
      });
      if (max === -1 || chipInputBinding._selected(el).length < max) {
        chipInputBinding._enable(el);
      }
    }
  });
  Shiny.inputBindings.register(chipInputBinding, "yonder.chipInput");

  let fileInputBinding = new Shiny.InputBinding();
  $.extend(fileInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-file[id]"),
    initialize: el => {
      let $el = $(el);
      $el.on("dragover", e => {
        e.stopPropagation();
        e.preventDefault();
      });
      $el.on("dragcenter", e => {
        e.stopPropagation();
        e.preventDefault();
      });
      $el.on("drop", e => {
        e.stopPropagation();
        e.preventDefault();
        fileInputBinding._upload(el, e.originalEvent.dataTransfer.files);
      });
      $el.on("change", e => {
        fileInputBinding._upload(el);
      });
    },
    getValue: el => null,
    receiveMessage: (el, msg) => {
      let input = el.querySelector("input");
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
    _post: function (uri, job, file, final, el) {
      let xhr = new XMLHttpRequest();
      xhr.open("POST", uri, true);
      xhr.setRequestHeader("Content-Type", "application/octet-stream");
      xhr.onreadystatechange = function () {
        if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200 && final) {
          Shiny.shinyapp.makeRequest("uploadEnd", [job, el.id], res => {
            el.querySelector("input[type='file']").value = "";
          }, err => {
            console.error(`uploadEnd request failed for ${el.id}: ${err}`);
          });
        }
      };
      xhr.send(file);
    },
    _upload: function (el, files) {
      let input = el.querySelector("input[type='file']");
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
      let info = files.map(f => {
        return {
          name: f.name,
          size: f.size,
          type: f.type
        };
      });
      Shiny.shinyapp.makeRequest("uploadInit", [info], res => {
        let job = res.jobId;
        let uri = res.uploadUrl;
        for (var i = 0; i < files.length; i++) {
          this._post(uri, job, files[i], i === files.length - 1, el);
        }
      }, err => {
        console.error(`uploadInit request failed for ${el.id}: ${err}`);
      });
    }
  });
  document.addEventListener("DOMContentLoaded", () => {
    bsCustomFileInput.init(".yonder-file[id] input[type='file']");
  });
  Shiny.inputBindings.register(fileInputBinding, "yonder.fileInput");

  let formInputBinding = new Shiny.InputBinding();
  $.extend(formInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-form[id]"),
    initialize: el => {
      let $document = $(document);
      let $el = $(el);
      let store = {};
      let value = null;
      el.querySelectorAll(".yonder-form-submit").forEach(s => {
        s.setAttribute("type", "submit");
      });
      $document.on("shiny:inputchanged.yonder", e => {
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
      $el.on("click.yonder", ".yonder-form-submit", e => {
        value = e.currentTarget.value;
      });
      $el.on("submit.yonder", (e, v) => {
        e.preventDefault();
        if (v !== undefined) {
          value = v;
        }
        Object.keys(store).forEach(key => {
          Shiny.onInputChange(key, store[key], {
            priority: "event"
          });
        });
      });
    },
    getValue: el => null,
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("submit.yonder", e => callback());
    },
    unsubscribe: el => {
      $(el).off(".yonder");
      $(document).off("shiny:inputchanged.yonder");
    },
    receiveMessage: (el, msg) => {
      if (msg.submit !== undefined && msg.submit !== null) {
        $(el).trigger("submit.yonder", msg.submit);
      }
    }
  });
  Shiny.inputBindings.register(formInputBinding, "yonder.formInput");

  let linkInputBinding = new Shiny.InputBinding();
  $.extend(linkInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-link[id]"),
    initialize: el => {
      $(el).on("click", e => el.value = +el.value + 1);
      el.value = 0;
    },
    getValue: el => +el.value > 0 ? +el.value : null,
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("click.yonder", e => callback());
      $el.on("link.value.yonder", e => callback());
    },
    unsubscribe: el => $(el).off(".yonder"),
    receiveMessage: (el, msg) => {
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

  let listGroupInputBinding = new Shiny.InputBinding();
  $.extend(listGroupInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-list-group[id]"),
    initialize: el => {
      let $el = $(el);
      $el.on("click", ".list-group-item-action:not(.active):not(.disabled)", e => {
        el.querySelectorAll(".active").forEach(item => {
          item.classList.remove("active");
        });
        e.currentTarget.classList.add("active");
      });
      $el.on("click", ".list-group-item-action.active:not(.disabled)", e => {
        e.currentTarget.classList.remove("active");
      });
    },
    getValue: el => {
      let items = el.querySelectorAll(".list-group-item-action.active:not(.disabled)");
      if (items.length === 0) {
        return null;
      }
      return Array.prototype.slice.call(items).map(i => i.value);
    },
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("click.yonder", e => callback());
      $el.on("listgroup.select.yonder", e => callback());
    },
    unsubcribe: el => $(el).off(".yonder"),
    receiveMessage: (el, msg) => {
      if (msg.content) {
        el.querySelectorAll(".list-group-item").forEach(item => {
          el.removeChild(item);
        });
        el.insertAdjacentHTML("afterbegin", msg.content);
      }
      if (msg.selected) {
        if (msg.selected !== true) {
          el.querySelectorAll(".list-group-item.active").forEach(item => {
            item.classList.remove("active");
          });
        }
        el.querySelectorAll(".list-group-item").forEach(item => {
          if (msg.selected === true || msg.selected.indexOf(item.value) > -1) {
            item.classList.add("active");
          }
        });
        $(el).trigger("listgroup.select.yonder");
      }
      if (msg.enable) {
        let enable = msg.enable;
        if (enable === true) {
          el.querySelectorAll(".list-group-item").forEach(item => {
            item.classList.remove("disabled");
          });
        } else {
          el.querySelectorAll(".list-group-item").forEach(item => {
            if (enable.indexOf(item.value) > -1) {
              item.classList.remove("disabled");
            }
          });
        }
      }
      if (msg.disable) {
        let disable = msg.disable;
        if (disable === true) {
          el.querySelectorAll(".list-group-item").forEach(item => {
            item.classList.add("disabled");
          });
        } else {
          el.querySelectorAll(".list-group-item").forEach(item => {
            if (disable.indexOf(item.value) > -1) {
              item.classList.add("disabled");
            }
          });
        }
      }
    }
  });
  Shiny.inputBindings.register(listGroupInputBinding, "yonder.listGroupInput");

  let menuInputBinding = new Shiny.InputBinding();
  $.extend(menuInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-menu[id]"),
    initialize: el => {
      let $el = $(el);
      $el.on("click", ".dropdown-item:not(.disabled)", e => {
        let active = el.querySelector(".dropdown-item.active");
        if (active !== null) {
          active.classList.remove("active");
        }
        e.currentTarget.classList.add("active");
      });
      $el.on("nav.reset", e => {
        let active = el.querySelector(".dropdown-item.active");
        if (active !== null) {
          active.classList.remove("active");
        }
      });
    },
    getValue: el => {
      let active = el.querySelector(".dropdown-item.active:not(.disabled)");
      if (active === null) {
        return null;
      }
      return active.value;
    },
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("click.yonder", e => callback());
      $el.on("menu.select.yonder", e => callback());
    },
    unsubscribe: el => $(el).off(".yonder"),
    receiveMessage: (el, msg) => {
      if (msg.content) {
        el.querySelector(".dropdown-menu").innerHTML = msg.content;
      }
      if (msg.label) {
        let toggle = el.querySelector(".dropdown-toggle");
        toggle.innerHTML = msg.label;
      }
      if (msg.selected) {
        el.querySelectorAll(".dropdown-item").forEach(item => {
          if (msg.selected.indexOf(item.value) > -1) {
            item.classList.add("active");
          } else {
            item.classList.remove("active");
          }
        });
        $(el).trigger("menu.select.yonder");
      }
      if (msg.enable) {
        let enable = msg.enable;
        if (enable === true) {
          el.querySelector(".dropdown-toggle").classList.remove("disabled");
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
          el.querySelector(".dropdown-toggle").classList.add("disabled");
        } else {
          el.querySelectorAll(".dropdown-item").forEach(item => {
            if (disable.indexOf(item.value) > -1) {
              item.classList.add("disabled");
            }
          });
        }
      }
    }
  });
  Shiny.inputBindings.register(menuInputBinding, "yonder.menuInput");

  let navInputBinding = new Shiny.InputBinding();
  $.extend(navInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-nav[id]"),
    initialize: el => {
      let $el = $(el);
      $el.on("click", ".nav-link:not(.dropdown-toggle):not(.disabled)", e => {
        let active = el.querySelector(".dropdown-item.active");
        if (active !== null) {
          // trigger reset on menu input
          $(active.parentNode.parentNode).trigger("nav.reset");
        }
        el.querySelectorAll(".active").forEach(a => a.classList.remove("active"));
        e.currentTarget.classList.add("active");
      });
      $el.on("click", ".dropdown-item:not(.disabled)", e => {
        el.querySelectorAll(".active").forEach(a => a.classList.remove("active"));
        e.currentTarget.parentNode.parentNode.children[0].classList.add("active");
        e.currentTarget.classList.add("active");
      });
    },
    getValue: el => {
      let active = el.querySelector(".nav-link.active:not(.disabled)");
      if (active === null) {
        return null;
      }
      return active.value;
    },
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("click.yonder", ".dropdown-item", e => callback());
      $el.on("click.yonder", ".nav-link:not(.dropdown-toggle)", e => callback());
      $el.on("nav.select.yonder", e => callback());
    },
    unsubscribe: el => $(el).off(".yonder"),
    receiveMessage: (el, msg) => {
      if (msg.content) {
        el.querySelectorAll(".nav-item").forEach(item => el.removeChild(item));
        el.insertAdjacentHTML("afterbegin", msg.content);
      }
      if (msg.selected) {
        el.querySelectorAll(".nav-link").forEach(link => {
          if (msg.selected.indexOf(link.value) > -1) {
            link.classList.add("active");
          } else {
            link.classList.remove("active");
          }
        });
        $(el).trigger("nav.select.yonder");
      }
      if (msg.enable) {
        let enable = msg.enable;
        if (enable === true) {
          el.querySelectorAll(".nav-link").forEach(link => {
            link.classList.remove("disabled");
          });
        } else {
          el.querySelectorAll(".nav-link").forEach(link => {
            if (enable.indexOf(link.value) > -1) {
              link.classList.remove("disabled");
            }
          });
        }
      }
      if (msg.disable) {
        let disable = msg.disable;
        if (disable === true) {
          el.querySelectorAll(".nav-link").forEach(link => {
            link.classList.add("disabled");
          });
        } else {
          el.querySelectorAll(".nav-link").forEach(link => {
            if (disable.indexOf(link.value) > -1) {
              link.classList.add("disabled");
            }
          });
        }
      }
    }
  });
  Shiny.inputBindings.register(navInputBinding, "yonder.navInput");
  Shiny.addCustomMessageHandler("yonder:pane", msg => {
    let _show = function (pane) {
      if (pane === null || pane.classList.contains("show")) {
        return;
      }
      if (!pane.parentElement.classList.contains("tab-content")) {
        console.warn(`nav pane ${pane.id} is missing a nav content parent element`);
        return;
      }
      let previous = pane.parentElement.querySelector(".active");
      const complete = () => {
        const hiddenEvent = $.Event("hidden.bs.tab", {
          relatedTarget: pane
        });
        const shownEvent = $.Event("shown.bs.tab", {
          relatedTarget: previous
        });
        $(previous).trigger(hiddenEvent);
        $(pane).trigger(shownEvent);
      };
      bootstrap.Tab.prototype._activate(pane, pane.parentElement, complete);
    };
    let _hide = function (pane) {
      if (pane === null || !pane.classList.contains("show")) {
        return;
      }
      if (!pane.parentElement.classList.contains("tab-content")) {
        console.warn(`nav pane ${pane.id} is missing a nav content parent element`);
        return;
      }
      const complete = () => {
        const hiddenEvent = $.Event("hidden.bs.tab", {
          relatedTarget: pane
        });
        $(pane).trigger(hiddenEvent);
      };
      let dummy = document.createElement("div");
      bootstrap.Tab.prototype._activate(dummy, pane.parentElement, complete);
    };
    if (msg.type === undefined || msg.data === undefined || msg.data.target === undefined) {
      return;
    }
    let target = document.getElementById(msg.data.target);
    if (target === null) {
      return;
    }
    if (msg.type === "show") {
      _show(target);
    } else if (msg.type === "hide") {
      _hide(target);
    }
  });

  let radioInputBinding = new Shiny.InputBinding();
  $.extend(radioInputBinding, {
    find: scope => {
      return scope.querySelectorAll(".yonder-radio[id]");
    },
    getValue: el => {
      let radios = el.querySelectorAll(".custom-radio > input:checked:not(:disabled)");
      if (radios.length === 0) {
        return null;
      }
      return Array.prototype.slice.call(radios).map(r => r.value);
    },
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("change.yonder", e => callback());
      $el.on("radio.select.yonder", e => callback());
    },
    unsubscribe: el => {
      $(el).off(".yonder");
    },
    receiveMessage: (el, msg) => {
      if (msg.content) {
        el.querySelectorAll(".custom-radio").forEach(radio => {
          el.removeChild(radio);
        });
        el.insertAdjacentHTML("afterbegin", msg.content);
      }
      if (msg.selected) {
        el.querySelectorAll("input").forEach(input => {
          if (msg.selected.indexOf(input.value) > -1) {
            input.checked = true;
          } else {
            input.checked = false;
          }
        });
        $(el).trigger("radio.select.yonder");
      }
      if (msg.enable) {
        let enable = msg.enable;
        if (enable === true) {
          el.querySelectorAll(".custom-radio > input").forEach(input => {
            input.removeAttribute("disabled");
          });
        } else {
          el.querySelectorAll(".custom-radio > input").forEach(input => {
            if (enable.indexOf(input.value) > -1) {
              input.removeAttribute("disabled");
            }
          });
        }
      }
      if (msg.disable) {
        let disable = msg.disable;
        if (disable === true) {
          el.querySelectorAll(".custom-radio > input").forEach(input => {
            input.setAttribute("disabled", "");
          });
        } else {
          el.querySelectorAll(".custom-radio > input").forEach(input => {
            if (disable.indexOf(input.value) > -1) {
              input.setAttribute("disabled", "");
            }
          });
        }
      }
      if (msg.valid) {
        el.querySelector(".valid-feedback").innerHTML = msg.valid;
        el.querySelectorAll(".custom-control-input").forEach(radio => {
          radio.classList.add("is-valid");
        });
      }
      if (msg.invalid) {
        el.querySelector(".invalid-feedback").innerHTML = msg.invalid;
        el.querySelectorAll(".custom-control-input").forEach(radio => {
          radio.classList.add("is-invalid");
        });
      }
      if (!msg.valid && !msg.invalid) {
        el.querySelectorAll(".valid-feedback").forEach(vf => vf.innerHTML = "");
        el.querySelectorAll(".invalid-feedback").forEach(ivf => ivf.innerHTML = "");
        el.querySelectorAll(".custom-control-input").forEach(radio => {
          radio.classList.remove("is-valid");
          radio.classList.remove("is-invalid");
        });
      }
    }
  });
  Shiny.inputBindings.register(radioInputBinding, "yonder.radioInput");

  let radiobarInputBinding = new Shiny.InputBinding();
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
    find: scope => scope.querySelectorAll(".yonder-radiobar[id]"),
    getValue: el => {
      let radios = el.querySelectorAll("input:checked:not(:disabled)");
      if (radios.length === 0) {
        return null;
      }
      return Array.prototype.slice.call(radios).map(r => r.value);
    },
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("click.yonder", e => callback());
      $el.on("change.yonder", e => callback());
      $el.on("radiobar.select.yonder", e => callback());
    },
    unsubscribe: el => {
      $(el).off(".yonder");
    },
    receiveMessage: (el, msg) => {
      if (msg.content) {
        el.innerHTML = msg.content;
      }
      if (msg.selected) {
        el.querySelectorAll("input").forEach(input => {
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
        let enable = msg.enable;
        if (enable === true) {
          el.querySelectorAll(".btn").forEach(btn => {
            btn.classList.remove("disabled");
            btn.children[0].removeAttribute("disabled");
          });
        } else {
          el.querySelectorAll("input").forEach(input => {
            if (enable.indexOf(input.value) > -1) {
              input.parentNode.classList.remove("disabled");
              input.removeAttribute("disabled");
            }
          });
        }
      }
      if (msg.disable) {
        let disable = msg.disable;
        if (disable === true) {
          el.querySelectorAll(".btn").forEach(btn => {
            btn.classList.add("disabled");
            btn.children[0].setAttribute("disabled", "");
          });
        } else {
          el.querySelectorAll("input").forEach(input => {
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

  let rangeInputBinding = new Shiny.InputBinding();
  $.extend(rangeInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-range[id]"),
    getId: el => el.id,
    getValue: el => +el.children[0].value,
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("input.yonder", callback(true));
      $el.on("range.value.yonder");
    },
    unsubscribe: el => $(el).off(".yonder"),
    receiveMessage: (el, msg) => {
      let input = el.children[0];
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

  let selectInputBinding = new Shiny.InputBinding();
  $.extend(selectInputBinding, {
    find: scope => {
      return scope.querySelectorAll(".yonder-select[id]");
    },
    initialize: el => {
      let $el = $(el);
      $el.on("click", ".dropdown-item", e => {
        $el[0].querySelector("input").placeholder = e.currentTarget.innerText;
        let prev = $el[0].querySelector(".active");
        if (prev) {
          prev.classList.remove("active");
        }
        e.currentTarget.classList.add("active");
      });
      let $input = $(el.querySelector("input"));
      $el.on("input change", "input", e => {
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
      $el.on("hide.bs.dropdown", e => {
        $input[0].value = "";
        el.querySelectorAll(".filtered").forEach(f => {
          f.classList.remove("filtered");
        });
      });
    },
    getValue: el => {
      let selected = el.querySelectorAll(".dropdown-item.active:not(.disabled)");
      if (selected.length === 0) {
        return null;
      }
      return Array.prototype.slice.call(selected).map(o => o.value);
    },
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("click.yonder", ".dropdown-item", e => callback());
      $el.on("select.select.yonder", e => callback()); // ha.
    },
    unsubscribe: el => {
      $(el).off(".yonder");
    },
    receiveMessage: (el, msg) => {
      if (msg.content) {
        el.querySelector(".dropdown-menu").innerHTML = msg.content;
        let input = el.querySelector("input");
        input.placeholder = input.getAttribute("data-original-placeholder") || "";
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
  let groupSelectInputBinding = new Shiny.InputBinding();
  $.extend(groupSelectInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-group-select[id]"),
    getValue: el => {
      let inputs = el.querySelectorAll(".input-group-prepend .input-group-text, select, .input-group-append .input-group-text");
      return Array.prototype.slice.call(inputs).map(i => /^(DIV|SPAN)$/.test(i.tagName) ? i.innerText : i.value || null).filter(value => value !== null);
    },
    getType: () => "yonder.group.select",
    subscribe: (el, callback) => {
      let $el = $(el);
      if (el.querySelectorAll(".btn").length > 0) {
        $el.on("click", ".dropdown-item", e => callback());
      } else {
        $el.on("change", e => callback());
        $el.on("groupselect.select.yonder", e => callback());
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

  let textualInputBinding = new Shiny.InputBinding();
  $.extend(textualInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-textual[id]"),
    getValue: el => {
      let input = el.children[0];
      if (input.value === "") {
        return null;
      }
      return input.type === "number" ? Number(input.value) : input.value;
    },
    subscribe: (el, callback) => {
      let $el = $(el);
      $el.on("change.yonder", e => callback(true));
      $el.on("input.yonder", e => callback(true));
      $el.on("textual.value.yonder", e => callback(true));
    },
    unsubscribe: el => $(el).off(".yonder"),
    getRatePolicy: () => ({
      policy: "debounce",
      delay: 250
    }),
    receiveMessage: (el, msg) => {
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
      let input = el.querySelector("input");
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
  let groupTextInputBinding = new Shiny.InputBinding();
  $.extend(groupTextInputBinding, {
    find: scope => scope.querySelectorAll(".yonder-group-text[id]"),
    getValue: el => {
      let inputs = el.querySelectorAll(".input-group-prepend .input-group-text, input, .input-group-append .input-group-text");
      return Array.prototype.slice.call(inputs).map(i => /^(DIV|SPAN)$/.test(i.tagName) ? i.innerText : i.value || null).filter(value => value !== null);
    },
    getType: () => "yonder.group.text",
    getRatePolicy: el => ({
      policy: "debounce",
      delay: 250
    }),
    subscribe: (el, callback) => {
      let $el = $(el);
      if (el.querySelectorAll(".btn").length > 0) {
        $el.on("click.yonder", ".dropdown-item", e => callback());
        $el.on("click.yonder", ".btn:not(.dropdown-toggle", e => callback());
      } else {
        $el.on("input.yonder", e => callback(true));
        $el.on("change.yonder", e => callback(true));
        $el.on("textual.value.yonder", e => callback());
      }
    },
    unsubscribe: el => $(el).off(".yonder"),
    receiveMessage: (el, msg) => {
      let input = el.querySelector("input");
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

  Shiny.addCustomMessageHandler("yonder:collapse", msg => {
    if (msg.type === undefined || msg.data === undefined || msg.data.target === undefined) {
      return false;
    }
    if (msg.type === "show" || msg.type === "hide" || msg.type === "toggle") {
      let target = document.getElementById(msg.data.target);
      if (target === null) {
        return false;
      }
      $(target).collapse(msg.type);
      return true;
    }
    return false;
  });

  Shiny.addCustomMessageHandler("yonder:download", msg => {
    if (!(msg.filename && msg.token && msg.key)) {
      throw "invalid download event";
    }
    const uri = `/session/${msg.token}/download/${msg.key}`;
    let agent = window.navigator.userAgent;
    let ie = /MSIE/.test(agent);
    if (ie === true) {
      let xhr = new XMLHttpRequest();
      xhr.open("GET", uri);
      xhr.responseType = "blob";
      xhr.onload = () => saveAs(xhr.response, msg.filename);
      xhr.send();
    } else {
      fetch(uri).then(res => res.blob()).then(blob => {
        saveAs(blob, msg.filename);
      });
    }
  });

  Shiny.addCustomMessageHandler("yonder:content", msg => {
    let _replace = data => {
      if (!data.id) {
        return;
      }
      let target = document.getElementById(data.id);
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
        Object.keys(data.attrs).forEach(key => {
          target.setAttribute(key, data.attrs[key]);
        });
      }
    };
    let _remove = data => {
      if (!data.id) {
        return;
      }
      let target = document.getElementById(data.id);
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
      console.warn(`no content "${msg.type}" method`);
    }
  });

  $(() => {
    document.body.insertAdjacentHTML("beforeend", "<div class='yonder-modals'></div>");
  });
  Shiny.addCustomMessageHandler("yonder:modal", function (msg) {
    if (msg.type === undefined) {
      return false;
    }
    let _close = function (data) {
      let modals = document.querySelector(".yonder-modals").childNodes;
      if (modals.length === 0) {
        return;
      }
      if (data.id) {
        modals = Array.prototype.filter.call(modals, m => m.id === data.id);
      }
      modals.forEach(modal => {
        if (!modal.classList.contains("yonder-modal")) {
          return;
        }
        $(modal).modal("hide");
      });
    };
    let _show = function (data) {
      if (data.id) {
        let possible = document.getElementById(data.id);
        if (possible && possible.classList.contains("yonder-modal")) {
          console.warn("ignoring modal with duplicate id");
          return;
        }
      }
      if (data.dependencies) {
        Shiny.renderDependencies(data.dependencies);
      }
      let container = document.querySelector(".yonder-modals");
      container.insertAdjacentHTML("beforeend", data.content);
      let modal = container.querySelector(".yonder-modal:last-child");
      Shiny.initializeInputs(modal);
      Shiny.bindAll(modal);
      let $modal = $(modal);
      $modal.one("hidden.bs.modal", e => {
        if (modal.id) {
          Shiny.onInputChange(modal.id, true);
          setTimeout(() => Shiny.onInputChange(modal.id, null), 100);
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
      console.warn(`no modal ${msg.type} method`);
    }
  });

  Shiny.addCustomMessageHandler("yonder:popover", msg => {
    if (!msg.data.id || !document.getElementById(msg.data.id)) {
      return;
    }
    let _show = data => {
      let $target = $(document.getElementById(data.id));
      $target.popover({
        content: () => undefined,
        placement: data.placement,
        template: data.content,
        title: () => undefined,
        trigger: "manual"
      });
      if (data.duration) {
        setTimeout(() => $target.popover("hide"), data.duration);
      }
      $target.popover("show");
    };
    let _close = data => {
      let target = document.getElementById(data.id);
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
      console.warn(`no "${msg.type}" popover method`);
    }
  });

  $(() => {
    document.body.insertAdjacentHTML("beforeend", "<div class='yonder-toasts'></div>");
    $(".yonder-toasts").on("hidden.bs.toast", ".toast", e => {
      if (e.currentTarget.hasAttribute("data-action")) {
        let action = e.currentTarget.getAttribute("data-action");
        Shiny.onInputChange(action, true);
        setTimeout(() => Shiny.onInputChange(action, null), 100);
      }
      e.delegateTarget.removeChild(e.currentTarget);
    });
  });
  Shiny.addCustomMessageHandler("yonder:toast", msg => {
    let _show = function (data) {
      document.querySelector(".yonder-toasts").insertAdjacentHTML("beforeend", data.content);
      $(".yonder-toasts > .toast:last-child").toast("show");
    };
    let _close = function (data) {
      let toasts = document.querySelectorAll(".yonder-toasts .toast");
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
      console.warn(`no toast ${msg.type} method`);
    }
  });

  $(() => $("[data-toggle=\"tooltip\"]").tooltip());

}));
//# sourceMappingURL=yonder.js.map
