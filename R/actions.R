#' Input actions
#'
#' These functions are used in conjunction with yonder's reactive input functions'
#' `actions` argument.
#'
#' @param id A character string specifying the id of a [navPane()] or
#'   [collapsePane()].
#'
#' @param ... Additional arguments, currently ignored.
#'
#' @aliases action
#' @name actions
NULL

input_action <- function(plugin, action, id) {
  structure(
    class = c("input_action", "list"),
    list(
      plugin = plugin,
      action = action,
      target = paste0("#", id),
      value = id
    )
  )
}

is_input_action <- function(x) {
  inherits(x, "input_action")
}

set_action_target <- function(action, id) {
  action$target <- paste0("#", id)
  action
}

set_action_value <- function(action, value) {
  action$value <- value
  action
}

get_action_value <- function(action) {
  action$value
}

c.input_action <- function(...) {
  list(...)
}

as.list.input_action <- function(x) {
  list(
    `data-toggle` = x$plugin,
    `data-target` = x$target,
    `data-action` = x$action
  )
}

normalize_actions <- function(actions, values) {
  if (is.null(actions) || length(actions) == 0) {
    return(vector("list", length(values)))
  }

  actions <- Map(
    action = actions,
    name = names2(actions),
    function(action, name) {
      if (name != "") {
        set_action_value(action, name)
      } else {
        action
      }
    },
    USE.NAMES = FALSE
  )

  names(actions) <- vapply(actions, get_action_value, character(1))

  lapply(values, function(value) {
    if (value %in% names2(actions)) {
      actions[names2(actions) == value][[1]]
    }
  })
}
