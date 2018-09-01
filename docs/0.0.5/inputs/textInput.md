---
this: textInput
filename: R/textual.R
layout: page
roxygen:
  title: Textual inputs
  description: Textual inputs.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the textual input, defaults
      to `NULL`.
  - name: value
    description: |-
      A character string or a value coerced to a character string
      specifying the default value of the textual input.
  - name: placeholder
    description: |-
      A character string specifying placeholder text for the
      input, defaults to `NULL`, in which case there is no placeholder text.
  - name: size
    description: |-
      One of `"small"` or `"large"` specifying the size transformation
      of the input, defaults to `NULL`, in which case the input's size is
      unchanged.
  - name: readonly
    description: |-
      If `TRUE`, the textual input is read-only preventing
      modification of the value, defaults `FALSE`.
  - name: help
    description: |-
      A character string specifying the help text of the textual input,
      defaults to `NULL`, in which case no help text is added.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  sections: ~
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                p("For best results open in a browser") %>%
                  font(weight = "bold")
              )
            ),
            row(
              column(
                h6("Text input:"),
                textInput(id = "text"),
                h6("Search input:"),
                searchInput(id = "search"),
                h6("Email input:"),
                emailInput(id = "email"),
                h6("URL input:"),
                urlInput(id = "url"),
                h6("Telephone input:"),
                telephoneInput(id = "tel"),
                h6("Password input:"),
                passwordInput(id = "pass"),
                h6("Number input:"),
                numberInput(id = "num") %>%
                  background("green")
              ),
              column(
                verbatimTextOutput("values")
              )
            )
          ),
          server = function(input, output) {
            output$values <- renderPrint({
              list(
                text = input$text, search = input$search, email = input$email,
                url = input$url, telephone = input$tel, password = input$pass,
                number = input$num
               )
            })
          }
        )
      }
    output:
    - "function (req) \n{\n    if (!identical(req$REQUEST_METHOD, \"GET\")) \n        return(NULL)\n
      \   if (!isTRUE(grepl(uiPattern, req$PATH_INFO))) \n        return(NULL)\n    textConn
      <- file(open = \"w+\")\n    on.exit(close(textConn))\n    showcaseMode <- .globals$showcaseDefault\n
      \   if (.globals$showcaseOverride) {\n        mode <- showcaseModeOfReq(req)\n
      \       if (!is.null(mode)) \n            showcaseMode <- mode\n    }\n    testMode
      <- .globals$testMode %OR% FALSE\n    bookmarkStore <- getShinyOption(\"bookmarkStore\",
      default = \"disable\")\n    if (bookmarkStore == \"disable\") {\n        restoreContext
      <- RestoreContext$new()\n    }\n    else {\n        restoreContext <- RestoreContext$new(req$QUERY_STRING)\n
      \   }\n    withRestoreContext(restoreContext, {\n        uiValue <- NULL\n        if
      (is.function(ui)) {\n            if (length(formals(ui)) > 0) {\n                uiValue
      <- ..stacktraceon..(ui(req))\n            }\n            else {\n                uiValue
      <- ..stacktraceon..(ui())\n            }\n        }\n        else {\n            if
      (getCurrentRestoreContext()$active) {\n                warning(\"Trying to restore
      saved app state, but UI code must be a function for this to work! See ?enableBookmarking\")\n
      \           }\n            uiValue <- ui\n        }\n    })\n    if (is.null(uiValue))
      \n        return(NULL)\n    renderPage(uiValue, textConn, showcaseMode, testMode)\n
      \   html <- paste(readLines(textConn, encoding = \"UTF-8\"), collapse = \"\\n\")\n
      \   return(httpResponse(200, content = enc2utf8(html)))\n}"
    - "function () \n{\n    server\n}"
    - 'NULL'
    - list()
    - list(appDir = "/Users/nteetor/git/zeppelin", bookmarkStore = NULL)
---
