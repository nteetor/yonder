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
#' @param label A character string specifying a label for the input, defaults to
#'   `NULL`. If a label is specified it is advised, though not necessary, to
#'   also specify an `id` for the input.
#'
#' @param ... Additional named arguments passed as HTML attributes to the input.
#'
#' @param placeholder A character string specifying placeholder text for the
#'   input, defaults to `NULL`, in which case there is no placeholder text.
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
#' @param id A character string specifying the id of the select input.
#'
#' @param options A character vector specifying the labels of the select input
#'   options.
#'
#' @param values A character vector specifying the values of the select input
#'   options, defaults to `options`.
#'
#' @param selected One of `options` indicating the default value of the select
#'   input, defaults to `NULL`. If `NULL` the first value is selected by
#'   default.
#'
#' @param multiple If `TRUE` multiple options may be selected, defaults to
#'   `FALSE`, in which case only one option may be selected.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @family inputs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           selectInput(
#'             id = "select",
#'             options = c("Choose one", "One", "Two", "Three"),
#'             values = list(NULL, 1, 2, 3),
#'             multiple = TRUE
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
#'         input$select
#'       })
#'     }
#'   )
#' }
#'
#'
selectInput <- function(id, options, values = options, selected = NULL,
                        multiple = FALSE, ...) {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `selectInput` argument, `id` must be a character string or NULL",
      call. = FALSE
    )
  }

  if (length(options) != length(values)) {
    stop(
      "invalid `selectInput` arguments, `options` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  if (!is.null(selected)) {
    if (length(selected) > 1) {
      stop(
        "invalid `selectInput` argument, `selected` must be of length 1",
        call. = FALSE
      )
    }

    if (!(selected %in% options)) {
      stop(
        "invalid `selectInput` argument, `selected` must be one of `values`",
        call. = FALSE
      )
    }
  }

  selected <- match2(selected, values, default = TRUE)

  tags$select(
    class = collate(
      "dull-select-input",
      "dull-input",
      "custom-select",
      if (multiple) "h-100"
    ),
    id = id,
    lapply(
      seq_along(options),
      function(i) {
        tags$option(
          `data-value` = values[[i]],
          options[[i]],
          selected = if (selected[[i]]) NA
        )
      }
    ),
    ...,
    multiple = if (multiple) NA,
    bootstrap()
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
#'               label = "Title",
#'               choices = c("Mrs.", "Miss", "Mr.", "none"),
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
