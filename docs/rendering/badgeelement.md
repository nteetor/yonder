---
name: badgeElement
title: Badges
description: |-
  Small highlighted content which scales to its parent's size. A badge may
  be dynamically updated with [replaceElement()].
inheritParams: outputElement
parameters:
- name: '...'
  description: |-
    Named arguments passed as HTML attributes to the parent
    element or tag elements passed as children to the parent element.
details: |-
  Use [replaceElement()] and [removeElement()] to modify the contents of a
  badge.
sections:
- title: Example application
  body: |-
    ```
    ui <- container(
      buttonInput(
        id = "clicker",
        label = list(
          "Clicks",
          badgeElement("counter") %>%
            margin(left = 2) %>%
            background("teal")
        )
      )
    )

    server <- function(input, output) {
      observe({
        clicks <- if (is.null(input$clicker)) 0 else input$clicker
        replaceElement("counter", clicks)
      })
    }

    shinyApp(ui, server)
    ````
family: rendering
export: ''
examples:
- title: Possible colors
  body:
  - type: code
    content: |-
      colors <- c(
        "red", "purple", "indigo", "blue", "cyan", "teal", "green",
        "yellow", "amber", "orange", "grey", "white"
      )

      div(
        lapply(colors, function(color) {
          badgeElement(color, color) %>%
            background(color) %>%
            margin(2) %>%
            padding(1)
        })
      ) %>%
        display("flex") %>%
        flex(wrap = TRUE)
    output: |-
      <div class="d-flex flex-wrap">
        <span class="yonder-element badge badge-red m-2 p-1" id="red">red</span>
        <span class="yonder-element badge badge-purple m-2 p-1" id="purple">purple</span>
        <span class="yonder-element badge badge-indigo m-2 p-1" id="indigo">indigo</span>
        <span class="yonder-element badge badge-blue m-2 p-1" id="blue">blue</span>
        <span class="yonder-element badge badge-cyan m-2 p-1" id="cyan">cyan</span>
        <span class="yonder-element badge badge-teal m-2 p-1" id="teal">teal</span>
        <span class="yonder-element badge badge-green m-2 p-1" id="green">green</span>
        <span class="yonder-element badge badge-yellow m-2 p-1" id="yellow">yellow</span>
        <span class="yonder-element badge badge-amber m-2 p-1" id="amber">amber</span>
        <span class="yonder-element badge badge-orange m-2 p-1" id="orange">orange</span>
        <span class="yonder-element badge badge-grey m-2 p-1" id="grey">grey</span>
        <span class="yonder-element badge badge-white m-2 p-1" id="white">white</span>
      </div>
rdname: badgeElement
layout: doc
---
