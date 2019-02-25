---
name: closeToast
title: Toasts
description: |-
  Send notifications to the user. Create notification elements, toasts, with
  the `toast()` function. Display toasts with `showToast()` and remove all
  active toasts with `closeToast()`.
parameters:
- name: '...'
  description: |-
    Any number of character strings or tag elements to include in the
      body of the toast.

      Any number of named arguments passed as HTML attributes to the parent
      element.
- name: header
  description: |-
    A character string or tag element specifying a header for the
    toast, defaults to `NULL`. A close button is always included in the
    header.
- name: toast
  description: A toast element, typically built with `toast()`.
- name: duration
  description: |-
    A positive integer or `NULL` specifying the duration of the
    toast in seconds by default a toast is removed after 4 seconds. If `NULL`
    the toast is not automatically removed.
- name: action
  description: |-
    A character string specifying a reactive id. If specified, the
    hiding or closing of the toast will set the reactive id `action` to `TRUE`.
inheritParams: updateInput
sections:
- title: Showing notifications
  body: |-
    ```R
    ui <- container(
      buttonInput(
        id = "show",
        label = "Show notification"
      ) %>%
        margin(3)
    )

    server <- function(input, output) {
      observeEvent(input$show, {
        showToast(
          toast(
            header = list(
              span("Notification") %>%
                margin(right = "4"),
              span(strftime(Sys.time(), "%H:%M")) %>%
                margin(right = 1)
            ),
            "This is notification ", input$show
          ) %>%
            margin(right = 2, top = 2)
        )
      })
    }

    shinyApp(ui, server)
    ```
- title: Reacting to notifications
  body: |-
    When a notification is not automatically closed you may want to know
    when the notification is manually closed.

    ```R
    ui <- container(
      buttonInput(
        id = "show",
        label = "Show notification"
      ) %>%
        margin(3)
    )

    server <- function(input, output) {
      observeEvent(input$show, {
        showToast(
          action = "undo",
          duration = NULL,
          toast(
            header = tags$strong("Close") %>%
              margin(right = "auto"),
            "When closing this notification, ",
            "see the console"
          ) %>%
            margin(right = 2, top = 2)
        )
      })

      observeEvent(input$undo, {
        print("The notification was closed")
      })
    }

    shinyApp(ui, server)
    ```
family: content
export: ''
examples:
- title: A simple toast
  body:
  - type: text
    content: The `"fade"` and `"show"` classes have been added for the sake of these
      examples.
    output: ~
  - type: code
    content: |-
      toast(
        class = "fade show",
        header = div("Header") %>%
          margin(right = "auto"),
        "Hello, world!"
      )
    output: |-
      <div aria-atomic="true" aria-live="polite" class="toast fade show" role="alert">
        <div class="toast-header">
          <div class="mr-auto">Header</div>
          <button type="button" class="ml-2 mb-1 close" data-dismiss="toast" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="toast-body">Hello, world!</div>
      </div>
- title: Styling pieces of a toast
  body:
  - type: code
    content: |-
      toast(
        class = "fade show",
        header = list(
          div("Notification") %>%
            font(weight = "bold") %>%
            margin(right = "auto"),
          tags$small("1 min ago")
        ),
        "Hello, world!"
      )
    output: |-
      <div aria-atomic="true" aria-live="polite" class="toast fade show" role="alert">
        <div class="toast-header">
          <div class="font-weight-bold mr-auto">Notification</div>
          <small>1 min ago</small>
          <button type="button" class="ml-2 mb-1 close" data-dismiss="toast" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="toast-body">Hello, world!</div>
      </div>
rdname: closeToast
layout: doc
---
