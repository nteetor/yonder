#' Form inputs
#'
#' @description
#'
#' Form inputs are a new reactive input. Form inputs are an alternative to
#' shiny's submit buttons. A form input is comprised of any number of
#' inputs. The value of these inputs will not change until the form input's
#' submit input is clicked. A form input's reactive value also depends on the
#' submit input. This allows you to distinguish between different clicks if
#' your form includes multiple submit inputs.
#'
#' A submit input is a special type of button used to control form input
#' submission. Because of their specific usage, submit inputs do not require an
#' `id`, but may have a specified `value`. Submit inputs will _not_ freeze all
#' reactive inputs, see [formInput()].
#'
#' If `id` or `submit` are `NULL` the form input will not freeze its child
#' inputs.
#'
#' @inheritParams buttonInput
#'
#' @param ... Any number of unnamed arguments (inputs or tag elements) passed as
#'   child elements to the form.
#'
#'   Additional named arguments passed as HTML attributes to the parent element.
#'
#' @param submit A button input, when clicked the form input will update its
#'   reactive child inputs, defaults to `buttonInput(NULL, "Submit")`.
#'
#' @param inline One of `TRUE` or `FALSE`, if `TRUE` the form and its child
#'   elements are rendered in a horizontal row, defaults to `FALSE`. On small
#'   viewports, think mobile device, `inline` intentionally has no effect and
#'   the form will span multiple lines.
#'
#' @details
#'
#' When `inline` is `TRUE` you may want to adjust the right margin of each child
#' element for viewports larger than mobile, `margin(<TAG>, right = c(sm = 2))`,
#' more information at [margin()]. You only need to apply extra space for larger
#' viewports because inline forms do not take effect on small viewports.
#'
#' @section Frozen inputs with scope:
#'
#' ```R
#' ui <- container(
#'   formInput(
#'     id = "form",
#'     formGroup(
#'       label = "Email",
#'       emailInput(
#'         id = "email"
#'       )
#'     ),
#'     formGroup(
#'       label = "Password",
#'       passwordInput(
#'         id = "password"
#'       )
#'     )
#'   )
#' )
#'
#' server <- function(input, output) { }
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
#'     id = NULL,
#'     formGroup(
#'       label = "Ice creams",
#'       radioInput(
#'         id = "flavorChoice",
#'         choices = c("Mint", "Moose tracks", "Marble"),
#'       )
#'     ),
#'     submit = buttonInput(  # <-
#'       id = NULL,
#'       label = "Make choice"
#'     ) %>%
#'       background("teal")
#'   )
#' ) %>%
#'   border("teal") %>%
#'   width(50)
#'
formInput <- function(id, ..., submit = buttonInput(NULL, "Submit"),
                      inline = FALSE) {
  assert_id()

  if (!tag_class_re(submit, "yonder-button")) {
    stop(
      "invalid `formInput()` argument, `submit` must be a button input",
      call. = FALSE
    )
  }

  shiny::registerInputHandler(
    type = "yonder.form",
    fun = function(x, session, name) {
      if (length(x) > 0) x[[2]]
    },
    force = TRUE
  )

  submit <- tag_class_add(submit, "yonder-form-submit")

  component <- tags$form(
    class = str_collate(
      "yonder-form",
      if (inline) "form-inline"
    ),
    id = id,
    ...,
    submit
  )

  attach_dependencies(component)
}

#' Add labels, help text, and formatting to inputs
#'
#' Form groups are a way of labelling an input. Form rows are similar to
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
#' @param width A [responsive] argument. One of `1:12` or "auto" specifying a
#'   column width for the form group, defaults to `NULL`.
#'
#' @family layout
#' @export
#' @examples
#'
#' ## Grid layout forms
#'
#' # Use responsive arguments to adjust form layouts based on viewport size.
#' # Be sure to adjust the size of your browser window between large and small.
#'
#' card(
#'   formRow(
#'     formGroup(
#'       width = c(md = 6),  # <-
#'       label = "Email",
#'       emailInput(
#'         id = "email",
#'         placeholder = "e@@mail.com"
#'       )
#'     ),
#'     formGroup(
#'       width = c(md = 6),  # <-
#'       label = "Password",
#'       passwordInput(
#'         id = "password",
#'         placeholder = "123456"
#'       ),
#'       help = "Please consider something better than 123456"
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
  if (!is_tag(input) && !is_strictly_list(input)) {
    stop(
      "invalid `formGroup()` argument, `input` must be a tag element or list",
      call. = FALSE
    )
  }

  build <- column(width = width)

  if (build$attribs$class != "col") {
    build$attribs$class <- sub("^col\\s+", "", build$attribs$class)
  }

  width <- resp_construct(width, c(1:12, "auto"))
  classes <- resp_classes(width, "col")

  component <- tags$div(
    class = str_collate(
      "form-group",
      classes
    ),
    ...,
    tags$label(label),
    input,
    if (!is.null(help)) {
      tags$small(
        class = "form-text text-muted",
        help
      )
    }
  )

  attach_dependencies(component)
}

#' @rdname formGroup
#' @export
formRow <- function(...) {
  attach_dependencies(
    tags$div(class = "form-row", ...)
  )
}
