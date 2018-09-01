---
this: formRow
filename: R/forms.R
layout: page
roxygen:
  title: Add labels, help text, and formatting to inputs
  description: |-
    Form groups are a way of labelling an input. Form rows are similar to
    [row()]s, but include additional styles intended for forms. The flexibility
    provided by form rows and groups means you can confidently develop shiny
    applications for devices and screens of varying sizes.
  parameters:
  - name: label
    description: |-
      A character string specifying a label for the input or `NULL`
      in which case a label is not added.
  - name: input
    description: A tag element specifying the input to label.
  - name: help
    description: |-
      A character string specifying help text for the input, defaults
      to `NULL`, in which case help text is not added.
  - name: '...'
    description: |-
      For **formGroup**, additional named arguments passed as HTML
        attributes to the parent element.

        For **formRow**, any number of `formGroup`s or additional named arguments
        passed as HTML attributes to the parent element.
  - name: width
    description: |-
      A [responsive] argument. One of `1:12` or "auto" specifying a
      column width for the form group, defaults to `NULL`.
  sections: ~
  return: ~
  family: layout
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      # to see this example in action adjust your browser window
      # from large to small, notice how the form elements expand?
      if (interactive()) {
        shinyApp(
          ui = container(
            center = TRUE,
            card(
              formRow(
                formGroup(
                  width = c(md = 6),
                  label = "Email",
                  emailInput(
                    id = "email",
                    placeholder = "e@mail.com"
                  )
                ),
                formGroup(
                  width = c(md = 6),
                  label = "Password",
                  passwordInput(
                    id = "password",
                    placeholder = "123456"
                  ),
                  help = "Please consider something better than 123456"
                )
              ),
              formGroup(
                label = "Username",
                groupInput(
                  id = "username",
                  left = "@"
                )
              ),
              buttonInput(
                id = "go",
                label = "Go!"
              ) %>%
                background("blue")
            ) %>%
              margin(3) %>%
              background("grey")
          ),
          server = function(input, output) {
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
