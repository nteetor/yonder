#' Tag margins and padding
#'
#' @description
#'
#' These functions are used in conjunction with [tagReduce] to change the
#' padding or margins of a tag. Each argument value may be a single value or a
#' vector of four values. Margins and padding are specified as 0, 1, 2, 3, 4, or
#' 5. 0 removes any margins or padding. 5 is equivalent to `3rem` (`rem` is a
#' relative unit of measurement in css).
#'
#' Specifying a single value changes the margin or padding of all four tag
#' sides. To apply different margins or padding to each side pass a vector of
#' four values. In this case, the first value is for the top side, second for
#' the left side, third for the bottom side, and the fourth value is for the
#' left side. As a wise help page once said, think "**tr**ou**bl**e" to help
#' remember the order.
#'
#' @param default One of 0, 1, 2, 3, 4, 5 specifying the default margins or
#'   padding to apply. If the margins and padding remain the same across all
#'   viewports then only `default` needs to be specified.
#'
#' @param sm Like `default`, but the margins or padding are applied once the
#'   viewport is 576 pixels wide, think phone in landscape mode.
#'
#' @param md Like `default`, but the margins or padding are applied once the
#'   viewport is 768 pixels wide, think tablets.
#'
#' @param lg Like `default`, but the margins or padding are applied once the
#'   viewport is 992 pixels wide, think desktop.
#'
#' @param xl Like `default`, but the margins or padding are applied once the
#'   viewport is 1200 pixels wide, think large desktop.
#'
#' @family utilities
#' @export
padding <- function(default = NULL, sm = NULL, md = NULL, lg = NULL,
                    xl = NULL) {
  args <- dropNulls(list(default = default, sm = sm , md = md, lg = lg, xl = xl))

  if (length(args) == 0) {
    stop(
      "invalid `padding` arguments, at least one argument must not be NULL",
      call. = FALSE
    )
  }

  classes <- vapply(
    names2(args),
    function(nm) {
      arg <- args[[nm]]

      if (!all(arg %in% 0:5)) {
        stop(
          "invalid `padding` argument, `", nm, "` value(s) must be 0, 1, 2, 3, 4, or 5",
          call. = FALSE
        )
      }

      if (length(arg) != 1 && length(arg) != 4) {
        stop(
          "invalid `padding` argument, `", nm, "` must be a single value or a vector of 4 values",
          call. = FALSE
        )
      }

      prefix <- "p"
      sides <- c("t", "r", "b", "l")

      breakpoint <- if (nm == "default") "-" else paste0("-", nm, "-")

      if (length(default) == 4) {
        return(paste0(prefix, sides, breakpoint, arg, collapse = " "))
      }

      paste0(prefix, breakpoint, arg)
    },
    character(1)
  )

  class <- collate(classes)

  function(tag) {
    htmltools::tagAppendAttributes(tag, class = class)
  }
}

#' @rdname padding
#' @export
margins <- function(default = NULL, sm = NULL, md = NULL, lg = NULL,
                    xl = NULL) {
  args <- dropNulls(list(default = default, sm = sm, md = md, lg = lg, xl = xl))

  if (length(args) == 0) {
    stop(
      "invalid `margins` arguments, at least one argument must not be NULL",
      call. = FALSE
    )
  }

  prefix <- "m"
  sides <- c("t", "r", "b", "l")

  classes <- vapply(
    names2(args),
    function(nm) {
      arg <- args[[nm]]

      if (!all(arg %in% 0:5)) {
        stop(
          "invalid `margins` argument, `", nm, "` value(s) must be 0, 1, 2, 3, 4, or 5",
          call. = FALSE
        )
      }

      if (length(arg) != 4 && length(arg) != 1) {
        stop(
          "invalid `margins` argument, `", nm, "` must be a single value or a vector of four values",
          call. = FALSE
        )
      }

      breakpoint <- if (nm == "default") "-" else paste0("-", nm, "-")

      if (length(arg) == 4) {
        return(paste0(prefix, sides, breakpoint, arg, collapse = " "))
      }

      paste0(prefix, breakpoint, arg)
    },
    character(1)
  )

  class <- collate(classes)

  function(tag) {
    htmltools::tagAppendAttributes(tag, class = class)
  }
}

