---
this: showBar
filename: R/progress.R
layout: page
requires: ~
roxygen:
  title: Progress bars
  description: |-
    Create simple or composite progress bars. To create a composite progress bar
    pass multiple calls to `bar` to a progress output. Each `bar` component has
    its own id, value, label, and attributes. Furthermore, utility functions may
    be applied to individual bars for added customization.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the progress outlet or
      progress bar.

      For **bar**, specifying an id allows you to update an existing bar in a
      progress outlet with `showBar()`. If `id` is `NULL`, `showBar()` will
      append instead of replace a progress bar.
  - name: '...'
    description: |-
      For **progressOutlet**, one or more `bar` elements to include by
      default.

      For **progressOutlet** and **bar**, additional named arguments passed as
      HTML attributes to the parent element.
  - name: value
    description: |-
      An integer between 0 and 100 specifying the initial value
      of a bar.
  - name: label
    description: |-
      A character string specifying the label of a bar, defaults to
      `NULL`, in which case a label is not added.
  - name: striped
    description: |-
      If `TRUE`, the progress bar has a striped gradient, defaults
      to `FALSE`.
  - name: outlet
    description: A character string specifying the id of a progress outlet.
  - name: bar
    description: A bar element, typically a call to `bar()`.
  - name: session
    description: A reactive context, defaults to [getDefaultReactiveDomain()](/yonder/0.0.5/getDefaultReactiveDomain.html).
  sections:
  - title: Example application
    body: |-
      ```R
      ui <- container(
        progressOutlet("tasks"),
        buttonInput(
          id = "inc",
          "Increment progress"
        ) %>%
          margin(top = 3)
      ) %>%
        flex(direction = "column")

      server <- function(input, output) {
        observeEvent(input$inc, ignoreInit = TRUE, {
          showBar(
            id = "tasks",
            bar(
              id = "laundry",
              value = min(100, input$inc * 10)
            ) %>%
              background("amber")
          )
        })
      }

      shinyApp(ui, server)
      ```
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Striped variant</h3>
  - type: source
    value: |2-

      progressOutlet(
        id = NULL,
        bar(
          id = NULL,
          value = 41,
          striped = TRUE  # <-
        ) %>%
          background("blue")
      )
  - type: output
    value: |-
      <div class="yonder-progress progress">
        <div class="progress-bar progress-bar-striped bg-blue" role="progressbar" style="width: 41%" aria-valuemin="0" aria-valuemax="100"></div>
      </div>
  - type: markdown
    value: |
      <h3>Labeled bars</h3>
  - type: source
    value: |2-

      progressOutlet(
        id = NULL,
        bar(
          id = NULL,
          value = 64,
          label = "Trees planted"  # <-
        ) %>%
          background("green")
      )
  - type: output
    value: |-
      <div class="yonder-progress progress">
        <div class="progress-bar bg-green" role="progressbar" style="width: 64%" aria-valuemin="0" aria-valuemax="100">Trees planted</div>
      </div>
  - type: markdown
    value: |
      <h3>Multiple bars</h3>
  - type: source
    value: |2-

      progressOutlet(
        id = NULL,  # <- this is typically not NULL
        bar(
          id = NULL,
          value = 40
        ) %>%
          background("red"),
        bar(
          id = NULL,
          value = 20
        ) %>%
          background("orange")
      )
  - type: output
    value: |-
      <div class="yonder-progress progress">
        <div class="progress-bar bg-red" role="progressbar" style="width: 40%" aria-valuemin="0" aria-valuemax="100"></div>
        <div class="progress-bar bg-orange" role="progressbar" style="width: 20%" aria-valuemin="0" aria-valuemax="100"></div>
      </div>
---
