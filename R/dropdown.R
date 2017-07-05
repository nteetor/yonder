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
#'   dropdownItem("Option 1", href = "#"),
#'   dropdownItem("Option 2", href = "#")
#' )
#'
#' dropdown(
#'   id = "flavor",
#'   label = "Ice cream flavors",
#'   dropdownItem("Vanilla", href = "vanilla"),
#'   dropdownItem("Chocolate", href = "chocolate"),
#'   dropdownItem("Mint", href = "mint")
#' )
#'
dropdown <- function(..., label = NULL, context = "secondary", split = FALSE) {
  browser()
  tags$div(
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
    ...,
    bootstrap()
  )
}

#' @rdname dropdown
dropdownItem <- function(label = NULL, href = NULL, ...) {
  tags$a(
    class = "dropdown-item",
    href = href,
    ...
  )
}
