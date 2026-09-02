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
    verbatimTextOutput("paths"),
    input_file(
      id = "stg",
      label = "Staged upload",
      select = "many",
      upload_mode = "manual"
    ),
    verbatimTextOutput("stg_info"),
    verbatimTextOutput("stg_state"),
    input_form(
      id = "frm",
      input_file(id = "frm_upl", select = "many", upload_mode = "manual"),
      form_submit_button(label = "Send", value = "send")
    ),
    verbatimTextOutput("frm_info"),
    verbatimTextOutput("frm_observed")
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

    # Basenames only: app code keyed on basename(datapath) is the pattern a
    # batch of same-extension files could collapse.
    output$paths <- renderText({
      upload <- input$upl

      if (is.null(upload)) {
        return("none")
      }

      paste(basename(upload$datapath), collapse = "; ")
    })

    output$stg_state <- renderText({
      paste(
        file_upload_status("stg"),
        nrow(file_upload_staged("stg")),
        file_upload_progress("stg")
      )
    })

    output$stg_info <- renderText({
      upload <- input$stg

      if (is.null(upload)) {
        return("none")
      }

      paste(upload$name, upload$size, collapse = "; ")
    })

    # The natural thing an app author writes: react to the submit, read
    # the file the form was carrying. Correct only because the form
    # holds its own value until the staged upload lands.
    frm_seen <- reactiveVal("observer has not run")

    observeEvent(input$frm, {
      upload <- input$frm_upl

      frm_seen(
        if (is.null(upload)) "NULL" else paste(upload$name, collapse = "; ")
      )
    })

    output$frm_observed <- renderText(frm_seen())

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
      start_file_upload("stg"),
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
    # Lifts the 100-byte limit for the one test that needs a file big
    # enough to still be on the wire when it cancels. Per app process, and
    # every test launches its own.
    observeEvent(
      input$do_relax,
      options(shiny.maxRequestSize = 5e6),
      ignoreInit = TRUE
    )
  }

shinyApp(ui, server)
