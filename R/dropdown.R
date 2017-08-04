#' Dropdown input
#'
#' Dropdown inputs, dropdown menus, function similar to a set of buttons. The
#' initial dropdown open does not trigger a reactive event, but a subsequent
#' click on one of the menu choices triggers a reactive event. The value of a
#' dropdown item may be specified in `dropdownItem`, otherwise the default value
#' is `NULL`. The reactive value of the dropdown input is the value of the
#' clicked dropdown item.
#'
#' @param labels A character vector specifying the labels of the dropdown menu
#'   choices.
#'
#' @param values A character vector specifying the values of the dropdown menu
#'   choices, defaults to `values`.
#'
#' @param disabled One or more of `values` indicating which dropdown menu items
#'   to disable, defaults to `NULL`.
#'
#' @param dividers One or more of `values` indicating which dropdown menu items
#'   are the start of a new section, defaults to `NULL`. Divider lines will be
#'   placed above the indicated values separating the dropdown menu items into
#'   sections.
#'
#' @param dropup If `TRUE`, the dropdown menu extends upwards instead of
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
#'             labels = paste("Action", 1:5),
#'             dividers = "Action 4"
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
#'         input$dropdown
#'       })
#'     }
#'   )
#' }
#'
dropdownInput <- function(id, labels, values = labels, disabled = NULL,
                          dividers = NULL, dropup = FALSE, ...) {
  if (length(labels) != length(values)) {
    stop(
      "invalid `dropdownInput` arguments, `labels` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  disabled <- match2(disabled, values)
  dividers <- match2(dividers, values)

  tags$div(
    class = collate(
      "dull-dropdown-input",
      "btn-group",
      if (dropup) "dropup" else "dropdown"
    ),
    id = id,
    tags$button(
      class = "btn btn-secondary dropdown-toggle",
      type = "button",
      `data-toggle` = "dropdown",
      `aria-haspop` = "true",
      `aria-expanded` = "false"
    ),
    tags$div(
      class = collate(
        "dropdown-menu",
        "dropdown-menu-right"
      ),
      lapply(
        seq_along(labels),
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
              `data-value` = values[[i]],
              labels[[i]]
            )
          )
        }
      )
    ),
    ...,
    bootstrap()
  )
}
