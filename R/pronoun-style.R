#' Style pronoun
#'
n#' @description
#'
#' The `.style` pronoun allows you to define styles for a tag element within the
#' element's context. Prior to the introduction of the `.style` pronoun tag
#' elements had to be piped into design utilities.
#'
#' ```R
#' div() %>% background("primary") %>% display("flex")
#' ```
#'
#' Once the content of a tag element grows to more than a few lines, associating
#' the element's styles with the element itself becomes increasingly
#' unintuitive. In these situations, make use of the `.style` pronoun.
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
.style <- structure(list(), class = "yonder_style_pronoun")

style_pronoun <- function(subclass = NULL) {
  structure(list(), class = c("yonder_style_pronoun", subclass))
}

is_style_pronoun <- function(x) {
  inherits(x, "yonder_style_pronoun")
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

    if (!is_style_pronoun(x)) {
      stop(
        "unexpected `.style` object",
        call. = FALSE
      )
    }
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
