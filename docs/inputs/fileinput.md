---
name: fileInput
title: Upload user files
description: Upload files to the server.
inheritParams: checkboxInput
parameters:
- name: placeholder
  description: |-
    A character string specifying the text inside the file
    input, defaults to `"Choose file"`.
- name: browse
  description: |-
    A character string specifying the label of file input, defaults
    to `"Browse"`.
- name: multiple
  description: |-
    One of `TRUE` or `FALSE` specifying whether or not the user
    can upload multiple files at once, defaults to `TRUE`.
- name: accept
  description: |-
    A character vector of possible MIME types or file extensions,
    defaults to `NULL`, in which case any file type may be selected.
sections:
- title: '**Example** uploading a file'
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
    content: fileInput(id = "file1")
    output: |-
      <div class="yonder-file custom-file" id="file1">
        <input type="file" class="custom-file-input" multiple autocomplete="off"/>
        <label class="custom-file-label" data-browse="Browse">Choose file</label>
        <div class="valid-feedback"></div>
        <div class="invalid-feedback"></div>
      </div>
- title: Adding a button
  body:
  - type: code
    content: |-
      fileInput(
        id = "file2",
        left = buttonInput("upload", "Upload") %>%
          background("green")
      )
    output: |-
      <div class="yonder-file custom-file" id="file2" left="&lt;button class=&quot;yonder-button btn btn-green&quot; type=&quot;button&quot; role=&quot;button&quot; id=&quot;upload&quot; autocomplete=&quot;off&quot;&gt;Upload&lt;/button&gt;">
        <input type="file" class="custom-file-input" multiple autocomplete="off"/>
        <label class="custom-file-label" data-browse="Browse">Choose file</label>
        <div class="valid-feedback"></div>
        <div class="invalid-feedback"></div>
      </div>
- title: Customizing text
  body:
  - type: code
    content: |-
      fileInput(
        id = "file3",
        placeholder = "Pick a file",
        browse = "Go go go!"
      )
    output: |-
      <div class="yonder-file custom-file" id="file3">
        <input type="file" class="custom-file-input" multiple autocomplete="off"/>
        <label class="custom-file-label" data-browse="Go go go!">Pick a file</label>
        <div class="valid-feedback"></div>
        <div class="invalid-feedback"></div>
      </div>
rdname: fileInput
layout: doc
---
