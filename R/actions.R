#' Input actions
#'
#' @description
#'
#' Input actions are a new feature in yonder. These actions allow a reactive
#' input to interact with elements of your application's user interface without
#' requiring server-side logic. See below for components inputs may interact
#' with using input actions. Not all of yonder's reactive inputs may be used
#' with input actions.
#'
#' @section Supported inputs:
#'
#' * [buttonInput()]
#'
#' * [buttonGroupInput()]
#'
#' * [linkInput()]
#'
#' * [navInput()]
#'
#' @section Actionable components:
#'
#' **Nav panes**
#'
#' A nav pane may be shown with [showNavTarget()] or hidden with
#' [hideNavTarget()].
#'
#' **Collapse panes**
#'
#' A collapse pane may be opened with [showCollapseTarget()] or hidden with
#' [hideCollapseTarget()] or toggled with [toggleCollapseTarget()].
#'
#' Toggling a collapse pane will open the pane if closed or close the pane
#' if currently open.
#'
#' **Modals**
#'
#'
#' **Toasts**
#'
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
    `data-plugin` = x$plugin,
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
