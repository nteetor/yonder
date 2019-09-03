#' Input actions
#'
#' These functions are used in conjunction with the `targets` argument found
#' in all of yonder's reactive input functions.
#'
#' @param id A character string specifying the id of a [navPane()] or
#'   [collapsePane()].
#'
#' @param ... Additional arguments, currently ignored.
#'
#' @name actions
NULL

#' @rdname actions
#' @export
showTarget <- function(id, ...) {
  create_targeter("show", id)
}

#' @rdname actions
#' @export
hideTarget <- function(id, ...) {
  create_targeter("hide", id)
}

create_targeter <- function(action, id) {
  structure(
    class = c("targeter", "list"),
    list(
      action = action,
      target = id
    )
  )
}

is_targeter <- function(x) {
  inherits(x, "targeter")
}

#' Explain a targetting action
#'
#' Printing a targetting action displays a message about the action performed.
#'
#' @param x An object with class `"targeter"`.
#'
#' @param ... Additional arguments passed on to other methods.
#'
#' @keywords internal
#' @export
print.targeter <- function(x, ...) {
  msg <- "Selecting the input choice with the corresponding value _%s_ the element with id `%s`"
  cat(sprintf(msg, x$action, x$id), "\n")
  invisible(x)
}

construct_targets <- function(targets, values) {
  if (is.null(targets)) {
    return(targets)
  }

  if (length(targets) > 1) {
    targets <- lapply(targets, function(target) {
      if (is.character(target)) {
        paste0("#", target, collapse = " ")
      } else if (is_targeter(target)) {
        stop("Not implemented")
      }
    })

    if (all(names2(targets) == "")) {
      names(targets) <- values
    }

    targets
  } else if (is.character(targets)) {
    targets
  }
}

get_target <- function(targets, value) {
  if (is.null(targets)) {
    NULL
  } else if (is.character(targets)) {
    paste0("#", value)
  } else {
    targets[[value]]
  }
}
