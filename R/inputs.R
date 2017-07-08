#' Inputs
#'
#' Form control inputs.
#'
#' @param label A character vector specifying a label for the input, defaults to
#'   `NULL`. If a label is specified it is advised, though not necessary, to
#'   also specify an `id` for the input.
#'
#' @param ... Named arguments passed as HTML attributes to the input. Specify
#'   `value` to give the input a default value. Specify `placeholder` to give
#'   the input hint text about the expected value of the input.
#'
#' @format NULL
#' @export
#' @examples
#'
inputs <- list()

#' Textual Inputs
#'
#' description
#'
#' @usage
#'
#' inputs$text(label = NULL, ...)
#'
#' @param label Input label.
#'
#' @param value Input value.
#'
#' @param placeholder Input placeholder text.
#'
#' @param toggleable If `TRUE`, a checkbox is included as part of the input,
#'   when unchecked the value of the input is always `NULL`, defaults to
#'   `FALSE`.
#'
#' @aliases search email url telephone password number datetime date month week
#'   time color
#'
#' @name text
inputs$text <- function(label = NULL, value = NULL, placeholder = NULL, ...) {
  textualInput("text", label, value, placeholder, ...)
}

inputs$search <- function(label = NULL, value = NULL, placeholder = NULL, ...) {
  textualInput("search", ...)
}

inputs$email <- function(label = NULL, ...) {
  textualInput("email", ...)
}

inputs$url <- function(label = NULL, ...) {
  textualInput("url", ...)
}

inputs$telephone <- function(label = NULL, value = NULL, placeholder = NULL, ...) {
  textualInput("tel", label, value, placeholder, ...)
}

inputs$password <- function(label = NULL, ...) {
  textualInput("password", ...)
}

inputs$number <- function(label = NULL, ...) {
  textualInput("number", ...)
}

inputs$datetime <- function(label = NULL, ...) {
  textualInput("datetime-local", ...)
}

inputs$date <- function(label = NULL, ...) {
  textualInput("date", label, NULL, NULL, ...)
}

inputs$month <- function(label = NULL, ...) {
  textualInput("month", ...)
}

inputs$week <- function(label = NULL, ...) {
  textualInput("week", ...)
}

inputs$time <- function(label = NULL, ...) {
  textualInput("time", ...)
}

inputs$color <- function(label = NULL, ...) {
  textualInput("color", ...)
}

textualInput <- function(type, label, value, placeholder, ...) {
  args <- list(...)

  htmltools::tagList(
    if (!is.null(label)) {
      tags$label(
        `for` = args$id,
        label
      )
    },
    tags$input(
      class = collate(
        paste0("dull-", type),
        "dull-input form-control"
      ),
      type = type,
      value = value,
      placeholder = placeholder,
      ...
    )
  )
}

#' Fieldset, grouping inputs
#'
#' Use `input$fieldset` to associate inputs. Good for screen readers and other
#' assitive technologies.
#'
#' @usage
#'
#' inputs$fieldset(legend = NULL, ...)
#'
#' @param legend A label for the associated inputs or a custom tag, defaults to
#'   `NULL`.
#'
#' @param disabeld If `TRUE`, all inputs within the fieldset are rendered in a
#'   disabled state, defaults to `FALSE`.
#'
#' @param ... Inputs to group or additional named arguments passed as HTML
#'   attributes to the parent `<fieldset>` element.
#'
#' @name fieldset
inputs$fieldset <- function(..., legend = NULL, disabled = FALSE) {
  tags$fieldset(
    if (is_tag(legend)) {
      legend
    } else if (!is.null(legend)) {
      tags$legend(legend)
    },
    ...
  )
}

#' Checkboxes
#'
#' Checkbox input.
#'
#' @param name Checkbox name.
#'
#' @param value The checkbox value.
#'
#' @param label The checkbox label.
#'
#' @param id A character string specifying the HTML id of a checkbox input to
#'   update.
#'
#' @param context One of `"success"`, `"warning"`, or `"danger"`, specifying
#'   a visual context for the checkbox.
#'
#' @name checkbox
#' @examples
#'
#'
inputs$checkbox <- function(name = NULL, value = NULL, label = NULL, ...) {
  tags$div(
    class = "form-group",
    tags$label(
      class = "dull-checkbox dull-input custom-control custom-checkbox",
      tags$input(
        class = "custom-control-input",
        type = "checkbox",
        name = name,
        value = value
      ),
      tags$span(class = "custom-control-indicator"),
      tags$span(
        class = "custom-control-description",
        label
      ),
      ...,
      bootstrap()
    )
  )
}

#' @rdname checkbox
updateCheckbox <- function(id, context, session = getDefaultReactiveDomain()) {
  if (!(context %in% c("success", "warning", "danger"))) {
    stop(
      'invalid `updateCheckbox` argument, `context` must be one "success", ',
      '"warning", or "danger"',
      call. = FALSE
    )
  }

  session$sendInputMessage(
    id,
    list(
      context = paste0("has-", context)
    )
  )
}

