---
name: showCollapsePane
title: Collapse sections
description: |-
  The `collapsePane()` creates a collapsible container. The state of the
  container, expanded or collapsed, is toggled using `showCollapsePane()`,
  `hideCollapsePane()`, and `toggleCollapsePane()`.
parameters:
- name: id
  description: A character string specifying the id of the collapse pane.
- name: show
  description: |-
    One of `TRUE` or `FALSE` specifying if the collapsible pane
    is shown when the page renders, defaults to `FALSE`.
- name: '...'
  description: |-
    Tag elements inside the collapsible pane or additional named
    arguments passed as HTML attributes to parent element.
- name: session
  description: A reactive context, defaults to [getDefaultReactiveDomain()](getdefaultreactivedomain.html).
details: |-
  Padding may not be applied to the collapsible pane div element. To pad a
  collapsible pane first wrap the pane in another element and add padding to
  this new element.
sections:
- title: App with collapse
  body: |-
    ```R
    ui <- container(
      buttonInput(
        id = "demo",
        label = "Toggle collapse"
      ),
      collapsePane(
        id = "collapse",
        p(
          "Pellentesque condimentum, magna ut suscipit hendrerit, ",
          "ipsum augue ornare nulla, non luctus diam neque sit amet urna."
        ),
        p(
          "Praesent fermentum tempor tellus.  Vestibulum convallis, ",
          "lorem a tempus semper, dui dui euismod elit, vitae placerat ",
          "urna tortor vitae lacus."
        )
      )
    )

    server <- function(input, output) {
      observeEvent(input$demo, {
        toggleCollapsePane("collapse")
      })
    }

    shinyApp(ui, server)
    ```
family: content
export: ''
examples:
- title: Examples
  body:
  - type: text
    content: As these are server-side utilities, please run the example applications
      above.
    output: ~
rdname: showCollapsePane
layout: doc
---
