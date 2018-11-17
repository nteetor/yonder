---
this: badgeOutput
filename: R/badge.R
layout: page
requires: ~
roxygen:
  title: Badge outputs
  description: |-
    Small highlighted content which scales to its parent's size. Useful for
    displaying dynamically changing counts or tickers, drawing attention to new
    options, or tagging content.
  parameters:
  - name: id
    description: A character string specifying the id of the badge output.
  - name: '...'
    description: |-
      Additional named argument passed as HTML attributes to the parent
      element.
  - name: expr
    description: |-
      An expression which returns a character string specifying the
      label of the badge.
  - name: env
    description: |-
      The environment in which to evaluate `expr`, defaults to the
      calling environment.
  - name: quoted
    description: |-
      One of `TRUE` or `FALSE` specifying if `expr` is a quoted
      expression.
  sections: []
  return: ~
  family: outputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h2>Buttons with badges</h2>
  - type: markdown
    value: |
      <p>Typically, you would use <code>renderBadge()</code> to update a badge's value. Here we are hard-coding a default value of 7.</p>
  - type: source
    value: |2-

      buttonInput(
        id = NULL,
        label = "Process",
        badgeOutput(
          id = NULL,
          7
        ) %>%
          background("cyan")
      )
  - type: output
    value: |-
      <button class="yonder-button btn btn-grey" type="button" role="button">
        Process
        <span class="yonder-badge badge badge-cyan">7</span>
      </button>
  - type: markdown
    value: |
      <h2>Possible colors</h2>
  - type: source
    value: |2-

      colors <- c(
        "red", "purple", "indigo", "blue", "cyan", "teal", "green",
        "yellow", "amber", "orange", "grey", "white"
      )

      div(
        lapply(
          colors,
          function(color) {
            badgeOutput(
              id = NULL,
              color
            ) %>%
              background(color) %>%
              margin(2)
          }
        )
      ) %>%
        display("flex") %>%
        flex(wrap = TRUE)
  - type: output
    value: |-
      <div class="d-flex flex-wrap">
        <span class="yonder-badge badge badge-red">red</span>
        <span class="yonder-badge badge badge-purple">purple</span>
        <span class="yonder-badge badge badge-indigo">indigo</span>
        <span class="yonder-badge badge badge-blue">blue</span>
        <span class="yonder-badge badge badge-cyan">cyan</span>
        <span class="yonder-badge badge badge-teal">teal</span>
        <span class="yonder-badge badge badge-green">green</span>
        <span class="yonder-badge badge badge-yellow">yellow</span>
        <span class="yonder-badge badge badge-amber">amber</span>
        <span class="yonder-badge badge badge-orange">orange</span>
        <span class="yonder-badge badge badge-grey">grey</span>
        <span class="yonder-badge badge badge-white">white</span>
      </div>
---
