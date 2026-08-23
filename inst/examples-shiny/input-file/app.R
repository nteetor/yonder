# Demo app for input_file() / <bsides-file>.
#
# Five cards:
#
#   1. One file, any type: the default. Click the drop zone (or tab to it
#      and press Enter) to browse. The value arrives as a one-row data
#      frame once the upload finishes.
#
#   2. Many files, .csv only: `select = "many"` with an `accept` filter,
#      and a templated summary line ("{done}/{n} uploaded") that stays
#      live while the file list is collapsed.
#      Drop a folder, drop a .txt, or drop something over the size limit
#      and the rejection is reported inline without a round trip — the
#      picker's own filtering does not apply to drops. Pasting works the
#      same way, screenshots included. While a batch is in flight the
#      Cancel control abandons it, and the server never sets the value.
#
#   3. Progress: the component emits a `bsides-file:progress` DOM event
#      through the upload, which app JavaScript can listen for. Upload
#      something large enough to watch it tick.
#
#   4. Server updates: reset_file() clears the list, update_file() swaps
#      `accept` and the placeholder and disables/enables the input. The
#      value itself is never set from the server — the upload protocol
#      writes it, and offers no way to unset it.
#
#   5. Staged upload: upload_mode = "manual". Files accumulate in the
#      list — same-name additions replace, each row removable — and the
#      batch starts from the Upload button, or from the server:
#      file_upload_start() is the button's twin. Cancel mid-flight and
#      the set returns, ready to retry. upload_max = 3 caps the set:
#      once full the input stops accepting files until one is removed,
#      and a drop that would overfill it is rejected whole.
#
#      The card renders the file_upload_*() readers live rather than
#      printing them: the status string as a badge, the staged set with
#      sizes, a progress bar while a batch is in flight, the delivered
#      value, and — drop a folder, or a fourth file — the condition
#      from file_upload_error(): its class, its message, and the
#      per-file reason codes underneath.

library(yonder)
library(bslib)

# Shiny caps uploads at 5 MB by default and rejects a whole batch if any
# one file is over. Raised here so the progress card has something to
# show.
options(shiny.maxRequestSize = 50 * 1024^2)

# Listens for the component's progress event and hands it back to the
# server as an input value. The event bubbles from every file input on
# the page, so a page with several must filter by the event's target --
# here, only the Progress card's input.
progress_listener <-
  htmltools::tags$script(htmltools::HTML(
    "document.addEventListener('bsides-file:progress', (event) => {
       if (event.target.id !== 'big') return;

       const { file, batch } = event.detail;

       Shiny.setInputValue('progress', {
         input: event.target.id,
         file: file ? file.name : null,
         percent: Math.round(batch * 100)
       });
     });"
  ))

# Binary steps under decimal labels, matching the file input's own size
# formatting.
format_size <- function(bytes) {
  units <- c("B", "kB", "MB", "GB", "TB")
  unit <- 1

  while (bytes >= 1024 && unit < length(units)) {
    bytes <- bytes / 1024
    unit <- unit + 1
  }

  paste(if (unit == 1) bytes else round(bytes, 1), units[unit])
}

