# The form/file interaction in a single card: a message composer built
# from an input_form() holding a manual-mode input_file().
#
# A form holds its inputs' values back until it is submitted. A file
# input is the awkward case, because a batch's value is delivered when
# the upload completes rather than when the user touches anything, and
# that delivery is not one of the values the form is holding — so an
# auto-mode input delivers whenever its upload happens to land, and a
# form cannot hold that back. Staging is the answer: nothing uploads
# until the form is submitted, and the form waits for the upload before
# releasing anything.
#
# The card plays that back as a composer. The submit observer is the
# only writer to the sent list, so every message it renders — note and
# attachments together — is proof of the ordering: input$upload was
# already set when the observer ran. The strip under the form renders
# the file_upload_*() readers live: the staged set while it waits, a
# progress bar while the form waits on the batch, and
# file_upload_error()'s condition when something goes wrong.
#
# upload_button = "none" drops the input's own Upload button: Send is
# the batch's only trigger here, and a second button uploading without
# submitting would sit right above it doing a subtler version of the
# same thing. The cancel control still appears while a batch is in
# flight.
#
# What to try:
#
#   1. Write a note, stage a file or two, and press Send. The batch
#      uploads, Send holds its pending state, and the message lands in
#      the sent list whole. The composer then clears — update_text()
#      and reset_file() from the same observer.
#
#   2. Stage a few large files, press Send, then press Cancel while the
#      bar runs. The bar is the batch's total, across files that are on
#      the wire together, and Cancel abandons all of them at once. The
#      submit is abandoned rather than delayed: nothing lands in the
#      sent list, the note stays in the box, and the files stay staged —
#      Send again retries the whole submission.
#
#   3. Drop a folder, or a file over the size limit. The rejection
#      renders from file_upload_error()'s condition, and the staged set
#      survives it.

library(yonder)
library(bslib)

# Raised so there is time to catch the Cancel in step 2.
options(shiny.maxRequestSize = 50 * 1024^2)

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

# The form's fieldset stacks its inputs edge to edge; give the composer
# a column layout with breathing room.
composer_style <- tags$style(HTML(
  "#compose fieldset {
     display: flex;
     flex-direction: column;
     gap: 0.75rem;
     align-items: flex-start;
   }
   #compose fieldset > * {
     align-self: stretch;
   }
   #compose .bsides-input-form-submit {
     align-self: flex-start;
   }"
))

shinyApp(
  ui = page_fluid(
    title = "A file input inside a form",
    composer_style,
    card(
      card_header("Message composer"),
      input_form(
        id = "compose",
        input_text(
          id = "note",
          label = "Note",
          placeholder = "Write a note to send with the files"
        ),
        input_file(
          id = "upload",
          label = "Attachments",
          select = "many",
          upload_mode = "manual",
          upload_button = "none",
          placeholder = "Stage files, then send the form"
        ),
        form_submit_button(label = "Send", value = "send")
      ),
      uiOutput("upload_state"),
      tags$hr(class = "my-2"),
      div(class = "small fw-semibold text-body-secondary", "Sent"),
      uiOutput("outbox")
    )
  ),
  server = function(input, output, session) {
    # The submit observer is the only writer here, which is the
    # demonstration: a message can only carry its attachments because
    # input$upload is set by the time the observer runs.
    messages <- reactiveVal(list())

    observeEvent(input$compose, {
      upload <- input$upload

      messages(c(
        messages(),
        list(list(
          note = input$note,
          files = upload,
          time = format(Sys.time(), "%H:%M:%S")
        ))
      ))

      # A real composer clears after sending.
      update_text("note", value = "")
      reset_file("upload")
    })

    output$outbox <- renderUI({
      msgs <- messages()

      if (length(msgs) == 0) {
        return(div(
          class = "text-body-secondary small py-3 text-center",
          "Nothing sent yet — write a note, stage a file or two, and",
          "press Send."
        ))
      }

      div(
        class = "d-flex flex-column gap-2",
        lapply(rev(msgs), function(msg) {
          n <- if (is.null(msg$files)) 0 else nrow(msg$files)

          div(
            class = "border rounded-3 px-3 py-2 bg-body-tertiary",
            div(if (nzchar(msg$note)) msg$note else em("no note")),
            if (n > 0) {
              div(
                class = "d-flex flex-wrap gap-1 mt-1",
                lapply(seq_len(n), function(i) {
                  span(
                    class = "badge rounded-pill text-bg-light border fw-normal",
                    paste0(
                      msg$files$name[i],
                      " · ",
                      format_size(msg$files$size[i])
                    )
                  )
                })
              )
            },
            div(
              class = "small text-body-secondary mt-1",
              sprintf(
                "sent at %s · input$upload held %s at submit",
                msg$time,
                if (n == 0) {
                  "no files"
                } else if (n == 1) {
                  "1 file"
                } else {
                  paste(n, "files")
                }
              )
            )
          )
        })
      )
    })

    # The readers, rendered as the state they report: the staged set
    # while it waits on Send, the batch while the form waits on it, and
    # the condition when something goes wrong.
    output$upload_state <- renderUI({
      status <- file_upload_status("upload")
      staged <- file_upload_staged("upload")
      err <- file_upload_error("upload")

      alert <- if (!is.null(err)) {
        failure <- inherits(err, "bsides_file_failure")

        div(
          class = "alert alert-danger small mb-0",
          strong(if (failure) "Upload failed" else "Rejected"),
          lapply(strsplit(conditionMessage(err), "\n")[[1]], div),
          if (failure) {
            div(
              class = "mt-1",
              "The form was not submitted and the files are still",
              "staged — Send again retries the whole submission."
            )
          }
        )
      }

      bar <- if (status == "uploading") {
        percent <- round(file_upload_progress("upload") * 100)

        div(
          div(
            class = "small text-body-secondary mb-1",
            sprintf("Uploading — %d%% · the form waits for the batch", percent)
          ),
          div(
            class = "progress",
            style = "height: 0.5rem",
            div(class = "progress-bar", style = sprintf("width: %d%%", percent))
          )
        )
      }

      waiting <- if (status == "staged") {
        div(
          class = "small text-body-secondary",
          sprintf(
            "%s staged (%s) — held until Send",
            if (nrow(staged) == 1) "1 file" else paste(nrow(staged), "files"),
            format_size(sum(staged$size))
          )
        )
      }

      if (is.null(alert) && is.null(bar) && is.null(waiting)) {
        return(NULL)
      }

      div(class = "d-flex flex-column gap-2 mt-2", alert, bar, waiting)
    })
  }
)
