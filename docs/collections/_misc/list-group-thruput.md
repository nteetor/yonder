---
layout: page
slug: list-group-thruput
roxygen:
  rdname: ~
  name: listGroupThruput
  doctype: ~
  title: List group thruputs
  description: |-
    A way of handling and outlining content as a list. List groups function
    similarly to checkbox groups. A list group returns a reactive vector of
    values from its active (selected) list group items. List group items are
    selected or unselected by clicking on them.
  parameters:
  - name: id
    description: |-
      A character vector specifying the reactive id of the list group
      thruput.
  - name: '...'
    description: |-
      For `listGroupThruput()`, additional named arguments passed on as
        HTML attributes to the parent list group element.

        For `listGroupItem()`, the text or HTML content of the list group item.

        For `renderListGroup()`, any number of expressions which return a
        `listGroupItem()` or calls to `listGroupItem()`.
  - name: multiple
    description: |-
      One of `TRUE` or `FALSE` specifyng if multiple list group
      items may be selected, defaults to `TRUE`.
  - name: flush
    description: |-
      One of `TRUE` or `FALSE` specifying if the list group is
      rendered without a border, defaults to `FALSE`. Removing the list group
      border is useful when rendering a list group inside a custom parent
      container, e.g. inside a `card()`.
  - name: value
    description: |-
      A character string specifying the value of the list group item,
      defaults to `NULL`, in which case the list group item has no value. List
      group items without a value are not actionable, i.e. they cannot be
      selected.
  - name: selected
    description: |-
      `TRUE` or `FALSE` specifying if the list group item is
      selected by default, defaults to `FALSE`.
  - name: disabled
    description: |-
      `TRUE` or `FALSE` specifying if the list group item can be
      selected, defaults to `FALSE`.
  - name: env
    description: |-
      The environment in which to evalute the expressions based to
      `renderListGroup()`.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              default = 3,
              listGroupThruput(
                id = "thrulist"
              )
            ),
            col(
              rangeInput(
                id = "num",
                min = 0,
                max = 20,
                step = 2
              ),
              sliderInput(
                id = "level",
                choices = c("red", "orange", "green", "cyan")
              )
            )
          )
        ),
        server = function(input, output) {
          output$thrulist <- renderListGroup(
            listGroupItem(
              "Cras justo odio",
              badgeOutput("badge1", 0) %>%
                background(input$level)
            ) %>%
              display("flex") %>%
              content("between") %>%
              items("center"),
            listGroupItem(
              "Dapibus ac facilisis in",
              badgeOutput("badge2", 0) %>%
                background(input$level)
            ) %>%
              display("flex") %>%
              content("between") %>%
              items("center")
          )

          output$badge1 <- renderBadge(input$num)
          output$badge2 <- renderBadge(input$num)
        }
      )
    }

    lessons <- list(
      stars = c(
        "The stars and moon are far too bright",
        "Their beam and smile splashing o'er all",
        "To illuminate while turning my sight",
        "From the shadows wherein deeper shadows fall"
      ),
      joy = c(
        "A single step, her hand aloft",
        "More than a step, a joyful bound",
        "The moment, precious, small, soft",
        "And within a truth was found"
      )
    )

    shinyApp(
      ui = container(
        row(
          col(
            class = "ml-auto",
            default = 3,
            listGroupThruput(
              id = "lesson",
              multiple = FALSE,
              listGroupItem(
                value = "stars",
                h5("Stars"),
                lessons[["stars"]][1]
              ),
              listGroupItem(
                value = "joy",
                h5("Joy"),
                lessons[["joy"]][1]
              )
            )
          ),
          col(
            class = "mr-auto",
            htmlOutput("text")
          )
        )
      ),
      server = function(input, output) {
        output$text <- renderText({
          req(input$lesson)
          HTML(paste(lessons[[input$lesson]], collapse = "</br>"))
        })
      }
    )
  aliases: ~
  family: ~
  export: yes
  filename: list-group.R
  source: "listGroupThruput <- function(id, ..., multiple = TRUE, flush = FALSE) {\n
    \   tags$div(class = collate(\"dull-list-group-thruput list-group\", \n        if
    (flush) \n            \"list-group-flush\"), `data-multiple` = if (multiple) \n
    \       \"true\"\n    else \"false\", id = id, ...)\n}"
---
