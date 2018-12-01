#' List group thruputs
#'
#' A way of handling and outlining content as a list. List groups function
#' similarly to checkbox groups. A list group returns a reactive vector of
#' values from its active (selected) list group items. List group items are
#' selected or unselected by clicking on them.
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
#' @template thruput
#' @export
#' @examples
#'
#' ### Getting started
#'
#' listGroupThruput(
#'   id = NULL,
#'   listGroupItem(
#'     rangeInput(NULL)
#'   )
#' )
#'
#' ### Fancier list items
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
#' listGroupThruput(
#'   id = NULL,
#'   multiple = FALSE,
#'   listGroupItem(
#'     value = "stars",
#'     h5("Stars"),
#'     lessons[["stars"]][1]
#'   ),
#'   listGroupItem(
#'     value = "joy",
#'     h5("Joy"),
#'     lessons[["joy"]][1]
#'   )
#' )
#'
listGroupThruput <- function(id, ..., multiple = TRUE, flush = FALSE) {
  thruput <- tags$div(
    class = collate(
      "yonder-list-group list-group",
      if (flush) "list-group-flush"
    ),
    `data-multiple` = if (multiple) "true" else "false",
    id = id,
    ...
  )

  thruput <- attachDependencies(
    thruput,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  thruput
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
  installExprFunction(list(...), "func", env, FALSE, label = "list group items")

  createRenderFunction(
    func,
    function(data, session, name) {
      if (is_strictly_list(data)) {
        data <- unlist(data, recursive = FALSE)
      }

      list(
        items = lapply(
          data,
          function(x) {
            if (is.function(x)) {
              HTML(as.character(x()))
            } else {
              HTML(as.character(x))
            }
          }
        )
      )
    }
  )
}
