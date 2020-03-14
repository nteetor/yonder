arg_scalar_character <- "non-empty character string"
arg_vector_character <- "character vector"
arg_tag_element <- "tag element (e.g. `div()`, `tags$span()`)"
arg_list <- "list"
arg_in_values <- "value from `values`"
arg_null <- "`NULL`"
arg_addon <- c("`buttonInput()`", "list of `buttonInput()`s", "`dropdown()`")
arg_counting_number <- "integer greater than zero"

abort_assertion <- function(...) {
  abort(..., trace = trace_back(bottom = 3))
}

assert_id <- function() {
  var <- env_get(caller_env(), "id")

  if (is_missing(var)) {
    abort_assertion("argument `id` is required")
  }

  if (is_null(var)) {
    return()
  }

  if (is_chr_na(var) || is_string(var, "") || !is_scalar_character(var)) {
    abort_assertion(
      c("argument `id` must be one of",
        arg_scalar_character,
        arg_null)
    )
  }
}

assert_label <- function() {
  var <- env_get(caller_env(), "label")

  if (is_missing(var)) {
    abort_assertion("argument `label` is required")
  }

  if (!(is_null(var) || is_tag(var) || is_bare_list(var) || is_scalar_character(var))) {
    abort_assertion(
      c("argument `label` must be one of",
        arg_scalar_character,
        arg_tag_element,
        arg_list,
        arg_null)
    )
  }
}

assert_choices <- function() {
  var <- env_get(caller_env(), "choices")

  if (!(is_null(var) || is_character(var) || is_bare_list(var))) {
    abort_assertion(
      c("argument `choices` must be one of",
        arg_scalar_character,
        arg_vector_character,
        arg_list,
        arg_null)
    )
  }

  val <- env_get(caller_env(), "values")

  if (length(var) != length(val)) {
    abort_assertion("arguments `choices` and `values` must be the same length")
  }
}

assert_selected <- function(len) {
  var <- env_get(caller_env(), "selected")

  if (is_null(var)) {
    return()
  }

  if (length(var) > len) {
    abort_assertion("argument `selected` has too many values")
  }

  if (length(var) < len) {
    abort_assertion("argument `selected` has too few values")
  }

  val <- env_get(caller_env(), "values")

  if (!(var %in% val)) {
    abort_assertion(
      c("argument `selected` must be one of",
        arg_in_values,
        arg_null)
    )
  }
}

assert_session <- function() {
  var <- env_get(caller_env(), "session")

  if (is_null(var)) {
    abort_assertion("`session` must be a reactive context")
  }
}

assert_left <- function() {
  var <- env_get(caller_env(), "left")

  if (is_null(var)) {
    return()
  }

  if (!is_addon(var)) {
    abort_assertion(
      c("argument `left` must be one of",
        arg_scalar_character,
        arg_vector_character,
        arg_addon,
        arg_null)
    )
  }
}

assert_right <- function() {
  var <- env_get(caller_env(), "right")

  if (is_null(var)) {
    return()
  }

  if (!is_addon(var)) {
    abort_assertion(
      c("argument `right` must be one of",
        arg_scalar_character,
        arg_vector_character,
        arg_addon,
        arg_null)
    )
  }
}

is_addon <- function(x) {
  if (is_bare_list(x)) {
    all(vapply(x, tag_name_is, logical(1), name = "button"))
  } else {
    is_character(x) ||
      inherits_all(x, c("yonder_button", "yonder_input")) ||
      inherits_all(x, c("yonder_dropdown"))
  }
}

assert_duration <- function() {
  var <- env_get(caller_env(), "duration")

  if (is_null(var)) {
    return()
  }

  if (!is_scalar_integerish(var) || var <= 0) {
    abort_assertion(
      c("argument `duration` must be one of",
        arg_counting_number,
        arg_null
      )
    )
  }
}

assert_possible <- function(var, possible) {
  var_q <- enquo(var)
  var_v <- eval_tidy(var_q)

  if (is_null(var_v)) {
    return()
  }

  if (!all(var_v %in% possible)) {
    if (is_character(possible)) {
      possible <- paste0('"', possible, '"')
    }

    abort_assertion(
      c(sprintf("argument `%s` must be one of", as_label(var_q)),
        possible)
    )
  }
}

assert_found <- function(var) {
  var_q <- enquo(var)

  var_nm <- as_label(var_q)
  var_env <- quo_get_env(var_q)

  if (is_missing(env_get(var_env, var_nm))) {
    abort_assertion(sprintf("argument `%s` is required", var_nm))
  }
}
