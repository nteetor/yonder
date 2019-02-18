#' A chips input
#'
#' A selectize alternative.
#'
#' @inheritParams buttonInput
#'
#' @param choices A character vector or list specifying the possible choices.
#'
#' @param values A character vector or list of strings specifying the input's
#'   values, defaults to `choices`.
#'
#' @param selected One or more of `values` specifying which values are selected
#'   by default.
#'
#' @param max A number specifying the maximum number of items a user may select.
#'
#' @param block One of `TRUE` or `FALSE` specifying the layout of chips. If
#'   `TRUE` chips fill the width of the parent element, otherwise if `FALSE` the
#'   chips are rendered inline, defaults to `TRUE`. Rendering chips inline is
#'   useful when choice text is consistently short.
#'
#' @family inputs
#' @export
chipInput <- function(id, choices, values = choices, selected = NULL, ...,
                      max = NULL, block = TRUE) {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `chipInput()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  selected <- if (is.null(selected)) FALSE else (selected %in% values)

  dropdownToggle <- tags$input(
    class = "form-control form-control-sm",
    `data-toggle` = "dropdown"
  )

  dropdownItems <- Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$button(
        class = collate(
          "dropdown-item",
          if (select) "selected"
        ),
        value = value,
        choice
      )
    }
  )

  chips <- Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$button(
        class = collate(
          "chip",
          if (select) "active"
        ),
        ## href = "javascript:void(0)",
        value = value,
        span(
          class = "chip-content",
          choice
        ),
        span(
          class = "chip-close",
          HTML("&times;")
        )
      )
    }
  )

  element <- div(
    id = id,
    class = collate(
      "yonder-chip",
      "btn-group dropup"
    ),
    `data-max` = max %||% -1,
    dropdownToggle,
    div(
      class = "dropdown-menu",
      dropdownItems
    ),
    div(
      class = collate(
        "chips",
        if (block) "chips-block" else "chips-inline"
      ),
      chips
    ),
    ...
  )

  attachDependencies(element, yonderDep())
}
