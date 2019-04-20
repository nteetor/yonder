get_variable <- function(x) {
  get(x, envir = parent.frame(2), inherits = FALSE)
}

get_caller <- function() {
  paste0(sys.call(sys.parent() - 1)[[1]], "()")
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
}

assert_choices <- function() {
  choices <- get_variable("choices")
  values <- get_variable("values")
  fun <- get_caller()

  if (length(choices) == 0) {
    stop(
      "invalid argument in `", fun, "`, length of `choices` must be >= 1",
      call. = FALSE
    )
  }

  if (length(choices) != length(values)) {
    stop(
      "invalid argument in `", fun, "`, `choices` and `values` must be the ",
      "same length",
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
