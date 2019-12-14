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

style_test <- function(...) {
  style_eval_dots(...)
}

style_eval_dots <- function(..., .context = list()) {
  style_mask <- list(
    .style = exec(style_create_pronoun, !!!.context)
  )

  # All this because,
  # 1. with_bindings splices its arguments, can't do the following,
  #    with_bindings(dots_list(...), .style = ..)
  # 2. eval_tidy(quo(dots_list(...)), style_mask) does _not_ work

  qargs <- enquos(...)
  args <- lapply(qargs, eval_tidy, data = style_mask)

  Reduce(function(a, b) dots_list(!!!a, b), args, init = list())
}

style_create_pronoun <- function(...) {
  style_splice2(structure(list(), ...))
}

style_class_add <- function(x, new) {
  x <- unbox(x)

  if (!is.null(x$class)) {
    new <- paste(x$class, new)
  }

  x$class <- new

  style_splice2(x)
}

style_class_build <- function(x, body, prefix = NULL) {
  x <- unbox(x)

  if (is.null(prefix)) {
    return(body)
  }

  sprintf("%s-%s", style_get_prefix(x, prefix), body)
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
