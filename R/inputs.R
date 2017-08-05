textualInput <- function(id, label, value, placeholder, type, ...) {
  tags$div(
    class = "dull-textual-input dull-input form-group row",
    id = id,
    tags$label(
      class = "col-sm-2 col-form-label",
      label
    ),
    tags$div(
      class = "col-sm-10",
      tags$input(
        class = "form-control",
        type = type,
        value = value,
        placeholder = placeholder
      )
    ),
    ...
  )
}

#' Inputs
#'
#' Form control inputs.
#'
#' @param id A character string specifying the id of the textual input, defaults
#'   to `NULL`. If specified, a reactive value is available to the shiny server
#'   function.
#'
#' @param label A character vector specifying a label for the input, defaults to
#'   `NULL`. If a label is specified it is advised, though not necessary, to
#'   also specify an `id` for the input.
#'
#' @param ... Named arguments passed as HTML attributes to the input. Specify
#'   `value` to give the input a default value. Specify `placeholder` to give
#'   the input hint text about the expected value of the input.
#'
#' @param placeholder A character string specifying placeholder text for the
#'   input, defaults to `NULL`.
#'
#' @details
#'
#' * text - Single-line text input, linebreaks are removed.
#' * search - Single-line text input for search strings, linebreaks are removed.
#' * email - Single-line text input for email addresses, validated to contain
#'   the empty string or a valid email address.
#' * url - Single-line text input for URLs, validated to contain the empty
#'   string or valid absolute URL.
#' * tel - Single-line text input for telephone numbers, syntax is not enforced.
#' * password - Single-line text input for password, value is obscured.
#' * number - Number picker.
#' * datetime - Date and time picker, no time zone.
#' * date - Year, month, and day picker, no time.
#' * month - Month and year picker, no time zone.
#' * week - Week of year picker.
#' * time - Time picker.
#' * color - Color picker.
#'
#' @family inputs
#' @export
#' @examples
#'
#' stub
#'
textInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placeholder, "text", ...)
}

#' @rdname textInput
#' @export
searchInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placeholder, "search", ...)
}

#' @rdname textInput
#' @export
emailInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placeholder, "email", ...)
}

#' @rdname textInput
#' @export
urlInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placeholder, "url", ...)
}

#' @rdname textInput
#' @export
telephoneInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placholder, "tel", ...)
}

#' @rdname textInput
#' @export
passwordInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placeholder, "password", ...)
}

#' @rdname textInput
#' @export
numberInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placeholder, "number", ...)
}

# @rdname textInput
# @export
dateInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placeholder, "date", ...)
}

# @rdname textInput
# @export
datetimeInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placeholder, "datetime-local", ...)
}

# @rdname textInput
# @export
monthInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placeholder, "month", ...)
}

# @rdname textInput
# @export
weekInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placeholder, "week", ...)
}

# @rdname textInput
# @export
timeInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placeholder, "time", ...)
}

#' @rdname textInput
#' @export
colorInput <- function(id, label, value = NULL, placeholder = NULL, ...) {
  textualInput(id, label, value, placeholder, "color", ...)
}

#' Group and label multiple inputs
#'
#' Use `fieldset` to associate and label inputs. Good for screen readers and
#' other assitive technologies.
#'
#' @param legend A character string specifying the fieldset's legend.
#'
#' @param ... Any number of inputs to group or named arguments passed as HTML
#'   attributes to the parent element.
#'
#' @export
#' @examples
#'
#' stub
#'
fieldset <- function(legend, ...) {
  if (!is.character(legend)) {
    stop(
      "invalid `fieldset` argument, `legend` must be a character string",
      call. = FALSE
    )
  }

  args <- list(...)
  attrs <- attribs(args)
  inputs <- elements(args)

  tagConcatAttributes(
    tags$fieldset(
      class = "form-group row",
      tags$legend(
        class = "col-form-legend col-sm-2",
        legend
      ),
      tags$div(
        class = "col-sm-10",
        inputs
      )
    ),
    attrs
  )
}

#' Select input
#'
#' A select input.
#'
#' @param id A character string specifying an id for the select input, defaults
#'   to `NULL`. When specified, a reactive value is available to the shiny
#'   server.
#'
#' @param label A character string specifying a label for the select input
#'   option, defaults to `NULL`.
#'
#' @param value A character string specifying a value for the select input
#'   option, defaults to `NULL`.
#'
#' @param selected If `TRUE`, the select option is selected when the page
#'   renders, defaults to `FALSE`.
#'
#' @family inputs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       formInline(
#'         label("Preference"),
#'         selectInput(
#'           id = "mySelect",
#'           option("Choose...", selected = TRUE),
#'           option("One", 1),
#'           option("Two", 2),
#'           option("Three", 3)
#'         ),
#'         checkboxInput(
#'           label = "Remember my preference"
#'         ),
#'         buttonInput(
#'           "Go!",
#'           context = "secondary"
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#'
#' }
#'
#'
selectInput <- function(..., id = NULL) {
  tags$select(
    class = collate(
      "dull-select-input",
      "dull-input",
      "custom-select"
    ),
    ...,
    id = id,
    bootstrap()
  )
}

