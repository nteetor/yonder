#' Chip inputs
#'
#' The chip input is a selectize alternative. Choices are selected from a
#' dropdown menu and appear as chips below the input's text box. Chips do not
#' appear in the order they are selected. Instead chips are shown in the order
#' specified by the `choices` argument. Use the `max` argument to limit the
#' number of choices a user may select.
#'
#' @inheritParams checkboxInput
#'
#' @param choices A character vector or list specifying the possible choices.
#'
#' @param values A character vector or list of strings specifying the input's
#'   values, defaults to `choices`.
#'
#' @param selected One or more of `values` specifying which values are selected
#'   by default.
#'
#' @param placeholder A character string specifying placeholder text of the
#'   chip input, defaults to `NULL`.
#'
#' @param max A number specifying the maximum number of items a user may select,
#'   defaults to `Inf`.
#'
#' @param inline One of `TRUE` or `FALSE` specifying if chips are rendered
#'   inline. If `TRUE` multiple chips may fit onto a single row, otherwise, if
#'   `FALSE`, chips expand to fill the width of their parent element, one chip
#'   per row.
#'
#' @param sort One of `"stack"`, `"queue"`, or `"fixed"` specifying how
#'   selected chips are ordered, defaults to `"stack"`.
#'
#'   `"stack"`, selected chips are placed ahead of other selected chips.
#'
#'   `"queue"`, selected chips are placed behind other selected chips.
#'
#'   `"fixed"`, selected chips appear in the order specified by
#'   `choices` and `values`. Use `"fixed"` and sort `choices` to keep selected
#'   chips in the same sorted order.
#'
#' @family inputs
#' @export
chipInput <- function(id, choices = NULL, values = choices, selected = NULL,
                      ..., placeholder = NULL, max = Inf, inline = TRUE,
                      sort = "stack") {
  assert_id()
  assert_choices()
  assert_possible(sort, c("stack", "queue", "fixed"))

  dep_attach({
    toggle <- tags$input(
      class = "form-control custom-select",
      `data-toggle` = "dropdown",
      placeholder = placeholder
    )

    chips <- map_chipchips(choices, values, selected)
    items <- map_chipitems(choices, values, selected)

    tags$div(
      id = id,
      class = str_collate(
        "yonder-chip",
        "btn-group dropup"
      ),
      `data-max` = if (max == Inf) -1 else max,
      `data-sort` = sort,
      toggle,
      tags$div(
        class = "dropdown-menu",
        items
      ),
      tags$div(
        class = str_collate(
          "chips",
          if (!inline) "chips-block" else "chips-inline",
          "chips-grey"
        ),
        chips
      ),
      ...
    )
  })
}

#' @rdname chipInput
#' @export
updateChipInput <- function(id, choices = NULL, values = choices,
                            selected = NULL, max = NULL,
                            enable = NULL, disable = NULL,
                            session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_session()

  chips <- map_chipchips(choices, values, selected)
  items <- map_chipitems(choices, values, selected)

  chips <- coerce_content(chips)
  items <- coerce_content(items)
  selected <- coerce_selected(selected)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)

  session$sendInputMessage(id, list(
    chips = chips,
    items = items,
    selected = selected,
    enable = enable,
    disable = disable
  ))
}

map_chipitems <- function(choices, values, selected) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }

  selected <- values %in% selected

  Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$button(
        class = str_collate(
          "dropdown-item",
          if (select) "selected"
        ),
        value = value,
        choice
      )
    }
  )
}

map_chipchips <- function(choices, values, selected) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }

  selected <- values %in% selected

  Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$button(
        class = str_collate(
          "chip",
          if (select) "active"
        ),
        value = value,
        tags$span(
          class = "chip-content",
          choice
        ),
        tags$span(
          class = "chip-close",
          HTML("&times;")
        )
      )
    }
  )
}
