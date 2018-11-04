---
this: showModal
filename: R/modal.R
layout: page
requires: ~
roxygen:
  title: Modal dialogs
  description: |-
    Modals are a flexible alert window, which disable interaction with the page
    behind them. Modals may include inputs or buttons or simply text.
  parameters:
  - name: title
    description: |-
      A character string or tag element specifying the title of the
      modal.
  - name: body
    description: A character string or tag element specifying the body of the modal.
  - name: footer
    description: |-
      A character string or tag element specifying the footer of the
      modal.
  - name: center
    description: |-
      One of `TRUE` or `FALSE` specifying whether the modal is
      vertically centered on the page, defaults to `FALSE`.
  - name: size
    description: |-
      One of `"small"` or `"large"` specifying whether to shrink or
      grow the width of the modal, defaults to `NULL`, in which case the modal's
      width is not adjusted.
  - name: modal
    description: A modal tag element created using `modal()`.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      parent element.
  - name: session
    description: A reactive context, defaults to [getDefaultReactiveDomain()](/yonder/0.0.5/getDefaultReactiveDomain.html).
  sections:
  - title: Example application
    body: |-
      ```R
      ui <- container(
        buttonInput(
          id = "trigger",
          "Open modal",
          icon("plus")
        )
      )

      server <- function(input, output) {
        observeEvent(input$trigger, ignoreInit = TRUE, {
          showModal(
            modal(
              title = "A simple modal",
              body = paste(
                "Cras mattis consectetur purus sit amet fermentum.",
                "Cras justo odio, dapibus ac facilisis in, egestas",
                "eget quam. Morbi leo risus, porta ac consectetur",
                "ac, vestibulum at eros."
              )
            )
          )
        })
      }

      shinyApp(ui, server)
      ```
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Simple modal</h3>
  - type: source
    value: |2-

      modal(
        title = "Title",
        body = "Cras placerat accumsan nulla.",
        footer = buttonInput(
          id = "closeModal",
          label = "Close"
        ) %>%
          background("blue")
      )
  - type: output
    value: |-
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Title</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&amp;times;</span>
            </button>
          </div>
          <div class="modal-body">Cras placerat accumsan nulla.</div>
          <div class="modal-footer">
            <button class="yonder-button btn btn-blue" type="button" role="button" id="closeModal">Close</button>
          </div>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Modal with container body</h3>
  - type: source
    value: |2-

      modal(
        size = "large",
        title = "More complex",
        body = container(
          row(
            column("Cras placerat accumsan nulla."),
            column("Curabitur lacinia pulvinar nibh."),
            column(
              "Aliquam posuere.",
              "Praesent fermentum tempor tellus."
            )
          )
        )
      )
  - type: output
    value: |-
      <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">More complex</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&amp;times;</span>
            </button>
          </div>
          <div class="modal-body">
            <div class="container-fluid">
              <div class="row">
                <div class="col">Cras placerat accumsan nulla.</div>
                <div class="col">Curabitur lacinia pulvinar nibh.</div>
                <div class="col">
                  Aliquam posuere.
                  Praesent fermentum tempor tellus.
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
---
