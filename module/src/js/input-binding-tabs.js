export let tabsInputBinding = new Shiny.InputBinding();

$.extend(tabsInputBinding, {
  Selector: {
    SELF: ".yonder-tabs[id]",
    SELECTED: ".nav-item > .active:not(.disabled)"
  },
  Events: [
    { type: "shown.bs.tab" }
  ],
  initialize: function(el) {
    let id = el.id;
    let $tabs = $(el).find(".nav-link");
    let $panes = $(`.tab-content[data-tabs="${ id }"] > .tab-pane`);
    let active = $tabs.map((i, e) => e.classList.contains("active")).get().indexOf(true);

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

      $pane.removeAttr("data-tabs");

      if (index === active) {
        $pane.addClass("show active");
      }
    });

    $tabs.each((index, tab) => {
      let $tab = $(tab);

      $tab.attr({
        "id": `${ id }-tab-${ index }`,
        "data-toggle": "tab",
        "href": `#${ id }-pane-${ index }`,
        "aria-controls": `${ id }-pane-${ index }`
      });
    });
  }
});
