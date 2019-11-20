coerce_content <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }

  if (length(x) == 0) {
    return(list())
  }

  if (is_tag(x)) {
    HTML(as.character(x))
  } else if (inherits(x, "AsIs")) {
    HTML(
      paste(
        vapply(x, as.character, character(1)),
        collapse = "<br>\n"
      )
    )
  } else {
    HTML(
      paste(
        vapply(x, as.character, character(1)),
        collapse = "\n"
      )
    )
  }
}

coerce_selected <- function(x) {
  if (is.null(x)) {
    x
  } else if (isTRUE(x)) {
    TRUE
  } else {
    unname(lapply(x, as.character))
  }
}

coerce_enable <- function(x) {
  if (!is.null(x)) {
    if (!isTRUE(x)) {
      lapply(x, as.character)
    } else {
      x
    }
  }
}

coerce_disable <- function(x) {
  if (!is.null(x)) {
    if (!isTRUE(x)) {
      lapply(x, as.character)
    } else {
      x
    }
  }
}

coerce_valid <- function(x) {
  if (!is.null(x)) {
    HTML(as.character(x))
  }
}

coerce_invalid <- function(x) {
  if (!is.null(x)) {
    HTML(as.character(x))
  }
}

coerce_submit <- function(x) {
  if (identical(as.logical(x), FALSE)) {
    NULL
  } else {
    x
  }
}
