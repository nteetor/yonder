coerce_content <- function(x) {
  if (length(x) > 0) {
    if (is_tag(x)) {
      HTML(as.character(x))
    } else {
      HTML(paste(
        vapply(x, function(i) HTML(as.character(i)), character(1)),
        collapse = "\n"
      ))
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
      lapply(x, function(i) HTML(as.character(i)))
    } else {
      x
    }
  }
}

coerce_disable <- function(x) {
  if (!is.null(x)) {
    if (!isTRUE(x)) {
      lapply(x, function(i) HTML(as.character(i)))
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
