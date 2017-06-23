# plain utils ----

`%||%` <- function(a, b) if (is.null(a)) b else a

re <- function(string, pattern) {
  if (length(string) == 0) {
    return(FALSE)
  }

  grepl(pattern, string)
}

ID <- function(x) {
  paste0(x, "-", paste0(sample(seq_len(1000), 2, TRUE), collapse = "-"))
}

elodin <- function(x) {
  names(x) %||% rep.int("", length(x))
}

is_named <- function(x) {
  all(elodin(x) != "")
}

is_tag <- function(x) {
  inherits(x, "shiny.tag")
}

collate <- function(..., collapse = " ") {
  paste(c(...), collapse = collapse)
}

bad_context <- function(x, extra = NULL) {
  if (is.null(x)) {
    return(FALSE)
  }

  !(x %in% c("success", "info", "warning", "danger", extra))
}

# shiny utils ----

getShinyDefaultReactiveDomain <- function() {
  shiny:::.globals$domain
}

dropNulls <- function(x) {
  x[!vapply(x, is.null, logical(1))]
}

# tag utils ----

tagHasClass <- function(x, class) {
  if (is.null(x$attribs$class)) {
    return(FALSE)
  }

  grepl(
    paste0(
      c("^", "^", "\\s", "\\s"), class, c("$", "\\s", "\\s", "$"),
      collapse = "|"
    ),
    x$attribs$class
  )
}

tagEnsureClass <- function(x, class) {
  if (is.null(x$attribs$class)) {
    x$attribs$class <- class
    return(x)
  }

  if (!tagHasClass(x, class)) {
    x$attribs$class <- collate(x$attribs$class, class)
    return(x)
  }

  x
}
