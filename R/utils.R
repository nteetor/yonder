# necessary for `createRenderFunction()`
globalVariables("func")

# plain utils ----
`%||%` <- function(a, b) if (is.null(a)) b else a

encode_commas <- function(x) {
  gsub(",", "&#44;", x, fixed = TRUE)
}

is_strictly_list <- function(x) {
  length(class(x)) == 1 && class(x) == "list"
}

drop_nulls <- function(x) {
  if (length(x) == 0) {
    x
  } else {
    x[!vapply(x, is.null, logical(1))]
  }
}

str_conjoin <- function(x, con = "or") {
  if (length(x) == 1) {
    return(as.character(x))
  }

  if (length(x) == 2) {
    return(paste(x[1], con, x[2]))
  }

  paste0(paste(x[-length(x)], collapse = ", "), ", ", con, " ", x[length(x)])
}

str_collate <- function(..., collapse = " ") {
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

str_re <- function(string, pattern, len0 = TRUE) {
  if (length(string) == 0) {
    return(len0)
  }

  grepl(paste0("^(?:", pattern, ")$"), string)
}

generate_id <- function(prefix) {
  paste(c(prefix, sample(1000, 2, TRUE)), collapse = "-")
}

names2 <- function(x) {
  names(x) %||% rep.int("", length(x))
}

named_values <- function(x) {
  x[names2(x) != ""]
}

unnamed_values <- function(x) {
  x[names2(x) == ""]
}

is_tag <- function(x) {
  inherits(x, "shiny.tag")
}

tag_browse <- function(x) {
  htmltools::browsable(x)
}

tag_name_is <- function(x, name) {
  stopifnot(is_tag(x))
  isTRUE(x$name == name)
}

tag_attributes_add <- function(x, attrs = NULL, ...) {
  stopifnot(is_tag(x))

  args <- c(attrs, list(...))

  if (length(args) == 0) {
    return(x)
  }

  x$attribs <- c(x$attribs, args)

  x
}

tag_class_add <- function(x, class) {
  stopifnot(is_tag(x))

  class <- trimws(class, "both")

  if (length(class) < 1 || !all(nzchar(class))) {
    return(x)
  }

  if (is.null(x$attribs$class)) {
    x$attribs$class <- paste(class, collapse = " ")
    return(x)
  }

  class <- unlist(strsplit(class, "\\s+"))

  dups <- vapply(class, grepl, logical(1), x = x$attribs$class, fixed = TRUE)
  new <- paste0(class[!dups], collapse = " ")

  if (isTRUE(nzchar(new))) {
    x$attribs$class <- paste(x$attribs$class, new)
  }

  x
}

tag_class_remove <- function(x, regex) {
  stopifnot(is_tag(x))

  if (is.null(x$attribs$class)) {
    return(x)
  }

  class_indices <- names2(x$attribs) == "class"
  class_values <- x$attribs[class_indices]

  class_subbed <- vapply(
    class_values, gsub, character(1),
    pattern = regex, replacement = ""
  )

  class_trimmed <- trimws(gsub("\\s+", " ", class_subbed), "both")

  x$attribs[class_indices] <- class_trimmed

  x
}

tag_class_re <- function(x, regex) {
  stopifnot(is_tag(x))

  if (is.null(x$attribs$class)) {
    return(FALSE)
  }

  regex <- paste0(
    c("^", "^", "\\s", "\\s"), regex, c("$", "\\s", "\\s", "$"),
    collapse = "|"
  )

  class_indices <- names2(x$attribs) == "class"

  any(vapply(x$attribs[class_indices], grepl, logical(1), pattern = regex))
}

resp_msg_breaks <- function(argument, invalid) {
  fun <- sys.call(1)[[1]]

  sprintf(
    "invalid call to `%s()`, argument `%s` contains unexpected breakpoint%s %s",
    as.character(fun),
    as.character(argument),
    if (length(invalid) > 1) "s" else "",
    str_conjoin(paste0("`", invalid, "`"))
  )
}

resp_msg_values <- function(argument, invalid) {
  if (is.character(invalid)) {
    invalid <- paste0('"', invalid, '"')
  }

  fun <- sys.call(1)[[1]]

  sprintf(
    "invalid argument in `%s()`, `%s` contains unexpected value%s %s",
    as.character(fun),
    as.character(argument),
    if (length(invalid) > 1) "s" else "",
    str_conjoin(as.character(invalid), con = "and")
  )
}

resp_msg_too_many <- function(argument, invalid) {
  fun <- sys.call(1)[[1]]

  sprintf(
    "invalid argument in `%s()`, `%s` breakpoint%s %s contain%s too many values",
    as.character(fun),
    as.character(argument),
    if (length(invalid) > 1) "s" else "",
    str_conjoin(paste0("`", invalid, "`"), con = "and"),
    if (length(invalid) > 1) "" else "s"
  )
}

resp_msg_duplicates <- function(duplicates, arguments) {
  fun <- sys.call(1)[[1]]
  duplicates <- as.character(duplicates)
  arguments <- as.character(arguments)

  sprintf(
    "invalid call to `%s()`, %s breakpoint%s specified in multiple arguments %s",
    as.character(fun),
    str_conjoin(sprintf("`%s`", duplicates), con = "and"),
    if (length(duplicates) > 1) "s" else "",
    str_conjoin(sprintf("`%s`", arguments), con = "and")
  )
}

resp_check <- function(...) {
  passed <- as.character(as.list(substitute(list(...)))[-1])
  args <- list(...)
  flat <- unlist(list(...))

  if (any(duplicated(names(flat)))) {
    dups <- names(flat)[duplicated(names(flat))]
    points <- passed[vapply(args, function(a) any(names(a) %in% dups), logical(1))]
    caller <-  sys.call(-1)[[1]]

    stop(
      resp_msg_duplicates(dups, points),
      call. = FALSE
    )
  }
}

resp_check_breaks <- function(values) {
  if (length(values) == 0) {
    return(NULL)
  }

  names2(values)[!str_re(names2(values), "default|xs|sm|md|lg|xl")]
}

resp_check_lengths <- function(values) {
  if (length(values) == 0) {
    return(NULL)
  }

  names2(values)[vapply(values, length, numeric(1)) > 1]
}

resp_check_value <- function(values, possible) {
  if (length(values) == 0) {
    return(NULL)
  }

  unlist(values)[!(unlist(values) %in% possible)]
}

resp_construct <- function(values, possible) {
  if (is.null(values)) {
    return(list())
  }

  values <- as.list(values)
  args <- match.call()$values

  if (is.null(names(values)) && length(values) > 1) {
    stop(
      resp_msg_too_many(args, "default"),
      call. = FALSE
    )
  }

  if (length(values) == 1 && names2(values) == "") {
    names(values) <- "default"
  }

  if (length(invalid <- resp_check_lengths(values))) {
    stop(
      resp_msg_too_many(args, invalid),
      call. = FALSE
    )
  }

  if (length(invalid <- resp_check_breaks(values))) {
    stop(
      resp_msg_breaks(args, invalid),
      call. = FALSE
    )
  }

  if (length(invalid <- resp_check_value(values, possible))) {
    stop(
      resp_msg_values(args, invalid),
      call. = FALSE
    )
  }

  names(values)[names2(values) == "xs"] <- "default"

  values
}

resp_classes <- function(values, prefix) {
  if (!length(values)) {
    return(NULL)
  }

  default <- values[names2(values) == "default"]
  if (length(default)) {
    default <- paste0(prefix, "-", default)
  } else {
    default <- NULL
  }

  points <- values[names2(values) != "default"]
  if (length(points)) {
    points <- paste0(prefix, "-", names2(points), "-", points)
  } else {
    points <- NULL
  }

  c(default, points)
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
