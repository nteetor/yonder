---
name: popover
title: Display a popover
description: |-
  Popovers are small windows of content associated with a tag element. Use
  `popover()` to construct the element and `showPopover()` to add it to any tag
  element with an HTML id. Popovers are great for explaining inputs and giving
  hints to the users. Popovers are hidden with `closePopover()`.
parameters:
- name: '...'
  description: |-
    Character strings or tag elements specifying the content of the
    popover or additional named arguments passed as HTML attributes to the
    parent element.
- name: title
  description: |-
    A character string specifying a title for the popover, defaults
    to `NULL`, in which case a title is not added.
- name: target
  description: |-
    A character string specifying the id of the element where the
    popover is shown.
- name: popover
  description: The popover element to show, typically a call to `popover()`.
- name: placement
  description: |-
    One of `"top"`, `"left"`, `"bottom"`, or `"right"`
    specifying where the popover is positioned relative to the target tag
    element indicated by `id`.
- name: duration
  description: |-
    A positive integer specifying the duration of the popover
    in seconds or `NULL`, in which case the popover is not automatically
    removed. When `NULL` is specified the popover can be removed with
    `closePopover()`.
- name: id
  description: |-
    A character string specifying the HTML id of a popover's target tag
    element.
- name: session
  description: A reactive context, defaults to [getDefaultReactiveDomain()](getDefaultReactiveDomain.html).
sections:
- title: Example application
  body: |-
    ```R
    ui <- container(
      buttonInput("showHelp", "Help!"),
      div(
        id = "textBlock1",
        "Sociis natoque penatibus et magnis"
      ) %>%
        padding(3)
    ) %>%
      display("flex") %>%
      flex(justify = "around")

    server <- function(input, output) {
      observeEvent(input$showHelp, ignoreInit = TRUE, {
        showPopover(
          target = "textBlock1",
          popover(title = "Hint", "I am a <div> element!"),
          placement = "bottom",
          duration = 4
        )
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
    content: Please see example application above.
    output: ~
rdname: popover
layout: doc
---
