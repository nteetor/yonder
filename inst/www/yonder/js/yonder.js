(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory(require('jQuery'), require('Shiny')) :
  typeof define === 'function' && define.amd ? define(['jQuery', 'Shiny'], factory) :
  (global.yonder = factory(global.$,global.Shiny));
}(this, (function ($$1,Shiny$1) { 'use strict';

  $$1 = $$1 && $$1.hasOwnProperty('default') ? $$1['default'] : $$1;
  Shiny$1 = Shiny$1 && Shiny$1.hasOwnProperty('default') ? Shiny$1['default'] : Shiny$1;

  var deactivateRelatives = function deactivateRelatives(el) {
    el.parentNode.querySelectorAll(".tab-pane[id]").forEach(function (pane) {
      document.querySelectorAll("[data-target=\"#" + pane.id + "\"]").forEach(function (t) {
        return t.classList.remove("active");
      });
    });
  };

  var actionPerform = function actionPerform(el) {
    var plugin = el.getAttribute("data-plugin");
    var action = el.getAttribute("data-action");
    var target = el.getAttribute("data-target");

    if (!(plugin && action && target)) {
      return;
    }

    if (document.querySelector(target).classList.contains("show")) {
      return;
    }

    if (plugin === "tab") {
      deactivateRelatives(document.querySelector(target));
    }

    $(el)[plugin](action);

    if (el.tagName === "BUTTON") {
      if (el.classList.contains("btn")) {
        window.setTimeout(function () {
          return el.classList.remove("active");
        }, 1);
      }

      if (el.classList.contains("dropdown-item")) {
        window.setTimeout(function () {
          el.querySelector(".dropdown-toggle").classList.remove("active");
        }, 1);
      }
    } else if (el.tagName === "INPUT") {
      window.setTimeout(function () {
        return el.classList.remove("active");
      }, 1);
    }
  }; // $(() => {
  //   let active = document.querySelectorAll(".active[data-plugin], input:checked[data-plugin]");
  //   active.forEach(a => actionPerform(a));
  // });


  var actionListener = function actionListener(el, selector, event) {
    $(el).on(event, selector, function (e) {
      var clicked = e.currentTarget;
      actionPerform(clicked);
    });
  };

  function _defineProperties(target, props) {
    for (var i = 0; i < props.length; i++) {
      var descriptor = props[i];
      descriptor.enumerable = descriptor.enumerable || false;
      descriptor.configurable = true;
      if ("value" in descriptor) descriptor.writable = true;
      Object.defineProperty(target, descriptor.key, descriptor);
    }
  }

  function _createClass(Constructor, protoProps, staticProps) {
    if (protoProps) _defineProperties(Constructor.prototype, protoProps);
    if (staticProps) _defineProperties(Constructor, staticProps);
    return Constructor;
  }

  function _defineProperty(obj, key, value) {
    if (key in obj) {
      Object.defineProperty(obj, key, {
        value: value,
        enumerable: true,
        configurable: true,
        writable: true
      });
    } else {
      obj[key] = value;
    }

    return obj;
  }

  function ownKeys(object, enumerableOnly) {
    var keys = Object.keys(object);

    if (Object.getOwnPropertySymbols) {
      var symbols = Object.getOwnPropertySymbols(object);
      if (enumerableOnly) symbols = symbols.filter(function (sym) {
        return Object.getOwnPropertyDescriptor(object, sym).enumerable;
      });
      keys.push.apply(keys, symbols);
    }

    return keys;
  }

  function _objectSpread2(target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i] != null ? arguments[i] : {};

      if (i % 2) {
        ownKeys(source, true).forEach(function (key) {
          _defineProperty(target, key, source[key]);
        });
      } else if (Object.getOwnPropertyDescriptors) {
        Object.defineProperties(target, Object.getOwnPropertyDescriptors(source));
      } else {
        ownKeys(source).forEach(function (key) {
          Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key));
        });
      }
    }

    return target;
  }

  function _inheritsLoose(subClass, superClass) {
    subClass.prototype = Object.create(superClass.prototype);
    subClass.prototype.constructor = subClass;
    subClass.__proto__ = superClass;
  }

  function _getPrototypeOf(o) {
    _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) {
      return o.__proto__ || Object.getPrototypeOf(o);
    };
    return _getPrototypeOf(o);
  }

  function _setPrototypeOf(o, p) {
    _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) {
      o.__proto__ = p;
      return o;
    };

    return _setPrototypeOf(o, p);
  }

  function isNativeReflectConstruct() {
    if (typeof Reflect === "undefined" || !Reflect.construct) return false;
    if (Reflect.construct.sham) return false;
    if (typeof Proxy === "function") return true;

    try {
      Date.prototype.toString.call(Reflect.construct(Date, [], function () {}));
      return true;
    } catch (e) {
      return false;
    }
  }

  function _construct(Parent, args, Class) {
    if (isNativeReflectConstruct()) {
      _construct = Reflect.construct;
    } else {
      _construct = function _construct(Parent, args, Class) {
        var a = [null];
        a.push.apply(a, args);
        var Constructor = Function.bind.apply(Parent, a);
        var instance = new Constructor();
        if (Class) _setPrototypeOf(instance, Class.prototype);
        return instance;
      };
    }

    return _construct.apply(null, arguments);
  }

  function _isNativeFunction(fn) {
    return Function.toString.call(fn).indexOf("[native code]") !== -1;
  }

  function _wrapNativeSuper(Class) {
    var _cache = typeof Map === "function" ? new Map() : undefined;

    _wrapNativeSuper = function _wrapNativeSuper(Class) {
      if (Class === null || !_isNativeFunction(Class)) return Class;

      if (typeof Class !== "function") {
        throw new TypeError("Super expression must either be null or a function");
      }

      if (typeof _cache !== "undefined") {
        if (_cache.has(Class)) return _cache.get(Class);

        _cache.set(Class, Wrapper);
      }

      function Wrapper() {
        return _construct(Class, arguments, _getPrototypeOf(this).constructor);
      }

      Wrapper.prototype = Object.create(Class.prototype, {
        constructor: {
          value: Wrapper,
          enumerable: false,
          writable: true,
          configurable: true
        }
      });
      return _setPrototypeOf(Wrapper, Class);
    };

    return _wrapNativeSuper(Class);
  }

  function _assertThisInitialized(self) {
    if (self === void 0) {
      throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
    }

    return self;
  }

  var InputError =
  /*#__PURE__*/
  function (_Error) {
    _inheritsLoose(InputError, _Error);

    function InputError(code, message) {
      var _this;

      var full = message ? code + ": " + message : code;
      _this = _Error.call(this, full) || this;
      _this.name = code;
      _this.message = full;
      return _this;
    }

    return InputError;
  }(_wrapNativeSuper(Error));

  var dataStore = function () {
    var storeData = {};
    var id = 1;
    return {
      set: function set(element, key, data) {
        if (typeof element.key === "undefined") {
          element.key = {
            key: key,
            id: id
          };
          id++;
        }
        storeData[element.key.id] = data;
      },
      get: function get(element, key) {
        if (!element || typeof element.key === "undefined") {
          return null;
        }

        var keyProperties = element.key;

        if (keyProperties.key === key) {
          return storeData[keyProperties.id];
        }

        return null;
      },
      delete: function _delete(element, key) {
        if (typeof element.key === "undefined") {
          return;
        }

        var keyProperties = element.key;

        if (keyProperties.key === key) {
          delete storeData[keyProperties.id];
          delete element.key;
        }
      }
    };
  }();

  var Store = {
    setData: function setData(instance, key, data) {
      dataStore.set(instance, key, data);
    },
    getData: function getData(instance, key) {
      return dataStore.get(instance, key);
    },
    removeData: function removeData(instance, key) {
      dataStore.delete(instance, key);
    }
  };

  var VERSION = "0.1.2";

  var Input =
  /*#__PURE__*/
  function () {
    function Input(element, type, self) {
      if (typeof element !== "object" && element.nodeType !== 1) {
        throw new InputError("Invalid Argument", "`element` must be an element");
      }

      this._element = element;
      this._type = type;
      this._value = null;

      this._callback = function () {};
    } // getters ----


    var _proto = Input.prototype;

    // methods ----
    _proto.content = function content(html) {
      this._element.innerHTML = html;
    };

    _proto.dispose = function dispose() {
      Store.removeData(this._element, this._type);
      this._element = null;
    } // public ----
    ;

    Input.initialize = function initialize(element, type, input) {
      var data = Store.getData(element, type);

      if (!data) {
        data = new input(element);
      }
    };

    Input.find = function find(scope, selector) {
      return scope.querySelectorAll(selector);
    };

    Input.getId = function getId(element) {
      return element.id;
    };

    Input.getType = function getType(element) {
      return null;
    };

    Input.getValue = function getValue(element) {
      throw new InputError("Unimplemented Method");
    };

    Input.subscribe = function subscribe(element, callback, type) {
      var input = Store.getData(element, type);

      if (!input) {
        return;
      }

      input._callback = callback;
    };

    Input.unsubscribe = function unsubscribe(element, type) {
      var input = Store.getData(element, type);

      if (!input) {
        return;
      }

      input._callback = function () {};
    };

    Input.receiveMessage = function receiveMessage(element, message, type) {
      var input = Store.getData(element, type);

      if (!input) {
        return;
      }

      message.forEach(function (msg) {
        console.log(msg);
        var method = msg[0],
            args = msg[1];

        if (args === null) {
          return;
        }

        input[method](args);
      });
    };

    Input.getState = function getState(element, data) {
      throw "not implemented";
    };

    Input.getRatePolicy = function getRatePolicy() {
      return null;
    };

    _createClass(Input, null, [{
      key: "VERSION",
      get: function get() {
        return VERSION;
      }
    }]);

    return Input;
  }();

  // IE 11, ensure querySelectorAll + forEach works
  var _Element$prototype = Element.prototype,
      matches = _Element$prototype.matches,
      closest = _Element$prototype.closest;

  if (!matches) {
    matches = Element.prototype.matchesSelector || Element.prototype.mozMatchesSelector || Element.prototype.msMatchesSelector || Element.prototype.oMatchesSelector || Element.prototype.webkitMatchesSelector || function (s) {
      var matches = (this.document || this.ownerDocument).querySelectorAll(s),
          i = matches.length;

      while (--i >= 0 && matches.item(i) !== this) {}

      return i > -1;
    };
  }

  if (!closest) {
    closest = function closest(s) {
      var el = this;

      do {
        if (matches.call(el, s)) return el;
        el = el.parentElement || el.parentNode;
      } while (el !== null && el.nodeType === 1);

      return null;
    };
  }

  var findClosest = function findClosest(element, selector) {
    return closest.call(element, selector);
  };

  var asArray = function asArray(x) {
    if (!x) {
      return [];
    } else if (typeof x === "object" && x.length) {
      return Array.prototype.slice.call(x);
    } else {
      return [x];
    }
  };

  var getPluginAttributes = function getPluginAttributes(element) {
    return [element.getAttribute("data-plugin"), element.getAttribute("data-action"), element.getAttribute("data-target")];
  };

  var isNode = function isNode(x) {
    return x && x.nodeType === 1;
  };

  var activateElements = function activateElements(elements) {
    if (!elements) {
      return;
    }

    if (elements.length) {
      asArray(elements).forEach(function (e) {
        return activateElements(e);
      });
    } else if (elements.classList) {
      elements.classList.add("active");
    }
  };

  var deactivateElements = function deactivateElements(elements) {
    if (!elements) {
      return;
    }

    if (elements.length) {
      asArray(elements).forEach(function (e) {
        return deactivateElements(e);
      });
    } else if (elements.classList) {
      elements.classList.remove("active");
    }
  };

  var filterElements = function filterElements(elements, values, getValue) {
    if (getValue === void 0) {
      getValue = function getValue(x) {
        return x.value;
      };
    }

    var targetValues = asArray(values).map(function (x) {
      return isNode(x) ? x : x.toString();
    });
    elements = asArray(elements);
    var elementValues = elements.map(getValue);
    var foundElements = [];

    for (var i = 0; i < targetValues.length; i++) {
      var v = targetValues[i];
      var found = elements[isNode(v) ? elements.indexOf(v) : elementValues.indexOf(v)];

      if (found === undefined) {
        continue;
      }

      foundElements.push(found);
    }

    return foundElements;
  };

  var all = function all() {
    for (var i = 0; i++; i < arguments.length) {
      if (!(i < 0 || arguments.length <= i ? undefined : arguments[i])) {
        return false;
      }
    }

    return true;
  };

  var NAME = "buttongroup";
  var TYPE = "yonder." + NAME;
  var ClassName = {
    INPUT: "yonder-button-group",
    CHILD: "btn",
    DISABLED: "disabled"
  };
  var Selector = {
    INPUT: "." + ClassName.INPUT,
    CHILD: "." + ClassName.CHILD,
    PARENT_CHILD: "." + ClassName.INPUT + " ." + ClassName.CHILD,
    PLUGIN: "[data-plugin]"
  };
  var Event = {
    CLICK: "click." + TYPE
  };

  var ButtonGroupInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(ButtonGroupInput, _Input);

    _createClass(ButtonGroupInput, null, [{
      key: "TYPE",
      get: function get() {
        return TYPE;
      }
    }]);

    function ButtonGroupInput(element) {
      var _this;

      _this = _Input.call(this, element, TYPE) || this;

      if (!element.classList.contains(ClassName.INPUT)) {
        throw new InputError("Invalid Element", "the target element is invalid");
      }

      _this._counter = 0;
      Store.setData(element, TYPE, _assertThisInitialized(_this));
      return _this;
    }

    var _proto = ButtonGroupInput.prototype;

    _proto.value = function value(x) {
      if (typeof x === "undefined") {
        return this._value;
      }

      this._value = x;

      this._callback();

      return this;
    };

    _proto.content = function content(html) {
      this._element.innerHTML = html;
    };

    _proto.disable = function disable(values) {
      var children = this._element.querySelectorAll(Selector.CHILD);

      asArray(children).forEach(function (btn) {
        if (typeof values === "undefined" || values.indexOf(btn.value) > -1) {
          btn.setAttribute(ClassName.DISABLED, "");
          btn.setAttribute("aria-disabled", "true");
        }
      });
    };

    _proto.enable = function enable(values) {
      var children = this._element.querySelectorAll(Selector.CHILD);

      asArray(children).forEach(function (btn) {
        if (typeof values === "undefined" || values.indexOf(btn.value) > -1) {
          btn.removeAttribute(ClassName.DISABLED);
          btn.setAttribute("aria-disabled", "false");
        }
      });
    };

    ButtonGroupInput.find = function find(scope) {
      return _Input.find.call(this, scope, "." + ClassName.INPUT);
    };

    ButtonGroupInput.initialize = function initialize(element) {
      _Input.initialize.call(this, element, TYPE, ButtonGroupInput);
    };

    ButtonGroupInput.getType = function getType(element) {
      return TYPE;
    };

    ButtonGroupInput.getValue = function getValue(element) {
      var input = Store.getData(element, TYPE);

      if (!input) {
        return null;
      }

      return {
        value: input.value(),
        counter: input._counter++
      };
    };

    ButtonGroupInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE);
    };

    ButtonGroupInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE);
    };

    ButtonGroupInput.receiveMessage = function receiveMessage(element, message) {
      _Input.receiveMessage.call(this, element, message, TYPE);
    };

    ButtonGroupInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, ButtonGroupInput);
    };

    return ButtonGroupInput;
  }(Input);

  $$1(document).on(Event.CLICK, Selector.PARENT_CHILD, function (event) {
    var button = event.currentTarget;
    var group = findClosest(button, Selector.INPUT);
    var input = Store.getData(group, TYPE);

    if (!input) {
      return;
    }

    input.value(button.value);
  });
  $$1(document).on(Event.CLICK, "" + Selector.PARENT_CHILD + Selector.PLUGIN, function (event) {
    var button = event.currentTarget;

    var _getPluginAttributes = getPluginAttributes(button),
        plugin = _getPluginAttributes[0],
        action = _getPluginAttributes[1],
        target = _getPluginAttributes[2];

    if (!plugin || !action || !target) {
      return;
    }

    if (plugin === "tab") {
      $$1(button).one("shown.bs.tab", function (e) {
        return button.classList.remove("active");
      });
    }

    $$1(button)[plugin](action);
  });

  if (Shiny$1) {
    Shiny$1.inputBindings.register(ButtonGroupInput.ShinyInterface(), TYPE);
  }

  var NAME$1 = "button";
  var TYPE$1 = "yonder." + NAME$1;
  var ClassName$1 = {
    INPUT: "yonder-button"
  };
  var Selector$1 = {
    INPUT: "." + ClassName$1.INPUT,
    PLUGIN: "[data-plugin]"
  };
  var Event$1 = {
    CLICK: "click." + TYPE$1
  };

  var ButtonInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(ButtonInput, _Input);

    _createClass(ButtonInput, null, [{
      key: "TYPE",
      get: function get() {
        return TYPE$1;
      }
    }]);

    function ButtonInput(element) {
      var _this;

      _this = _Input.call(this, element, TYPE$1) || this;
      _this._value = 0;
      _this._isLink = element.tagName === "A";
      Store.setData(element, TYPE$1, _assertThisInitialized(_this));
      return _this;
    }

    var _proto = ButtonInput.prototype;

    _proto.value = function value(x) {
      if (typeof x === "undefined") {
        return this._value;
      }

      this._value = x;

      this._callback();

      return this;
    };

    _proto.content = function content(html) {
      this._element.innerHTML = html;
    };

    _proto.disable = function disable(values) {
      if (this._isLink) {
        this._element.classList.add("disabled");
      } else {
        this._element.setAttribute("disabled", "");
      }
    };

    _proto.enable = function enable() {
      if (this._isLink) {
        this._element.classList.remove("disabled");
      } else {
        this._element.removeAttribute("disabled");
      }
    } // static ----
    ;

    ButtonInput.initialize = function initialize(element) {
      _Input.initialize.call(this, element, TYPE$1, ButtonInput);
    };

    ButtonInput.find = function find(scope) {
      return _Input.find.call(this, scope, Selector$1.INPUT);
    };

    ButtonInput.getValue = function getValue(element) {
      var input = Store.getData(element, TYPE$1);

      if (!input) {
        return null;
      }

      return input.value() === 0 ? null : input.value();
    };

    ButtonInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE$1);
    };

    ButtonInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE$1);
    };

    ButtonInput.receiveMessage = function receiveMessage(element, message) {
      _Input.receiveMessage.call(this, element, message, TYPE$1);
    };

    ButtonInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, ButtonInput);
    };

    return ButtonInput;
  }(Input);

  $$1(document).on(Event$1.CLICK, Selector$1.INPUT, function (event) {
    var button = findClosest(event.target, Selector$1.INPUT);
    var input = Store.getData(button, TYPE$1);

    if (!input) {
      return;
    }

    input.value(input.value() + 1);
  });
  $$1(document).on(Event$1.CLICK, "" + Selector$1.INPUT + Selector$1.PLUGIN, function (event) {
    var button = findClosest(event.target, Selector$1.INPUT);

    var _getPluginAttributes = getPluginAttributes(button),
        plugin = _getPluginAttributes[0],
        action = _getPluginAttributes[1],
        target = _getPluginAttributes[2];

    if (!(plugin && action && target)) {
      return;
    }

    if (plugin === "tab") {
      $$1(button).one("shown.bs.tab", function (e) {
        return button.classList.remove("active");
      });
    }

    $$1(button)[plugin](action);
  });

  if (Shiny$1) {
    Shiny$1.inputBindings.register(ButtonInput.ShinyInterface(), TYPE$1);
  }

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
        el.querySelector(".valid-feedback").innerHTML = "";
        el.querySelector(".invalid-feedback").innerHTML = "";
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

      chipInputBinding._items(el, value).forEach(function (item) {
        item.classList.add("selected");
      });

      var chips = el.querySelector(".chips");

      chipInputBinding._chips(el, value).forEach(function (chip) {
        chips.insertBefore(chips.removeChild(chip), chips.firstChild);
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
      $el.on("submit.yonder", function (e) {
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
    }
  });
  Shiny.inputBindings.register(formInputBinding, "yonder.formInput");

  var linkInputBinding = new Shiny.InputBinding();
  $.extend(linkInputBinding, {
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-link[id]");
    },
    initialize: function initialize(el) {
      el.value = 0;
      $(el).on("click", function (e) {
        return el.value = +el.value + 1;
      });
      actionListener(el, null, "click");
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
      actionListener(el, ".list-group-item:not(.disabled)", "click");
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

  var NAME$2 = "menu";
  var TYPE$2 = "yonder." + NAME$2;
  var ClassName$2 = {
    INPUT: "yonder-menu",
    CHILD: "dropdown-item"
  };
  var Selector$2 = {
    INPUT: "." + ClassName$2.INPUT,
    CHILD: "." + ClassName$2.CHILD,
    PARENT_CHILD: "." + ClassName$2.INPUT + " ." + ClassName$2.CHILD,
    TOGGLE: "[data-toggle='dropdown']"
  };
  var Event$2 = {
    CLICK: "click." + TYPE$2,
    CLOSE: "hide.bs.dropdown",
    CLOSED: "hidden.bs.dropdown"
  };

  var MenuInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(MenuInput, _Input);

    function MenuInput(element) {
      var _this;

      _this = _Input.call(this, element, TYPE$2) || this;
      _this._counter = 0;
      Store.setData(element, TYPE$2, _assertThisInitialized(_this));
      return _this;
    }

    var _proto = MenuInput.prototype;

    _proto.value = function value(x) {
      if (typeof x === "undefined") {
        return this._value;
      }

      this._value = x;

      this._callback();

      return this;
    };

    _proto.select = function select(values) {
      var children = this._element.querySelectorAll(Selector$2.CHILD);

      var targets = filterElements(children, values);
      deactivateElements(children);

      if (targets.length) {
        activateElements(targets[0]);
        this.value(targets[0].value);
      }
    } // static ----
    ;

    MenuInput.initialize = function initialize(element) {
      var input = Store.getData(element, TYPE$2);

      if (!input) {
        input = new MenuInput(element);
      }
    };

    MenuInput.find = function find(element) {
      return _Input.find.call(this, element, Selector$2.INPUT);
    };

    MenuInput.getType = function getType(element) {
      return TYPE$2;
    };

    MenuInput.getValue = function getValue(element) {
      var input = Store.getData(element, TYPE$2);

      if (!input) {
        return null;
      }

      return {
        value: input.value(),
        counter: input._counter++
      };
    };

    MenuInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE$2);
    };

    MenuInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE$2);
    };

    MenuInput.receiveMessage = function receiveMessage(element, message) {
      _Input.receiveMessage.call(this, element, message, TYPE$2);
    };

    MenuInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, MenuInput);
    };

    _createClass(MenuInput, null, [{
      key: "TYPE",
      get: function get() {
        return TYPE$2;
      }
    }, {
      key: "Selector",
      get: function get() {
        return Selector$2;
      }
    }, {
      key: "Event",
      get: function get() {
        return Event$2;
      }
    }]);

    return MenuInput;
  }(Input); // events ----


  $$1(document).on(Event$2.CLICK, Selector$2.PARENT_CHILD, function (event) {
    var item = findClosest(event.target, Selector$2.CHILD);

    if (!item) {
      return;
    }

    var menu = findClosest(item, Selector$2.INPUT);
    var menuInput = Store.getData(menu, TYPE$2);

    if (!menuInput) {
      return;
    }

    menuInput.select(item);
  });

  if (Shiny$1) {
    Shiny$1.inputBindings.register(MenuInput.ShinyInterface(), TYPE$2);
  }

  var NAME$3 = "nav";
  var TYPE$3 = "yonder." + NAME$3;
  var ClassName$3 = {
    INPUT: "yonder-nav",
    CHILD: "nav-link",
    ITEM: "nav-item"
  };
  var Selector$3 = {
    INPUT: "." + ClassName$3.INPUT,
    CHILD: "." + ClassName$3.CHILD,
    PARENT_CHILD: "." + ClassName$3.INPUT + " ." + ClassName$3.CHILD,
    ACTIVE: ".active",
    DISABLED: ".disabled",
    PLUGIN: "[data-plugin]",
    NAV_ITEM: "." + ClassName$3.ITEM,
    MENU_TOGGLE: MenuInput.Selector.TOGGLE,
    MENU_ITEM: MenuInput.Selector.CHILD
  };
  var Event$3 = {
    CLICK: "click." + TYPE$3
  };

  var NavInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(NavInput, _Input);

    function NavInput(element) {
      var _this;

      _this = _Input.call(this, element, TYPE$3) || this;
      Store.setData(element, TYPE$3, _assertThisInitialized(_this));
      return _this;
    }

    var _proto = NavInput.prototype;

    _proto.value = function value(x) {
      if (typeof x === "undefined") {
        return this._value;
      }

      this._value = x;

      this._callback();

      return this;
    };

    _proto.select = function select(values) {
      var children = this._element.querySelectorAll(Selector$3.CHILD);

      var targets = filterElements(children, values);
      deactivateElements(children);
      asArray(children).forEach(function (child) {
        if (targets.indexOf(child) > -1) {
          return;
        }

        var menuInput = Store.getData(child.parentNode, MenuInput.TYPE);

        if (!menuInput) {
          return;
        }

        menuInput.select(null);
      });

      if (targets.length) {
        activateElements(targets[0]);
        this.value(targets[0].value);
      }
    };

    _proto.disable = function disable(values) {};

    _proto.enable = function enable(values) {} // static ----
    ;

    NavInput.initialize = function initialize(element) {
      var input = Store.getData(element, TYPE$3);

      if (!input) {
        input = new NavInput(element);
      }
    };

    NavInput.find = function find(scope) {
      return _Input.find.call(this, scope, Selector$3.INPUT);
    };

    NavInput.getValue = function getValue(element) {
      var input = Store.getData(element, TYPE$3);

      if (!input) {
        return null;
      }

      return input.value();
    };

    NavInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE$3);
    };

    NavInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE$3);
    };

    NavInput.receiveMessage = function receiveMessage(element, message) {
      _Input.receiveMessage.call(this, element, message, TYPE$3);
    };

    NavInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, NavInput);
    };

    return NavInput;
  }(Input); // events ----


  $$1(document).on(Event$3.CLICK, Selector$3.PARENT_CHILD + ":not(" + Selector$3.MENU_TOGGLE + ")", function (event) {
    var nav = findClosest(event.target, Selector$3.INPUT);
    var navInput = Store.getData(nav, TYPE$3);

    if (!navInput) {
      return;
    }

    console.log("hmm");
    var button = findClosest(event.target, Selector$3.CHILD);
    navInput.select(button);
  });
  $$1(document).on(Event$3.CLICK, "" + Selector$3.PARENT_CHILD + Selector$3.PLUGIN, function (event) {
    var link = findClosest(event.target, Selector$3.CHILD);

    var _getPluginAttributes = getPluginAttributes(link),
        plugin = _getPluginAttributes[0],
        action = _getPluginAttributes[1],
        target = _getPluginAttributes[2];

    if (!all(plugin, action, target)) {
      return;
    }

    deactivateElements(link);
    $$1(link)[plugin](action);
  });
  $$1(document).on(Event$3.CLICK, Selector$3.INPUT + " " + Selector$3.MENU_ITEM, function (event) {
    var nav = findClosest(event.target, Selector$3.INPUT);
    var navInput = Store.getData(nav, TYPE$3);

    if (!navInput) {
      return;
    }

    var item = findClosest(event.target, Selector$3.NAV_ITEM);
    var link = item.querySelector(Selector$3.CHILD);
    navInput.select(link);
  });

  if (Shiny$1) {
    Shiny$1.inputBindings.register(NavInput.ShinyInterface(), TYPE$3);
  }
  Shiny$1.addCustomMessageHandler("yonder:pane", function (msg) {
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
        var hiddenEvent = $$1.Event("hidden.bs.tab", {
          relatedTarget: pane
        });
        var shownEvent = $$1.Event("shown.bs.tab", {
          relatedTarget: previous
        });
        $$1(previous).trigger(hiddenEvent);
        $$1(pane).trigger(shownEvent);
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
        var hiddenEvent = $$1.Event("hidden.bs.tab", {
          relatedTarget: pane
        });
        $$1(pane).trigger(hiddenEvent);
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
    initialize: function initialize(el) {
      actionListener(el, "input[type='radio']", "input");
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
        el.querySelector(".valid-feedback").innerHTML = "";
        el.querySelector(".invalid-feedback").innerHTML = "";
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
    find: function find(scope) {
      return scope.querySelectorAll(".yonder-radiobar[id]");
    },
    initialize: function initialize(el) {
      actionListener(el, "input[type='radio']", "change");
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
        var input = el.querySelector("input");
        input.classList.remove("is-valid");
        input.classList.remove("is-invalid");
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
        el.children[0].removeAattribute("disabled");
      }

      if (msg.disable) {
        el.children[0].setAttribute("disabled", "");
      }

      if (msg.valid) {
        el.querySelector(".valid-feedback").innerHTML = msg.valid;
        el.classList.remove("is-invalid");
        el.classList.add("is-valid");
      }

      if (msg.invalid) {
        el.querySelector(".invalid-feedback").innerHTML = msg.invalid;
        el.classList.remove("is-valid");
        el.classList.add("is-invalid");
      }

      if (!msg.valid && !msg.invalid) {
        el.querySelector(".valid-feedback").innerHTML = "";
        el.querySelector(".invalid-feedback").innerHTML = "";
        el.children[0].classList.remove("is-valid");
        el.children[0].classList.remove("is-invalid");
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
    $("[data-toggle=\"tooltip\"]").tooltip();
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

  var yonder = {
    ButtonGroupInput: ButtonGroupInput,
    ButtonInput: ButtonInput,
    MenuInput: MenuInput,
    NavInput: NavInput
  };

  return yonder;

})));
//# sourceMappingURL=yonder.js.map