#' @rdname selectInput
#' @export
option <- function(label = NULL, value = NULL, selected = FALSE) {
  tags$option(
    `data-value` = value,
    selected = if (selected) NA,
    label
  )
}

#' Group inputs, combination buttons and text
#'
#' An input group is composite reactive input which may consist of one or two
#' buttons, dropdowns, character addons, or any combination of these elements.
#' Character addons, specified with `left` and `right` may be used to ensure an
#' input group's value always has a certain prefix or suffix and render a
#' visual cue to indicate this behavior. Buttons and dropdowns may be included
#' to control when the input group's reactive value updates. See below for more
#' information and examples.
#'
#' @param id A character string specifying an id for the input, defaults to
#'   `NULL`. When specified, a reactive value, `input$<id>`, is available to the
#'   shiny server function.
#'
#' @param placeholder A character string specifying placeholder text for the
#'   input group, defaults to `NULL`.
#'
#' @param value A character string specifying an initial value for the input
#'   group, defaults to `NULL`.
#'
#' @param left,right A character string, [buttonInput] element, or
#'   [dropdownInput] element, used as the left or right addon, respectively, of
#'   the input group, both default to `NULL`. Addon's affect the reactive events
#'   and value of the input group, see the details section below for more
#'   information.
#'
#' @details
#'
#' **reactive event**
#'
#' If either `left` or `right` is a button or a dropdown the reactive value of
#' the input group is changed when either button or a dropdown item is clicked.
#' If either `left` and `right` are character strings or `NULL` the reactive
#' value of the input group will update each time the text input is changed by
#' the user.
#'
#' **input value**
#'
#' An input group's value is `NULL` when its text input is empty and neither,
#' if any, buttons or dropdown item's have been clicked. Otherwise, a input
#' group's value is list of two named elements. The first element is `value`
#' which is the concatenation of `left`, *if a character string*, the text input
#' value, and `right`, *if a character string*. The second element is `click`
#' and is indicates which button or dropdown item was clicked. The value of
#' `click` depends on the value of the button or dropdown item, see
#' [buttonInput] or [dropdownItem].
#'
#' @family inputs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           groupInput(
#'             id = "groupinput",
#'             left = "@",
#'             placeholder = "Username",
#'             class = "input-group-lg"
#'           )
#'         ),
#'         col(
#'           display4(
#'             textOutput("value")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderText({
#'         input$groupinput
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           groupInput(
#'             id = "groupinput",
#'             left = c("$", "0.00")
#'           )
#'         ),
#'         col(
#'           display4(
#'             textOutput("value")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderText({
#'         input$groupinput
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           groupInput(
#'             id = "groupinput",
#'             left = "@",
#'             placeholder = "Username",
#'             right = buttonInput(
#'               id = "right",
#'               label = "Search"
#'             )
#'           )
#'         ),
#'         col(
#'           display4(
#'             textOutput("value")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderText({
#'         input$groupinput
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           groupInput(
#'             id = "groupinput",
#'             left = dropdownInput(
#'               id = "dropdown",
#'               title = "Choose",
#'               labels = c("One", "Two")
#'             ),
#'             placeholder = "Username",
#'             right = "!"
#'           )
#'         ),
#'         col(
#'           display4(
#'             textOutput("value")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderText({
#'         input$groupinput
#'       })
#'     }
#'   )
#' }
#'
groupInput <- function(id, placeholder = NULL, value = NULL, left = NULL,
                       right = NULL, ...) {
  if (!is.null(left) && !is.character(left) && !tagIs(left, "button") &&
      !tagHasClass(left, "dull-dropdown-input")) {
    stop(
      "invalid `groupInput` argument, `left` must be a character string, ",
      "buttonInput(), or dropdownInput()",
      call. = FALSE
    )
  }

  if (!is.null(right) && !is.character(right) && !tagIs(right, "button") &&
      !tagHasClass(right, "dull-dropdown-input")) {
    stop(
      "invalid `groupInput` argument, `right` must be a character string, ",
      "buttonInput(), or dropdownInput()",
      call. = FALSE
    )
  }

  tags$div(
    class = "dull-group-input input-group",
    id = id,
    if (!is.null(left)) {
      if (is.character(left)) {
        lapply(left, function(l) tags$span(class = "input-group-addon", l))
      } else {
        tags$span(
          class = "input-group-btn",
          left
        )
      }
    },
    ...,
    tags$input(
      type = "text",
      class = "form-control",
      placeholder = placeholder,
      value = value
    ),
    if (!is.null(right)) {
      if (is.character(right)) {
        lapply(right, function(r) tags$span(class = "input-group-addon", r))
      } else {
        tags$span(
          class = "input-group-btn",
          right
        )
      }
    }
  )
}
