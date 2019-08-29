coerce_content <- function(x) {
  if (length(x) > 0) {
    if (is_tag(x)) {
      HTML(as.character(x))
    } else {
      HTML(
        paste(
          vapply(x, as.character, character(1)),
          collapse = "\n"
        )
      )
    }
  } else {
    ""
  }
}

coerce_selected <- function(x) {
  if (is.null(x)) {
    x
  } else if (isTRUE(x)) {
    x
  } else {
    lapply(x, as.character)
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

format_targets <- function(targets, values) {
  if (is.null(targets)) {
    return(targets)
  }

  if (length(targets) > 1) {
    targets <- lapply(targets, function(target) {
      if (is.character(target)) {
        paste0("#", target, collapse = " ")
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