#' Radios
#'
#' Create an input of one or more radio inputs. If an `id` parameter is
#' specified the `name` attribute of each child radio element is given this
#' value.
#'
#' @usage
#'
#' inputs$radios(labels = NULL, values = NULL, ...)
#'
#' @param labels A list or character vectors of labels for each of the
#'   individual radio elements, defaults to `NULL`.
#'
#' @param values A list or vector of values for each of the individual radio
#'   elements, one value may be named `checked` to indicate a default value for
#'   the element, defaults to `NULL`.
#'
#' @param stacked If `TRUE` the radio elements appear on sepearate lines,
#'   defaults to `FALSE`, in which case the radio elements are rendered inline.
#'
#' @param ... Additional named arguments passed on to the parent element as
#'   HTML attributes.
#'
#' @aliases radio
#' @name radios
#' @examples
#'
inputs$radios <- function(labels = NULL, values = NULL, stacked = FALSE, ...) {
  if (length(labels) != length(values)) {
    stop(
      "`inputs$radios` arguments `labels` and `values` must be the same length",
      call. = FALSE
    )
  }

  args <- list(...)
  attrs <- attribs(args)

  tagConcatAttributes(
    tags$div(
      class = collate(
        "dull-radios dull-input form-group",
        if (stacked) "custom-controls-stacked"
      ),
      lapply(
        seq_along(labels),
        function(i) {
          tags$label(
            class = "custom-control custom-radio",
            tags$input(
              class = "custom-control-input",
              type = "radio",
              name = attrs$id,
              value = values[[i]],
              checked = if (names2(values[i]) == "checked") NA
            ),
            tags$span(class = "custom-control-indicator"),
            tags$span(
              class = "custom-control-description",
              labels[[i]]
            )
          )
        }
      ),
      ...,
      bootstrap()
    ),
    attrs
  )
}

# Name an argument "selected" otherwise the first item is the default value.
inputs$select <- function(labels, values) {
  if (length(labels) != length(values)) {
    stop(
      "`inputs$select` arguments `labels` and `value` must have the same length",
      call. = FALSE
    )
  }

  tags$select(
    class = "dull-select dull-input custom-select",
    lapply(
      seq_along(labels),
      function(i) {
        lab <- labels[i]
        val <- values[i]

        tags$option(
          value = val,
          selected = if ("selected" %in% c(names2(lab), names2(val))) NA,
          lab
        )
      }
    )
  )
}

#' Input group, buttons and text
#'
#' An input group is composite reactive input which may consist of one or two
#' buttons, dropdowns, character addons, or any combination of these elements.
#' Character addons, specified with `left` and `right` may be used to ensure an
#' input group's value always has a certain prefix or suffix and render a
#' visual cue to indicate this behavior. Buttons and dropdowns may be included
#' to control when the input group's reactive value updates. See below for more
#' information and examples.
#'
#' @param placeholder A character string specifying placeholder text for the
#'   input group, defaults to `NULL`.
#'
#' @param value A character string specifying an initial value for the input
#'   group, defaults to `NULL`.
#'
#' @param left,right A character string, [inputs$button] element, or [dropdown]
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
#' [inputs$button] or [dropdownItem].
#'
#' @aliases inputs$group
#' @name group
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       inputs$group(
#'         id = "nearlytext"
#'       ),
#'       inputs$group(
#'         id = "username",
#'         placeholder = "username",
#'         left = "@@",
#'         right = inputs$button(
#'           label = "Go!",
#'           value = "go"
#'         )
#'       ),
#'       inputs$group(
#'         id = "github",
#'         left = "https://github.com/"
#'       ),
#'       inputs$group(
#'         id = "preference",
#'         left = inputs$button(
#'           label = icons$fa("thumbs-up"),
#'           value = "up"
#'         ),
#'         right = inputs$button(
#'           label = "^", #icons$fa("thumbs-down"),
#'           value = "down"
#'         )
#'       ),
#'       inputs$group(
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
inputs$group <- function(placeholder = NULL, value = NULL, left = NULL,
                         right = NULL, ...) {
  if (!is.null(left) && !is.character(left) && !tagIs(left, "button") &&
      !tagHasClass(left, "dull-dropdown")) {
    stop(
      "invalid `inputs$group` argument, `left` must be a character string, ",
      "button element, or dropdown element",
      call. = FALSE
    )
  }

  if (!is.null(right) && !is.character(right) && !tagIs(right, "button") &&
      !tagHasClass(right, "dull-dropdown")) {
    stop(
      "invalid `inputs$group` argument, `right` must be a character string, ",
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
    inputs$text(
      value = value,
      placeholder = placeholder
    ),
    if (!is.null(right)) {
      tags$span(
        class = if (is_tag(right)) "input-group-btn" else "input-group-addon",
        right
      )
    },
    ...
  )
}
