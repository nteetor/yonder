---
name: hideModal
title: Modal dialogs
description: |-
  Modals are a flexible alert window, which disable interaction with the page
  behind them. Modals may include inputs or buttons or simply text. To use
  one or more modals you must first register the modal from the server with
  `registerModal()`. This will assocaite the modal with an id at which point
  the rest of your application's server may hide or show the modal with
  `showModal()` and `hideModal()`, respectively, by referring to this id.
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
    One of `"small"`, `"large"`, or `"xl"` (extra large) specifying
    whether to shrink or grow the width of the modal, defaults to `NULL`, in
    which case the width is not adjusted.
- name: id
  description: A character string specifying the id to associate with the modal.
- name: modal
  description: A modal tag element created using `modal()`.
- name: exprs
  description: |-
    A list of named values used to interpolate placeholders in a
    registered modal, defaults to `list()`.
- name: '...'
  description: |-
    Additional named arguments passed as HTML attributes to the
    parent element.
inheritParams: updateInput
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
      isolate(
        registerModal(
          id = "modal1",
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
      )

      observeEvent(input$trigger, ignoreInit = TRUE, {
        showModal("modal1")
      })
    }

    shinyApp(ui, server)
    ```
family: content
export: ''
examples:
- title: Simple modal
  body:
  - type: code
    content: |-
      modal(
        title = "Title",
        body = "Cras placerat accumsan nulla.",
        footer = buttonInput(
          id = "closeModal",
          label = "Close"
        ) %>%
          background("blue")
      )
    output: |-
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Title</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">Cras placerat accumsan nulla.</div>
          <div class="modal-footer">
            <button class="yonder-button btn btn-blue" type="button" role="button" id="closeModal" autocomplete="off">Close</button>
          </div>
        </div>
      </div>
- title: Modal with container body
  body:
  - type: code
    content: |-
      modal(
        size = "large",
        title = "More complex",
        body = container(
          columns(
            column("Cras placerat accumsan nulla."),
            column("Curabitur lacinia pulvinar nibh."),
            column(
              "Aliquam posuere.",
              "Praesent fermentum tempor tellus."
            )
          )
        )
      )
    output: |-
      <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">More complex</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
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
rdname: hideModal
layout: doc
---
