---
layout: page
slug: form-group
roxygen:
  rdname: ~
  name: formGroup
  doctype: ~
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
  examples: |
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
  aliases: ~
  family: layout
  export: yes
  filename: forms.R
  source: "formGroup <- function(label, input, help = NULL, ..., width = NULL) {\n
    \   if (!is_tag(input)) {\n        stop(\"invalid `formGroup()` argument, expecting
    `input` to be a tag element\", \n            call. = FALSE)\n    }\n    build
    <- column(width = width)\n    extra <- if (build$attribs$class != \"col\") {\n
    \       sub(\"^col\\\\s+\", \"\", build$attribs$class)\n    }\n    width <- ensureBreakpoints(width,
    c(1:12, \"auto\"))\n    classes <- createResponsiveClasses(width, \"col\")\n    tags$div(class
    = collate(\"form-group\", classes), label, input, \n        if (!is.null(help))
    {\n            tags$small(class = \"form-text text-muted\", help)\n        },
    include(\"core\"))\n}"
---
