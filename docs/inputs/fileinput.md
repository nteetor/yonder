---
name: fileInput
title: Upload user files
description: Upload files to the server.
parameters:
- name: placeholder
  description: |-
    A character string specifying the text inside the file
    input, defaults to `"Choose file"`.
- name: left,right
  description: |-
    A character string or button element placed prepended or
    appended respectively to the file input. For more information refer to
    [groupInput()](inputs/groupinput.html).

    Clicking on an element specified by `right` also opens the file input
    dialog.
- name: multiple
  description: |-
    One of `TRUE` or `FALSE` specifying whether or not the user
    can upload multiple files at once, defaults to `TRUE`.
- name: accept
  description: |-
    A character vector of possible MIME types or file extensions,
    defaults to `NULL`, in which case any file type may be selected.
- name: id
  description: A character string specifying the reactive id of the input.
- name: '...'
  description: Additional named arguments passed as HTML attributes to the parent
    element.
details: |-
  Be careful when adjusting the right or left margin of a file input. In the
  current version of Bootstrap file inputs can be pushed off the side of a
  page.
sections:
- title: Uploading a file
  body: |-
    ```R
    shinyApp(
      ui = container(
        fileInput("upload") %>%
          margin(0, "auto", 0, "auto")
      ),
      server = function(input, output) {
        observe({
          req(input$upload)

          print(input$upload)
        })
      }
    )
    ```
family: inputs
export: ''
examples:
- title: Standard file input
  body:
  - type: code
    content: fileInput(id = NULL)
    output: |-
      <div class="yonder-file input-group">
        <div class="custom-file">
          <input type="file" class="custom-file-input" multiple/>
          <label class="custom-file-label">Choose file</label>
          <div class="invalid-feedback"></div>
        </div>
        <div class="input-group-append">
          <span class="input-group-text">Browse</span>
        </div>
      </div>
- title: Adding another button
  body:
  - type: code
    content: |-
      fileInput(
        id = NULL,
        left = buttonInput(NULL, "Upload") %>%
          background("transparent") %>%
          border("green")
      ) %>%
        margin("auto", 0, "auto", 0)
    output: |-
      <div class="yonder-file input-group m-auto mt-0 mr-auto mb-0">
        <div class="input-group-prepend">
          <button class="yonder-button btn btn-grey bg-transparent border border-green" type="button" role="button">Upload</button>
        </div>
        <div class="custom-file">
          <input type="file" class="custom-file-input" multiple/>
          <label class="custom-file-label">Choose file</label>
          <div class="invalid-feedback"></div>
        </div>
        <div class="input-group-append">
          <span class="input-group-text">Browse</span>
        </div>
      </div>
rdname: fileInput
layout: doc
---
