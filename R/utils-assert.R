get_caller <- function(gen = 1) {
  paste0(sys.call(sys.parent() - gen)[[1]], "()")
}

get_variable <- function(x) {
  g_env <- parent.frame(2)

  if (is.symbol(g_env[[x]]) && !nzchar(g_env[[x]])) {
    stop(
      "invalid argument in `", get_caller(2), "`, please specify `", x, "`",
      call. = FALSE
    )
  }

  g_env[[x]]
}

assert_id <- function() {
  id <- get_variable("id")
  fun <- get_caller()

  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid argument in `", fun, "`, `id` must be a character string ",
      "or NULL",
      call. = FALSE
    )
  }

  if (length(id) > 1) {
    stop(
      "invalid argument in `", fun, "`, `id` must be a single character string",
      call. = FALSE
    )
  }

  if (!is.null(id) && (isTRUE(is.na(id)) || isTRUE(id == ""))) {
    stop(
      "invalid argument in `", fun, "`, `id` must be a non-zero length ",
      "character string",
      call. = FALSE
    )
  }
}

assert_label <- function() {
  label <- get_variable("label")
  fun <- get_caller()

  if (!(is.null(label) || is_tag(label) ||
        is_strictly_list(label) || is.atomic(label))) {
    stop(
      "invalid argument in `", fun, "`, `label` must be a tag element, ",
      "character string, list, or NULL",
      call. = FALSE
    )
  }
}

assert_choices <- function(strict = TRUE) {
  choices <- get_variable("choices")
  values <- get_variable("values")
  fun <- get_caller()

  if (strict) {
    pass <- length(choices) == length(values)
  } else {
    pass <- is.null(choices) || is.null(values) ||
      length(choices) == length(values)
  }

  if (!pass) {
    addendum <- if (is_tag(choices)) {
      "if `choices` is a single tag element be sure to wrap the value in list()"
    }

    stop(
      "invalid arguments in `", fun, "`, `choices` and `values` must be the ",
      "same length", addendum,
      call. = FALSE
    )
  }
}

assert_labels <- function(strict = TRUE) {
  labels <- get_variable("labels")
  values <- get_variable("values")
  fun <- get_caller()

  if (strict) {
    pass <- length(labels) == length(values)
  } else {
    pass <- is.null(labels) || is.null(values) ||
      length(labels) == length(values)
  }

  if (!pass) {
    addendum <- if (is_tag(labels)) {
      "if `labels` is a single tag element be sure to wrap the value in list()"
    }

    stop(
      "invalid arguments in `", fun, "`, `labels` and `values` must be the ",
      "same length", addendum,
      call. = FALSE
    )
  }
}

assert_selected <- function(length) {
  selected <- get_variable("selected")
  fun <- get_caller()

  if (!is.null(selected) && length(selected) != length) {
    stop(
      "invalid argument in `", fun, "`, `selected` must be NULL or a ",
      "single value",
      call. = FALSE
    )
  }
}

assert_possible <- function(x, possible) {
  if (!is.null(x) && !all(x %in% possible)) {
    arg <- as.character(match.call()[[2]])
    fun <- get_caller()

    if (is.character(possible)) {
      possible <- paste0('"', possible, '"')
    }

    if (length(possible) == 1) {
      items <- possible
    } else if (length(possible) == 2) {
      items <- paste(possible[1], "or", possible[2])
    } else {
      items <- paste0(
        paste(utils::head(possible, -1), collapse = ", "),
        ", or ",
        utils::tail(possible, 1)
      )
    }

    stop(
      "invalid argument in `", fun, "`, `", arg, "` must be one ",
      "of ", items,
      call. = FALSE
    )
  }
}

assert_found <- function(x) {
  if (missing(x)) {
    arg <- as.character(match.call()[[2]])
    fun <- get_caller()

    stop(
      "invalid argument in `", fun, "`, please specify `", arg, "`",
      call. = FALSE
    )
  }
}

assert_session <- function() {
  session <- get_variable("session")
  fun <- get_caller()

  if (is.null(session)) {
    stop(
      "invalid argument in `", fun, "`, `session` is NULL, but expected a ",
      "reactive context",
      call. = FALSE
    )
  }
}

assert_tag <- function() {
  tag <- get_variable("tag")
  fun <- get_caller()

  if (!is_tag(tag)) {
    stop(
      "invalid argument in `", fun, "`, `tag` must be shiny.tag element",
      call. = FALSE
    )
  }
}

assert_left <- function() {
  left <- get_variable("left")
  fun <- get_caller()

  if (!is.null(left) && !is_addon(left)) {
    stop(
      "invalid argument in `", fun, "`, `left` must be a character string, ",
      "buttonInput(), dropdown(), or NULL",
      call. = FALSE
    )
  }
}

assert_right <- function() {
  right <- get_variable("right")
  fun <- get_caller()

  if (!is.null(right) && !is_addon(right)) {
    stop(
      "invalid argument in `", fun, "`, `right` must be a character string, ",
      "buttonInput(), dropdown(), or NULL",
      call. = FALSE
    )
  }
}

is_addon <- function(x) {
  if (is_strictly_list(x)) {
    all(vapply(x, tag_name_is, logical(1), name = "button"))
  } else {
    is.character(x) ||
      tag_name_is(x, "button") ||
      tag_class_re(x, "dropdown")
  }
}

assert_duration <- function(x) {
  duration <- get_variable("duration")
  fun <- get_caller()

  if (!is.null(duration)) {
    if (!is.numeric(duration) || duration <= 0) {
      stop(
        "invalid argument in `", fun, "`, `duration` must be a positive ",
        "integer or NULL",
        call. = FALSE
      )
    }
  }
}
