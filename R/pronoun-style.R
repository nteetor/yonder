#' Style pronoun
#'
#' @description
#'
#' The `.style` pronoun allows you to define styles for a tag element within the
#' element's context. Prior to the introduction of the `.style` pronoun tag
#' elements had to be piped into design utilities.
#'
#' ```R
#' div() %>% background("primary") %>% display("flex")
#' ```
#'
#' Once the content of `div()` grows to more than a few lines associating the
#' styles with the `div()` becomes increasingly unintuitive. In these
#' situations, make use of the `.style` pronoun.
#'
#' ```R
#' div(
#'   .style %>%
#'     background("primary") %>%
#'     display("flex")
#' )
#' ```
#'
#' @include utils.R
#' @export
## .style <- s3_class_add(rlang::splice(list()), "yonder_style_accumulator")
.style <- local({
  s <- splice(list())
  class(s) <- unique(c("yonder_style_accumulator", class(s)))
  s
})

style_pronoun <- function(extra = NULL) {
  if (!is.null(extra)) {
    extra <- paste0("yonder_", extra)
  }

  structure(list(), class = c("yonder_style_accumulator", extra))
}

style_dots_eval <- function(..., .style = NULL, .mask = NULL) {
  .style <- .style %||% style_pronoun(.style)

  .mask <- list2(.style = .style, !!!.mask)

  # eval_tidy and with_bindings don't seem to affect ... evaluation
  qargs <- enquos(...)
  args <- lapply(qargs, eval_tidy, data = .mask)

  flatten_if(args)
}

style_create_pronoun <- function(...) {
  style_splice2(structure(list(), ...))
}

style_class_add <- function(x, new) {
  if (!nzchar(new) || length(new) == 0) {
    return(x)
  }

  if (is_box(x)) {
    x <- unbox(x)
  }

  if (length(new) > 1) {
    new <- paste(new, collapse = " ")
  }

  if (!is.null(x$class)) {
    new <- paste(x$class, new)
  }

  x$class <- new

  style_splice2(x)
}

style_class_build <- function(x, prefix, ...) {
  x <- unbox(x)

  if (is.null(prefix)) {
    return(body)
  }

  args <- vapply(list(...), as.character, character(1))

  paste(c(style_get_prefix(x, prefix), args), collapse = "-")
}

style_get_prefix <- function(x, default) {
  x %@% "prefix" %||% default
}

style_splice <- function(x) {
  s3_class_add(splice(x), "yonder_style_accumulator")
}

style_splice2 <- function(x) {
  s <- splice(x)
  class(s) <- unique(c("yonder_style_accumulator", class(s)))
  s
}
