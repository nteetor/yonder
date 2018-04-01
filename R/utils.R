# plain utils ----

`%||%` <- function(a, b) if (is.null(a)) b else a

`%??%` <- function(a, b) if (!is.null(a)) b else NULL

encode_commas <- function(x) {
  gsub(",", "&#44;", x, fixed = TRUE)
}

# check that a date string is in the format YYYY-mm-dd
is_ymd <- function(x) {
  grepl("\\d{4}-\\d{2}-\\d{2}", x)
}

is_date <- function(x) {
  inherits(x, c("Date", "POSIXlt", "POSIXt"))
}

is_strictly_list <- function(x) {
  length(class(x)) == 1 && class(x) == "list"
}

to_sentence <- function(x, con = "or") {
  if (length(x) == 1) {
    return(x)
  }

  if (length(x) == 2) {
    return(paste(x[1], con, x[2]))
  }

  paste0(paste(x[-length(x)], collapse = ", "), ", ", con, " ", x[length(x)])
}

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
  unname(x[names2(x) == ""])
}

# Join HTML attribute values
#
# A function to join HTML attribute values with `htmltools` in mind. If all
# arguments are `NULL`, `NULL` is returned so the attribute can be dropped. If
# all arguments are the empty string, `NULL` is returned so the attribute can
# be dropped. If all arguments are `NA`, then `NA` is returned to preserve a
# boolean attribute. Otherwise, all arguments are collapsed together into a
# single string suitable for an HTML attribute.
#
# @param ... Any number of arguments to combine together as a single HTML
#   attribute value.
#
# @param collapse A character string specifying how the arguments are pasted
#   together, passed to `paste`, defaults to `" "`.
#
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

responsives <- function(prefix, values, possible) {
  call <- as.character(sys.call(-1))[1]

  if (length(values) == 0) {
    stop(
      "invalid `", call, "` arguments, at least one argument must not be NULL",
      call. = FALSE
    )
  }

  breakpoints <- names2(values)
  allowed <- paste(possible, collapse = "|")

  vapply(
    breakpoints,
    function(point) {
      val <- values[[point]]

      if (!re(val, allowed)) {
        if (is.character(possible)) {
          possible <- paste0('"', possible, '"')
        }

        stop(
          "invalid `", call, "` argument, `", point, "` must be one of ",
          to_sentence(possible),
          call. = FALSE
        )
      }

      if (point == "default") {
        paste0(prefix, "-", val)
      } else {
        paste0(prefix, "-", point, "-", val)
      }
    },
    character(1)
  )
}

# shiny utils ----

dropNulls <- function(x) {
  x[!vapply(x, is.null, logical(1))]
}

# borrowed from shiny, see shiny/R/utils.R
wrapFunctionLabel <- function(func, name, ..stacktraceon = FALSE) {
  if (name == "name" || name == "func" || name == "relabelWrapper") {
    stop("Invalid name for wrapFunctionLabel: ", name)
  }
  assign(name, func, environment())
  registerDebugHook(name, environment(), name)

  relabelWrapper <- eval(substitute(
    function(...) {
      # This `f` gets renamed to the value of `name`. Note that it may not
      # print as the new name, because of source refs stored in the function.
      if (..stacktraceon)
        shiny::..stacktraceon..(f(...))
      else
        f(...)
    },
    list(f = as.name(name))
  ))

  relabelWrapper
}

# borrowed from shiny, see shiny/R/utils.R
registerDebugHook <- function(name, where, label) {
  if (exists("registerShinyDebugHook", mode = "function")) {
    registerShinyDebugHook <- get("registerShinyDebugHook", mode = "function")
    params <- new.env(parent = emptyenv())
    params$name <- name
    params$where <- where
    params$label <- label
    registerShinyDebugHook(params)
  }
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

tagAddClass <- function(x, class) {
  if (is.null(x$attribs$class)) {
    x$attribs$class <- class
    return(x)
  }

  this <- x$attribs$class
  this <- paste(this, class)
  this <- gsub("^\\s+|\\s+$", "", this)

  x$attribs$class <- this

  x
}

tagDropClass <- function(x, regex) {
  if (is.null(x$attribs$class)) {
    return(x)
  }

  x$attribs$class <- gsub(regex, "", x$attribs$class)
  x
}

tagDropContext <- function(x, prefix) {
  if (is.null(x$attribs$class)) {
    return(x)
  }

  reg <- paste0(prefix, "-(primary|secondary|success|info|warning|danger|light|dark|white|muted)")
  x$attribs$class <- gsub(reg, "", x$attribs$class)

  x
}
