---
this: fileInput
filename: R/file.R
layout: page
requires: ~
roxygen:
  title: Upload user files
  description: Upload files to the server.
  parameters:
  - name: id
    description: A character string specifying the HTML id of the file input.
  - name: placeholder
    description: |-
      A character string specifying the text inside the file
      input, defaults to `"Choose file"`.
  - name: left,right
    description: |-
      A character string or button element placed prepended or
      appended respectively to the file input. For more information refer to
      [groupInput()](/yonder/0.0.5/inputs/groupInput.html).

      Clicking on an element specified by `right` also opens the file input
      dialog.
  - name: '...'
    description: |-
      Additional named arguments passed on as HTML attributes to the
      parent element.
  - name: multiple
    description: |-
      One of `TRUE` or `FALSE` specifying whether or not the user
      can upload multiple files at once, defaults to `TRUE`.
  - name: accept
    description: |-
      A character vector of possible MIME types or file extensions,
      defaults to `NULL`, in which case any file type may be selected.
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
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h2>Standard file input</h2>
  - type: source
    value: |2-

      fileInput(id = NULL)
  - type: output
    value: |-
      <div class="yonder-file input-group">
        <div class="custom-file">
          <input type="file" class="custom-file-input" multiple/>
          <label class="custom-file-label">Choose file</label>
        </div>
        <div class="input-group-append">
          <span class="input-group-text">Browse</span>
        </div>
      </div>
  - type: markdown
    value: |
      <h2>Adding another button</h2>
  - type: source
    value: |2-

      fileInput(
        id = NULL,
        left = buttonInput(NULL, "Upload") %>%
          background("transparent") %>%
          border("green")
      ) %>%
        margin("auto", 0, "auto", 0)
  - type: output
    value: |-
      <div class="yonder-file input-group mt-auto mr-0 mb-auto ml-0">
        <div class="input-group-prepend">
          <button class="yonder-button btn btn-grey bg-transparent border border-green" type="button" role="button">Upload</button>
        </div>
        <div class="custom-file">
          <input type="file" class="custom-file-input" multiple/>
          <label class="custom-file-label">Choose file</label>
        </div>
        <div class="input-group-append">
          <span class="input-group-text">Browse</span>
        </div>
      </div>
---
