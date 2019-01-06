---
name: closeAlert
title: Static and actionable alerts
description: |-
  Use `showAlert` to let the user know of successes or to call attention to
  problems. While alerts are static by default they can also be made
  actionable. Actionable alerts can be used for undoing or redoing an action
  and more.
parameters:
- name: '...'
  description: |-
    Character strings specifying the text of the alert or additional
    named arguments passed as HTML attributes to the alert element.
- name: title
  description: |-
    A character string or tag element specifying a heading for the
    alert, defaults to `NULL`, in which case a title is not added.
- name: alert
  description: An alert tag element, typically a call to `alert()`.
- name: duration
  description: |-
    A positive integer or `NULL` specifying the duration of the
    alert, by default the alert is removed after 4 seconds. If `NULL` the
    alert is not automatically removed.
- name: action
  description: |-
    A character string specifying a reactive id. If specified a
    button is added to the alert. When this button is clicked a reactive value
    is triggered, `input[[action]]` is set to `TRUE`. When the alert is removed
    `input[[action]]` is reset to `NULL`.
- name: session
  description: A reactive context, defaults to [getDefaultReactiveDomain()](getDefaultReactiveDomain.html).
sections:
- title: Displaying an alert
  body: |-
    ```R
    ui <- container(
      buttonInput("show", "Alert!") %>%
        margin(3)
    )

    server <- function(input, output) {
      observeEvent(input$show, {
        color <- sample(c("teal", "red", "orange", "blue"), 1)

        showAlert(
          alert("Alert") %>% background(color)
        )
      })
    }

    shinyApp(ui, server)
    ```
- title: Reacting to alerts
  body: |-
    ```R
    ui <- container(
      row(
        column(
          groupInput(
            id = "text",
            right = buttonInput("clear", icon("times")) %>%
              background("red")
          )
        ),
        column(
          verbatimTextOutput("value")
        )
      ) %>%
        margin(3)
    )

    server <- function(input, output) {
      oldValue <- NULL

      output$value <- renderPrint(input$text)

      observeEvent(input$clear, ignoreInit = TRUE, {
        oldValue <<- input$text
        updateValues("text", "")

        showAlert(
          alert("Undo clear.") %>%
            background("yellow"),
          action = "undo"
        )
      })

      observeEvent(input$undo, {
        updateValues("text", oldValue)
      })
    }

    shinyApp(ui, server)
    ```
- title: Removing alerts
  body: |-
    ```R
    ui <- container(
      buttonInput("add", "Alert") %>%
        margin(3),
      buttonInput("first", "Remove first alert"),
      buttonInput(
        id = "reds",
        label = "Remove red alerts",
        alt = "the red ones offend the aesthetic"
      ),
      buttonInput("alert", "Remove 'Alert' alerts")
    )

    server <- function(input, output) {
      observeEvent(input$add, {
        color <- sample(c("teal", "purple", "yellow", "red"), 1)
        showAlert(
          alert("Alert") %>%
            background(color),
          duration = NULL
        )
      })

      observeEvent(input$first, {
        closeAlert(1)
      })

      observeEvent(input$reds, {
        closeAlert(class = "alert-red")
      })

      observeEvent(input$alert, {
        closeAlert("Alert")
      })
    }

    shinyApp(ui, server)
    ```
family: content
export: ''
examples:
- title: Default alert
  body:
  - type: code
    content: alert("Donec at pede.")
    output: <div class="alert alert-grey fade show" role="alert">Donec at pede.</div>
- title: Adding more
  body:
  - type: code
    content: |-
      alert(
        p("Etiam vel tortor sodales"),
        hr(),
        p("Fusce commodo.") %>%
          margin(bottom = 0)
      ) %>%
        background("amber")
    output: |-
      <div class="alert fade show alert-amber" role="alert">
        <p>Etiam vel tortor sodales</p>
        <hr/>
        <p class="mb-0">Fusce commodo.</p>
      </div>
rdname: closeAlert
layout: doc
---
