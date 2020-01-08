style_pronoun <- function(subclass = NULL) {
  structure(list(), class = c(subclass, "yonder_style_pronoun"))
}

is_style_pronoun <- function(x) {
  inherits(x, "yonder_style_pronoun")
}

is_style_box <- function(x) {
  is_box(x) && is_style_pronoun(unbox(x))
}

is_style_bare <- function(x) {
  is_style_pronoun(x) && length(class(x)) == 1
}

print.yonder_style_pronoun <- function(x, ...) {
  cat("<pronoun>\n")
  invisible(x)
}

str.yonder_style_pronoun <- function(object, ...) {
  cat("<pronoun>\n")
  invisible(NULL)
}

style_dots_eval <- function(..., .style = NULL, .mask = NULL) {
  .style <- .style %||% style_pronoun()

  .mask <- list2(.style = .style, !!!.mask)

  # eval_tidy and with_bindings don't seem to affect ... evaluation
  qargs <- enquos(...)
  args <- lapply(qargs, eval_tidy, data = .mask)

  flatten_if(args)
}

style_class_add <- function(x, new) {
  if (!nzchar(new) || length(new) == 0) {
    return(x)
  }

  if (is_spliced(x)) {
    x <- unbox(x)
  }

  if (length(new) < 1 || all(!nzchar(new)) || is_na(new)) {
    return(x)
  }

  if (length(new) > 1) {
    new <- paste(new, collapse = " ")
  }

  if (!is.null(x$class)) {
    new <- paste(x$class, new)
  }

  x$class <- new

  rlang::splice(x)
}

#' Style pronoun
#'
#' @description
#'
#' The `.style` pronoun allows you to define styles for a tag element within the
#' context of the element. Prior to the introduction of the `.style` pronoun tag
#' styles were always applied outside or after constructing a tag element.
#'
#' ```R
#' card() %>% background("primary") %>% display("flex")
#' ```
#'
#' However, once the content of a tag element grows to more than a few lines,
#' associating the element's styles with the element becomes increasingly
#' unintuitive. In these situations, make use of the `.style` pronoun.
#'
#' ```R
#' card(
#'   .style %>%
#'     border("primary") %>%
#'     font("primary")
#' )
#' ```
#'
#' @format NULL
#' @include utils.R
#' @export
.style <- style_pronoun()
