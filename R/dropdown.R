#' Dropdown input
#'
#' Dropdown inputs, or dropdown menus, function similar to a set of buttons.
#' The initial click to open a dropdown menu does not trigger a reactive event,
#' but a click on one of the dropdown items triggers a reactive event. The
#' reactive value of a dropdown input is the value of the most recently clicked
#' dropdown menu item.
#'
#' @param id A character string specifying the id of the dropdown input.
#'
#' @param label A character string specifying the label of the dropdown's button.
#'
#' @param choices A character vector specifying the labels of the dropdown menu
#'   items.
#'
#' @param values A character vector, list of character strings, vector of values
#'   to coerce to character strings, or list of values to coerce to character
#'   strings specifying the values of the dropdown input's choices, defaults to
#'   `choices`.
#'
#' @param disabled One or more of `values` indicating which dropdown menu items
#'   to disable, defaults to `NULL`, in which case all choices are enabled.
#'
#' @param dividers One or more of `values` indicating which dropdown menu items
#'   are the start of a new section, defaults to `NULL`. Divider lines will be
#'   placed above the indicated values separating the dropdown menu items into
#'   sections.
#'
#' @param dropup If `TRUE`, the dropdown menu opens upwards instead of
#'   downwards, defaults to `FALSE`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           dropdownInput(
#'             id = "dropdown",
#'             label = "A dropdown",
#'             choices = paste("Action", 1:5),
#'             dividers = "Action 4"
#'           ) %>%
#'             background("orange")
#'         ),
#'         col(
#'           d4(
#'             textOutput("value")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderText({
#'         input$dropdown
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       buttonInput("click", "Change dropdown choices"),
#'       dropdownInput(
#'         id = "foo",
#'         label = "A dropdown",
#'         choices = c("Hello", "World")
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$click, {
#'         updateChoices(
#'           id = "foo",
#'           Hello = "Hello!"
#'         )
#'       })
#'     }
#'   )
#' }
#'
dropdownInput <- function(id, label, choices, values = choices, disabled = NULL,
                          dividers = NULL, direction = "down", ...) {
  if (length(choices) != length(values)) {
    stop(
      "invalid `dropdownInput` arguments, `choices` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  if (!is.null(disabled) && !all(disabled %in% values)) {
    problematic <- paste0('"', disabled[!(disabled %in% values)], '"')
    warning(
      "problematic `dropdownInput` argument, `disabled` contains ",
      to_sentence(problematic, "and"), " which are not in `values`",
      call. = FALSE
    )
  }

  if (!is.null(dividers) && !all(dividers %in% values)) {
    problematic <- paste0('"', dividers[!(dividers %in% values)], '"')
    warning(
      "problematic `dropdownInput` argument, `dividers` contains ",
      to_sentence(problematic, "and"), " which are not in `values`",
      call. = FALSE
    )
  }

  if (!re(direction, "up|right|down|left", len0 = FALSE)) {
    stop(
      "invalid `dropdownInput` arguments, `direction` must be one of ",
      '"up", "right", "down", or "left"',
      call. = FALSE
    )
  }

  disabled <- match2(disabled, values)
  dividers <- match2(dividers, values)

  tags$div(
    class = collate(
      "dull-dropdown-input",
      "btn-group",
      paste0("drop", direction)
    ),
    id = id,
    `data-value` = NULL,
    tags$button(
      class = collate(
        "btn",
        "dropdown-toggle",
        "btn-grey"
      ),
      type = "button",
      `data-toggle` = "dropdown",
      `aria-haspop` = "true",
      `aria-expanded` = "false",
      label
    ),
    tags$div(
      class = collate(
        "dropdown-menu",
        "dropdown-menu-right"
      ),
      lapply(
        seq_along(choices),
        function(i) {
          list(
            if (dividers[[i]]) {
              tags$div(class = "dropdown-divider")
            },
            tags$a(
              class = collate(
                "dropdown-item",
                if (disabled[[i]]) "disabled"
              ),
              href = NA,
              `data-value` = values[[i]],
              choices[[i]]
            )
          )
        }
      )
    ),
    ...,
    includes()
  )
}
