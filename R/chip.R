#' Chip input, selectize alternative
#'
#' The chip input is a selectize alternative. Choices are selected from a
#' dropdown menu and appear as chips below the input's text box. Chips do not
#' appear in the order they are selected. Instead chips are shown in the order
#' specified by the `choices` argument. Use the `max` argument to limit the
#' number of choices a user may select.
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
#' @param inline One of `TRUE` or `FALSE` specifying if chips are rendered
#'   inline. If `TRUE` multiple chips may fit onto a single row, otherwise, if
#'   `FALSE`, chips expand to fill the width of their parent element, one chip
#'   per row.
#'
#' @section **Example** simple application:
#'
#' ```R
#' ui <- container(
#'   chipInput(
#'     id = "chips",
#'     choices = paste("Option number", 1:10),
#'     values = 1:10,
#'     inline = TRUE
#'   ) %>%
#'     width("1/2")
#' )
#'
#' server <- function(input, output) {
#'
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @section **Example** inline chips:
#'
#' ```R
#' ui <- container(
#'   chipInput(
#'     id = "chips",
#'     choices = c(
#'       "A rather long option, isn't it?",
#'       "Shorter",
#'       "A middle-size option",
#'       "One more"
#'     ),
#'     values = 1:4,
#'     fill = FALSE
#'   ) %>%
#'     width("1/2") %>%
#'     background("blue") %>%
#'     shadow("small")
#' )
#'
#' server <- function(input, output) {
#'
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Default input
#'
#' chipInput(
#'   id = "chip1",
#'   choices = paste("Choice", 1:5)
#' )
#'
chipInput <- function(id, choices = NULL, values = choices, selected = NULL,
                      ..., max = NULL, inline = TRUE) {
  assert_id()
  assert_choices()

  selected <- values %in% selected

  toggle <- tags$input(
    class = "form-control form-control-sm",
    `data-toggle` = "dropdown"
  )

  chips <- map_chips(choices, values, selected)

  component <- tags$div(
    id = id,
    class = str_collate(
      "yonder-chip",
      "btn-group dropup"
    ),
    `data-max` = max %||% -1,
    toggle,
    tags$div(
      class = "dropdown-menu",
      chips$items
    ),
    tags$div(
      class = str_collate(
        "chips",
        if (!inline) "chips-block" else "chips-inline",
        "chips-grey"
      ),
      chips$chips
    ),
    ...
  )

  attach_dependencies(component)
}

#' @rdname chipInput
#' @export
updateChipInput <- function(id, choices = NULL, values = NULL, selected = NULL,
                            enable = NULL, disable = NULL,
                            session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  if (!is.null(choices)) {
    chips <- lapply(
      map_chips(choices, values, selected),
      function(x) HTML(as.character(x))
    )
  } else {
    chips <- list(chips = NULL, items = NULL)
  }

  session$sendInputMessage(id, list(
    chips = chips$chips,
    items = chips$items,
    enable = enable,
    disable = disable
  ))
}

map_chips <- function(choices, values, selected) {
  items <- Map(
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

  chips <- Map(
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

  list(items = items, chips = chips)
}
