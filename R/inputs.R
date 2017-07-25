textualInput <- function(value, placeholder, id, type, ...) {
  tags$input(
    class = collate(
      "dull-textual",
      "dull-input",
      "form-control"
    ),
    type = type,
    value = value,
    placeholder = placeholder,
    ...,
    id = id
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
textInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  textualInput(value, placeholder, id, "text", ...)
}

#' @rdname textInput
#' @export
searchInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  textualInput(value, placeholder, id, "search", ...)
}

#' @rdname textInput
#' @export
emailInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  textualInput(value, placeholder, id, "email", ...)
}

#' @rdname textInput
#' @export
urlInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  textualInput(value, placeholder, id, "url", ...)
}

#' @rdname textInput
#' @export
telephoneInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  textualInput(value, placholder, id, "tel", ...)
}

#' @rdname textInput
#' @export
passwordInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  textualInput(value, placeholder, id, "password", ...)
}

#' @rdname textInput
#' @export
numberInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  textualInput(value, placeholder, id, "number", ...)
}

# @rdname textInput
# @export
dateInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  textualInput(value, placeholder, id, "date", ...)
}

# @rdname textInput
# @export
datetimeInput <- function(value = NULL, placeholder = NULL,  ..., id = NULL) {
  textualInput(
    value, placeholder, id, if (time) "datetime-local" else "date", ...
  )
}

# @rdname textInput
# @export
monthInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  textualInput(value, placeholder, id, "month", ...)
}

# @rdname textInput
# @export
weekInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  textualInput(value, placeholder, id, "week", ...)
}

# @rdname textInput
# @export
timeInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  textualInput(value, placeholder, id, "time", ...)
}

#' @rdname textInput
#' @export
colorInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  textualInput(value, placeholder, id, "color", ...)
}

#' Visually group and label inputs
#'
#' Use `fieldset` to associate inputs. Good for screen readers and other
#' assitive technologies.
#'
#' @param id A character string specifying the id of the fieldset, defaults to
#'  `NULL`. Specifying an id is only necessary when using `updateFieldset` to
#'  disable or enable the inputs within the fieldset.
#'
#' @param legend A character string specifying a label for fieldset, defaults to
#'   `NULL`.
#'
#' @param disabled If `TRUE`, all inputs within the fieldset are rendered in a
#'   disabled state, defaults to `FALSE`.
#'
#' @param ... Inputs to put within the fieldset or additional named arguments
#'   passed as HTML attributes to the parent element.
#'
#' @export
#' @examples
#'
#' stub
#'
fieldset <- function(..., legend = NULL, disabled = FALSE, id = NULL) {
  tags$fieldset(
    class = "dull-fieldset",
    tags$legend(legend),
    ...,
    id = id
  )
}

updateFieldset <- function() {
  # STUB, needs to be worked on
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
#'         button(
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
    value = value,
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
#' @param left,right A character string, [button] element, or [dropdown]
#'   element, used as the left or right addon, respectively, of the input group,
#'   both default to `NULL`. Addon's affect the reactive events and value of the
#'   input group, see the details section below for more information.
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
#' [button] or [dropdownItem].
#'
#' @family inputs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       groupInput(
#'         id = "nearlytext"
#'       ),
#'       groupInput(
#'         id = "username",
#'         placeholder = "username",
#'         left = "@@",
#'         right = button(
#'           label = "Go!",
#'           value = "go"
#'         )
#'       ),
#'       groupInput(
#'         id = "github",
#'         left = "https://github.com/"
#'       ),
#'       groupInput(
#'         id = "preference",
#'         left = button(
#'           label = fontAwesome("thumbs-up"),
#'           value = "up"
#'         ),
#'         right = button(
#'           label = fontAwesome("thumbs-down"),
#'           value = "down"
#'         )
#'       ),
#'       groupInput(
#'         id = "options",
#'         placeholder = "",
#'         left = dropdown(
#'           label = "Action",
#'           dropdownItem("Action", "action"),
#'           dropdownItem("Another action", "another"),
#'           dropdownItem("Something else", "something"),
#'           dropdownDivider(),
#'           dropdownItem("Final", "final")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         print(input$nearlytext)
#'       })
#'
#'       observe({
#'         print(input$username)
#'       })
#'
#'       observe({
#'         print(input$github)
#'       })
#'
#'       observe({
#'         print(input$preference)
#'       })
#'
#'       observe({
#'         print(input$options)
#'       })
#'     }
#'   )
#' }
#'
groupInput <- function(placeholder = NULL, value = NULL, left = NULL,
                       right = NULL, ..., id = NULL) {
  if (!is.null(left) && !is.character(left) && !tagIs(left, "button") &&
      !tagHasClass(left, "dull-dropdown")) {
    stop(
      "invalid `groupInput` argument, `left` must be a character string, ",
      "button(), or dropdown()",
      call. = FALSE
    )
  }

  if (!is.null(right) && !is.character(right) && !tagIs(right, "button") &&
      !tagHasClass(right, "dull-dropdown")) {
    stop(
      "invalid `groupInput` argument, `right` must be a character string, ",
      "button(), or dropdown()",
      call. = FALSE
    )
  }

  tags$div(
    class = "dull-input-group input-group",
    if (!is.null(left)) {
      tags$span(
        class = if (is_tag(left)) "input-group-btn" else "input-group-addon",
        left
      )
    },
    textInput(
      value = value,
      placeholder = placeholder
    ),
    if (!is.null(right)) {
      tags$span(
        class = if (is_tag(right)) "input-group-btn" else "input-group-addon",
        right
      )
    },
    ...,
    id = id
  )
}
