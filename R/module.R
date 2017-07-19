format.module <- function(x, ...) {
  title <- paste0("Module: ", attr(x, "name") %||% "[?]")
  components <- names(x)
  classes <- paste0("<", vapply(x, function(i) class(i)[1], character(1)), ">")
  body <- paste0("  ", components, " ", classes, "\n", collapse = "")
  paste0(title, "\n", body)
}

print.module <- function(x, ...) {
  cat(format(x))
  invisible(x)
}
