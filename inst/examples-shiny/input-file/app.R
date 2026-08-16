# Demo app for input_file() / <bsides-file>.
#
# Four cards:
#
#   1. One file, any type: the default. Click the drop zone (or tab to it
#      and press Enter) to browse. The value arrives as a one-row data
#      frame once the upload finishes.
#
#   2. Many files, .csv only: `select = "many"` with an `accept` filter.
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
#   4. Server updates: update_file() clears the list, swaps `accept` and
#      the placeholder, and disables/enables the input. The value itself
#      is never set from the server — the upload protocol writes it, and
#      offers no way to unset it.

library(yonder)
library(bslib)

# Shiny caps uploads at 5 MB by default and rejects a whole batch if any
# one file is over. Raised here so the progress card has something to
# show.
options(shiny.maxRequestSize = 50 * 1024^2)

# Listens for the component's progress event and hands it back to the
# server as an input value.
progress_listener <-
  htmltools::tags$script(htmltools::HTML(
    "document.addEventListener('bsides-file:progress', (event) => {
       const { file, batch } = event.detail;

       Shiny.setInputValue('progress', {
         input: event.target.id,
         file: file ? file.name : null,
         percent: Math.round(batch * 100)
       });
     });"
  ))

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
          placeholder = "Drop .csv files here, or click to browse"
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
      update_file("many", reset = TRUE)
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
  }
)
