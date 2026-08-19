# Test app for input_file(). Driven by tests/testthat/test-file-e2e.R via
# {shinytest2}.

library(yonder)
library(bslib)

# Rendered under a generous limit and served under a small one. The gap is
# deliberate: the client pre-validates against the attribute captured at
# render time, the server enforces whatever option is in force when the
# upload arrives. It is the only way to reach the server's rejection
# without the client short-circuiting it first.
options(shiny.maxRequestSize = 1e6)

ui <-
  page_fluid(
    input_file(
      id = "upl",
      label = "Upload data",
      select = "many",
      accept = ".csv"
    ),
    verbatimTextOutput("info"),
    verbatimTextOutput("contents"),
    input_file(
      id = "stg",
      label = "Staged upload",
      select = "many",
      upload_mode = "manual"
    ),
    verbatimTextOutput("stg_info"),
    input_form(
      id = "frm",
      input_file(id = "frm_upl", select = "many", upload_mode = "manual"),
      form_submit_button(label = "Send", value = "send")
    ),
    verbatimTextOutput("frm_info")
  )

server <-
  function(input, output, session) {
    options(shiny.maxRequestSize = 100)

    output$info <- renderText({
      upload <- input$upl

      if (is.null(upload)) {
        return("none")
      }

      paste(upload$name, upload$size, upload$type, collapse = "; ")
    })

    output$contents <- renderText({
      upload <- input$upl

      if (is.null(upload)) {
        return("none")
      }

      paste(
        vapply(
          upload$datapath,
          function(path) paste(readLines(path, warn = FALSE), collapse = ""),
          character(1)
        ),
        collapse = "; "
      )
    })

    output$stg_info <- renderText({
      upload <- input$stg

      if (is.null(upload)) {
        return("none")
      }

      paste(upload$name, upload$size, collapse = "; ")
    })

    output$frm_info <- renderText({
      upload <- input$frm_upl

      if (is.null(upload)) {
        return("none")
      }

      paste(input$frm, paste(upload$name, collapse = "; "), sep = " / ")
    })

    # Fired from the tests with `trigger()`.
    observeEvent(
      input$do_reset,
      reset_file("upl"),
      ignoreInit = TRUE
    )
    observeEvent(
      input$do_start,
      file_upload_start("stg"),
      ignoreInit = TRUE
    )
    observeEvent(
      input$do_disable,
      update_file("upl", disable = TRUE),
      ignoreInit = TRUE
    )
    observeEvent(
      input$do_enable,
      update_file("upl", enable = TRUE),
      ignoreInit = TRUE
    )
  }

shinyApp(ui, server)
