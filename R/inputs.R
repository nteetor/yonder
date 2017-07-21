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
#' @param type A character string specifying the type of the text input, a
#'   specific type may be used when appropriate, e.g. when `type = "password"`
#'   the input's value is obscured, displays as asterisks. See `Details` for
#'   possible `type` values.
#'
#' @aliases search email url telephone password number datetime date month week
#'   time color
#'
#' @details
#'
#' ** `text` values **
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
#' @name text
textInput <- function(value = NULL, placeholder = NULL, ..., id = NULL) {
  # searchInput
  # emailInput
  # urlInput
  # telephoneInput
  # passwordInput
  # numberInput
  # datetimeInput
  # dateInput
  # monthInput
  # weekInput
  # timeInput
  # colorInput

  # if (!re(type, "text|search|email|url|tel|password|number|datetime|date|month|week|time|color")) {
  #   stop(
  #     'invalid `` argument, see ?text for valid `type` values',
  #     call. = FALSE
  #   )
  # }

  tags$input(
    class = collate(
      paste0("dull-", type),
      "dull-input form-control"
    ),
    type = "text",
    value = value,
    placeholder = placeholder,
    ...,
    id = id
  )
}

#' Visually group and label inputs
#'
#' Use `input$fieldset` to associate inputs. Good for screen readers and other
#' assitive technologies.
#'
#' @param id A character string specifying the id of the fieldset, defaults to
#'  `NULL`. Specifying an id is only necessary when using `updateFieldset` to
#'  disable or enable the inputs contained in the fieldset.
#'
#' @param legend A label for the associated inputs or a custom tag, defaults to
#'   `NULL`.
#'
#' @param disabled If `TRUE`, all inputs within the fieldset are rendered in a
#'   disabled state, defaults to `FALSE`.
#'
#' @param ... Inputs to group or additional named arguments passed as HTML
#'   attributes to the parent `<fieldset>` element.
#'
#' @export
#' @examples
#'
#' stub
#'
fieldset <- function(..., legend = NULL, disabled = FALSE, id = NULL) {
  tags$fieldset(
    if (is_tag(legend)) {
      legend
    } else if (!is.null(legend)) {
      tags$legend(legend)
    },
    ...,
    id = id
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
#'   library(shiny)
#'
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
    class = "dull-select dull-input custom-select",
    ...
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
#'   library(shiny)
#'
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
      "button element, or dropdown element",
      call. = FALSE
    )
  }

  if (!is.null(right) && !is.character(right) && !tagIs(right, "button") &&
      !tagHasClass(right, "dull-dropdown")) {
    stop(
      "invalid `groupInput` argument, `right` must be a character string, ",
      "button element, or dropdown element",
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