shinyApp(
  ui = page_fluid(
    title = "input_file() demo",
    progress_listener,
    layout_columns(
      col_widths = c(6, 6, 6, 6),
      card(
        card_header("One file, any type"),
        input_file(
          id = "one",
          label = "Attachment"
        ),
        verbatimTextOutput("one_value")
      ),
      card(
        card_header("Many files, .csv only"),
        input_file(
          id = "many",
          label = "Data files",
          select = "many",
          accept = c(".csv", "text/csv"),
          placeholder = "Drop .csv files here, or click to browse",
          # The file list's summary line is a template; state tokens keep
          # it live through the upload. Default: "{files} · {size}".
          summary = "{done}/{n} uploaded · {size}"
        ),
        verbatimTextOutput("many_value")
      ),
      card(
        card_header("Progress"),
        input_file(
          id = "big",
          label = "Something large",
          placeholder = "Drop a big file to watch the bar"
        ),
        verbatimTextOutput("progress_value")
      ),
      card(
        card_header("Server updates"),
        input_button(id = "reset", label = "Reset the .csv input"),
        input_button(id = "images", label = "Accept images instead"),
        input_button(id = "hint", label = "Change placeholder"),
        input_checkbox(id = "disable", choice = "Disable the .csv input")
      ),
      card(
        card_header("Staged upload"),
        input_file(
          id = "staged",
          label = "Batch of files",
          select = "many",
          upload_mode = "manual",
          upload_max = 3,
          placeholder = "Stage files, then upload together"
        ),
        input_button(id = "start", label = "Start from the server"),
        uiOutput("staged_state")
      )
    )
  ),
  server = function(input, output, session) {
    # The value is a data frame of name, size, type, and datapath — the
    # same contract as shiny::fileInput(). datapath points at a temporary
    # file owned by the session.
    output$one_value <- renderPrint({
      input$one
    })

    output$many_value <- renderPrint({
      upload <- input$many

      if (is.null(upload)) {
        return(NULL)
      }

      # A peek at what actually arrived, read back off disk.
      data.frame(
        name = upload$name,
        size = upload$size,
        first_line = vapply(
          upload$datapath,
          function(path) readLines(path, n = 1, warn = FALSE)[1],
          character(1)
        ),
        row.names = NULL
      )
    })

    output$progress_value <- renderPrint({
      input$progress
    })

    observeEvent(input$reset, {
      reset_file("many")
    })

    observeEvent(input$images, {
      update_file("many", accept = "image/*")
    })

    observeEvent(input$hint, {
      update_file("many", placeholder = "Any image will do now")
    })

    observeEvent(input$disable, ignoreInit = TRUE, {
      if (isTRUE(input$disable)) {
        update_file("many", disable = TRUE)
      } else {
        update_file("many", enable = TRUE)
      }
    })

    # The readers rendered live, each shown as itself: the badge is the
    # literal status string, the reasons are the condition's stable
    # codes. Reading four readers here means this re-renders whenever
    # any facet changes, progress ticks included — fine for a demo, and
    # the liveness is the point.
    output$staged_state <- renderUI({
      status <- file_upload_status("staged")
      staged <- file_upload_staged("staged")
      err <- file_upload_error("staged")
      delivered <- input$staged

      appearance <- c(
        idle = "secondary",
        staged = "info",
        uploading = "primary",
        done = "success",
        failed = "danger",
        cancelled = "warning"
      )

      header <- div(
        class = "d-flex align-items-center gap-2",
        span(
          class = paste0("badge text-bg-", appearance[[status]]),
          status
        ),
        span(
          class = "small text-body-secondary",
          sprintf("%d of 3 staged", nrow(staged))
        )
      )

      bar <- if (status == "uploading") {
        percent <- round(file_upload_progress("staged") * 100)
        div(
          class = "progress",
          style = "height: 0.5rem",
          div(class = "progress-bar", style = sprintf("width: %d%%", percent))
        )
      }

      rows <- if (nrow(staged) > 0) {
        tags$ul(
          class = "list-group list-group-flush small",
          lapply(seq_len(nrow(staged)), function(i) {
            tags$li(
              class = "list-group-item d-flex justify-content-between px-0",
              span(staged$name[i]),
              span(class = "text-body-secondary", format_size(staged$size[i]))
            )
          })
        )
      }

      # The condition at both depths: conditionMessage() as the
      # headline, $files as the per-file detail. The reason codes are
      # the stable surface; the message text is display copy.
      alert <- if (!is.null(err)) {
        rejection <- inherits(err, "bsides_file_rejection")

        div(
          class = "alert alert-danger small mb-0",
          div(
            strong(if (rejection) "Rejected" else "Upload failed"),
            lapply(strsplit(conditionMessage(err), "\n")[[1]], div)
          ),
          if (nrow(err$files) > 0) {
            tags$table(
              class = "table table-sm table-borderless small mb-0 mt-2",
              tags$tbody(
                lapply(seq_len(nrow(err$files)), function(i) {
                  limit <- err$files$limit[i]

                  tags$tr(
                    tags$td(err$files$name[i]),
                    tags$td(tags$code(err$files$reason[i])),
                    tags$td(
                      if (is.na(limit)) {
                        ""
                      } else if (err$files$reason[i] == "size") {
                        format_size(limit)
                      } else {
                        limit
                      }
                    )
                  )
                })
              )
            )
          }
        )
      }

      sent <- if (!is.null(delivered)) {
        div(
          class = "small text-success",
          sprintf("Delivered: %s", paste(delivered$name, collapse = ", "))
        )
      }

      div(class = "d-flex flex-column gap-2", header, bar, rows, alert, sent)
    })

    observeEvent(input$start, {
      file_upload_start("staged")
    })
  }
)
