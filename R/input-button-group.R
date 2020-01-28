#' Button group inputs
#'
#' A set of buttons with custom values.
#'
#' @inheritParams buttonInput
#'
#' @param choices A character vector specifying the labels for each button in
#'   the group.
#'
#' @param values A character vector specifying the values of each button in the
#'   group, defaults to `choices`.
#'
#' @param direction One of `"horizontal"` or `"vertical"` specifying the layout
#'   of the buttons, defaults to `"horizontal"`.
#'
#' @param enable One of `values` indicating individual buttons to enable or
#'   `TRUE` to enable the entire input, defaults to `NULL`.
#'
#' @param disable One of `values` indicating individual buttons to disable or
#'   `TRUE` to disable the entire input, defaults to `NULL`.
#'
#' @param labels Deprecated, see `values`.
#'
#' @includeRmd man/roxygen/button-group.Rmd
#'
#' @family inputs
#' @export
buttonGroupInput <- function(..., id, choices = NULL, values = choices,
                             labels = deprecated(),
                             direction = "horizontal") {
  if (!is_missing(labels)) {
    deprecate_soft(
      "0.2.0",
      "yonder::buttonGroupInput(labels = )",
      "yonder::buttonGroupInput(choices = )"
    )

    choices <- labels
  }

  assert_id()
  assert_choices()

  shiny::registerInputHandler(
    type = "yonder.button.group",
    fun = function(x, session, name) {
      if (length(x) > 1) x[[2]]
    },
    force = TRUE
  )

  with_deps({
    buttons <- map_buttons(choices, values)

    tag <- tags$div(
      class = "yonder-button-group btn-group",
      id = id,
      role = "group",
      buttons
    )

    args <- style_dots_eval(..., .style = style_pronoun("yonder_button_group"))

    tag <- tag_extend_with(tag, args)

    s3_class_add(tag, c("yonder_button_group", "yonder_input"))
  })
}

#' @rdname buttonGroupInput
#' @export
updateButtonGroupInput <- function(id, choices = NULL, values = choices,
                                   enable = NULL, disable = NULL,
                                   session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_session()

  buttons <- map_buttons(choices, values)

  content <- coerce_content(buttons)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)

  session$sendInputMessage(id, list(
    content = content,
    enable = enable,
    disable = disable
  ))
}

map_buttons <- function(choices, values) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }

  Map(
    label = choices,
    value = values,
    function(label, value) {
      tags$button(
        type = "button",
        class = "btn",
        value = value,
        label
      )
    }
  )
}
