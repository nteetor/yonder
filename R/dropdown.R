#' Dropdown input
#'
#' Dropdown inputs, dropdown menus, function similar to a set of buttons. The
#' initial dropdown open does not trigger a reactive event, but a subsequent
#' click on one of the menu choices triggers a reactive event. The value of a
#' dropdown item may be specified in `dropdownItem`, otherwise the default value
#' is `NULL`. The reactive value of the dropdown input is the value of the
#' clicked dropdown item.
#'
#' @param ... Any number of dropdown items passed to `dropdown` or additional
#'   named arguments passed as HTML attributes to the respective parent element.
#'
#' @param label A character string specifying the label for a dropdown, dropdown
#'   item, or dropdown header, defaults to `NULL` for dropdowns and dropdown
#'   items, but is required for a dropdown header.
#'
#' @param value A character string specifying the value of a dropdown item,
#'   defaults to `NULL`.
#'
#' @param context One of `"primary"`, `"secondary"`, `"success"`, `"info"`,
#'   `"warning"`, or `"danger"` specifying the visual context of the dropdown,
#'   defaults to `"secondary"`.
#'
#' @param align One of `"left"` or `"right"` specifying which side of the
#'   dropdown button the menu aligns to, defaults to `"left"`.
#'
#' @param split If `TRUE`, the dropdown is changed aesthetically such that the
#'   dropdown icon is split into a separate, smaller button, defaults to
#'   `FALSE`.
#'
#' @param dropup If `TRUE`, the dropdown menu extends upwards, defaults to
#'   `FALSE`.
#'
#' @param disabled If `TRUE`, the dropdown item renders in a disabled state and
#'   will not trigger a reactive event, defaults to `FALSE`. The state of a
#'   dropdown item may be toggled with `updateDropdownItem`.
#'
#' @export
#' @examples
#' dropdownInput(
#'   label = "Secondary",
#'   dropdownItem("Option 1"),
#'   dropdownItem("Option 2")
#' )
#'
#' dropdownInput(
#'   id = "flavor",
#'   label = "Ice cream flavors",
#'   dropdownItem("Vanilla", "vanilla"),
#'   dropdownItem("Chocolate", "chocolate"),
#'   dropdownItem("Mint", "mint")
#' )
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           dropdownInput(
#'             id = "desserts",
#'             label = "Pick a dessert to learn more",
#'             align = "right",
#'             dropdownHeader("Frozen"),
#'             dropdownItem("Ice cream", "icecream"),
#'             dropdownItem("Gelato", "gelato"),
#'             dropdownHeader("Baked goods"),
#'             dropdownItem("Cake", "cake"),
#'             dropdownItem("Pie", "pie")
#'           )
#'         ),
#'         col(
#'           dropdownInput(
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
dropdownInput <- function(..., label = NULL, context = "secondary",
                          split = FALSE, align = "left", dropup = FALSE) {
  if (!re(context, "primary|secondary|success|info|warning|danger", len0 = FALSE)) {
    stop(
      'invalid `dropdownInput` argument, `context` must be one of "primary", ',
      '"secondary", "success", "info", "warning", or "danger"',
      call. = FALSE
    )
  }

  if (!re(align, "left|right", len0 = FALSE)) {
    stop(
      'invalid `dropdownInput` argument, `align` must be one of "left" or ',
      '"right"',
      call. = FALSE
    )
  }

  args <- list(...)
  attrs <- attribs(args)
  items <- elements(args)

  tagConcatAttributes(
    tags$div(
      class = collate(
        "dull-dropdown-input",
        "btn-group",
        if (dropup) "dropup" else "dropdown"
      ),
      if (split) button(context = context, label = label),
      button(
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
        class = collate(
          "dropdown-menu",
          if (align == "right") "dropdown-menu-right"
        ),
        items
      ),
      bootstrap()
    ),
    attrs
  )
}

#' @rdname dropdownInput
#' @export
dropdownItem <- function(label = NULL, value = NULL, disabled = FALSE, ...) {
  tags$a(
    class = collate(
      "dull-dropdown-item",
      "dropdown-item",
      if (disabled) "disabled"
    ),
    `data-value` = value,
    label,
    ...
  )
}

#' @rdname dropdownInput
#' @export
dropdownDivider <- function() {
  tags$div(class = "dropdown-divider")
}

#' @rdname dropdownInput
#' @export
dropdownHeader <- function(label) {
  tags$h6(class = "dropdown-header", label)
}
