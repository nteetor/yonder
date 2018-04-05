let tabsInputBinding = new Shiny.InputBinding();

$.extend(tabsInputBinding, {
  Selector: {
    SELF: ".dull-tabs-input[id]",
    SELECTED: ".nav-item > .active:not(.disabled)"
  },
  Events: [
    { type: "shown.bs.tab" }
  ],
  initialize: function(el) {
    let id = el.id;
    let $tabs = $(el).find(".nav-link");
    let $panes = $(`.tab-content[data-tablist="${ id }"] > .tab-pane`);
    let active = $tabs.index(".active");

    if ($tabs.length === 0 || $panes.length === 0) {
      throw "tabs input: missing tabs or panes";
    }

    if ($tabs.length != $panes.length) {
      throw "tabs input: incorrect number of tabs for panes";
    }

    $panes.each((index, pane) => {
      let $pane = $(pane);

      $pane.attr({
        "id": `${ id }-pane-${ index }`,
        "aria-labelledby": `${ id }-tab-${ index }`
      });

      if (index == active) {
        $pane.addClass("show active");
      }
    });

    $tabs.each((index, tab) => {
      let $tab = $(tab);

      $tab.attr({
        "id": `${ id }-tab-${ index }`,
        "href": `#${ id }-pane-${ index }`,
        "aria-controls": `${ id }-pane-${ index }`
      });

      /*$tab.on("click", (e) => {
        e.preventDefault();
        $tab.tab("show");
      });*/
    });
  }
});

Shiny.inputBindings.register(tabsInputBinding, "dull.tabsInput");
