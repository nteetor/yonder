---
layout: page
slug: padding
roxygen:
  rdname: ~
  name: padding
  doctype: ~
  title: Tag element margin and padding
  description: |-
    Use the `margin()` and `padding()` utilities to change the margin or padding
    of a tag element.  The margin of a tag element is the space outside and
    around the tag element, its border, and its content.  The padding of a tag
    element is the space between the tag element's border and its content or
    child elements.
  parameters:
  - name: .tag
    description: A tag element.
  - name: top
    description: |-
      A [responsive] argument. One of `0:5` or `"auto"`. 0 removes all
        space and 5 adds the most space.

        If an **unnamed** value is passed as `top` `margin()` and `padding()` will
        apply the spcified spacing to **all** sides.
  - name: right,bottom,left
    description: |-
      A [responsive] argument. One of `0:5` or `"auto"`. 0
      removes all space and 5 adds the most space.
  sections:
  - title: Centering an element
    content: |-
      In most modern browsers you want to horizontally center a tag element
      using the [flex] layout. Alternatively, you can horizontally center an element
      using `margin(<TAG>, right = "auto", left = "auto")`.
      ```
      div("Nam a sapien. Integer placerat tristique nisl.") %>%
        width(50) %>%
        height(25) %>%
        margin(top = 2, r = "auto", b = 2, l = "auto") %>%
        padding(3) %>%
        background("amber")
      )
      ```
  - title: Building an inline form
    content: |-
      Inline form elements automatically use of the flex layout providing you a
      means of creating condensed sets of inputs. However you may need to adjust
      the spacing of the form's child elements.
      Here is an inline form without any additional spacing applied.
      ```
      formInput(
        id = NULL,
        inline = TRUE,
        textInput(id = NULL, placeholder = "Sam Vimes"),
        groupInput(id = NULL, right = "@", placeholder = "Username"),
        checkboxInput(id = NULL, choice = "Remember me")
        )
      )
      ```
      Not great. But, with some styling we can make this form sparkle. Notice
      we are also adjusting the default submit button added to the form input.
      ```
      formInput(
        id = NULL,
        inline = TRUE,
        textInput(id = NULL, placeholder = "Sam Vimes") %>%
          margin(r = c(sm = 2), b = 2),
        groupInput(id = NULL, right = "@", placeholder = "Username") %>%
          margin(r = c(sm = 2), b = 2),
        checkboxInput(id = NULL, choice = "Remember me") %>%
          margin(r = c(sm = 2), b = 2),
        submit = submitInput() %>%
          margin(b = 2)
      )
      ```
      Now we're cooking with gas!
  examples:
  - |-
    padding(div(), c(xs = 0, sm = 2, lg = 4))

    margin(div(), right = c(md = "auto"))

    margin(div(), bottom = 3, left = 1)
  - |
    div(
      div() %>%
        margin(4) %>%
        padding(4) %>%
        background("grey") %>%
        border()
    )
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source: "padding <- function(.tag, top = NULL, right = NULL, bottom = NULL, \n    left
    = NULL) {\n    possibles <- c(0:5, \"auto\")\n    this <- sys.call()\n    if (all(re(names2(this),
    \"\\\\.tag|\")) && length(this) == 3) {\n        all <- tryCatch(ensureBreakpoints(top,
    possibles), error = function(e) stop(\"invalid call to `padding()`, unexpected
    argument value \", \n            top, call. = FALSE))\n        classes <- createResponsiveClasses(all,
    \"p\")\n        return(tagAddClass(.tag, classes))\n    }\n    top <- ensureBreakpoints(top,
    possibles)\n    right <- ensureBreakpoints(right, possibles)\n    bottom <- ensureBreakpoints(bottom,
    possibles)\n    left <- ensureBreakpoints(left, possibles)\n    classes <- c(createResponsiveClasses(top,
    \"t\"), createResponsiveClasses(right, \n        \"r\"), createResponsiveClasses(bottom,
    \"b\"), createResponsiveClasses(left, \n        \"l\"))\n    if (!is.null(classes))
    {\n        classes <- paste0(\"p\", classes)\n    }\n    tagAddClass(.tag, classes)\n}"
---
