is_tag <- function(x) {
  inherits(x, "shiny.tag")
}

tag_browse <- function(x) {
  htmltools::browsable(x)
}

tag_name_is <- function(x, name) {
  stopifnot(is_tag(x))
  isTRUE(x$name == name)
}

tag_extend_with <- function(x, pieces) {
  stopifnot(is_tag(x))

  x <- tag_children_add(x, unnamed_values(pieces))
  x <- tag_attributes_add(x, named_values(pieces))

  x
}

tag_children_add <- function(x, children = NULL, ...) {
  stopifnot(is_tag(x))

  args <- c(children, list(...))

  if (length(args) == 0) {
    return(x)
  }

  x$children <- c(x$children, args)

  x
}

tag_attributes_add <- function(x, attrs = NULL, ...) {
  stopifnot(is_tag(x))

  args <- c(attrs, list(...))

  if (length(args) == 0) {
    return(x)
  }

  x$attribs <- c(x$attribs, args)

  x
}

tag_class_add <- function(x, new) {
  if (is_style_pronoun(x) || is_style_box(x)) {
    return(style_class_add(x, new))
  }

  stopifnot(is_tag(x))

  new <- trimws(new, "both")
  prev <- x$attribs$class

  if (length(new) < 1 || !all(nzchar(new))) {
    return(x)
  }

  if (is.null(prev)) {
    x$attribs$class <- paste(new, collapse = " ")
    return(x)
  }

  new <- unlist(strsplit(new, "\\s+"))

  dups <- vapply(new, grepl, logical(1), x = prev, fixed = TRUE)
  new <- paste0(new[!dups], collapse = " ")

  if (isTRUE(nzchar(new))) {
    x$attribs$class <- paste(prev, new)
  }

  dep_attach(x)
}

tag_class_remove <- function(x, regex) {
  stopifnot(is_tag(x))

  if (is.null(x$attribs$class)) {
    return(x)
  }

  class_indices <- rlang::names2(x$attribs) == "class"
  class_values <- x$attribs[class_indices]

  class_subbed <- vapply(
    class_values, gsub, character(1),
    pattern = regex, replacement = ""
  )

  class_trimmed <- trimws(gsub("\\s+", " ", class_subbed), "both")

  x$attribs[class_indices] <- class_trimmed

  x
}

tag_class_re <- function(x, regex) {
  stopifnot(is_tag(x))

  if (is.null(x$attribs$class)) {
    return(FALSE)
  }

  regex <- paste0(
    c("^", "^", "\\s", "\\s"), regex, c("$", "\\s", "\\s", "$"),
    collapse = "|"
  )

  class_indices <- rlang::names2(x$attribs) == "class"

  any(vapply(x$attribs[class_indices], grepl, logical(1), pattern = regex))
}
