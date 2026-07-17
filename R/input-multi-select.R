#' Multi select input
#'
#' A selectize alternative: selected values render as removable chips,
#' edited through a text entry with a filtering dropdown. The dropdown
#' lists the choices with a checkmark beside the current selections —
#' picking a listed selection removes it, picking anything else adds it.
#' Chips do not toggle; the set of chips is the input's value. For fixed,
#' toggleable chips see [input_chip_group()].
#'
#' @inheritParams input_checkbox
#'
#' @param choices A character vector of choice labels, defaults to `NULL`.
#'   May be empty and populated later with [update_multi_select()].
#'
#' @param values A character vector of values for the input's choices,
#'   defaults to `choices`.
#'
#' @param select A character vector of the selected values, defaults to
#'   `NULL` — no chips render by default. With `edit = "choices"` these
#'   must be found in `values`; with `edit = "free"` any strings are
#'   allowed. In [update_multi_select()], `select` replaces the chip set —
#'   the current selection is reset and the new selection applied.
#'
#' @param edit A character string bounding what users may select:
#'
#'   * `"choices"` (default), selections come only from the choices.
#'   * `"free"`, typed text also creates new values. Without `choices`
#'     there is no dropdown at all — a free-text tag input.
#'
#' @param type A character string, a Bootstrap theme color name coloring
#'   the chips. Defaults to `"primary"`.
#'
#' @param layout A character string. With `"vertical"` (default) chips wrap
#'   onto new lines; with `"horizontal"` chips stay on one scrolling row.
#'
#' @param placeholder A string specifying placeholder text for the text
#'   input, defaults to `NULL`.
#'
#' @param max A whole number specifying the maximum number of selections,
#'   defaults to `NULL`. Once reached, the text input is disabled until a
#'   value is removed.
#'
#' @details
#'
#' ## Server value
#'
#' A character vector of the selected values, or `NULL` when nothing is
#' selected.
#'
#' @returns A [htmltools::tag] object.
#'
#' @family inputs
#'
#' @export
input_multi_select <- function(
  id,
  ...,
  choices = NULL,
  values = choices,
  select = NULL,
  edit = c("choices", "free"),
  type = "primary",
  layout = c("vertical", "horizontal"),
  placeholder = NULL,
  max = NULL
) {
  check_string(id, allow_empty = FALSE)
  check_character(choices, allow_null = TRUE)
  check_character(values, allow_null = TRUE)
  check_character(select, allow_null = TRUE)
  edit <- arg_match(edit)
  type <- arg_match(type, chip_group_types)
  layout <- arg_match(layout)
  check_string(placeholder, allow_null = TRUE)
  check_number_whole(max, allow_null = TRUE)
  multi_select_check_choices(choices, values, select, edit = edit)

  args <- list2(...)
  attrs <- keep_named(args)

  input <-
    htmltools::tag(
      "bsides-multi-select",
      list2(
        id = id,
        choices = if (non_null(choices)) {
          chip_group_choices_json(choices, values)
        },
        chips = if (non_null(select)) {
          format(jsonlite::toJSON(select))
        },
        edit = if (edit != "choices") edit,
        type = type,
        layout = if (layout != "vertical") layout,
        placeholder = placeholder,
        max = max,
        !!!attrs
      )
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, "bsides_multi_select")

  input
}

#' @rdname input_multi_select
#'
#' @param enable If `TRUE`, enable the input, defaults to `NULL`.
#'
#' @param disable If `TRUE`, disable the input, defaults to `NULL`. When both
#'   `enable` and `disable` are `TRUE`, `disable` wins.
#'
#' @details
#'
#' When `update_multi_select()` replaces an input's choices, selections no
#' longer among the new choices are removed (free-text chips of an
#' `edit = "free"` input are kept). Without `values` in the call, `select`
#' cannot be validated server-side; on an `edit = "choices"` input,
#' unmatched values are dropped with a warning in the browser console.
#'
#' @export
update_multi_select <- function(
  id,
  choices = NULL,
  values = choices,
  select = NULL,
  placeholder = NULL,
  max = NULL,
  enable = NULL,
  disable = NULL,
  session = get_current_session()
) {
  check_string(id, allow_empty = FALSE)
  check_character(choices, allow_null = TRUE)
  check_character(values, allow_null = TRUE)
  check_character(select, allow_null = TRUE)
  check_string(placeholder, allow_null = TRUE)
  check_number_whole(max, allow_null = TRUE)
  check_bool(enable, allow_null = TRUE)
  check_bool(disable, allow_null = TRUE)
  multi_select_check_choices(choices, values, select, edit = NULL)

  msg <-
    drop_nulls(list(
      choices = if (non_null(choices)) {
        chip_group_choices_list(choices, values)
      },
      select = select,
      placeholder = placeholder,
      max = max,
      enable = enable,
      disable = disable
    ))

  session$sendInputMessage(id, msg)
}

# Validation for the choices/values/select trio. At edit = "choices" the
# set is bounded: `select` must resolve against `values` (and must be NULL
# when there are no choices). At edit = "free" any strings are allowed.
# `edit = NULL` (the update function, which cannot know the input's mode)
# validates `select` only when `values` is part of the same call —
# otherwise the client warns in the browser console.
multi_select_check_choices <- function(
  choices,
  values,
  select,
  edit,
  call = caller_env()
) {
  if (non_null(choices) && length(choices) != length(values)) {
    abort(
      "`choices` and `values` must be the same length.",
      call = call
    )
  }

  if (is.null(select) || identical(edit, "free")) {
    return(invisible(NULL))
  }

  if (identical(edit, "choices") && is.null(values)) {
    abort(
      '`select` must be `NULL` when `choices` is `NULL` and `edit` is "choices".',
      call = call
    )
  }

  if (non_null(values) && !all(select %in% values)) {
    missing <- setdiff(select, values)

    abort(
      sprintf(
        "`select` values must be found in `values`, not %s.",
        str_conjoin(sprintf('"%s"', missing))
      ),
      call = call
    )
  }
}

multi_select_input_type <- "bsides.multiselect"

multi_select_input_register_handler <- function() {
  shiny::registerInputHandler(
    multi_select_input_type,
    function(
      value,
      session,
      name
    ) {
      if (length(value) < 1) {
        return(NULL)
      }

      unlist(value, recursive = FALSE, use.names = FALSE)
    },
    force = TRUE
  )
}
