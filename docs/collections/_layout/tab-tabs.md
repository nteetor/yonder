---
layout: page
slug: tab-tabs
roxygen:
  rdname: ~
  name: tabTabs
  doctype: ~
  title: Tabbable content
  description: |-
    Create a set of tabs for controlling tab content. Tabs are separated from
    content and panes for flexible placement. In the examples below you can see
    how this allows tabs to be used inside [card()]s. The flexibility also allows
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
      defaults to `values[1]`.`
  - name: '...'
    description: |-
      For **tabContent**, calls to `tabPane` or named arguments passed
        as HTML attributes to the parent element.

        For **tabPane**, any number of tag elements or named arguments passed as
        HTML attributes to the parent element.

        For **tabTabs**, additional named arguments passed as HTML attributes to
        the parent element.
  sections: ~
  examples:
  - |-
    tabTabs(
      id = "myTabs",
      labels = c("Home", "About", "Posts"),
      values = c("home", "about", "blog")
    )

    tabContent(
      tabs = "myTabs",
      tabPane(
        tags$h1("Pane 1"),
        tags$p("Lorem Dapibus Malesuada Cras Cursus")
      ),
      tabPane(
        tags$h1("Pane 2"),
        tags$p("Magna Aenean Mattis Ultricies Ridiculus")
      )
    )
  - |-
    if (interactive()) {
      shinyApp(
        ui = container(
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
        ),
        server = function(input, output) {
          observe({
            showAlert(input$tabs, duration = 2, color = "grey")
          })
        }
      )
    }
  - |
    if (interactive()) {
      shinyApp(
        ui = container(
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
        ),
        server = function(input, output) {

        }
      )
    }
  aliases: ~
  family: layout
  export: yes
  filename: tabs.R
  source: "tabTabs <- function(id, labels, values = labels, active = values[1], \n
    \   ...) {\n    if (length(labels) == 0) {\n        stop(\"invalid `tabTabs()`
    argument, `labels` must contain at least one \", \n            \"character string\",
    call = FALSE)\n    }\n    if (!all(is.character(labels))) {\n        stop(\"invalid
    `tabTabs()` argument, `labels` must be a character vector\", \n            call.
    = FALSE)\n    }\n    if (!is.null(id) && !is.character(id)) {\n        stop(\"invalid
    `tabTabs()` argument, `id` must be a character string or \", \n            \"NULL\",
    call. = FALSE)\n    }\n    if (!is.null(active)) {\n        if (length(active)
    > 1) {\n            stop(\"invalid `tabTabs()` argument, `active` must be a single
    character \", \n                \"string\", call. = FALSE)\n        }\n        if
    (!(active %in% values)) {\n            stop(\"invalid `tabTabs()` argument, `active`
    must be one of `values`\", \n                call. = FALSE)\n        }\n    }\n
    \   active <- match2(active, values)\n    tags$ul(class = \"dull-tabs-input nav
    nav-tabs\", role = \"tablist\", \n        id = id, ..., Map(label = labels, value
    = values, active = active, \n            function(label, value, active) {\n                tags$li(class
    = \"nav-item\", tags$a(class = collate(\"nav-link\", \n                  if (active)
    \n                    \"active\"), `data-tabs` = \"tab\", `data-value` = value,
    \n                  `aria-selected` = if (active) \n                    \"true\"\n
    \                 else \"false\", label))\n            }), include(\"core\"))\n}"
---
