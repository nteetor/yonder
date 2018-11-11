# necessary for `createRenderFunction()`
globalVariables("func")

# plain utils ----

`%||%` <- function(a, b) if (is.null(a)) b else a

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

conjoin <- function(x, con = "or") {
  if (length(x) == 1) {
    return(as.character(x))
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

  grepl(paste0("^(", pattern, ")$"), string)
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

msgInvalidValues <- function(fun, argument, invalid) {
  if (is.character(invalid)) {
    invalid <- paste0('"', invalid, '"')
  }

  sprintf(
    "invalid call to `%s()`, argument `%s` contains unexpected value%s %s",
    as.character(fun),
    as.character(argument),
    if (length(invalid) > 1) "s" else "",
    conjoin(as.character(invalid), con = "and")
  )
}

msgInvalidBreakpoints <- function(fun, argument, invalid) {
  sprintf(
    "invalid call to `%s()`, argument `%s` contains unexpected breakpoint%s %s",
    as.character(fun),
    as.character(argument),
    if (length(invalid) > 1) "s" else "",
    conjoin(paste0("`", invalid, "`"))
  )
}

msgInvalidTooManyValues <- function(fun, argument, invalid) {
  sprintf(
    "invalid call to `%s()`, argument `%s` breakpoint%s %s contain%s too many values",
    as.character(fun),
    as.character(argument),
    if (length(invalid) > 1) "s" else "",
    conjoin(paste0("`", invalid, "`"), con = "and"),
    if (length(invalid) > 1) "" else "s"
  )
}

msgDuplicateBreakpoints <- function(fun, duplicates, arguments) {
  fun <- as.character(fun)
  duplicates <- as.character(duplicates)
  arguments <- as.character(arguments)

  sprintf(
    "invalid call to `%s()`, %s breakpoint%s specified in multiple arguments %s",
    fun,
    conjoin(sprintf("`%s`", duplicates), con = "and"),
    if (length(duplicates) > 1) "s" else "",
    conjoin(sprintf("`%s`", arguments), con = "and")
  )
}

checkDuplicateBreakpoints <- function(...) {
  passed <- as.character(as.list(substitute(list(...)))[-1])
  args <- list(...)
  flat <- unlist(list(...))

  if (any(duplicated(names(flat)))) {
    dups <- names(flat)[duplicated(names(flat))]
    points <- passed[vapply(args, function(a) any(names(a) %in% dups), logical(1))]
    caller <-  sys.call(-1)[[1]]

    stop(
      msgDuplicateBreakpoints(caller, dups, points),
      call. = FALSE
    )
  }
}

ensureBreakpoints <- function(values, possible) {
  if (is.null(values)) {
    return(list())
  }

  values <- as.list(values)
  caller <- sys.call(-1)[[1]]
  passed <- match.call()$values

  if (length(values) == 1 && names2(values) == "") {
    names(values) <- "default"
  }

  if (length(invalid <- getInvalidBreakpoints(values))) {
    stop(
      msgInvalidBreakpoints(caller, passed, invalid),
      call. = FALSE
    )
  }

  if (length(invalid <- getInvalidLengths(values))) {
    stop(
      msgInvalidTooManyValues(caller, passed, invalid),
      call. = FALSE
    )
  }

  if (length(invalid <- getInvalidValues(values, possible))) {
    stop(
      msgInvalidValues(caller, passed, invalid),
      call. = FALSE
    )
  }

  names(values) <- vapply(
    names2(values),
    function(nm) if (nm == "xs") "default" else nm,
    character(1)
  )

  values
}

getInvalidBreakpoints <- function(values) {
  if (length(values) == 0) {
    return(NULL)
  }

  names2(values)[!re(names2(values), "default|xs|sm|md|lg|xl")]
}

getInvalidLengths <- function(values) {
  if (length(values) == 0) {
    return(NULL)
  }

  names2(values)[vapply(values, length, numeric(1)) > 1]
}

getInvalidValues <- function(values, possible) {
  if (length(values) == 0) {
    return(NULL)
  }

  unlist(values)[!vapply(values, `%in%`, logical(1), possible)]
}

createResponsiveClasses <- function(values, prefix) {
  if (!length(values)) {
    return(NULL)
  }

  vapply(
    names2(values),
    function(breakpoint) {
      value <- values[[breakpoint]]

      if (breakpoint == "default") {
        paste0(prefix, "-", value)
      } else {
        paste0(prefix, "-", breakpoint, "-", value)
      }
    },
    character(1),
    USE.NAMES = FALSE
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

# https://github.com/rstudio/shiny/blob/c332c051f33fe325f6c2e75426daaabb6366d50a/R/html-deps.R#L43
processDeps <- function(tags, session) {
  ui <- takeSingletons(tags, session$singletons, desingleton = FALSE)$ui
  ui <- surroundSingletons(ui)

  dependencies <- lapply(
    resolveDependencies(findDependencies(ui)),
    createWebDependency
  )
  names(dependencies) <- NULL

  # list(
  #   html = doRenderTags(ui),
  #   deps = dependencies
  # )
  dependencies
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

tagRename <- function(tag, name) {
  if (!is_tag(tag)) {
    return(NULL)
  }

  tag$name <- name
  tag
}

tagIs <- function(x, name) {
  if (!is_tag(x)) {
    return(FALSE)
  }

  isTRUE(x$name %in% name)
}

tagAddClass <- function(x, class) {
  stopifnot(is_tag(x))

  if (length(class) < 1) {
    return(x)
  }

  class <- trimws(class)

  if (is.null(x$attribs$class)) {
    x$attribs$class <- paste(class, collapse = " ")
    return(x)
  }

  old <- unlist(strsplit(x$attribs$class, "\\s+"))
  new <- unlist(strsplit(class, "\\s+"))

  x$attribs$class <- paste(unique(c(old, new)), collapse = " ")

  x
}

tagDropClass <- function(x, regex) {
  if (is.null(x$attribs$class)) {
    return(x)
  }

  x$attribs$class <- gsub(regex, "", x$attribs$class)
  x$attribs$class <- gsub("\\s+", " ", x$attribs$class)
  x
}
