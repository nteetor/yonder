---
this: tabPane
filename: R/tabs.R
layout: page
roxygen:
  title: Tabbable content
  description: |-
    Create a set of tabs for controlling tab content. Tabs are separated from
    content and panes for flexible placement. In the examples below you can see
    how this allows tabs to be used inside [card()](/yonder/0.0.5/card().html)s. The flexibility also allows
    tabs to be added to navbars. When building tabbed content be sure to create a
    pane for each label in your tabs and link tabs to content by the `id` and
    `tabs` arguments, see below.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the tabs, to connect a set
      of tabs to content pass the same value to `tabContent` as `tabs`. Tabs do
      have a reactive value, by default the label of the active tab. To `values`
      to specify custom values.
  - name: tabs
    description: A character string specifying the id of a set of tabs.
  - name: labels
    description: A character vector specifying the labels of the tabs.
  - name: values
    description: |-
      A character vector specifying a custom value for each tab,
      defaults to `labels`.
  - name: active
    description: |-
      One of `values` specifying which tab is initially shown,
      defaults to `values[1](/yonder/0.0.5/1.html)`.`
  - name: '...'
    description: |-
      For **tabContent**, calls to `tabPane` or named arguments passed
        as HTML attributes to the parent element.

        For **tabPane**, any number of tag elements or named arguments passed as
        HTML attributes to the parent element.

        For **tabTabs**, additional named arguments passed as HTML attributes to
        the parent element.
  sections: ~
  return: ~
  family: layout
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>A card with tabbed content</h3>
  - type: source
    value: |2-

      card(
        header = tabTabs(
          id = "tabs",
          labels = c("Home", "Profile", "Contact"),
        ),
        tabContent(
          tabs = "tabs",
          tabPane(
            "Vestibulum id ligula porta felis euismod semper. Cras justo
                   odio, dapibus ac facilisis in, egestas eget quam."
          ),
          tabPane(
            "Duis mollis, est non commodo luctus, nisi erat porttitor ligula,
                   eget lacinia odio sem nec elit. Aenean eu leo quam. Pellentesque
                   ornare sem lacinia quam venenatis vestibulum."
          ),
          tabPane(
            "Donec ullamcorper nulla non metus auctor fringilla. Nullam id
                   dolor id nibh ultricies vehicula ut id elit."
          )
        )
      ) %>%
        margin(4) %>%
        width(50)
  - type: output
    value: |-
      <div class="card m-4 w-50">
        <div class="card-header">
          <ul class="yonder-tabs nav nav-tabs card-header-tabs" role="tablist" id="tabs">
            <li class="nav-item">
              <a class="nav-link active" data-tabs="tab" data-value="Home" aria-selected="true">Home</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" data-tabs="tab" data-value="Profile" aria-selected="false">Profile</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" data-tabs="tab" data-value="Contact" aria-selected="false">Contact</a>
            </li>
          </ul>
        </div>
        <div class="card-body">
          <div class="tab-content" data-tabs="tabs">
            <div class="tab-pane fade" role="tab-panel">Vestibulum id ligula porta felis euismod semper. Cras justo
                   odio, dapibus ac facilisis in, egestas eget quam.</div>
            <div class="tab-pane fade" role="tab-panel">Duis mollis, est non commodo luctus, nisi erat porttitor ligula,
                   eget lacinia odio sem nec elit. Aenean eu leo quam. Pellentesque
                   ornare sem lacinia quam venenatis vestibulum.</div>
            <div class="tab-pane fade" role="tab-panel">Donec ullamcorper nulla non metus auctor fringilla. Nullam id
                   dolor id nibh ultricies vehicula ut id elit.</div>
          </div>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Two column layout with tabs</h3>
  - type: source
    value: |2-

      row(
        column(
          default = 4,
          card(
            p("Nullam quis risus eget urna mollis ornare vel eu leo. Nullam
                  id dolor id nibh ultricies vehicula ut id elit.")
          ) %>%
            background("grey")
        ),
        column(
          tabTabs(
            id = "myTabs",
            labels = c("Home", "About", "Posts")
          ) %>%
            margin(bottom = 5),
          tabContent(
            tabs = "myTabs",
            tabPane(
              h4("This is home."),
              p("Pellentesque dapibus suscipit ligula.  Donec ",
                "posuere augue in quam.  Etiam vel tortor ",
                "sodales tellus ultricies commodo.  Suspendisse ",
                "potenti.  Aenean in sem ac leo mollis blandit."),
              p("Donec neque quam, dignissim in, mollis nec, ",
                "sagittis eu, wisi.  Phasellus lacus.  Etiam ",
                "laoreet quam sed arcu.  Phasellus at dui in ligula",
                "mollis ultricies.  Integer placerat tristique nisl.")
            ),
            tabPane(
              h4("All about."),
              p("Pellentesque dapibus suscipit ligula. ",
                "Phasellus neque orci, porta a, aliquet quis, semper a, massa. ",
                "Nullam tristique diam non turpis. ",
                "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.")
            ),
            tabPane(
              h4("Blog items."),
              p("Nullam tempus.  Mauris ac felis vel velit ",
                "tristique imperdiet.  Donec at pede.  Etiam vel ",
                "neque nec dui dignissim bibendum.  Vivamus id ",
                "enim.  Phasellus neque orci, porta a, aliquet ",
                "quis, semper a, massa.  Phasellus purus.")
            )
          )
        )
      ) %>%
        padding(3)
  - type: output
    value: "<div class=\"row p-3\">\n  <div default=\"4\" class=\"col\">\n    <div
      class=\"card bg-grey\">\n      <div class=\"card-body\">\n        <p>Nullam
      quis risus eget urna mollis ornare vel eu leo. Nullam\n            id dolor
      id nibh ultricies vehicula ut id elit.</p>\n      </div>\n    </div>\n  </div>\n
      \ <div class=\"col\">\n    <ul class=\"yonder-tabs nav nav-tabs mb-5\" role=\"tablist\"
      id=\"myTabs\">\n      <li class=\"nav-item\">\n        <a class=\"nav-link active\"
      data-tabs=\"tab\" data-value=\"Home\" aria-selected=\"true\">Home</a>\n      </li>\n
      \     <li class=\"nav-item\">\n        <a class=\"nav-link\" data-tabs=\"tab\"
      data-value=\"About\" aria-selected=\"false\">About</a>\n      </li>\n      <li
      class=\"nav-item\">\n        <a class=\"nav-link\" data-tabs=\"tab\" data-value=\"Posts\"
      aria-selected=\"false\">Posts</a>\n      </li>\n    </ul>\n    <div class=\"tab-content\"
      data-tabs=\"myTabs\">\n      <div class=\"tab-pane fade\" role=\"tab-panel\">\n
      \       <h4>This is home.</h4>\n        <p>\n          Pellentesque dapibus
      suscipit ligula.  Donec \n          posuere augue in quam.  Etiam vel tortor
      \n          sodales tellus ultricies commodo.  Suspendisse \n          potenti.
      \ Aenean in sem ac leo mollis blandit.\n        </p>\n        <p>\n          Donec
      neque quam, dignissim in, mollis nec, \n          sagittis eu, wisi.  Phasellus
      lacus.  Etiam \n          laoreet quam sed arcu.  Phasellus at dui in ligula\n
      \         mollis ultricies.  Integer placerat tristique nisl.\n        </p>\n
      \     </div>\n      <div class=\"tab-pane fade\" role=\"tab-panel\">\n        <h4>All
      about.</h4>\n        <p>\n          Pellentesque dapibus suscipit ligula. \n
      \         Phasellus neque orci, porta a, aliquet quis, semper a, massa. \n          Nullam
      tristique diam non turpis. \n          Lorem ipsum dolor sit amet, consectetuer
      adipiscing elit.\n        </p>\n      </div>\n      <div class=\"tab-pane fade\"
      role=\"tab-panel\">\n        <h4>Blog items.</h4>\n        <p>\n          Nullam
      tempus.  Mauris ac felis vel velit \n          tristique imperdiet.  Donec at
      pede.  Etiam vel \n          neque nec dui dignissim bibendum.  Vivamus id \n
      \         enim.  Phasellus neque orci, porta a, aliquet \n          quis, semper
      a, massa.  Phasellus purus.\n        </p>\n      </div>\n    </div>\n  </div>\n</div>"
---
