(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory(require('jQuery'), require('Shiny')) :
  typeof define === 'function' && define.amd ? define(['jQuery', 'Shiny'], factory) :
  (global.yonder = factory(global.$,global.Shiny));
}(this, (function ($,Shiny) { 'use strict';

  $ = $ && $.hasOwnProperty('default') ? $['default'] : $;
  Shiny = Shiny && Shiny.hasOwnProperty('default') ? Shiny['default'] : Shiny;

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
    _createClass(Input, null, [{
      key: "VERSION",
      // getters ----
      get: function get() {
        return VERSION;
      } // methods ----

    }]);

    function Input(element, type) {
      if (typeof element === "object" && element.nodeType !== 1 && typeof element !== "string") {
        throw new InputError("Invalid Argument", "`element` must be a node or string");
      }

      if (typeof element === "string") {
        element = document.querySelector(element);

        if (!element) {
          throw new InputError("Element Not Found", "could not find element for given `element` selector");
        }
      }

      this._element = element;
      this._type = type;
      this._value = null;

      this._callback = function () {};

      Store.setData(element, type, this);
    }

    var _proto = Input.prototype;

    _proto.content = function content(html) {
      this._element.innerHTML = html;
    };

    _proto.dispose = function dispose() {
      Store.removeData(this._element, this._type);
      this._element = null;
    } // public ----
    ;

    Input.initialize = function initialize(element, type, impl) {
      var input = Store.getData(element, type);

      if (!input) {
        input = new impl(element);
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

    Input.getValue = function getValue(element, type) {
      var input = Store.getData(element, type);

      if (!input) {
        return null;
      }

      return input.value();
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

      Store.removeData(element, type);
    };

    Input.receiveMessage = function receiveMessage(element, message, type) {
      var input = Store.getData(element, type);

      if (!input) {
        return;
      }

      message.forEach(function (msg) {
        var method = msg[0],
            args = msg[1];

        if (!args) {
          input[method]();
        } else {
          input[method].apply(input, args);
        }
      });
    };

    Input.getState = function getState(element, data) {
      throw new InputError("Method Not Implemented");
    };

    Input.getRatePolicy = function getRatePolicy() {
      return null;
    };

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

  var activeElement = function activeElement(element) {
    return element.classList && element.classList.contains("active");
  };

  var disabledElement = function disabledElement(element) {
    return element.classList && element.classList.contains("disabled") && element.hasAttribute("disabled");
  };

  var activateElements = function activateElements(elements, callback) {
    if (!elements) {
      return;
    }

    if (elements.length) {
      asArray(elements).forEach(function (el) {
        return activateElements(el, callback);
      });
    } else if (elements.classList && !disabledElement(elements)) {
      elements.classList.add("active");

      if (typeof callback === "function") {
        callback(elements);
      }
    }
  };

  var deactivateElements = function deactivateElements(elements, callback) {
    if (!elements) {
      return;
    }

    if (elements.length) {
      asArray(elements).forEach(function (el) {
        return deactivateElements(el, callback);
      });
    } else if (elements.classList && !disabledElement(elements)) {
      elements.classList.remove("active");

      if (typeof callback === "function") {
        callback(elements);
      }
    }
  };

  var toggleElements = function toggleElements(elements, callback) {
    if (!elements) {
      return;
    }

    if (elements.length) {
      asArray(elements).forEach(function (e) {
        return toggleElements(e, callback);
      });
    } else if (elements.classList && !disabledElement(elements)) {
      var active = elements.classList.toggle("active");

      if (typeof callback === "function") {
        callback(elements, active);
      }
    }
  };

  var filterElements = function filterElements(elements, targets, getValue) {
    if (getValue === void 0) {
      getValue = function getValue(x) {
        return x.value;
      };
    }

    targets = asArray(targets);
    var targetValues = targets.map(function (x) {
      return isNode(x) ? getValue(x) : x.toString();
    });
    elements = asArray(elements);
    var elementValues = elements.map(getValue);
    var foundElements = [];
    var foundValues = [];

    for (var i = 0; i < targetValues.length; i++) {
      var v = targetValues[i];
      var el = elements[elementValues.indexOf(v)];

      if (el) {
        foundElements.push(el);
        foundValues.push(v);
      }
    }

    return [foundElements, foundValues];
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
      _this._counter = 0;
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
    } // static ----
    ;

    ButtonGroupInput.find = function find(scope) {
      return _Input.find.call(this, scope, Selector.INPUT);
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

  $(document).on(Event.CLICK, Selector.PARENT_CHILD, function (event) {
    var button = event.currentTarget;
    var group = findClosest(button, Selector.INPUT);
    var input = Store.getData(group, TYPE);

    if (!input) {
      return;
    }

    input.value(button.value);
  });
  $(document).on(Event.CLICK, "" + Selector.PARENT_CHILD + Selector.PLUGIN, function (event) {
    var button = event.currentTarget;

    var _getPluginAttributes = getPluginAttributes(button),
        plugin = _getPluginAttributes[0],
        action = _getPluginAttributes[1],
        target = _getPluginAttributes[2];

    if (!plugin || !action || !target) {
      return;
    }

    if (plugin === "tab") {
      $(button).one("shown.bs.tab", function (e) {
        return button.classList.remove("active");
      });
    }

    $(button)[plugin](action);
  });

  if (Shiny) {
    Shiny.inputBindings.register(ButtonGroupInput.ShinyInterface(), TYPE);
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
      // fields ----
      get: function get() {
        return TYPE$1;
      } // methods ----

    }]);

    function ButtonInput(element) {
      var _this;

      _this = _Input.call(this, element, TYPE$1) || this;
      _this._value = 0;
      _this._isLink = element.tagName === "A";
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
  }(Input); // events ----


  $(document).on(Event$1.CLICK, Selector$1.INPUT, function (event) {
    var button = findClosest(event.target, Selector$1.INPUT);
    var input = Store.getData(button, TYPE$1);

    if (!input) {
      return;
    }

    input.value(input.value() + 1);
  });
  $(document).on(Event$1.CLICK, "" + Selector$1.INPUT + Selector$1.PLUGIN, function (event) {
    var button = findClosest(event.target, Selector$1.INPUT);

    var _getPluginAttributes = getPluginAttributes(button),
        plugin = _getPluginAttributes[0],
        action = _getPluginAttributes[1],
        target = _getPluginAttributes[2];

    if (!(plugin && action && target)) {
      return;
    }

    if (plugin === "tab") {
      $(button).one("shown.bs.tab", function (e) {
        return button.classList.remove("active");
      });
    }

    $(button)[plugin](action);
  });

  if (Shiny) {
    Shiny.inputBindings.register(ButtonInput.ShinyInterface(), TYPE$1);
  }

  var TYPE$2 = "yonder." + TYPE$2;
  var ClassName$2 = {
    INPUT: "yonder-checkbar",
    CHILD: "btn"
  };
  var Selector$2 = {
    INPUT: "." + ClassName$2.INPUT,
    CHILD: "." + ClassName$2.CHILD,
    PARENT_CHILD: "." + ClassName$2.INPUT + " ." + ClassName$2.CHILD
  };
  var Event$2 = {
    CHANGE: "change." + TYPE$2
  };

  var CheckbarInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(CheckbarInput, _Input);

    // methods ----
    function CheckbarInput(element) {
      return _Input.call(this, element, TYPE$2) || this;
    }

    var _proto = CheckbarInput.prototype;

    _proto.value = function value(x) {
      if (typeof x === "undefined") {
        return this._value;
      }

      this._value = x;

      this._callback();

      return this;
    };

    _proto.select = function select(x) {
      var children = this._element.querySelectorAll(Selector$2.CHILD);

      var _filterElements = filterElements(children, x, function (child) {
        return child.children[0].value;
      }),
          targets = _filterElements[0],
          values = _filterElements[1];

      deactivateElements(targets, function (target) {
        target.children[0].checked = false;
      });

      if (targets.length) {
        activateElements(targets, function (target) {
          target.children[0].checked = true;
        });
        this.value(values);
      }
    };

    _proto.toggle = function toggle(x) {
      var children = this._element.querySelectorAll(Selector$2.CHILD);

      var _filterElements2 = filterElements(children, x, function (child) {
        return child.children[0].value;
      }),
          targets = _filterElements2[0];

      if (targets.length) {
        toggleElements(targets, function (target, active) {
          target.children[0].checked = active;
        });
        var remaining = asArray(children).filter(activeElement).map(function (child) {
          return child.children[0].value;
        });
        this.value(remaining);
      }
    } // static
    ;

    CheckbarInput.find = function find(scope) {
      return _Input.find.call(this, scope, Selector$2.INPUT);
    };

    CheckbarInput.initialize = function initialize(element) {
      _Input.initialize.call(this, element, TYPE$2, CheckbarInput);
    };

    CheckbarInput.getValue = function getValue(element) {
      return _Input.getValue.call(this, element, TYPE$2);
    };

    CheckbarInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE$2);
    };

    CheckbarInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE$2);
    };

    CheckbarInput.receiveMessage = function receiveMessage(element, message) {
      _Input.receiveMessage.call(this, element, message, TYPE$2);
    };

    CheckbarInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, CheckbarInput);
    };

    return CheckbarInput;
  }(Input); // events ----


  $(document).on(Event$2.CHANGE, Selector$2.PARENT_CHILD, function (event) {
    var checkbar = findClosest(event.target, Selector$2.INPUT);
    var checkbarInput = Store.getData(checkbar, TYPE$2);

    if (!checkbarInput) {
      return;
    }

    var button = findClosest(event.target, Selector$2.CHILD);
    checkbarInput.toggle(button);
  });

  if (Shiny) {
    Shiny.inputBindings.register(CheckbarInput.ShinyInterface(), TYPE$2);
  }

  var NAME$3 = "checkbox";
  var TYPE$3 = "yonder." + NAME$3;
  var ClassName$3 = {
    INPUT: "yonder-checkbox",
    CHILD: "custom-checkbox"
  };
  var Selector$3 = {
    INPUT: "." + ClassName$3.INPUT,
    CHILD: "." + ClassName$3.CHILD,
    INPUT_CHILD: "." + ClassName$3.INPUT + " ." + ClassName$3.CHILD
  };
  var Event$3 = {
    CHANGE: "change." + TYPE$3
  };

  var CheckboxInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(CheckboxInput, _Input);

    // methods ----
    function CheckboxInput(element) {
      return _Input.call(this, element, TYPE$3) || this;
    }

    var _proto = CheckboxInput.prototype;

    _proto.value = function value(x) {
      if (typeof x === "undefined") {
        return this._value;
      }

      this._value = x;

      this._callback();

      return this;
    };

    _proto.select = function select(x) {
      var children = this._element.querySelectorAll(Selector$3.CHILD);

      var _filterElements = filterElements(children, x, function (child) {
        return child.children[0].value;
      }),
          targets = _filterElements[0],
          values = _filterElements[1];

      deactivateElements(children, function (child) {
        child.children[0].checked = false;
      });

      if (targets.length) {
        activateElements(targets, function (target) {
          target.children[0].checked = true;
        });
        this.value(values);
      }
    };

    _proto.toggle = function toggle(x) {
      var children = this._element.querySelectorAll(Selector$3.CHILD);

      var _filterElements2 = filterElements(children, x, function (child) {
        return child.children[0].value;
      }),
          targets = _filterElements2[0];

      if (targets.length) {
        toggleElements(targets, function (target, active) {
          target.children[0].checked = active;
        });
        var remaining = asArray(children).filter(activeElement).map(function (child) {
          return child.children[0].value;
        });
        this.value(remaining);
      }
    } // static
    ;

    CheckboxInput.find = function find(scope) {
      return _Input.find.call(this, scope, Selector$3.INPUT);
    };

    CheckboxInput.initialize = function initialize(element) {
      _Input.initialize.call(this, element, TYPE$3, CheckboxInput);
    };

    CheckboxInput.getValue = function getValue(element) {
      return _Input.getValue.call(this, element, TYPE$3);
    };

    CheckboxInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE$3);
    };

    CheckboxInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE$3);
    };

    CheckboxInput.receiveMessage = function receiveMessage(element, message) {
      _Input.receiveMessage.call(this, element, message, TYPE$3);
    };

    CheckboxInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, CheckboxInput);
    };

    return CheckboxInput;
  }(Input); // events ----


  $(document).on(Event$3.CHANGE, Selector$3.INPUT_CHILD, function (event) {
    var checkbox = findClosest(event.target, Selector$3.INPUT);
    var checkboxInput = Store.getData(checkbox, TYPE$3);

    if (!checkboxInput) {
      return;
    }

    var box = findClosest(event.target, Selector$3.CHILD);
    checkboxInput.toggle(box);
  });

  if (Shiny) {
    Shiny.inputBindings.register(CheckboxInput.ShinyInterface(), TYPE$3);
  }

  var NAME$4 = "file";
  var TYPE$4 = "yonder." + NAME$4;
  var ClassName$4 = {
    INPUT: "yonder-file",
    PROGRESS: "progress",
    PROGRESS_BAR: "progress-bar",
    PROGRESS_STRIPED: "progress-bar-striped",
    PROGRESS_ANIMATED: "progress-bar-animated"
  };
  var Selector$4 = {
    INPUT: "." + ClassName$4.INPUT,
    PROGRESS: "." + ClassName$4.PROGRESS,
    PROGRESS_BAR: "." + ClassName$4.PROGRESS + " ." + ClassName$4.PROGRESS_BAR
  };
  var Event$4 = {
    DRAGENTER: "dragenter." + TYPE$4,
    DRAGOVER: "dragover." + TYPE$4,
    DROP: "drop." + TYPE$4,
    CHANGE: "change." + TYPE$4
  };

  var FileInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(FileInput, _Input);

    // methods ----
    function FileInput(element) {
      return _Input.call(this, element, TYPE$4) || this;
    }

    var _proto = FileInput.prototype;

    _proto.value = function value() {
      return null;
    };

    _proto.upload = function upload() {
      var _this = this;

      var files = asArray(this._element.children[0].files);

      if (!files.length) {
        return;
      }

      var fileInfo = files.map(function (file) {
        var name = file.name,
            size = file.size,
            type = file.type;
        return {
          name: name,
          size: size,
          type: type
        };
      });

      var progress = this._element.querySelector(Selector$4.PROGRESS);

      files.forEach(function (file) {
        var bar = document.createElement("div");
        bar.classList.add(ClassName$4.PROGRESS_BAR);
        bar.classList.add(ClassName$4.PROGRESS_STRIPED);
        bar.innerText = file.name;
        progress.appendChild(bar);
      });
      Shiny.shinyapp.makeRequest("uploadInit", [fileInfo], function (res) {
        var completed = 0;

        var _loop = function _loop(i) {
          var file = files[i];
          var bar = progress.children[i];
          var req = new XMLHttpRequest();
          req.addEventListener("loadstart", function (event) {
            bar.classList.add(ClassName$4.PROGRESS_ANIMATED);
          });
          req.upload.addEventListener("progress", function (event) {
            bar.style.width = Math.floor(event.loaded / event.total * 100 / files.length) + "%";
          });
          req.addEventListener("loadend", function (event) {
            bar.style.width = Math.floor(100 / files.length) + "%";
            bar.classList.remove(ClassName$4.PROGRESS_ANIMATED);
            completed++;

            if (completed === files.length) {
              req.addEventListener("loadend", function (event) {
                Shiny.shinyapp.makeRequest("uploadEnd", [res.jobId, _this._element.id]);
              });
            }
          });
          req.open("POST", res.uploadUrl, true);
          req.setRequestHeader("Content-Type", "application/octet-stream");
          req.send(file);
        };

        for (var i = 0; i < files.length; i++) {
          _loop(i);
        }
      });
    } // static ----
    ;

    FileInput.initialize = function initialize(element) {
      _Input.initialize.call(this, element, TYPE$4, FileInput);
    };

    FileInput.find = function find(scope) {
      return _Input.find.call(this, scope, Selector$4.INPUT);
    };

    FileInput.getValue = function getValue(element) {
      return _Input.getValue.call(this, element, TYPE$4);
    };

    FileInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE$4);
    };

    FileInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE$4);
    };

    FileInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, FileInput);
    };

    return FileInput;
  }(Input); // events ----


  $(document).on(Event$4.DRAGENTER, Selector$4.INPUT, function (event) {
    event.stopPropagation();
    event.preventDefault();
  });
  $(document).on(Event$4.DRAGOVER, Selector$4.INPUT, function (event) {
    event.stopPropagation();
    event.preventDefault();
  });
  $(document).on(Event$4.DROP, Selector$4.INPUT, function (event) {
    event.stopPropagation();
    event.preventDefault();
    var el = findClosest(event.target, Selector$4.INPUT);
    var fileInput = Store.getData(el, TYPE$4);

    if (!fileInput) {
      return;
    }

    el.children[0].files = event.originalEvent.dataTransfer.files;
    fileInput.upload();
  });
  $(document).on(Event$4.CHANGE, Selector$4.INPUT, function (event) {
    var el = findClosest(event.target, Selector$4.INPUT);
    var fileInput = Store.getData(el, TYPE$4);

    if (!fileInput) {
      return;
    }

    fileInput.upload();
  });

  if (Shiny) {
    Shiny.inputBindings.register(FileInput.ShinyInterface(), TYPE$4);
  }

  var NAME$5 = "form";
  var TYPE$5 = "yonder." + NAME$5;
  var ClassName$5 = {
    INPUT: "yonder-form",
    CHILD: "shiny-bound-input",
    SUBMIT: "yonder-form-submit"
  };
  var Selector$5 = {
    INPUT: "." + ClassName$5.INPUT,
    CHILD: "." + ClassName$5.CHILD,
    INPUT_CHILD: "." + ClassName$5.INPUT + " ." + ClassName$5.CHILD,
    SUBMIT: "." + ClassName$5.SUBMIT
  };
  var Event$5 = {
    CLICK: "click." + TYPE$5,
    CHANGE: "shiny:inputchanged." + TYPE$5,
    BOUND: "shiny:bound." + TYPE$5,
    UNBOUND: "shiny:unbound." + TYPE$5
  };

  var FormInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(FormInput, _Input);

    // methods ----
    function FormInput(element) {
      var _this;

      _this = _Input.call(this, element, TYPE$5, FormInput) || this;
      _this._map = {};
      _this._counter = 0;
      return _this;
    }

    var _proto = FormInput.prototype;

    _proto.value = function value(x) {
      if (typeof x === "undefined") {
        return {
          value: this._value,
          counter: this._counter
        };
      }

      this._value = x;
      this._counter++;

      this._callback();

      return this;
    };

    _proto.put = function put(key, value) {
      this._map[key] = value;
      return this;
    };

    _proto.delete = function _delete(key) {
      var value = this._map[key];
      delete this._map[key];
      return value;
    };

    _proto.fields = function fields() {
      return Object.keys(this._map);
    };

    _proto.entries = function entries() {
      var _this2 = this;

      return this.fields().map(function (key) {
        return [key, _this2._map[key]];
      });
    } // static ----
    ;

    FormInput.find = function find(scope) {
      return _Input.find.call(this, scope, Selector$5.INPUT);
    };

    FormInput.initialize = function initialize(element) {
      _Input.initialize.call(this, element, TYPE$5, FormInput);
    };

    FormInput.getType = function getType(element) {
      return TYPE$5;
    };

    FormInput.getValue = function getValue(element) {
      return _Input.getValue.call(this, element, TYPE$5);
    };

    FormInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE$5);
    };

    FormInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE$5);
    };

    FormInput.receiveMessage = function receiveMessage(element, message) {
      _Input.receiveMessage.call(this, element, message, TYPE$5);
    };

    FormInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, FormInput);
    };

    return FormInput;
  }(Input); // events ----


  $(document).on(Event$5.CLICK, Selector$5.SUBMIT, function (event) {
    var submitButton = findClosest(event.target, Selector$5.SUBMIT);
    var form = findClosest(submitButton, Selector$5.INPUT);

    if (!form) {
      return;
    }

    var formInput = Store.getData(form, TYPE$5);

    if (!formInput) {
      return;
    }

    formInput.value(submitButton.value);

    if (Shiny) {
      formInput.entries().forEach(function (_ref) {
        var key = _ref[0],
            value = _ref[1];
        Shiny.setInputValue(key, value, {
          priority: "event"
        });
      });
    }
  });
  $(document).on(Event$5.BOUND, Selector$5.INPUT_CHILD, function (event) {
    var child = event.target;
    var form = findClosest(child, Selector$5.INPUT);
    var formInput = Store.getData(form, TYPE$5);

    if (!formInput) {
      return;
    }

    var type = event.binding.getType();
    var id = type ? child.id + ":" + type : child.id;
    formInput.put(id, null);
  });
  $(document).on(Event$5.UNBOUND, Selector$5.INPUT_CHILD, function (event) {
    var child = event.target;
    var form = findClosest(child, Selector$5.INPUT);
    var formInput = Store.getData(form, TYPE$5);

    if (!formInput) {
      return;
    }

    var type = event.binding.getType();
    var id = type ? child.id + ":" + type : child.id;
    formInput.delete(id);
  });
  $(document).on(Event$5.CHANGE, Selector$5.INPUT_CHILD, function (event) {
    if (event.priority && event.priority === "event") {
      return;
    }

    var child = findClosest(event.target, Selector$5.CHILD);
    var form = findClosest(child, Selector$5.INPUT);
    var formInput = Store.getData(form, TYPE$5);

    if (!formInput) {
      return;
    }

    var type = event.binding.getType();
    var id = type ? child.id + ":" + type : child.id;
    formInput.put(id, event.value);
    event.preventDefault();
  });

  if (Shiny) {
    Shiny.inputBindings.register(FormInput.ShinyInterface(), TYPE$5);
  }

  var NAME$6 = "link";
  var TYPE$6 = "yonder." + NAME$6;
  var ClassName$6 = {
    INPUT: "yonder-link"
  };
  var Selector$6 = {
    INPUT: "." + ClassName$6.INPUT,
    PLUGIN: "[data-plugin]"
  };
  var Event$6 = {
    CLICK: "click." + TYPE$6
  };

  var LinkInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(LinkInput, _Input);

    _createClass(LinkInput, null, [{
      key: "TYPE",
      // fields ----
      get: function get() {
        return TYPE$6;
      } // methods ----

    }]);

    function LinkInput(element) {
      var _this;

      _this = _Input.call(this, element, TYPE$6) || this;
      _this._value = 0;
      return _this;
    }

    var _proto = LinkInput.prototype;

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
      this._element.setAttribute("disabled", "");
    };

    _proto.enable = function enable() {
      this._element.removeAttribute("disabled");
    } // static ----
    ;

    LinkInput.initialize = function initialize(element) {
      _Input.initialize.call(this, element, TYPE$6, LinkInput);
    };

    LinkInput.find = function find(scope) {
      return _Input.find.call(this, scope, Selector$6.INPUT);
    };

    LinkInput.getValue = function getValue(element) {
      var input = Store.getData(element, TYPE$6);

      if (!input) {
        return null;
      }

      return input.value() === 0 ? null : input.value();
    };

    LinkInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE$6);
    };

    LinkInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE$6);
    };

    LinkInput.receiveMessage = function receiveMessage(element, message) {
      _Input.receiveMessage.call(this, element, message, TYPE$6);
    };

    LinkInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, LinkInput);
    };

    return LinkInput;
  }(Input); // events ----


  $(document).on(Event$6.CLICK, Selector$6.INPUT, function (event) {
    var link = findClosest(event.target, Selector$6.INPUT);
    var linkInput = Store.getData(link, TYPE$6);

    if (!linkInput) {
      return;
    }

    linkInput.value(linkInput.value() + 1);
  });
  $(document).on(Event$6.CLICK, "" + Selector$6.INPUT + Selector$6.PLUGIN, function (event) {
    var link = findClosest(event.target, Selector$6.INPUT);

    var _getPluginAttributes = getPluginAttributes(link),
        plugin = _getPluginAttributes[0],
        action = _getPluginAttributes[1],
        target = _getPluginAttributes[2];

    if (!(plugin && action && target)) {
      return;
    }

    if (plugin === "tab") {
      $(link).one("shown.bs.tab", function (e) {
        return link.classList.remove("active");
      });
    }

    $(link)[plugin](action);
  });

  if (Shiny) {
    Shiny.inputBindings.register(LinkInput.ShinyInterface(), TYPE$6);
  }

  var NAME$7 = "listgroup";
  var TYPE$7 = "yonder." + NAME$7;
  var ClassName$7 = {
    INPUT: "yonder-list-group",
    CHILD: "list-group-item-action"
  };
  var Selector$7 = {
    INPUT: "." + ClassName$7.INPUT,
    CHILD: "." + ClassName$7.CHILD,
    INPUT_CHILD: "." + ClassName$7.INPUT + " ." + ClassName$7.CHILD,
    PLUGIN: "[data-plugin]"
  };
  var Event$7 = {
    CLICK: "click." + TYPE$7
  };

  var ListGroupInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(ListGroupInput, _Input);

    // methods ----
    function ListGroupInput(element) {
      return _Input.call(this, element, TYPE$7) || this;
    }

    var _proto = ListGroupInput.prototype;

    _proto.value = function value(x) {
      if (typeof x === "undefined") {
        return this._value;
      }

      this._value = x;

      this._callback();

      return this;
    };

    _proto.select = function select(x) {
      var children = this._element.querySelectorAll(Selector$7.CHILD);

      var _filterElements = filterElements(children, x),
          targets = _filterElements[0],
          values = _filterElements[1];

      deactivateElements(children);

      if (targets.length) {
        activateElements(targets[0]);
        this.value(values[0]);
      }

      return targets;
    } // static ----
    ;

    ListGroupInput.initialize = function initialize(element) {
      _Input.initialize.call(this, element, TYPE$7, ListGroupInput);
    };

    ListGroupInput.find = function find(scope) {
      return _Input.find.call(this, scope, Selector$7.INPUT);
    };

    ListGroupInput.getValue = function getValue(element) {
      return _Input.getValue.call(this, element, TYPE$7);
    };

    ListGroupInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE$7);
    };

    ListGroupInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE$7);
    };

    ListGroupInput.receiveMessage = function receiveMessage(element, message) {
      _Input.receiveMessage.call(this, element, message, TYPE$7);
    };

    ListGroupInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, ListGroupInput);
    };

    return ListGroupInput;
  }(Input); // events ----


  $(document).on(Event$7.CLICK, "" + Selector$7.INPUT_CHILD + Selector$7.PLUGIN, function (event) {
    var listItem = findClosest(event.target, Selector$7.CHILD);

    var _getPluginAttributes = getPluginAttributes(listItem),
        plugin = _getPluginAttributes[0],
        action = _getPluginAttributes[1],
        target = _getPluginAttributes[2];

    if (!all(plugin, action, target)) {
      return;
    }

    $(listItem)[plugin](action);
  });
  $(document).on(Event$7.CLICK, Selector$7.INPUT_CHILD, function (event) {
    var listGroup = findClosest(event.target, Selector$7.INPUT);
    var listGroupInput = Store.getData(listGroup, TYPE$7);

    if (!listGroupInput) {
      return;
    }

    var listItem = findClosest(event.target, Selector$7.CHILD);
    listGroupInput.select(listItem);
  });

  if (Shiny) {
    Shiny.inputBindings.register(ListGroupInput.ShinyInterface(), TYPE$7);
  }

  var NAME$8 = "menu";
  var TYPE$8 = "yonder." + NAME$8;
  var ClassName$8 = {
    INPUT: "yonder-menu",
    CHILD: "dropdown-item"
  };
  var Selector$8 = {
    INPUT: "." + ClassName$8.INPUT,
    CHILD: "." + ClassName$8.CHILD,
    PARENT_CHILD: "." + ClassName$8.INPUT + " ." + ClassName$8.CHILD,
    TOGGLE: "[data-toggle='dropdown']"
  };
  var Event$8 = {
    CLICK: "click." + TYPE$8,
    CLOSE: "hide.bs.dropdown",
    CLOSED: "hidden.bs.dropdown"
  };

  var MenuInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(MenuInput, _Input);

    _createClass(MenuInput, null, [{
      key: "TYPE",
      // fields ----
      get: function get() {
        return TYPE$8;
      }
    }, {
      key: "Selector",
      get: function get() {
        return Selector$8;
      }
    }, {
      key: "Event",
      get: function get() {
        return Event$8;
      } // methods ----

    }]);

    function MenuInput(element) {
      var _this;

      _this = _Input.call(this, element, TYPE$8) || this;
      _this._counter = 0;
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

    _proto.select = function select(x) {
      var children = this._element.querySelectorAll(Selector$8.CHILD);

      var _filterElements = filterElements(children, x),
          targets = _filterElements[0],
          values = _filterElements[1];

      deactivateElements(children);

      if (targets.length) {
        activateElements(targets[0]);
        this.value(values[0]);
      }
    } // static ----
    ;

    MenuInput.initialize = function initialize(element) {
      _Input.initialize.call(this, element, TYPE$8, MenuInput);
    };

    MenuInput.find = function find(element) {
      return _Input.find.call(this, element, Selector$8.INPUT);
    };

    MenuInput.getType = function getType(element) {
      return TYPE$8;
    };

    MenuInput.getValue = function getValue(element) {
      var input = Store.getData(element, TYPE$8);

      if (!input) {
        return null;
      }

      return {
        value: input.value(),
        counter: input._counter++
      };
    };

    MenuInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE$8);
    };

    MenuInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE$8);
    };

    MenuInput.receiveMessage = function receiveMessage(element, message) {
      _Input.receiveMessage.call(this, element, message, TYPE$8);
    };

    MenuInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, MenuInput);
    };

    return MenuInput;
  }(Input); // events ----


  $(document).on(Event$8.CLICK, Selector$8.PARENT_CHILD, function (event) {
    var item = findClosest(event.target, Selector$8.CHILD);

    if (!item) {
      return;
    }

    var menu = findClosest(item, Selector$8.INPUT);
    var menuInput = Store.getData(menu, TYPE$8);

    if (!menuInput) {
      return;
    }

    menuInput.select(item);
  });

  if (Shiny) {
    Shiny.inputBindings.register(MenuInput.ShinyInterface(), TYPE$8);
  }

  var NAME$9 = "nav";
  var TYPE$9 = "yonder." + NAME$9;
  var ClassName$9 = {
    INPUT: "yonder-nav",
    CHILD: "nav-link",
    ITEM: "nav-item"
  };
  var Selector$9 = {
    INPUT: "." + ClassName$9.INPUT,
    CHILD: "." + ClassName$9.CHILD,
    PARENT_CHILD: "." + ClassName$9.INPUT + " ." + ClassName$9.CHILD,
    ACTIVE: ".active",
    DISABLED: ".disabled",
    PLUGIN: "[data-plugin]",
    NAV_ITEM: "." + ClassName$9.ITEM,
    MENU: MenuInput.Selector.INPUT,
    MENU_TOGGLE: MenuInput.Selector.TOGGLE,
    MENU_ITEM: MenuInput.Selector.CHILD
  };
  var Event$9 = {
    CLICK: "click." + TYPE$9
  };

  var NavInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(NavInput, _Input);

    function NavInput(element) {
      return _Input.call(this, element, TYPE$9) || this;
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

    _proto.select = function select(x) {
      var children = this._element.querySelectorAll(Selector$9.CHILD);

      var _filterElements = filterElements(children, x),
          targets = _filterElements[0],
          values = _filterElements[1];

      deactivateElements(children, function (child) {
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
        this.value(values[0]);
      }
    };

    _proto.disable = function disable(values) {};

    _proto.enable = function enable(values) {} // static ----
    ;

    NavInput.initialize = function initialize(element) {
      _Input.initialize.call(this, element, TYPE$9, NavInput);
    };

    NavInput.find = function find(scope) {
      return _Input.find.call(this, scope, Selector$9.INPUT);
    };

    NavInput.getValue = function getValue(element) {
      return _Input.getValue.call(this, element, TYPE$9);
    };

    NavInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE$9);
    };

    NavInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE$9);
    };

    NavInput.receiveMessage = function receiveMessage(element, message) {
      _Input.receiveMessage.call(this, element, message, TYPE$9);
    };

    NavInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, NavInput);
    };

    return NavInput;
  }(Input); // events ----


  $(document).on(Event$9.CLICK, Selector$9.PARENT_CHILD + ":not(" + Selector$9.MENU_TOGGLE + ")", function (event) {
    var nav = findClosest(event.target, Selector$9.INPUT);
    var navInput = Store.getData(nav, TYPE$9);

    if (!navInput) {
      return;
    }

    var button = findClosest(event.target, Selector$9.CHILD);
    navInput.select(button);
  });
  $(document).on(Event$9.CLICK, "" + Selector$9.PARENT_CHILD + Selector$9.PLUGIN, function (event) {
    var link = findClosest(event.target, Selector$9.CHILD);

    var _getPluginAttributes = getPluginAttributes(link),
        plugin = _getPluginAttributes[0],
        action = _getPluginAttributes[1],
        target = _getPluginAttributes[2];

    if (!all(plugin, action, target)) {
      return;
    } // ensure we can select or activate a nav link that may already be active


    deactivateElements(link);
    $(link)[plugin](action);
  });
  $(document).on(Event$9.CLICK, Selector$9.INPUT + " " + Selector$9.MENU_ITEM, function (event) {
    var nav = findClosest(event.target, Selector$9.INPUT);
    var navInput = Store.getData(nav, TYPE$9);

    if (!navInput) {
      return;
    }

    var item = findClosest(event.target, Selector$9.NAV_ITEM);
    var link = item.querySelector(Selector$9.CHILD);
    navInput.select(link);
    var menu = findClosest(event.target, Selector$9.MENU);

    if (!menu.id) {
      var menuItem = findClosest(event.target, Selector$9.MENU_ITEM);
      navInput.value(menuItem.value);
    }
  }); // shiny ----
  // If shiny is present register the input's shiny interface with shiny's
  // input bindings.

  if (Shiny) {
    Shiny.inputBindings.register(NavInput.ShinyInterface(), TYPE$9);
  }

  if (Shiny) {
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
  }

  var NAME$a = "radio";
  var TYPE$a = "yonder." + NAME$a;
  var ClassName$a = {
    INPUT: "yonder-radio",
    CHILD: "custom-radio"
  };
  var Selector$a = {
    INPUT: "." + ClassName$a.INPUT,
    CHILD: "." + ClassName$a.CHILD,
    INPUT_CHILD: "." + ClassName$a.INPUT + " ." + ClassName$a.CHILD,
    PLUGIN: "[data-plugin]"
  };
  var Event$a = {
    CHANGE: "change." + TYPE$a
  };

  var RadioInput =
  /*#__PURE__*/
  function (_Input) {
    _inheritsLoose(RadioInput, _Input);

    // methods ----
    function RadioInput(element) {
      return _Input.call(this, element, TYPE$a) || this;
    }

    var _proto = RadioInput.prototype;

    _proto.value = function value(x) {
      if (typeof x === "undefined") {
        return this._value;
      }

      this._value = x;

      this._callback();

      return this;
    };

    _proto.select = function select(x) {
      var children = this._element.querySelectorAll(Selector$a.CHILD);

      var _filterElements = filterElements(children, x),
          targets = _filterElements[0],
          values = _filterElements[1];

      deactivateElements(children, function (child) {
        child.children[0].checked = false;
      });

      if (targets.length) {
        activateElements(targets[0], function (target) {
          target.children[0].checked = true;
        });
        this.value(values[0]);
      }
    } // static ----
    ;

    RadioInput.initialize = function initialize(element) {
      _Input.initialize.call(this, element, TYPE$a, RadioInput);
    };

    RadioInput.find = function find(scope) {
      return _Input.find.call(this, scope, Selector$a.INPUT);
    };

    RadioInput.getValue = function getValue(element) {
      return _Input.getValue.call(this, element, TYPE$a);
    };

    RadioInput.subscribe = function subscribe(element, callback) {
      _Input.subscribe.call(this, element, callback, TYPE$a);
    };

    RadioInput.unsubscribe = function unsubscribe(element) {
      _Input.unsubscribe.call(this, element, TYPE$a);
    };

    RadioInput.receiveMessage = function receiveMessage(element, message) {
      _Input.receiveMessage.call(this, element, message, TYPE$a);
    };

    RadioInput.ShinyInterface = function ShinyInterface() {
      return _objectSpread2({}, Input, {}, RadioInput);
    };

    return RadioInput;
  }(Input); // events ----


  $(document).on(Event$a.CHANGE, Selector$a.INPUT_CHILD, function (event) {
    var radio = findClosest(event.target, Selector$a.INPUT);
    var radioInput = Store.getData(radio, TYPE$a);

    if (!radioInput) {
      return;
    }

    var input = findClosest(event.target, Selector$a.CHILD);
    radioInput.value(input.value);
  });
  $(document).on(Event$a.CHANGE, "" + Selector$a.INPUT_CHILD + Selector$a.PLUGIN, function (event) {
    var input = findClosest(event.target, Selector$a.CHILD);

    var _getPluginAttributes = getPluginAttributes(input),
        plugin = _getPluginAttributes[0],
        action = _getPluginAttributes[1],
        target = _getPluginAttributes[2];

    if (!all(plugin, action, target)) {
      return;
    }

    $(input)[plugin](action);
  }); // shiny ----
  // If shiny is present register the radio input shiny interface with the input
  // bindings.

  if (Shiny) {
    Shiny.inputBindings.register(RadioInput.ShinyInterface(), TYPE$a);
  }

  // import "./input-binding-range.js";
  // import "./input-binding-select.js";
  // import "./input-binding-textual.js";
  // import "./collapse.js";
  // import "./download.js";
  // import "./content.js";
  // import "./modal.js";
  // import "./popover.js";
  // import "./tooltip.js";
  // import "./toast.js";

  var index = {
    ButtonGroupInput: ButtonGroupInput,
    ButtonInput: ButtonInput,
    CheckbarInput: CheckbarInput,
    CheckboxInput: CheckboxInput,
    FileInput: FileInput,
    FormInput: FormInput,
    LinkInput: LinkInput,
    ListGroupInput: ListGroupInput,
    MenuInput: MenuInput,
    NavInput: NavInput,
    RadioInput: RadioInput
  };

  return index;

})));
//# sourceMappingURL=yonder.js.map
