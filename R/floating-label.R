#' Floating labels
#'
#' Mark an input's `label` as a floating label. A floating label renders using
#' Bootstrap's `.form-floating` markup — the label starts inside the input and
#' floats up when the input is focused or filled. Only `.form-control` /
#' `.form-select` inputs support floating labels: [input_text()],
#' [input_numeric()], [input_select()], and [input_text_group()]. Other inputs
#' error when passed a `floating_label()`.
#'
#' @param text A character string. The label text.
#'
#' @param ... Optional named arguments specifying HTML attributes for the label
#'   element.
#'
#' @returns A character string with class `bsides_floating_label`.
#'
#' @family inputs
#'
#' @export
floating_label <-
  function(
    text,
    ...
  ) {
    check_string(text, allow_empty = FALSE)

    structure(
      text,
      attrs = keep_named(list(...)),
      class = "bsides_floating_label"
    )
  }

is_floating_label <-
  function(x) {
    inherits(x, "bsides_floating_label")
  }

# Attach a label to an input tag. A `NULL` label returns the input unchanged.
# A character label renders a standard label ahead of the input, using the
# wrapper the caller names: `"label"` for a `<label for>` pointing at
# `for_id`, `"fieldset"` for a `<fieldset>`/`<legend>` (the group inputs,
# where no single control can carry the label, and the custom elements,
# which `for` cannot target). A `floating_label()` renders Bootstrap's
# `.form-floating` markup when the input supports it and errors otherwise.
wrap_label <-
  function(
    input,
    label,
    ...,
    wrapper = c("label", "fieldset"),
    for_id = NULL,
    floating = c("unsupported", "supported"),
    call = caller_env()
  ) {
    wrapper <- arg_match(wrapper)
    floating <- arg_match(floating)

    if (is.null(label)) {
      return(input)
    }

    # Inputs that generate a control id only when labelled pass `for_id`
    # unconditionally, so this can only be checked past the early return.
    if (wrapper == "label" && is.null(for_id)) {
      abort(
        '`for_id` must not be `NULL` when `wrapper` is "label".',
        call = call
      )
    }

    if (is_floating_label(label)) {
      if (floating == "unsupported") {
        abort(
          c(
            "`label` must not be a `floating_label()`.",
            i = paste(
              "Floating labels require a `.form-control` or `.form-select`",
              "input: `input_text()`, `input_numeric()`, `input_select()`,",
              "or `input_text_group()`."
            )
          ),
          call = call
        )
      }

      return(wrap_label_floating(input, label, for_id))
    }

    check_string(label, allow_empty = FALSE, call = call)

    wrap_label_standard(input, label, wrapper, for_id)
  }

wrap_label_standard <-
  function(
    input,
    label,
    wrapper,
    for_id
  ) {
    if (wrapper == "fieldset") {
      tags$fieldset(
        tags$legend(
          class = "form-label fs-6",
          label
        ),
        input
      )
    } else {
      tags$div(
        tags$label(
          class = "form-label",
          `for` = for_id,
          label
        ),
        input
      )
    }
  }

# Bootstrap's floating labels key off a non-empty placeholder, visually hidden
# by `.form-floating`. Inject a blank one when the caller gave none.
# `.form-select` inputs do not need a placeholder.
wrap_label_floating <-
  function(
    input,
    label,
    for_id
  ) {
    if (
      identical(input$name, "input") &&
        is.null(htmltools::tagGetAttribute(input, "placeholder"))
    ) {
      input <- tagAppendAttributes(input, placeholder = " ")
    }

    tags$div(
      class = "form-floating",
      input,
      tags$label(
        `for` = for_id,
        !!!attr(label, "attrs"),
        as.character(label)
      )
    )
  }
