---
this: renderListGroup
filename: R/list-group.R
layout: page
roxygen:
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
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      if (interactive()) {
        shinyApp(
          ui = container(
            listGroupThruput(
              id = NULL,
              listGroupItem(
                rangeInput("slider1")
              )
            )
          ),
          server = function(input, output) {
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                default = 3,
                listGroupThruput(
                  id = "thrulist"
                )
              ),
              column(
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
                flex(justify = "between", align = "center"),
              listGroupItem(
                "Dapibus ac facilisis in",
                badgeOutput("badge2", 0) %>%
                  background(input$level)
              ) %>%
                display("flex") %>%
                flex(justify = "between", align = "center")
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
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
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
              column(
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
      }
    output:
    - "function (req) \n{\n    if (!identical(req$REQUEST_METHOD, \"GET\")) \n        return(NULL)\n
      \   if (!isTRUE(grepl(uiPattern, req$PATH_INFO))) \n        return(NULL)\n    textConn
      <- file(open = \"w+\")\n    on.exit(close(textConn))\n    showcaseMode <- .globals$showcaseDefault\n
      \   if (.globals$showcaseOverride) {\n        mode <- showcaseModeOfReq(req)\n
      \       if (!is.null(mode)) \n            showcaseMode <- mode\n    }\n    testMode
      <- .globals$testMode %OR% FALSE\n    bookmarkStore <- getShinyOption(\"bookmarkStore\",
      default = \"disable\")\n    if (bookmarkStore == \"disable\") {\n        restoreContext
      <- RestoreContext$new()\n    }\n    else {\n        restoreContext <- RestoreContext$new(req$QUERY_STRING)\n
      \   }\n    withRestoreContext(restoreContext, {\n        uiValue <- NULL\n        if
      (is.function(ui)) {\n            if (length(formals(ui)) > 0) {\n                uiValue
      <- ..stacktraceon..(ui(req))\n            }\n            else {\n                uiValue
      <- ..stacktraceon..(ui())\n            }\n        }\n        else {\n            if
      (getCurrentRestoreContext()$active) {\n                warning(\"Trying to restore
      saved app state, but UI code must be a function for this to work! See ?enableBookmarking\")\n
      \           }\n            uiValue <- ui\n        }\n    })\n    if (is.null(uiValue))
      \n        return(NULL)\n    renderPage(uiValue, textConn, showcaseMode, testMode)\n
      \   html <- paste(readLines(textConn, encoding = \"UTF-8\"), collapse = \"\\n\")\n
      \   return(httpResponse(200, content = enc2utf8(html)))\n}"
    - "function () \n{\n    server\n}"
    - 'NULL'
    - list()
    - list(appDir = "/Users/nteetor/git/zeppelin", bookmarkStore = NULL)
---
