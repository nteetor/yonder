.style <- rlang::splice(list())
class(.style) <- unique(c("yonder_style_accumulator", class(.style)))

style_splice <- function(x) {
  x <- rlang::splice(x)
  class(x) <- unique(c("yonder_style_accumulator", class(x)))
  x
}

style_class_add <- function(x, new) {
  x <- rlang::unbox(x)
  old <- x$class

  if (!is.null(old)) {
    new <- paste(old, new)
  }

  x$class <- new

  style_splice(x)
}

style_class_build <- function(x, body, prefix = NULL) {
  x <- rlang::unbox(x)

  paste(c(style_get_prefix(x, prefix), body), collapse = "-")
}

style_get_prefix <- function(x, default) {
  attr(x, "prefix", exact = TRUE) %||% default
}

style_create_context <- function(...) {
  s <- rlang::splice(structure(list(), ...))
  class(s) <- unique(c("yonder_style_accumulator", class(s)))
  s
}
