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
  args_flat <- unlist(args)
  args_names <- rlang::names2(args_flat)

  if (any(duplicated(args_names))) {
    dups <- args_names[duplicated(args_names)]
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

  v_names <- rlang::names2(values)

  v_names[!str_re(v_names, "default|xs|sm|md|lg|xl")]
}

resp_check_lengths <- function(values) {
  if (length(values) == 0) {
    return(NULL)
  }

  rlang::names2(values)[vapply(values, length, numeric(1)) > 1]
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
  v_names <- rlang::names2(values)
  args <- match.call()$values

  if (is.null(v_names) && length(values) > 1) {
    stop(
      resp_msg_too_many(args, "default"),
      call. = FALSE
    )
  }

  if (length(values) == 1 && v_names == "") {
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

  names(values)[v_names == "xs"] <- "default"

  values
}

resp_classes <- function(values, prefix) {
  if (!length(values)) {
    return(NULL)
  }

  v_names <- rlang::names2(values)

  default <- values[v_names == "default"]
  if (length(default)) {
    default <- paste0(prefix, "-", default)
  } else {
    default <- NULL
  }

  points <- values[v_names != "default"]
  if (length(points)) {
    points <- paste0(prefix, "-", rlang::names2(points), "-", points)
  } else {
    points <- NULL
  }

  c(default, points)
}
