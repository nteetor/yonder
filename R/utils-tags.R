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

tag_attributes_add <- function(x, attrs = NULL, ...) {
  stopifnot(is_tag(x))

  args <- c(attrs, list(...))

  if (length(args) == 0) {
    return(x)
  }

  x$attribs <- c(x$attribs, args)

  x
}

tag_class_add <- function(x, class) {
  stopifnot(is_tag(x))

  class <- trimws(class, "both")

  if (length(class) < 1 || !all(nzchar(class))) {
    return(x)
  }

  if (is.null(x$attribs$class)) {
    x$attribs$class <- paste(class, collapse = " ")
    return(x)
  }

  class <- unlist(strsplit(class, "\\s+"))

  dups <- vapply(class, grepl, logical(1), x = x$attribs$class, fixed = TRUE)
  new <- paste0(class[!dups], collapse = " ")

  if (isTRUE(nzchar(new))) {
    x$attribs$class <- paste(x$attribs$class, new)
  }

  x
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
