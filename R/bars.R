#' Checkbar and radiobar inputs
#'
#' These inputs behave similarly to their counter parts, checkbox and radio
#' inputs. However, yonder's checkbox input is a singleton value, thus the
#' checkbar input is more akin to shiny's checkbox group input.
#'
#' @param id A character string specifying the id of the input.
#'
#' @param choices A character vector or flat list of character strings
#'   specifying the labels of the checkbar or radiobar options.
#'
#' @param values A character vector, flat list of character strings, or object
#'   to coerce to either, specifying the values of the checkbar or radiobar
#'   options, defaults to `choices`.
#'
#' @param selected One or more of `values` indicating which of the checkbar or
#'   radiobar options are selected by default, defaults to `NULL`, in which case
#'   there is no default option.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ## An alternative to checkbox groups
#'
#' checkbarInput(
#'   id = NULL,
#'   choices = c(
#'     "Check 1",
#'     "Check 2",
#'     "Check 3"
#'   ),
#'   selected = "Check 1"
#' ) %>%
#'   background("blue") %>%
#'   margin(2)
#'
#' ## Radiobars in comparison
#'
#' radiobarInput(
#'   id = NULL,
#'   choices = c(
#'     "fusce sagittis",
#'     "libero non molestie",
#'     "magna orci",
#'     "ultrices dolor"
#'   ),
#'   selected = "ultrices dolor"
#' ) %>%
#'   background("grey")
#'
checkbarInput <- function(id, choices, values = choices, selected = NULL) {
  if (length(choices) != length(values)) {
    stop(
      "invalid `checkbarInput` arguments, `choices` and `values` must have ",
      "the same length",
      call. = FALSE
    )
  }

  selected <- match2(selected, values)

  tags$div(
    class = collate(
      "yonder-checkbar",
      if (length(choices) > 1) "btn-group",
      "btn-group-toggle"
    ),
    `data-toggle` = "buttons",
    id = id,
    lapply(
      seq_along(choices),
      function(i) {
        tags$label(
          class = collate(
            "btn",
            if (selected[[i]]) "active"
          ),
          tags$input(
            type = "checkbox",
            autocomplete = "off",
            `data-value` = values[[i]],
            checked = if (selected[[i]]) NA
          ),
          tags$span(
            choices[[i]]
          )
        )
      }
    )
  )
}

#' @family inputs
#' @rdname checkbarInput
#' @export
radiobarInput <- function(id, choices, values = choices, selected = NULL) {
  if (length(choices) != length(values)) {
    stop(
      "invalid `radiobarInput` arguments, `choices` and `values` must be ",
      "the same length",
      call. = FALSE
    )
  }

  selected <- match2(selected, values)

  tags$div(
    class = "yonder-radiobar btn-group btn-group-toggle",
    id = id,
    `data-toggle` = "buttons",
    lapply(
      seq_along(choices),
      function(i) {
        tags$label(
          class = collate(
            "btn",
            if (selected[[i]]) "active"
          ),
          tags$input(
            name = id,
            type = "radio",
            `data-value` = values[[i]],
            autocomplete = "false",
            checked = if (selected[[i]]) NA
          ),
          tags$span(
            choices[[i]]
          )
        )
      }
    )
  )
}
