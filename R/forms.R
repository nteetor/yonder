#' Form inputs
#'
#' @description
#'
#' Form inputs are a new reactive input. Form inputs are an alternative to
#' shiny's submit buttons. A form input is comprised of any number of inputs.
#' The value of these inputs will _not_ change until a form submit button within
#' the form input is clicked. A form input's reactive value depends on the
#' clicked form submit button. This allows you to distinguish between different
#' form submission types, think "login" versus "register".
#'
#' A form submit button, `formSubmit()`, is a special type of button used to
#' control form input submission. A form input and its child reactive inputs
#' will _never_ update if a form submit button is not included in `...` passed
#' to `formInput()`.
#'
#' @inheritParams checkboxInput
#'
#' @param ... Any number of unnamed arguments passed as child elements to the
#'   parent form element or named arguments passed as HTML attributes to the
#'   parent element. At least one `formSubmit()` must be included.
#'
#' @param inline One of `TRUE` or `FALSE`, if `TRUE` the form and its child
#'   elements are rendered in a horizontal row, defaults to `FALSE`. On small
#'   viewports, think mobile device, `inline` intentionally has no effect and
#'   the form will span multiple lines.
#'
#' @param label A character string specifying the label of the form submit
#'   button.
#'
#' @param value A character string specifying the value of the form submit
#'   button and the value of the form input when the button is clicked,
#'   defaults to `label`.
#'
#' @param submit One of `TRUE` or `FALSE` or a character string specifying
#'   whether to trigger a form submission, defaults to `FALSE`. If a character
#'   string, the form is submitted and the reactive value passed is the character
#'   string specified.
#'
#' @details
#'
#' When `inline` is `TRUE` you may want to adjust the right margin of each child
#' element for viewports larger than mobile, `margin(<TAG>, right = c(sm = 2))`,
#' see [margin()]. You only need to apply extra space for larger viewports
#' because inline forms do not take effect on small viewports.
#'
#' Use `updateFormInput()` to submit a form input. This will cause all the form's
#' child inputs to update.
#'
#' @section Frozen inputs with scope:
#'
#' ```R
#' ui <- container(
#'   formInput(
#'     id = "login",
#'     formGroup(
#'       label = "Username",
#'       textInput(
#'         id = "user"
#'       )
#'     ),
#'     formGroup(
#'       label = "Password",
#'       textInput(
#'         type = "password",
#'         id = "pass"
#'       )
#'     ),
#'     formSubmit(
#'       label = "Login",
#'       value = "login"
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   # Will not react until the form submit button is
#'   # clicked.
#'   observe({
#'     print(input$email)
#'     print(input$password)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### A simple form
#'
#' card(
#'   header = "Please pick a flavor",
#'   formInput(
#'     id = "form1",
#'     formGroup(
#'       label = "Ice creams",
#'       radioInput(
#'         id = "flavor",
#'         choices = c("Mint", "Moose tracks", "Marble"),
#'       )
#'     ),
#'     formSubmit("Make choice", "choice") %>%
#'       background("teal")
#'   )
#' ) %>%
#'   border("teal") %>%
#'   width(50)
#'
formInput <- function(id, ..., inline = FALSE) {
  assert_id()

  dep_attach({
    tags$form(
      class = str_collate(
        "yonder-form",
        if (inline) "form-inline"
      ),
      id = id,
      ...
    )
  })
}

#' @rdname formInput
#' @export
formSubmit <- function(label, value = label, ...) {
  dep_attach({
    tags$button(
      class = "yonder-form-submit btn btn-blue",
      value = value,
      label,
      ...
    )
  })
}

#' @rdname formInput
#' @export
updateFormInput <- function(id, submit = FALSE,
                            session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  if (!(is.logical(submit) || is.character(submit)) ||
        (is.character(submit) && length(submit) > 1)) {
    stop(
      "invalid argument in `updateFormInput()`, `submit` must be one of ",
      "TRUE or FALSE or a character string",
      call. = FALSE
    )
  }

  submit <- coerce_submit(submit)

  session$sendInputMessage(id, list(
    submit = submit
  ))
}

#' Input labels, help text, and formatting to inputs
#'
#' Form groups are a way of labeling an input. Form rows are similar to
#' [columns()]s, but include additional styles intended for forms. The
#' flexibility provided by form rows and groups means you can confidently
#' develop shiny applications for devices and screens of varying sizes.
#'
#' @param label A character string specifying a label for the input or `NULL`
#'   in which case a label is not added.
#'
#' @param input A tag element specifying the input to label.
#'
#' @param help A character string specifying help text for the input, defaults
#'   to `NULL`, in which case help text is not added.
#'
#' @param ... For **formGroup**, additional named arguments passed as HTML
#'   attributes to the parent element.
#'
#'   For **formRow**, any number of `formGroup`s or additional named arguments
#'   passed as HTML attributes to the parent element.
#'
#' @param width A [responsive] argument. One of `1:12`, `"content"`, or
#'   `"equal"` specifying a column width for the form group, defaults to `NULL`.
#'
#' @family layout
#' @export
#' @examples
#'
#' ### Grid layout forms
#'
#' # Use responsive arguments to adjust form layouts based on viewport size.
#' # Be sure to adjust the size of your browser window between large and small.
#'
#' card(
#'   formRow(
#'     formGroup(
#'       width = c(md = 6),  # <-
#'       label = "Username",
#'       textInput(
#'         id = "user"
#'       )
#'     ),
#'     formGroup(
#'       width = c(md = 6),  # <-
#'       label = "Password",
#'       textInput(
#'         type = "password",
#'         id = "pass"
#'       )
#'     )
#'   ),
#'   formGroup(
#'     label = "Username",
#'     groupTextInput(
#'       id = "username",
#'       left = "@@"
#'     )
#'   ),
#'   buttonInput(
#'     id = "go",
#'     label = "Go!"
#'   ) %>%
#'     background("blue")
#' ) %>%
#'   margin(3) %>%
#'   background("grey")
#'
formGroup <- function(label, input, ..., help = NULL, width = NULL) {
  assert_found(label)
  assert_found(input)

  if (!is_tag(input) && !is_strictly_list(input)) {
    stop(
      "invalid argument in `formGroup()`, `input` must be a tag element or list",
      call. = FALSE
    )
  }

  col_classes <- if (!is.null(width)) column(width = width)$attribs$class

  dep_attach({
    if (is_tag(label) && tag_name_is(label, "label")) {
      # do nothing
    } else {
      label <- tags$label(coerce_content(label))
    }

    if (is.character(help)) {
      help <- coerce_content(help)
    }

    tags$div(
      class = str_collate(
        "form-group",
        col_classes
      ),
      ...,
      label,
      input,
      if (!is.null(help)) {
        tags$small(
          class = "form-text text-muted",
          help
        )
      }
    )
  })
}

#' @rdname formGroup
#' @export
formRow <- function(...) {
  dep_attach({
    tags$div(class = "form-row", ...)
  })
}
