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
  - name: default,sm,md,lg,xl
    description: |-
      These arguments are taken directly from [col()]
      because `formGroup`s can replicate column behaviour in order to build
      highly flexible forms. To best understand these arguments please refer to
      the `col` help page.
  sections: ~
  examples: |
    # to see this example in action adjust your browser window
    # from large to small, notice how the form elements expand?
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              md = 6,
              card(
                formRow(
                  formGroup(
                    md = 6,
                    label = "Email",
                    emailInput(
                      id = "email",
                      placeholder = "e@mail.com"
                    )
                  ),
                  formGroup(
                    md = 6,
                    label = "Password",
                    passwordInput(
                      id = "password",
                      placeholder = "123456"
                    ),
                    help = "Please consider something
                      better than 123456"
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
                margins(3) %>%
                background("grey", +2)
            ) %>%
              margins("auto")
          )
        ),
        server = function(input, output) {
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: forms.R
  source:
  - formGroup <- function(label, input, help = NULL, ..., default = NULL,
  - '                      sm = NULL, md = NULL, lg = NULL, xl = NULL) {'
  - '  if (!is_tag(input)) {'
  - '    stop('
  - '      "invalid `formGroup()` argument, expecting `input` to be a tag element",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  build <- col('
  - '    default = default, sm = sm, md = md, lg = lg,'
  - '    xl = xl'
  - '  )'
  - '  extra <- if (build$attribs$class != "col") {'
  - '    sub("^col\\s+", "", build$attribs$class)'
  - '  }'
  - '  tags$div('
  - '    class = collate("form-group", extra), label, input,'
  - '    if (!is.null(help)) {'
  - '      tags$small(class = "form-text text-muted", help)'
  - '    }, include("core")'
  - '  )'
  - '}'
---
