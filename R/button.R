#' Button and link inputs
#'
#' @description
#'
#' Button inputs are useful as triggers for reactive or observer expressions.
#' The reactive value of a button input begins as `NULL`, but subsequently is
#' the number of clicks.
#'
#' @param id A character string specifying the id of the reactive input.
#'
#' @param label A character string specifying the label text on the button or
#'   link input.
#'
#' @param stretch One of `TRUE` or `FALSE` specifying stretched behaviour for
#'   the button or link input, defaults to `FALSE`. If `TRUE`, the button or
#'   link will receive clicks from its containing block element. For example, a
#'   stretched button or link inside a [card()] would update whenever the user
#'   clicked on the card.
#'
#' @param download One of `TRUE` or `FALSE` specifying if the button or link
#'   input is used to trigger a download, defaults to `FALSE`.
#'
#' @param tooltip A call to [tooltip()] specifying a tooltip for the button or
#'   link input, defaults to `NULL`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @param value A number specifying a new value for the button, defaults to
#'   `NULL`.
#'
#' @param enable If `TRUE` the button is enabled and will react to clicks from
#'   the user,  defaults to `NULL`.
#'
#' @param disable if `TRUE` the button is disabled and will not react to clicks
#'   from the user, default to `NULL`.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @details
#'
#' **Tooltips**
#'
#' To remove a button or link input's tooltip pass an empty tooltip,
#' `tooltip()`, to `updateButtonInput()` or `updateLinkInput()`.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### A plain button
#'
#' buttonInput(
#'   id = "button1",
#'   label = "Simple"
#' )
#'
#' ### Add a little color
#'
#' buttonInput(
#'   .style %>%
#'     background("primary"),
#'   id = "button2",
#'   label = "Blue"
#' )
#'
#' # Alternatively, a button can fill the width of its parent element.
#'
#' buttonInput(
#'   .style %>%
#'     background("danger"),
#'   id = "button3",
#'   label = "Full-width",
#'   fill = TRUE  # <-
#' )
#'
#' # Use design utilities to further adjust the width of a button.
#'
#' buttonInput(
#'   .style %>%
#'     background("danger") %>%
#'     width(75),  # <-
#'   id = "button4",
#'   label = "Full and back again",
#'   fill = TRUE  # <-
#' )
#'
#' ### Reactive links
#'
#' div("Curabitur", linkInput(id = "link1", label = "vulputate"),
#'     "vestibulum lorem.")
#'
#' ### Stretched buttons and links
#'
#' card(
#'   header = "Card with stretched button",
#'   p("Notice when you hover over the card, the button also detects ",
#'     "the hover."),
#'   buttonInput(
#'     .style %>%
#'       background("primary"),
#'     id = "go",
#'     label = "Go go go",
#'     stretch = TRUE
#'   )
#' )
#'
#' ### Download button
#'
#' buttonInput(
#'   download = TRUE,
#'   id = "download1",
#'   label = "Download",
#'   icon("download")
#' )
#'
buttonInput <- function(..., id, label, stretch = FALSE, download = FALSE,
                        tooltip = NULL) {
  assert_id()
  assert_label()

  with_deps({
    tag <- (if (download) tags$a else tags$button)(
      class = str_collate(
        "yonder-button",
        "btn",
        if (stretch) "stretched-link",
        if (download) "shiny-download-link"
      ),
      type = "button",
      role = "button",
      href = if (download) "",
      `_target` = if (download) NA,
      download = if (download) NA,
      id = id,
      label,
      autocomplete = "off"
    )

    ## tag <- tag_tooltip_add(tag, tooltip)
    args <- style_dots_eval(..., .style = style_pronoun("yonder_button"))
    tag <- tag_extend_with(tag, args)

    s3_class_add(tag, c("yonder_button", "yonder_input"))
  })
}

#' @rdname buttonInput
#' @export
updateButtonInput <- function(id, label = NULL, value = NULL,
                              disable = NULL, enable = NULL,
                              tooltip = NULL,
                              session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  if (!is.null(value) && !is.numeric(value)) {
    stop(
      "invalid argument in `updateButtonInput()`, `value` must be numeric or ",
      "NULL",
      call. = FALSE
    )
  }

  content <- coerce_content(label)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)

  session$sendInputMessage(id, list(
    content = content,
    value = value,
    disable = disable,
    enable = enable,
    tooltip = tooltip
  ))
}


#' @rdname buttonInput
#' @export
linkInput <- function(..., id, label, stretch = FALSE, download = FALSE,
                      tooltip = NULL) {
  assert_id()
  assert_label()

  with_deps({
    tag <- (if (download) tags$a else tags$button)(
      class = str_collate(
        "yonder-link",
        "btn",
        if (!download) "btn-link",
        if (stretch) "stretched-link",
        if (download) "shiny-download-link"
      ),
      href = if (download) "",
      `_target` = if (download) NA,
      download = if (download) NA,
      id = id,
      label
    )

    ## tag_tooltip_add(, tooltip)
    args <- style_dots_eval(...)
    tag <- tag_extend_with(tag, args)

    tag
  })
}

#' @rdname buttonInput
#' @export
updateLinkInput <- function(id, label = NULL, value = NULL,
                            enable = NULL, disable = NULL,
                            tooltip = NULL,
                            session = getDefaultReactiveDomain())  {
  assert_id()
  assert_session()

  if (!is.null(value) && !is.numeric(value)) {
    stop(
      "invalid argument in `updateLinkInput()`, `value` must be numeric or ",
      "NULL",
      call. = FALSE
    )
  }

  if (!is.null(value)) {
    value <- as.numeric(value)
  }

  content <- coerce_content(label)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)

  session$sendInputMessage(id, list(
    content = content,
    value = value,
    enable = enable,
    disable = disable,
    tooltip = tooltip
  ))
}

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
#' @family inputs
#' @export
#' @examples
#'
#' ### Default input
#'
#' buttonGroupInput(
#'   id = "group1",
#'   choices = c("Once", "Twice", "Thrice"),
#'   values = c(1, 2, 3)
#' )
#'
#' ### Styling the button group
#'
#' buttonGroupInput(
#'   .style %>%
#'     background("primary"),
#'   id = "group2",
#'   choices = c("Button 1", "Button 2", "Button 3")
#' )
#'
buttonGroupInput <- function(..., id, choices = NULL, values = choices,
                             labels = deprecated(),
                             direction = "horizontal") {
  if (is_present(labels)) {
    deprecate_soft(
      "0.2.0",
      "buttonGroupInput(labels = )",
      "buttonGroupInput(choices = )"
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
