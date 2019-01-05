---
name: downloadEvent
title: Trigger downloads
description: |-
  `downloadEvent` allows a custom reactive event to trigger a file
  download.
parameters:
- name: event
  description: |-
    A reactive input value (e.g. `input$click`), a call to a
    reactive expression, or a new expression inside curly braces. When `event`
    is triggered the file download is triggered.
- name: filename
  description: |-
    A reactive input value, a call to a reactive expression, a
    function, or a new expression inside curly braces which returns a string
    specifying the name of the downloaded file.
- name: handler
  description: |-
    A **function** with one argument that write's the content of
    the downloaded file. A temporary file is passed to the function, which is
    expected to write content (text, images, etc.) to the temporary file.
- name: domain
  description: |-
    A shiny session object, defaults to
    [getDefaultReactiveDomain()](/getDefaultReactiveDomain.html).
sections:
- title: Downloading a file
  body: |-
    ```R
    shinyApp(
      ui = container(
        textInput("name", "File name"),
        buttonInput("trigger", "Download")
      ),
      server = function(input, output) {
        downloadEvent(input$trigger, {
          if (is.null(input$name)) {
            "default"
          } else {
            input$name
          }
        }, function(file) {
          cat("hello, world!", file = file)
        })
      }
    )
    ```
family: utilities
export: ''
rdname: downloadEvent
layout: doc
---
