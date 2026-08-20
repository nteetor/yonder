# Demo app for input_file() / <bsides-file>.
#
# Seven cards:
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
#      the set returns, ready to retry.
#
#   6. Inside a form: a staged input in an input_form(). Type a note,
#      stage a file, submit. The batch starts on submit and the form
#      holds its own value until the upload finishes, so the observer
#      keyed on the submit sees the note and the files together. Watch
#      the submit button: it goes pending while the upload runs.
#
#   7. An abandoned submit: the same shape, but cancel the upload while
#      it runs (stage something large enough to catch). The submit is
#      abandoned rather than delayed — the counter does not move, the
#      form's held values stay held, and the staged set survives, so
#      submitting again retries the whole thing.

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

shinyApp(
  ui = page_fluid(
    title = "input_file() demo",
    progress_listener,
    layout_columns(
      col_widths = 6,
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
          placeholder = "Stage files, then upload together"
        ),
        input_button(id = "start", label = "Start from the server"),
        verbatimTextOutput("staged_value")
      ),
      card(
        card_header("Inside a form"),
        input_form(
          id = "note_form",
          input_text(id = "note", label = "Note"),
          input_file(
            id = "note_upl",
            label = "Attachments",
            select = "many",
            upload_mode = "manual",
            placeholder = "Stage files, then submit the form"
          ),
          form_submit_button(label = "Send", value = "send")
        ),
        verbatimTextOutput("note_form_value")
      ),
      card(
        card_header("An abandoned submit"),
        input_form(
          id = "abandon_form",
          input_file(
            id = "abandon_upl",
            label = "Attachments",
            select = "many",
            upload_mode = "manual",
            placeholder = "Stage something large, submit, then cancel"
          ),
          form_submit_button(label = "Send", value = "send")
        ),
        verbatimTextOutput("abandon_state")
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

    output$staged_value <- renderPrint({
      input$staged
    })

    observeEvent(input$start, {
      file_upload_start("staged")
    })

    # The natural thing to write, and correct here: the form withholds
    # its own value until the staged upload finishes, so input$note_upl
    # is already set by the time this runs. An auto-mode input in the
    # same form would not be — its value lands whenever its upload does.
    submitted <- reactiveVal("nothing submitted yet")

    observeEvent(input$note_form, {
      upload <- input$note_upl

      submitted(list(
        button = input$note_form,
        note = input$note,
        files = if (is.null(upload)) {
          "none"
        } else {
          paste(upload$name, collapse = ", ")
        }
      ))
    })

    output$note_form_value <- renderPrint(submitted())

    # Counts submits that actually went through. Cancelling the upload
    # abandons the submit, so this does not move.
    sent <- reactiveVal(0L)

    observeEvent(input$abandon_form, {
      sent(sent() + 1L)
    })

    output$abandon_state <- renderPrint({
      list(
        submits_completed = sent(),
        upload_status = file_upload_status("abandon_upl"),
        still_staged = file_upload_staged("abandon_upl")$name
      )
    })
  }
)
