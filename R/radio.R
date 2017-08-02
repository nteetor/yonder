#' Radio inputs
#'
#' Create a reactive radio input of one or more radio controls.
#'
#' @param id A character string specifying the id of the radio input, the
#'   reactive value of the radio input is available to the shiny server
#'   function as part of the `input` object.
#'
#' @param labels A character vector specifying labels for the radio input's
#'   choices.
#'
#' @param values A character vector, list of character strings, vector of values
#'   to coerce to character strings, or list of values to coerce to character
#'   strings specifying the values of the radio input's choices.
#'
#' @param selected One of `values` indicating the default selected value of the
#'   radio input, defaults to `NULL`, in which case the first choice is
#'   selected by default.
#'
#' @param header A character string specifying a header for the radio input,
#'   defaults to `NULL`, in which case a header is not added.
#'
#' @param inline If `TRUE`, the radio input renders inline, defaults to `FALSE`,
#'   in which case the radio controls render on separate lines.
#'
#' @param state One of `"success"`, `"warning"`, or `"danger"` indicating the
#'   state of the radio input. If the return value is `NULL` any visual context
#'   is removed.
#'
#' @param hint A character string specifying hint text to accompany a change in
#'   the input's state, defaults to `NULL`. If `state` is `NULL` then `hint`
#'   is ignored.
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
#'           radioInput(
#'             id = "state",
#'             header = "Pick a state",
#'             labels = list("none", "success", "danger", "warning"),
#'             values = list(NULL, "success", "danger", "warning"),
#'             footer = "change the state of the other radio input"
#'           )
#'         ),
#'         col(
#'           radioInput(
#'             id = "choices",
#'             header = "More choices",
#'             labels = paste("Choice", 1:4),
#'             values = 1:4,
#'             footer = "These choices won't do anything yet"
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         validateRadioInput(
#'           id = "choices",
#'           state = input$state,
#'           hint = paste("visual", input$state)
#'         )
#'       })
#'     }
#'   )
#' }
#'
radioInput <- function(id, labels, values, selected = NULL, header = NULL,
                       footer = NULL, inline = FALSE) {
  if (!is.null(selected) && !(selected %in% values)) {
    stop(
      "invalid `radioInput` argument, `selected` must be one of `values`",
      call. = FALSE
    )
  }

  if (length(labels) != length(values)) {
    stop(
      "invalid `radioInput` arguments, `labels` and `values` must be the same ",
      "length",
      call. = FALSE
    )
  }

  if (is.null(selected)) {
    selected <- c(TRUE, vector("logical", length(labels) - 1))
  } else {
    selected <- vapply(
      values, function(v) if (is.null(v)) FALSE else (v == selected), logical(1)
    )
  }

  tags$div(
    class = collate(
      "dull-radio-input",
      "dull-input",
      "form-group",
      if (!inline) "custom-controls-stacked"
    ),
    id = id,
    if (!is.null(header)) {
      tags$label(
        class = "form-control-label",
        `for` = id,
        header
      )
    },
    lapply(
      seq_along(labels),
      FUN = function(i) {
        tags$label(
          class = collate(
            "custom-control",
            "custom-radio"
          ),
          tags$input(
            class = "custom-control-input",
            type = "radio",
            name = id,
            `data-value` = values[[i]],
            checked = if (selected[[i]]) NA
          ),
          tags$span(
            class = "custom-control-indicator"
          ),
          tags$span(
            class = "custom-control-description",
            labels[[i]]
          )
        )
      }
    ),
    tags$div(class = "form-control-feedback"),
    if (!is.null(footer)) {
      tags$small(
        class = "form-text text-muted",
        footer
      )
    },
    bootstrap()
  )
}

#' @rdname radioInput
#' @export
updateRadioInput <- function(id, values,
                             session = getDefaultReactiveDomain()) {
  values <- vapply(values, as.character, character(1))

  session$sendInputMessage(
    id,
    list(
      value = value
    )
  )
}

#' @rdname radioInput
#' @export
validateRadioInput <- function(id, state, hint = NULL,
                               session = getDefaultReactiveDomain()) {
  if (!re(state, "success|warning|danger")) {
    stop(
      "invalid `validateRadioInput` argument, `state` must be one of ",
      '"success", "warning", or "danger"',
      call. = FALSE
    )
  }

  session$sendInputMessage(
    id,
    list(
      state = state,
      hint = if (!is.null(state)) hint
    )
  )
}

#' @rdname radioInput
#' @export
disableRadioInput <- function(id, session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      disable = TRUE
    )
  )
}

#' @rdname radioInput
#' @export
enableRadioInput <- function(id, session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      enable = TRUE
    )
  )
}

