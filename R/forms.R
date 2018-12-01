#' Form inputs
#'
#' @description
#'
#' Form inputs are a new reactive input. Form inputs are an alternative to
#' shiny's submit buttons. A form input is comprised of any number of
#' inputs. The value of these inputs will not change until the form input's
#' submit button is clicked. A form input has no value.
#'
#' **Important** if `id` or `submit` are `NULL` the form input will not freeze
#' its child inputs. This can be useful if you want to use a `formInput()`
#' solely for page layout.
#'
#' @param ... Any number of unnamed arguments (inputs or tag elements) passed as
#'   child elements of the form.
#'
#' @param submit A submit button or tags containing a submit button. The submit
#'   button will trigger the update of input form elements. Defaults to
#'   [submitInput()].
#'
#' @param inline One of `TRUE` or `FALSE`, if `TRUE` the form and its child
#'   elements are rendered in a horizontal row, defaults to `FALSE`. On small
#'   viewports, think mobile device, `inline` has no effect and the form will
#'   span multiple lines.
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
#' @template input
#' @export
#' @examples
#'
#' ### Customizing the submit button
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
#'     submit = submitInput(  # <-
#'       label = "Make choice",
#'       block = TRUE
#'     ) %>%
#'       background("teal")
#'   )
#' ) %>%
#'   border("teal") %>%
#'   width(50)
#'
formInput <- function(id, ..., submit = submitInput(), inline = FALSE) {
  input <- tags$form(
    class = collate(
      "yonder-form",
      if (inline) "form-inline"
    ),
    id = id,
    ...,
    submit
  )

  input <- attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  input
}

#' Add labels, help text, and formatting to inputs
#'
#' Form groups are a way of labelling an input. Form rows are similar to
#' [row()]s, but include additional styles intended for forms. The flexibility
#' provided by form rows and groups means you can confidently develop shiny
#' applications for devices and screens of varying sizes.
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
#'     groupInput(
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
formGroup <- function(label, input, help = NULL,..., width = NULL) {
  if (!is_tag(input)) {
    stop(
      "invalid `formGroup()` argument, expecting `input` to be a tag element",
      call. = FALSE
    )
  }

  build <- column(width = width)

  extra <- if (build$attribs$class != "col") {
    sub("^col\\s+", "", build$attribs$class)
  }

  width <- ensureBreakpoints(width, c(1:12, "auto"))
  classes <- createResponsiveClasses(width, "col")

  this <- tags$div(
    class = collate(
      "form-group",
      classes
    ),
    tags$label(label),
    input,
    if (!is.null(help)) {
      tags$small(
        class = "form-text text-muted",
        help
      )
    }
  )

  this <- attachDependencies(
    this,
    bootstrapDep()
  )

  this
}

#' @rdname formGroup
#' @export
formRow <- function(...) {
  this <- tags$div(
    class = "form-row",
    ...
  )

  this <- attachDependencies(
    this,
    bootstrapDep()
  )

  this
}

#' Group and label multiple inputs
#'
#' Use `fieldset` to associate and label inputs. This is good for screen readers
#' and other assistive technologies.
#'
#' @param legend A character string specifying the fieldset's legend.
#'
#' @param ... Any number of inputs to group or named arguments passed as HTML
#'   attributes to the parent element.
#'
#' @family layout
#' @export
#' @examples
#'
#' ### Grouping related inputs
#'
#' fieldset(
#'   legend = "Pizza order",
#'   formGroup(
#'     "What toppings would you like?",
#'     div(
#'       checkbarInput(
#'         id = "toppings",
#'         choices = c(
#'           "Cheese",
#'           "Black olives",
#'           "Mushrooms"
#'         )
#'       )
#'     )
#'   ),
#'   formGroup(
#'     "Is this for delivery?",
#'     checkboxInput(
#'       id = "deliver",
#'       choice = "Deliver"
#'     )
#'   ),
#'   submitInput("Place order")
#' )
#'
fieldset <- function(..., legend = NULL) {
  if (!is.null(legend) && !is.character(legend)) {
    stop(
      "invalid `fieldset()` argument, `legend` must be a character string",
      call. = FALSE
    )
  }

  args <- list(...)
  attrs <- attribs(args)
  inputs <- elements(args)

  this <- tagConcatAttributes(
    tags$fieldset(
      class = "form-group",
      if (!is.null(legend)) {
        tags$legend(
          class = "col-form-legend",
          legend
        )
      },
      tags$div(
        inputs
      )
    ),
    attrs
  )

  this <- attachDependencies(
    this,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  this
}
