#' Dropdown Menu
#'
#' A Bootstrap dropdown menu.
#'
#' @param ... Any number of `dropdownItem`s passed to `dropdown` or additional
#'   named arguments passed as HTML attributes to the respective parent element.
#'
#' @param label A character string labelling the dropdown or dropdown item,
#'   defaults to `NULL`.
#'
#' @param context One of `"primary"`, `"secondary"`, `"success"`, `"info"`
#'
#' @param split If `TRUE`, the dropdown is changed aesthetically such that the
#'   dropdown icon is split into a separate, smaller button, defaults to
#'   `FALSE`.
#'
#' @export
#' @examples
#' dropdown(
#'   label = "Secondary",
#'   dropdownItem("Option 1"),
#'   dropdownItem("Option 2")
#' )
#'
#' dropdown(
#'   id = "flavor",
#'   label = "Ice cream flavors",
#'   dropdownItem("Vanilla", "vanilla"),
#'   dropdownItem("Chocolate", "chocolate"),
#'   dropdownItem("Mint", "mint")
#' )
#'
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           dropdown(
#'             id = "desserts",
#'             label = "Pick a dessert!",
#'             dropdownItem("Ice cream", "icecream"),
#'             dropdownItem("Cake", "cake"),
#'             dropdownItem("Pie", "pie")
#'           )
#'         ),
#'         col(
#'           dropdown(
#'             id = "spices",
#'             label = "Check for a spice",
#'             dropdownItem("Cardamom", "cardamom"),
#'             dropdownItem("Nutmeg", "nutmeg"),
#'             dropdownItem("Vanilla", "vanilla")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         print(input$desserts)
#'       })
#'
#'       observe({
#'         print(input$spices)
#'       })
#'     }
#'   )
#' }
#'
dropdown <- function(..., label = NULL, context = "secondary", split = FALSE) {
  args <- list(...)
  attrs <- args[elodin(args) != ""]
  items <- args[elodin(args) == ""]

  drpdwn <- tags$div(
    class = "dropdown dull-dropdown",
    if (split) inputs$button(context = context, label = label),
    inputs$button(
      class = collate(
        "dropdown-toggle",
        if (split) "dropdown-toggle-split"
      ),
      label = label,
      context = context,
      `data-toggle` = "dropdown",
      if (split) tags$span(class = "sr-only", "Toggle Dropdown")
    ),
    tags$div(
      class = "dropdown-menu",
      items
    ),
    bootstrap()
  )

  drpdwn$attribs <- c(drpdwn$attribs, attrs)
  drpdwn
}

#' @rdname dropdown
dropdownItem <- function(label = NULL, value = NULL, ...) {
  tags$a(
    class = "dropdown-item",
    `data-value` = value,
    label,
    ...
  )
}
