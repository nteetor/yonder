---
this: rangeInput
filename: R/range.R
layout: page
roxygen:
  title: Ranges, intervals, and custom sliders
  description: A take on shiny's `sliderInput`.
  parameters:
  - name: id
    description: A character string specifying the id of the range input or `NULL`.
  - name: min
    description: |-
      A number specifying the minimum value of the range input, defaults
      to `0`.
  - name: max
    description: |-
      A number specifying the maximum value of the range input, defaults
      to `100`.
  - name: default
    description: |-
      A numeric vector between `min` and `max` specifying the
        default value of the range input.

        For **rangeInput**, a single number, defaults to `min`.

        For **intervalInput**, a vector of two numbers specifying the minimum and
        maximum of the slider interval, defaults to `c(min, max)`.
  - name: step
    description: |-
      A number specifying the interval step of the range input,
      defaults to `1`.
  - name: draggable
    description: |-
      One of `TRUE` or `FALSE` specifying if the user can drag the
      interval between an interval input's two sliders defaults to `FALSE`. If
      `TRUE` the slider interval may be dragged with the cursor, otherwise the
      interval is not draggable.
  - name: choices
    description: |-
      A character vector specifying the labels along the slider
      input.
  - name: values
    description: |-
      A character vector specifying the values of the slider input,
      defaults to `choices`.
  - name: selected
    description: |-
      One of `values` specifying the initial value of the slider
      input, defaults to `NULL`, in which case the slider input defaults to the
      first choice.
  - name: ticks
    description: |-
      One of `TRUE` or `FALSE` specifying if tick marks are added to
      the range input, defaults to `FALSE`. If `TRUE` tick marks are added,
      otherwise if `FALSE` tick marks are not added.
  - name: fill
    description: |-
      One of `TRUE` or `FALSE` specifying whether the filled portion of
        a range or slider input is shown. If `FALSE` the filled porition is hidden.

        For **rangeInput** the default is `TRUE`.

        For **sliderInput** the default is `FALSE`.
  - name: labels
    description: |-
      A number specifying how many ticks are labeled, defaults to
      `4`. If `snap` is `TRUE`, this argument is ignored and tick labels are
      based on `step`.
  - name: snap
    description: |-
      One of `TRUE` or `FALSE` specifying how the range input tick
      marks are labeled, defaults to `FALSE`. If `TRUE` the range input tick
      marks are adjusted to align with a multiple of `step`. If `FALSE` the range
      input tick marks are calculeted using `labels`.
  - name: prefix
    description: |-
      A character string specifying a prefix for the range input
      slider value, defaults to `NULL`, in which case a prefix is not prepended.
  - name: suffix
    description: |-
      A character string specifying a suffix for the range input
      slider value, defaults to `NULL`, in which case a prefix is not appended.
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
            rangeInput("default") %>%
              background("yellow"),
            rangeInput("blue") %>%
              background("blue"),
            rangeInput("red") %>%
              background("red"),
            rangeInput("white", step = 10, snap = TRUE) %>%
              background("green"),
            rangeInput("yellow", prefix = "$", suffix = ".00")
          ),
          server = function(input, output) {
            observe({
              req(input$default)
              cat(paste0(rep.int("\r", nchar(input$default)), input$default))
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
