if (Shiny === undefined) {
  var Shiny = {
    inputBindings: {},
    bindings: {}
  };

  Shiny.inputBindings.register = function(binding, name) {
    Shiny.bindings[name] = binding;
  };

  $(function() {
    Object.keys(Shiny.bindings).forEach(function(key) {
      let binding = Shiny.bindings[key];
      let elements = binding.find(document.body);

      for (var i = 0; i < elements.length; i++) {
        binding.initialize(elements[i]);

        let events = binding.Events;
        for (var j = 0; j < events.length; j++) {
          binding.attachHandler(
            elements[i],
            events[j].type,
            events[j].selector,
            events[j].callback,
            undefined,
            false
          );
        }
      }
    });
  });
}
