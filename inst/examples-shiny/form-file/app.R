# The form/file interaction in a single card: an input_form() holding a
# manual-mode input_file().
#
# A form holds its inputs' values back until it is submitted. A file
# input is the awkward case, because its value is set by the server when
# an upload finishes rather than by a client-side change — so an
# auto-mode input delivers whenever its upload happens to land, and a
# form cannot hold that back. Staging is the answer: nothing uploads
# until the form is submitted, and the form waits for the upload before
# releasing anything.
#
# What to try:
#
#   1. Type a note, stage a file or two, and press Send. Watch
#      `observed_at_submit`: the note and the files are both there. That
#      is the whole point — an observer keyed on the submit can read the
#      uploaded files, which is not true of an auto-mode input.
#
#   2. Watch the Send button while the batch runs. It goes pending and
#      stays disabled until the upload finishes.
#
#   3. Stage something large, press Send, then press Cancel on the file
#      input while it uploads. The submit is abandoned rather than
#      delayed: `submits` does not move, the note stays held, and the
#      staged set survives — so pressing Send again retries the whole
#      submission, note included.

library(yonder)
library(bslib)

# Raised so there is time to catch the Cancel in step 3.
options(shiny.maxRequestSize = 50 * 1024^2)

shinyApp(
  ui = page_fluid(
    title = "A file input inside a form",
    card(
      card_header("A file input inside a form"),
      input_form(
        id = "compose",
        input_text(id = "note", label = "Note"),
        input_file(
          id = "upload",
          label = "Attachments",
          select = "many",
          upload_mode = "manual",
          placeholder = "Stage files, then send the form"
        ),
        form_submit_button(label = "Send", value = "send")
      ),
      verbatimTextOutput("state")
    )
  ),
  server = function(input, output, session) {
    # The natural thing to write, and correct here: by the time this
    # runs, the staged batch has finished and input$upload is set.
    observed <- reactiveVal("nothing sent yet")
    submits <- reactiveVal(0L)

    observeEvent(input$compose, {
      upload <- input$upload

      submits(submits() + 1L)

      observed(list(
        button = input$compose,
        note = input$note,
        files = if (is.null(upload)) "none" else upload$name
      ))
    })

    # file_upload_status() and file_upload_staged() report the input's
    # state ahead of its value, which is what makes an abandoned submit
    # legible: the set is still staged and nothing was sent.
    output$state <- renderPrint({
      list(
        submits = submits(),
        observed_at_submit = observed(),
        upload_status = file_upload_status("upload"),
        staged_now = file_upload_staged("upload")$name
      )
    })
  }
)
