#' Multi select input
#'
#' The multi select input is a selectize alternative.
#'
#' @inheritParams input_checkbox
#'
#' @returns A [htmltools::tag] object.
#'
#' @family inputs
#'
#' @export
input_multi_select <- function(
  id,
  ...
) {
  check_string(id, allow_empty = FALSE)
  # @TODO check choices

  # check_character(values, allow_na = FALSE, allow_null = FALSE)
  # check_character(select, allow_null = TRUE)
  # check_character(disable, allow_null = TRUE)
  # check_number_whole(max, allow_null = TRUE)

  args <- rlang::list2(...)
  attrs <- keep_named(args)

  # toggle <-
  #   tags$input(
  #     class = "form-control dropdown-toggle",
  #     `data-toggle` = "dropdown",
  #     type = "text",
  #     placeholder = placeholder
  #   )
  #
  # options <-
  #   build_input_options(
  #     chip_option,
  #     choices,
  #     values,
  #     select,
  #     disable
  #   )

  input <-
    tags$div(
      id = id,
      class = "bsides-multiselect multi-select",
      !!!attrs,
      tags$div(
        class = "chip-group"
      ),
      tags$input(
        type = "text",
        class = "multi-select-input"
      )
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, "bsides_multi_select")

  input
}

#' @rdname input_multi_select
#' @export
update_multi_select <- function(
  id,
  choices = NULL,
  values = choices,
  selected = NULL,
  max = NULL,
  enable = NULL,
  disable = NULL,
  session = get_current_session()
) {}

chip_option <- function(
  choice,
  value,
  select
) {
  tags$li(
    tags$button(
      class = c(
        "dropdown-item",
        if (isTRUE(value %in% select)) "selected"
      ),
      value = value,
      choice
    )
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
