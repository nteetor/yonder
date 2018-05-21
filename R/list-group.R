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
#' @param ... For `listGroupThruput()`, additional named arguments passed on as
#'   HTML attributes to the parent list group element.
#'
#'   For `listGroupItem()`, the text or HTML content of the list group item.
#'
#'   For `renderListGroup()`, any number of expressions which return a
#'   `listGroupItem()` or calls to `listGroupItem()`.
#'
#' @param multiple One of `TRUE` or `FALSE` specifyng if multiple list group
#'   items may be selected, defaults to `TRUE`.
#'
#' @param flush One of `TRUE` or `FALSE` specifying if the list group is
#'   rendered without a border, defaults to `FALSE`. Removing the list group
#'   border is useful when rendering a list group inside a custom parent
#'   container, e.g. inside a `card()`.
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
#' @param env The environment in which to evalute the expressions based to
#'   `renderListGroup()`.
#'
#' @seealso
#'
#' Boostrap 4 list group documentation:
#' \url{https://getbootstrap.com/docs/4.0/components/list-group/}
#'
#' @family inputs
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         column(
#'           default = 3,
#'           listGroupThruput(
#'             id = "thrulist",
#'             componentOutput("items")
#'           )
#'         ),
#'         column(
#'           rangeInput(
#'             id = "num",
#'             min = 0,
#'             max = 20,
#'             step = 2
#'           ),
#'           sliderInput(
#'             id = "level",
#'             choices = c("red", "orange", "green", "cyan")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$items <- renderComponent(
#'         listGroupItem(
#'           "Cras justo odio",
#'           badgeOutput("badge1", 0) %>%
#'             background(input$level)
#'         ) %>%
#'           display(flex = TRUE) %>%
#'           flex(justify = "between", align = "center"),
#'         listGroupItem(
#'           "Dapibus ac facilisis in",
#'           badgeOutput("badge2", 0) %>%
#'             background(input$level)
#'         ) %>%
#'           display(flex = TRUE) %>%
#'           flex(justify = "between", align = "center")
#'       )
#'
#'       output$badge1 <- renderBadge(input$num)
#'       output$badge2 <- renderBadge(input$num)
#'     }
#'   )
#' }
#'
#'
#' lessons <- list(
#'   stars = c(
#'     "The stars and moon are far too bright",
#'     "Their beam and smile splashing o'er all",
#'     "To illuminate while turning my sight",
#'     "From the shadows wherein deeper shadows fall"
#'   ),
#'   joy = c(
#'     "A single step, her hand aloft",
#'     "More than a step, a joyful bound",
#'     "The moment, precious, small, soft",
#'     "And within a truth was found"
#'   )
#' )
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         column(
#'           class = "ml-auto",
#'           default = 3,
#'           listGroupThruput(
#'             id = "lesson",
#'             multiple = FALSE,
#'             listGroupItem(
#'               value = "stars",
#'               h5("Stars"),
#'               lessons[["stars"]][1]
#'             ),
#'             listGroupItem(
#'               value = "joy",
#'               h5("Joy"),
#'               lessons[["joy"]][1]
#'             )
#'           )
#'         ),
#'         column(
#'           class = "mr-auto",
#'           htmlOutput("text")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$text <- renderText({
#'         req(input$lesson)
#'         HTML(paste(lessons[[input$lesson]], collapse = "</br>"))
#'       })
#'     }
#'   )
#' }
#'
listGroupThruput <- function(id, ..., multiple = TRUE, flush = FALSE) {
  tags$div(
    class = collate(
      "dull-list-group-thruput list-group",
      if (flush) "list-group-flush"
    ),
    `data-multiple` = if (multiple) "true" else "false",
    id = id,
    ...
  )
}

#' @rdname listGroupThruput
#' @export
listGroupItem <- function(..., value = NULL, selected = FALSE,
                          disabled = FALSE) {
  tags$a(
    class = collate(
      "list-group-item",
      if (!is.null(value)) "list-group-item-action",
      if (selected) "active",
      if (disabled) "disabled"
    ),
    `data-value` = value,
    ...
  )
}

#' @rdname listGroupThruput
#' @export
renderListGroup <- function(...,  env = parent.frame()) {
  itemsFun <- shiny::exprToFunction(list(...), env, FALSE)

  function() {
    items <- lapply(itemsFun(), function(i) HTML(as.character(i)))

    list(
      items = items
    )
  }
}
