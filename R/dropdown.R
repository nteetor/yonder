#' Dropdown input
#'
#' Dropdown inputs, or dropdown menus, function similar to a set of buttons.
#' The initial click to open a dropdown menu does not trigger a reactive event,
#' but a click on one of the dropdown items triggers a reactive event. The
#' reactive value of a dropdown input is the value of the most recently clicked
#' dropdown menu item. Disabling a dropdown menu triggers a reactive event and
#' resets the reactive value to `NULL`.
#'
#' @param items A character vector specifying the labels of the dropdown menu
#'   items.
#'
#' @param values A character vector, list of character strings, vector of values
#'   to coerce to character strings, or list of values to coerce to character
#'   strings specifying the values of the dropdown input's choices, defaults to
#'   `items`.
#'
#' @param disabled,enabled One or more of `values` indicating which dropdown
#'   menu items to disable or enable, defaults to `NULL`. If `NULL` then
#'   `disableDropdownInput` and `enableDropdownInput` will disable or enable all
#'   the dropdown input's items, respectively.
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
#'             label = "A dropdown"
#'             items = paste("Action", 1:5),
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
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           offset = 1,
#'           dropdownInput(
#'             id = "actions",
#'             label = "Actions",
#'             items = c("disable", "enable", "disable some", "enable some"),
#'             dividers = "disable some"
#'           )
#'         ),
#'         col(
#'           dropdownInput(
#'             id = "dropdown",
#'             label = "Other actions",
#'             items = paste("Action", 1:5),
#'             disabled = "Action 3"
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
#'       observeEvent(input$actions, {
#'         if (input$actions == "disable") {
#'           disableDropdownInput("dropdown")
#'         } else if (input$actions == "enable") {
#'           enableDropdownInput("dropdown")
#'         } else if (input$actions == "disable some") {
#'           disableDropdownInput("dropdown", paste("Action", c(2, 3, 5)))
#'         } else if (input$actions == "enable some") {
#'           enableDropdownInput("dropdown", paste("Action", c(2, 3, 5)))
#'         }
#'       })
#'
#'       output$value <- renderText({
#'         input$dropdown
#'       })
#'     }
#'   )
#' }
#'
dropdownInput <- function(id, label, items, values = items, disabled = NULL,
                          dividers = NULL, context = "secondary",
                          dropup = FALSE, ...) {
  if (length(items) != length(values)) {
    stop(
      "invalid `dropdownInput` arguments, `items` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  if (!re(context, "secondary|primary|success|info|warning|danger", FALSE)) {
    stop(
      "invalid `dropdownInput` arguments, `context` must be one of ",
      '"secondary", "primary", "success", "info", "warning", or "danger"',
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
    `data-value` = NULL,
    tags$button(
      class = collate(
        "btn",
        paste0("btn-", context),
        "btn-secondary",
        "dropdown-toggle"
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
        seq_along(items),
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
              items[[i]]
            )
          )
        }
      )
    ),
    ...,
    bootstrap()
  )
}

#' @rdname dropdownInput
#' @export
disableDropdownInput <- function(id, disabled = NULL,
                                 session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      disable = if (is.null(disabled)) TRUE else as.list(disabled)
    )
  )
}

#' @rdname dropdownInput
#' @export
enableDropdownInput <- function(id, enabled = NULL,
                                session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      enable = if (is.null(enabled)) TRUE else as.list(enabled)
    )
  )
}
