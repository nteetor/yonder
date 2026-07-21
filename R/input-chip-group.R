#' Chip group input
#'
#' A reactive input whose choices render as toggleable chips — a checkbox
#' group rendered as chips. Clicking a chip (or pressing Enter or Space on
#' it) toggles its checked state; the input's value is the set of checked
#' chips. The set of chips is fixed: to let users add and remove values,
#' see [input_multi_select()].
#'
#' @inheritParams input_checkbox
#'
#' @param choices A character vector of chip labels, defaults to `NULL`.
#'   When `NULL`, the input renders without chips and may be populated
#'   later with [update_chip_group()].
#'
#' @param values A character vector of values for the input's choices,
#'   defaults to `choices`.
#'
#' @param select A character vector naming the checked values, one or more
#'   of `values`, defaults to `values` — every chip starts checked. Pass
#'   `NULL` to render all chips unchecked. In [update_chip_group()],
#'   `select` defaults to `NULL`, leaving the checked set untouched;
#'   otherwise `select` replaces the checked set — the current selection
#'   is reset and the new selection applied.
#'
#' @param type A character string, a Bootstrap theme color name. Checked
#'   chips have a solid `type` background; unchecked chips have a `type`
#'   border. Defaults to `"primary"`.
#'
#' @param layout A character string. With `"vertical"` (default) chips wrap
#'   onto new lines; with `"horizontal"` chips stay on one scrolling row.
#'
#' @details
#'
#' ## Server value
#'
#' A character vector of the checked chips' values, or `NULL` when no chips
#' are checked.
#'
#' @returns A [htmltools::tag] object.
#'
#' @family inputs
#'
#' @export
input_chip_group <-
  function(
    id,
    ...,
    choices = NULL,
    values = choices,
    select = values,
    type = "primary",
    layout = c("vertical", "horizontal")
  ) {
    check_string(id, allow_empty = FALSE)
    check_character(choices, allow_null = TRUE)
    check_character(values, allow_null = TRUE)
    check_character(select, allow_null = TRUE)
    type <- arg_match(type, chip_group_types)
    layout <- arg_match(layout)
    chip_group_check_choices(choices, values, select, strict = TRUE)

    args <- list2(...)
    attrs <- keep_named(args)

    input <-
      htmltools::tag(
        "bsides-chip-group",
        list2(
          id = id,
          choices = if (non_null(choices)) {
            chip_group_choices_json(choices, values)
          },
          checked = if (non_null(select)) {
            format(jsonlite::toJSON(select))
          },
          type = type,
          layout = if (layout != "vertical") layout,
          !!!attrs
        )
      )

    input <-
      dependency_append(input)

    input <-
      s3_class_add(input, "bsides_chip_group")

    input
  }

#' @rdname input_chip_group
#'
#' @param enable If `TRUE`, enable the input, defaults to `NULL`.
#'
#' @param disable If `TRUE`, disable the input, defaults to `NULL`. When both
#'   `enable` and `disable` are `TRUE`, `disable` wins.
#'
#' @details
#'
#' When `update_chip_group()` replaces an input's choices, checked values
#' whose chip no longer exists fall out of the checked set (pass `select`
#' in the same call to choose the new selection). Without `values` in the
#' call, `select` cannot be validated server-side; unmatched values are
#' dropped with a warning in the browser console.
#'
#' @export
update_chip_group <-
  function(
    id,
    choices = NULL,
    values = choices,
    select = NULL,
    enable = NULL,
    disable = NULL,
    session = get_current_session()
  ) {
    check_string(id, allow_empty = FALSE)
    check_character(choices, allow_null = TRUE)
    check_character(values, allow_null = TRUE)
    check_character(select, allow_null = TRUE)
    check_bool(enable, allow_null = TRUE)
    check_bool(disable, allow_null = TRUE)
    chip_group_check_choices(choices, values, select, strict = FALSE)

    msg <-
      drop_nulls(list(
        choices = if (non_null(choices)) {
          chip_group_choices_list(choices, values)
        },
        select = select,
        enable = enable,
        disable = disable
      ))

    session$sendInputMessage(id, msg)
  }

chip_group_types <- c(
  "primary",
  "secondary",
  "success",
  "danger",
  "warning",
  "info",
  "light",
  "dark"
)

# Shared validation for the choices/values/select trio. With
# `strict = TRUE` (the constructor) `select` must always resolve against
# `values`; with `strict = FALSE` (the update function) it is validated
# only when `values` is part of the same call — otherwise the client warns
# in the browser console for values matching no chip.
chip_group_check_choices <-
  function(
    choices,
    values,
    select,
    strict,
    call = caller_env()
  ) {
    if (non_null(choices) && length(choices) != length(values)) {
      abort(
        "`choices` and `values` must be the same length.",
        call = call
      )
    }

    if (is.null(select)) {
      return(invisible(NULL))
    }

    if (strict && is.null(values)) {
      abort(
        "`select` must be `NULL` when `choices` is `NULL`.",
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

chip_group_choices_list <-
  function(choices, values) {
    .mapply(
      function(label, value) list(label = label, value = value),
      list(as.character(choices), as.character(values)),
      NULL
    )
  }

chip_group_choices_json <-
  function(choices, values) {
    format(
      jsonlite::toJSON(
        chip_group_choices_list(choices, values),
        auto_unbox = TRUE
      )
    )
  }

chip_group_input_type <- "bsides.chipgroup"

chip_group_input_register_handler <-
  function() {
    shiny::registerInputHandler(
      chip_group_input_type,
      function(value, session, name) {
        if (length(value) < 1) {
          return(NULL)
        }

        unlist(value, recursive = FALSE, use.names = FALSE)
      },
      force = TRUE
    )
  }
