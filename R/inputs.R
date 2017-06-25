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
  textualInput("text", label, value, placeholder, ..., class = "dull-text")
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

inputs$telephone <- function(label = NULL, ...) {
  textualInput("tel", ...)
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
      class = "form-control",
      type = type,
      value = value,
      placeholder = placeholder,
      ...
    )
  )
}

# #
# #' @param side A character vector specifying on which side of the input to place
# #'   the addon.
# #'
# #' @param
# #' @rdname textual
# #' @export
# addon <- function(side = "left", ) {
#
# }

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
#' @details
#'
#' Explain textual checkbox.
#'
#' @name checkbox
#' @examples
#'
#'
inputs$checkbox <- function(name = NULL, value = NULL, label = NULL, ...) {
  tags$label(
    class = "dull-checkbox custom-control custom-checkbox",
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
  attrs <- args[elodin(args) != ""]
  content <- args[elodin(args) == ""]

  ir <- tags$div(
    class = collate(
      "dull-radios form-group",
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
            checked = if (elodin(values[i]) == "checked") NA
          ),
          tags$span(class = "custom-control-indicator"),
          tags$span(
            class = "custom-control-description",
            labels[[i]]
          )
        )
      }
    ),
    content,
    bootstrap()
  )

  ir$attribs <- c(ir$attribs, attrs)
  ir
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
    class = "custom-select",
    lapply(
      seq_along(labels),
      function(i) {
        lab <- labels[i]
        val <- values[i]

        tags$option(
          value = val,
          selected = if ("selected" %in% c(elodin(lab), elodin(val))) NA,
          lab
        )
      }
    )
  )
}

updateFormGroup <- function(id, context = NULL, session = getDefaultReactiveDomain()) {
  if (!(context %in% c("success", "warning", "danger"))) {
    stop(
      '`updateCheckbox` argument `context` must be one "success", "warning", or "danger"',
      call. = FALSE
    )
  }

  if (!is.null(context)) {
    session$sendInputMessage(id, list(context = paste0("has-", context)))
  }
}