#' Tag width and height
#'
#' Used in conjunction with [tagReduce] to change a tag element's width or
#' height. Widths and heights are specified as percentages of the parent
#' object's width or height.
#'
#' @param percentage One of 25, 50, 75, or 100 specifying width or height as a
#'   percentage of a parent element's width or height.
#'
#' @param max One of 25, 50, 75, or 100 specifying max width or max height as a
#'   percentage of a parent element's width or height.
#'
#' @export
#' @examples
#' tagReduce(
#'   width(25),
#'   height(100)
#'   tags$div()
#' )
#'
#' tagReduce(
#'   width(max = 75),
#'   tags$div()
#' )
#'
width <- function(percentage = NULL, max = NULL) {
  if (is.null(percentage) && is.null(max)) {
    stop(
      "invalid `width` arguments, `percentage` and `max` may not both be NULL",
      call. = FALSE
    )
  }

  if (!is.null(percentage) && !(percentage %in% c(25, 50, 75, 100))) {
    stop(
      "invalid `width` argument, `percentage` must be one of 25, 50, 75, or 100",
      call. = FALSE
    )
  }

  if (!is.null(max) && !(max %in% c(25, 50, 75, 100))) {
    stop(
      "invalid `width` argument, `max` must be one of 25, 50, 75, or 100",
      call. = FALSE
    )
  }

  class <- collate(
    percentage %??% paste0("w-", percentage),
    max %??% paste0("mw-", max)
  )

  function(tag) {
    htmltools::tagAppendAttributes(tag, class = class)
  }
}

#' @rdname width
#' @export
height <- function(percentage = NULL, max = NULL) {
  if (is.null(percentage) && is.null(max)) {
    stop(
      "invalid `height` arguments, `percentage` and `max` may not both be NULL",
      call. = FALSE
    )
  }

  if (!is.null(percentage) && !(percentage %in% c(25, 50, 75, 100))) {
    stop(
      "invalid `height` argument, `percentage` must be one of 25, 50, 75, or 100",
      call. = FALSE
    )
  }

  if (!is.null(max) && !(max %in% c(25, 50, 75, 100))) {
    stop(
      "invalid `height` argument, `max` must be one of 25, 50, 75, or 100",
      call. = FALSE
    )
  }

  class <- collate(
    percentage %??% paste0("h-", percentage),
    max %??% paste0("mh-", max)
  )

  function(tag) {
    htmltools::tagAppendAttributes(tag, class = class)
  }
}

#' Apply styles to a tag
#'
#' This function applies any number of styles generated by utility function
#' calls.
#'
#' @param ... Any number of utility function calls **and** one tag object.
#'
#' @export
#' @examples
#' tagReduce(
#'   width(25),
#'   padding(3),
#'   tags$div()
#' )
#'
#' tagReduce(
#'   margins(sm = 1, xl = 5),
#'   tags$span()
#' )
#'
tagReduce <- function(...) {
  args <- list(...)

  tag_objs <- vapply(args, is_tag, logical(1))

  if (!any(tag_objs)) {
    stop(
      "invalid call to `tagReduce`, one argument must be a tag object",
      call. = FALSE
    )
  }

  if (sum(tag_objs) > 1) {
    stop(
      "invalid call to `tagReduce`, only one argument may be a tag object",
      call. = FALSE
    )
  }

  funs <- args[!tag_objs]
  tag <- args[tag_objs][[1]]

  if (length(funs) == 0) {
    return(tag)
  }

  Reduce(function(acc, fun) fun(acc), funs, init = tag)
}

