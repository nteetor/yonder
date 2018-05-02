---
layout: page
slug: wrap
roxygen:
  rdname: ~
  name: wrap
  doctype: ~
  title: Wrapping flex items
  description: |-
    This function applies bootstrap classes to a tag element to change how the
    element's flex items wrap or do not wrap. By default items will not wrap
    onto new lines. See the *Wrapping* section below for more information on
    the possible wrapping behaviors.
  parameters:
  - name: tag
    description: A tag element.
  - name: default
    description: |-
      One of `"nowrap"`, `"wrap"`, or `"reverse"` specifying how the
      flex items of an element wrap.
  - name: sm
    description: |-
      Like `default`, but the wrapping behavior is applied once the
      viewport is 576 pixels wide, think phone in landscape mode.
  - name: md
    description: |-
      Like `default`, but the wrapping behavior is applied once the
      viewport is 768 pixels wide, think tablets.
  - name: lg
    description: |-
      Like `default`, but the wrapping behavior is applied once the
      viewport is 992 pixels wide, think desktop.
  - name: xl
    description: |-
      Like `default`, but the wrapping behavior is applied once the
      viewport is 1200 pixels wide, think large desktop.
  sections:
  - - 'Wrapping:'
    - |-
      **`"nowrap"`**, flex items do not wrap onto a new line and will extend
      beyond the boundaries of the parent element. This is the browser default.
    - |-
      ```
      | Item | Item | Item | Item | Item | Item |
      | 1    | 2    | 3    | 4    | 5    | 6    |
      ```
    - '**`"wrap"`**, flex items will wrap onto a new line.'
    - |-
      ```
      | Item 1 | Item 2 | Item 3 | Item 4 | === |
      | Item 5 | Item 6 | ===================== |
      ```
    - |-
      **`"reverse"`**, rows of flex items appear in reverse order wrapping from the
      bottom of the parent element up.
    - |-
      ```
      | Item 5 | Item 6 | ===================== |
      | Item 1 | Item 2 | Item 3 | Item 4 | === |
      ```
  examples: |
    # Make sure to try resizing the browser or viewer window after running
    # the following examples.

    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              tags$p("No wrap") %>%
                font(style = "italics"),
              lapply(
                1:15,
                . %>%
                  paste("Flex item", .) %>%
                  tags$div() %>%
                  width(25) %>%
                  border()
              ) %>%
                tags$div() %>%
                width(100) %>%
                display("flex")
            )
          )
        ),
        server = function(input, output) {

        }
      )
    }

    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              tags$p("wrap") %>%
                font(style = "italics"),
              lapply(
                1:15,
                . %>%
                  paste("Flex item", .) %>%
                  tags$div() %>%
                  width(25) %>%
                  border()
              ) %>%
                tags$div() %>%
                width(100) %>%
                display("flex") %>%
                wrap("wrap")
            )
          )
        ),
        server = function(input, output) {

        }
      )
    }
  aliases: ~
  family: flex
  export: yes
  filename: flex.R
  source: "wrap <- function(tag, default = NULL, sm = NULL, md = NULL, lg = NULL,
    \n    xl = NULL) {\n    args <- dropNulls(list(default = default, sm = sm, md
    = md, \n        lg = lg, xl = xl))\n    args <- lapply(args, function(a) switch(a,
    reverse = \"wrap-reverse\", \n        a))\n    classes <- responsives(\"flex\",
    args, c(\"wrap\", \"nowrap\", \n        \"wrap-reverse\"))\n    tagAddClass(tag,
    collate(classes))\n}"
---
