#' Checkbox and switch inputs
#'
#' Reactive checkbox and checkbar inputs. Users may select one or more choices.
#' The checkbox input appears as a standard checkbox or set of checkboxes. When
#' a checkbox input has no selected choices the reactive value is `NULL`. Switch
#' inputs differ from checkboxes only in appearance.
#'
#' @param id A character string specifying the id of the reactive input.
#'
#' @param choices A character string or vector specifying a label or labels for
#'   the checkbox or checkbar.
#'
#' @param values A character string or vector specifying values for the
#'   checkbox or checkbar input, defaults to `choice` or `values`, respectively.
#'
#' @param selected One or more of `values` specifying which choices are
#'   selected by default, defaults to `NULL`, in which case no choices are
#'   initially selected.
#'
#' @param inline One of `TRUE` or `FALSE` specifying if the checkbox input
#'   choices render inline or stacked, defaults to `FALSE`, in which case the
#'   choices are stacked.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   parent element or tag elements passed as child elements to the parent
#'   element.
#'
#' @param enable One of `values` specifying particular choices to enable or
#'   `TRUE` specifying the entire input is enabled, defaults to `NULL`.
#'
#' @param disable One of `values` specifying particular choices to disable or
#'   `TRUE` specifying the entire input is disabled, defaults to `NULL`.
#'
#' @param valid A character string specifying a message to the user indicating
#'   how the input's value is valid, defaults to `NULL.`
#'
#' @param invalid A character string specifying a message to the user
#'   indicating how the input's value is invalid, defaults to `NULL`.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### One option
#'
#' checkboxInput(
#'   id = "checkbox1",
#'   choices = "Choice 1",
#'   selected = "Choice 1"
#' )
#'
#' ### Multiple options
#'
#' checkboxInput(
#'   id = "checkbox2",
#'   choices = c("Choice 1", "Choice 2")
#' )
#'
#' ### Inline checkbox
#'
#' checkboxInput(
#'   id = "checkbox3",
#'   choices = c("Choice 1", "Choice 2", "Choice 3"),
#'   inline = TRUE
#' )
#'
#' ### Switches
#'
#' switchInput(
#'   id = "switch1",
#'   choices = paste("Switch choice", 1:3),
#'   selected = "Switch choice 3"
#' ) %>%
#'   active("indigo")
#'
checkboxInput <- function(id, choices = NULL, values = choices, selected = NULL,
                          ..., inline = FALSE) {
  assert_id()
  assert_choices()

  dep_attach({
    checkboxes <- map_checkboxes(choices, values, selected, inline)

    tags$div(
      class = "yonder-checkbox",
      id = id,
      checkboxes,
      ...
    )
  })
}

#' @rdname checkboxInput
#' @export
updateCheckboxInput <- function(id, choices = NULL, values = choices,
                                selected = NULL, inline = FALSE, enable = NULL,
                                disable = NULL, valid = NULL, invalid = NULL,
                                session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_session()

  checkboxes <- map_checkboxes(choices, values, selected, inline, FALSE)

  content <- coerce_content(checkboxes)
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

#' @rdname checkboxInput
#' @export
switchInput <- function(id, choices, values = choices, selected = NULL, ...) {
  assert_id()
  assert_choices()

  dep_attach({
    switches <- map_checkboxes(choices, values, selected, FALSE, TRUE)

    tags$div(
      class = "yonder-checkbox",
      id = id,
      switches,
      ...
    )
  })
}

#' @rdname checkboxInput
#' @export
updateSwitchInput <- function(id, choices = NULL, values = choices,
                              selected = NULL, enable = NULL,
                              disable = NULL, valid = NULL, invalid = NULL,
                              session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_session()

  switches <- map_checkboxes(choices, values, selected, FALSE, TRUE)

  content <- coerce_content(switches)
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

map_checkboxes <- function(choices, values, selected, inline,
                           switches = FALSE) {
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
      id <- generate_id("checkbox")

      tags$div(
        class = str_collate(
          "custom-control",
          if (switches) "custom-switch" else "custom-checkbox",
          if (inline) "custom-control-inline"
        ),
        tags$input(
          class = "custom-control-input",
          type = "checkbox",
          id = id,
          name = id,
          value = value,
          checked = if (select) NA,
          autocomplete = "off"
        ),
        tags$label(
          class = "custom-control-label",
          `for` = id,
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

#' Checkbar input
#'
#' A stylized checkbox input. The checkbar input appears similar to a group of
#' buttons, but with a checked or highlighted state.
#'
#' @inheritParams checkboxInput
#'
#' @param choices A character vector or list of tag element specifying the
#'   input's choices, defaults to `NULL`.
#'
#' @param values A vector of values specifying the values of the input's
#'   choices, defaults to `choices`.
#'
#' @param selected One or more of `values` specifying the input's default
#'   selected values, defaults to `NULL`.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Default checkbar
#'
#' checkbarInput(
#'   id = "cb1",
#'   choices = c("When", "Why", "Where")
#' )
#'
#' ### Modifying background color
#'
#' checkbarInput(
#'   id = "cb2",
#'   choices = c("What", "Which")
#' ) %>%
#'   background("teal")
#'
#' ### Labeling a checkbar
#'
#' formGroup(
#'   label = "Toppings",
#'   checkbarInput(
#'     id = "fixins",
#'     choices = c(
#'       "Sprinkles",
#'       "Nuts",
#'       "Fudge"
#'     )
#'   )
#' )
#'
checkbarInput <- function(id, choices = NULL, values = choices,
                          selected = NULL, ...) {
  assert_id()
  assert_choices()

  dep_attach({
    checkboxes <- map_checkbuttons(choices, values, selected)

    tags$div(
      class = "yonder-checkbar btn-group btn-group-toggle d-flex",
      id = id,
      `data-toggle` = "buttons",
      checkboxes,
      ...
    )
  })
}

#' @rdname checkbarInput
#' @export
updateCheckbarInput <- function(id, choices = NULL, values = choices,
                                selected = NULL, enable = NULL, disable = NULL,
                                session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_session()

  checkboxes <- map_checkbuttons(choices, values, selected)

  content <- coerce_content(checkboxes)
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

map_checkbuttons <- function(choices, values, selected) {
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
          type = "checkbox",
          autocomplete = "off",
          value = value,
          checked = if (select) NA
        ),
        choice
      )
    }
  )
}
