#' List group thruputs
#'
#' A way of handling and outlining content as a list. List groups function
#' similarly to checkbox groups. A list group returns a reactive vector of
#' values from its active (selected) list group items. List group items are
#' selected or unselected by clicking on them.
#'
#' @param id A character vector specifying the reactive id of the list group
#'   thruput.
#'
#' @param ... For `listGroupThruput`, additional named arguments passed on as
#'   HTML attributes to the parent list group element.
#'
#'   For `listGroupItem`, the text or HTML content of the list group item.
#'
#'   For `renderListGroup`, any number of expressions which return a
#'   `listGroupItem` or calls to `listGroupItem`.
#'
#' @param value A character string specifying the value of the list group item,
#'   defaults to `NULL`, in which case the list group item has no value. List
#'   group items without a value are not actionable, i.e. they cannot be
#'   selected.
#'
#' @param selected `TRUE` or `FALSE` specifying if the list group item is
#'   selected by default, defaults to `FALSE`.
#'
#' @param disabled `TRUE` or `FALSE` specifying if the list group item can be
#'   selected, defaults to `FALSE`.
#'
#' @seealso
#'
#' Boostrap 4 list group documentation:
#' \url{https://getbootstrap.com/docs/4.0/components/list-group/}
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           default = 3,
#'           listGroupThruput(
#'             id = "thrulist"
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$thrulist <- renderListGroup(
#'         listGroupItem(
#'           "Cras justo odio",
#'           badgeOutput("badge1", 14)
#'         ) %>%
#'           display("flex") %>%
#'           content("between"),
#'         listGroupItem(
#'           "Dapibus ac facilisis in",
#'           badgeOutput("badge2", 3)
#'         ) %>%
#'           display("flex") %>%
#'           content("between")
#'       )
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           listGroupThruput("listest")
#'         ),
#'         col(
#'           buttonInput("click", "Click")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$listest <- renderListGroup(
#'         listGroupItem(input$click),
#'         #
#'         # example where list group items break
#'         #
#'         listGroupItem(
#'           buttonInput("clack", "Clack"),
#'           input$clack
#'         )
#'       )
#'     }
#'   )
#' }
#'
listGroupThruput <- function(id, flush = FALSE, ...) {
  tags$div(
    class = collate(
      "dull-list-group-thruput list-group",
      if (flush) "list-group-flush"
    ),
    id = id,
    ...
  )
}

#' @rdname listGroupThruput
#' @export
listGroupItem <- function(..., value = NULL, selected = FALSE, disabled = FALSE) {
  tags$a(
    class = collate(
      "list-group-item",
      if (!is.null(value)) "list-group-item-action",
      if (selected) "active",
      if (disabled) "disabled"
    ),
    `data-value` = NULL,
    ...
  )
}

#' @rdname listGroupThruput
#' @export
renderListGroup <- function(..., env = parent.frame(), quoted = FALSE) {
  itemsFun <- shiny::exprToFunction(list(...), env, quoted)

  function() {
    items <- lapply(itemsFun(), function(i) HTML(as.character(i)))

    list(
      items = items
    )
  }
}
