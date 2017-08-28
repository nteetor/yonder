# plain utils ----

`%||%` <- function(a, b) if (is.null(a)) b else a

`map*` <- function(x, f) {
  if (length(x) == 1) {
    return(f(x))
  }

  lapply(
    x,
    function(i) {
      `map*`(i, f)
    }
  )
}

# conform x to structure of y
conform <- function(x, y) {
  if (length(unlist(y, FALSE)) != length(x)) {
    stop(
      "invalid `conform` arguments, `x` and `y` must have the same number of ",
      "items",
      call. = FALSE
    )
  }

  counter <- 0
  getnext <- function() {
    counter <<- counter + 1
    x[[counter]]
  }

  each(y, getnext)
}

re <- function(string, pattern, len0 = TRUE) {
  if (length(string) == 0 && len0) {
    # because grepl("", <regex>) returns TRUE, extend this to
    # handle character(0) or NULL
    return(TRUE)
  }

  grepl(pattern, paste0("^", string, "$"))
}

ID <- function(x) {
  vapply(
    x,
    function(i) {
      paste0(
        paste0(i, collapse = "-"), "-",
        paste0(sample(seq_len(1000), 2, TRUE), collapse = "-")
      )
    },
    character(1),
    USE.NAMES = FALSE
  )
}

names2 <- function(x) {
  names(x) %||% rep.int("", length(x))
}

match2 <- function(x, values, default = FALSE) {
  if (is.null(x)) {
    if (length(values) == 0) {
      return(NULL)
    }

    if (default) {
      return(c(TRUE, vector("logical", length(values) - 1)))
    } else {
      return(vector("logical", length(values)))
    }
  }

  vapply(
    values,
    function(v) {
      if (is.null(v)) {
        return(FALSE)
      }
      v %in% x
    },
    logical(1)
  )
}

attribs <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }
  x[names2(x) != ""]
}

elements <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }
  x[names2(x) == ""]
}

#' Join HTML attribute values
#'
#' A function to join HTML attribute values with `htmltools` in mind. If all
#' arguments are `NULL`, `NULL` is returned so the attribute can be dropped. If
#' all arguments are the empty string, `NULL` is returned so the attribute can
#' be dropped. If all arguments are `NA`, then `NA` is returned to preserve a
#' boolean attribute. Otherwise, all arguments are collapsed together into a
#' single string suitable for an HTML attribute.
#'
#' @param ... Any number of arguments to combine together as a single HTML
#'   attribute value.
#'
#' @param collapse A character string specifying how the arguments are pasted
#'   together, passed to `paste`, defaults to `" "`.
#'
#' @keywords internal
#' @export
#' @examples
#' collate(
#'   "container",
#'   "my-custom-class"
#' )
#'
#' collate(
#'   "container",
#'   utils$border(round = "all")
#' )
#'
collate <- function(..., collapse = " ") {
  args <- unique(c(...))

  if (is.null(args)) {
    NULL
  } else if (all(args == "")) {
    NULL
  } else if (all(is.na(args))) {
    NA_character_
  } else {
    paste(args, collapse = collapse)
  }
}

# shiny utils ----

dropNulls <- function(x) {
  x[!vapply(x, is.null, logical(1))]
}

# tag utils ----

is_tag <- function(x) {
  inherits(x, "shiny.tag")
}

tagConcatAttributes <- function(x, attrs) {
  if (!is_tag(x)) {
    return(NULL)
  }

  x$attribs <- c(x$attribs, attrs)
  x
}

tagHasClass <- function(x, class) {
  if (!is_tag(x) || is.null(x$attribs$class)) {
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
  if (!is_tag(x)) {
    return(NULL)
  }

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

tagRename <- function(tag, name) {
  if (!is_tag(tag)) {
    return(NULL)
  }

  tag$name <- name
  tag
}

tagIs <- function(x, name) {
  if (!is_tag(x)) {
    return(NULL)
  }
  x$name == name
}
