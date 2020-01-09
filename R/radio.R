#' Radio inputs
#'
#' A stylized radio input. A reactive input with multiple choices where only one
#' choice and value at most may be selected.
#'
#' @inheritParams checkboxInput
#'
#' @param choices A character vector or list of tag elements specifying the
#'   input's choices.
#'
#' @param values A character vector, list of character strings, vector of values
#'   to coerce to character strings, or list of values to coerce to character
#'   strings specifying the values of the radio input's choices, defaults to
#'   `choices`.
#'
#' @param selected One of `values` indicating the default selected value of the
#'   radio input, defaults to `NULL`, in which case the first choice is
#'   selected by default.
#'
#' @param inline If `TRUE`, the radio input renders inline, defaults to `FALSE`,
#'   in which case the radio controls render on separate lines.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Out-of-the-box radios
#'
#' radioInput(
#'   id = "radio1",
#'   choices = c(
#'     "Vehicula adipiscing mattis",
#'     "Magna nullam",
#'     "Aenean venenatis",
#'     "Tristique quam porta"
#'   )
#' )
#'
#' ### Inline radio input
#'
#' radioInput(
#'   id = "radio2",
#'   choices = c(
#'     "Choice 1",
#'     "Choice 2",
#'     "Choice 3"
#'   ),
#'   inline = TRUE  # <-
#' )
#'
radioInput <- function(id, choices = NULL, values = choices,
                       selected = values[[1]], ..., inline = FALSE) {
  assert_id()
  assert_choices()
  assert_selected(length = 1)

  dep_attach({
    radios <- map_radios(choices, values, selected, id, inline)

    tags$div(
      class = "yonder-radio",
      id = id,
      radios,
      ...
    )
  })
}

#' @rdname radioInput
#' @export
updateRadioInput <- function(id, choices = NULL, values = choices,
                             selected = NULL, inline = FALSE,
                             enable = NULL, disable = NULL,
                             valid = NULL, invalid = NULL,
                             session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_selected(length = 1)
  assert_session()

  radios <- map_radios(choices, values, selected, id, inline)

  content <- coerce_content(radios)
  selected <- coerce_selected(selected)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)
  valid <- coerce_valid(valid)
  invalid <- coerce_invalid(invalid)

  session$sendInputMessage(id, list(
    content = content,
    selected = selected,
    enable = enable,
    disable = disable,
    valid = valid,
    invalid = invalid
  ))
}

map_radios <- function(choices, values, selected, parent_id, inline) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }

  selected <- values %in% selected

  Map(
    choice = choices,
    value = values,
    select = selected,
    last = seq_along(choices) == length(choices),
    function(choice, value, select, last) {
      child_id <- generate_id("radio")

      tags$div(
        class = str_collate(
          "custom-control",
          "custom-radio",
          if (inline) "custom-control-inline"
        ),
        tags$input(
          class = "custom-control-input",
          type = "radio",
          id = child_id,
          name = parent_id,
          value = value,
          checked = if (select) NA,
          autocomplete = "off"
        ),
        tags$label(
          class = "custom-control-label",
          `for` = child_id,
          choice
        ),
        if (last) {
          list(
            tags$div(class = "valid-feedback"),
            tags$div(class = "invalid-feedback")
          )
        }
      )
    }
  )
}

#' Radiobar inputs
#'
#' A stylized group of radio inputs. A radiobar input is similar to a button
#' group, but with a checked or highlighted stated. Additionally, only one value
#' at most may be selected at any given time.
#'
#' @inheritParams checkboxInput
#'
#' @param choices A character vector or list of tag elements specifying the
#'   labels of the input's choices.
#'
#' @param values A vector specifying the values of the input's choices,
#'   defaults to `choices`.
#'
#' @param selected One of `values` specifying the input's default selected
#'   choice, defaults to `values[[1]]`.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Radiobars
#'
#' radiobarInput(
#'   id = "radiobar1",
#'   choices = c(
#'     "fusce sagittis",
#'     "libero non molestie",
#'     "magna orci",
#'     "ultrices dolor"
#'   ),
#'   selected = "ultrices dolor"
#' ) %>%
#'   background("grey")
#'
radiobarInput <- function(id, choices, values = choices, selected = values[[1]],
                          ...) {
  assert_id()
  assert_choices()
  assert_selected(length = 1)

  dep_attach({
    radios <- map_radiobuttons(choices, values, selected, id)

    tags$div(
      class = "yonder-radiobar btn-group btn-group-toggle d-flex",
      id = id,
      `data-toggle` = "buttons",
      ...,
      radios
    )
  })
}

#' @rdname radiobarInput
#' @export
updateRadiobarInput <- function(id, choices = NULL, values = choices,
                                selected = NULL, enable = NULL, disable = NULL,
                                session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_selected(length = 1)
  assert_session()

  radios <- map_radiobuttons(choices, values, selected, id)

  content <- coerce_content(radios)
  selected <- coerce_selected(selected)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)

  session$sendInputMessage(id, list(
    content = content,
    selected = selected,
    enable = enable,
    disable = disable
  ))
}

map_radiobuttons <- function(choices, values, selected, parent_id) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }

  selected <- values %in% selected

  Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$label(
        class = str_collate(
          "btn",
          "btn-grey",
          if (select) "active"
        ),
        tags$input(
          name = parent_id,
          type = "radio",
          value = value,
          checked = if (select) NA,
          autocomplete = "off"
        ),
        choice
      )
    }
  )
}
