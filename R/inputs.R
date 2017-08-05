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

#' Group inputs, combination button, dropdown, and text input
#'
#' A group input is a combination reactive input which may consist of one or two
#' buttons, dropdowns, static addons, or any combination of these elements.
#' Static addons, specified with `left` and `right` may be used to ensure an
#' group input's reactive value always has a certain prefix or suffix. These
#' static addons render with a shaded background to help indicated this behavior to the user.
#' Buttons and dropdowns may be included to control when the group input's
#' reactive value updates. See Details for more information.
#'
#' @param id A character string specifying the id of the group input.
#'
#' @param placeholder A character string specifying placeholder text for the
#'   input group, defaults to `NULL`.
#'
#' @param value A character string specifying an initial value for the input
#'   group, defaults to `NULL`.
#'
#' @param left,right A character vector specifying static addons or
#'   [buttonInput] or [dropdownInput] elements specifying dynamic addons.
#'   Addon's affect the reactive value of the group input, see the Details
#'   section below for more information.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   parent element.
#'
#' @details
#'
#' ** `left` is character or `right` is character **
#'
#' If `left` or `right` are character vectors, then the group input functions
#' like a text input. The value will update and trigger a reactive event when
#' the text box is modified. The group input's reactive value is the
#' concatention of the static addons specified by `left` or `right` and the
#' value of the text input.
#'
#' ** `left` is button or `right` is button **
#'
#' The button does not change the value of the group input. However, the input
#' no longer triggers event when the text box is updated. Instead the value
#' is updated when a button is clicked. Static addons are still applied to the
#' group input value.
#'
#' ** `left` is a dropdown or `right` is a dropdown **
#'
#' The value of the group input does chance depending on the clicked dropdown
#' menu item. The value of the input group is the concatentation of the
#' dropdown input value, the value of the text input, and any static addons.
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
#'             id = "buttongroup",
#'             left = "@",
#'             placeholder = "Username"
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
#'         input$buttongroup
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
#'             placeholder = "Search terms",
#'             right = buttonInput(
#'               id = "button",
#'               label = "Go!"
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
#'               title = "Title",
#'               labels = c("Mrs.", "Miss", "Mr.", "none"),
#'               values = c("Mrs. ", "Miss ", "Mr. ", "")
#'             ),
#'             placeholder = "First name",
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
        lapply(left, function(l) tags$span(class = "input-group-addon left-addon", l))
      } else {
        tags$span(
          class = "input-group-btn left-group",
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
        lapply(right, function(r) tags$span(class = "input-group-addon right-addon", r))
      } else {
        tags$span(
          class = "input-group-btn right-group",
          right
        )
      }
    }
  )
}
