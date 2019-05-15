---
name: showModal
title: Modal dialogs
description: |-
  Modals are a flexible alert window, which disable interaction with the page
  behind them. Modals may include inputs or buttons or simply text. To use
  one or more modals you must first register the modal from the server with
  `registerModal()`. This will assocaite the modal with an id at which point
  the rest of your application's server may hide or show the modal with
  `showModal()` and `hideModal()`, respectively, by referring to this id.
parameters:
- name: id
  description: |-
    A character string specifying the id of the modal, when closed
    `input[[id]]` is set to `TRUE`.
- name: title
  description: |-
    A character string or tag element specifying the title of the
    modal.
- name: '...'
  description: |-
    Unnamed arguments passed as tag elements to the body of the modal
    or named arguments passed as HTML attributes to the body element of the
    modal.
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
    One of `"sm"` (small), `"md"` (medium), `"lg"` (large), or `"xl"`
    (extra large) specifying the relative width of the modal, defaults to
    `"md"`.
- name: fade
  description: |-
    One of `TRUE` or `FALSE` specifying if the modal fades in when
    shown and fades out when closed, defaults to `TRUE`.
- name: modal
  description: A modal tag element created using `modal()`.
inheritParams: collapsePane
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
        id = NULL,
        title = "Title",
        body = "Cras placerat accumsan nulla."
      )
    output: |-
      <div class="yonder-modal modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            Cras placerat accumsan nulla.
            <div class="modal-header">
              <h5 class="modal-title">Title</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body"></div>
          </div>
        </div>
      </div>
- title: Modal with container body
  body:
  - type: code
    content: |-
      modal(
        id = NULL,
        size = "lg",
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
      <div class="yonder-modal modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
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
            <div class="modal-header">
              <h5 class="modal-title">More complex</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body"></div>
          </div>
        </div>
      </div>
rdname: showModal
layout: doc
---
