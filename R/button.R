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
#' ### A simple button
#'
#' buttonInput(
#'   id = "button1",
#'   label = "Simple"
#' )
#'
#' # Alternatively, a button can fill the width of its parent element.
#'
#' buttonInput(
#'   id = "button2",
#'   label = "Full-width",
#'   fill = TRUE  # <-
#' ) %>%
#'   background("red")
#'
#' # Use design utilities to further adjust the width of a button.
#'
#' buttonInput(
#'   id = "button3",
#'   label = "Full and back again",
#'   fill = TRUE  # <-
#' ) %>%
#'   background("red") %>%
#'   width("3/4")  # <-
#'
#' ### Possible colors
#'
#' colors <- c(
#'   "red", "purple", "indigo", "blue", "cyan", "teal", "green",
#'   "yellow", "amber", "orange", "grey"
#' )
#'
#' lapply(
#'   colors,
#'   function(color) {
#'     buttonInput(
#'       id = color,
#'       label = color
#'     ) %>%
#'       background(color) %>%
#'       margin(2)
#'   }
#' ) %>%
#'   div() %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
#'
#' ### Reactive links
#'
#' div("Curabitur ", linkInput("link1", "vulputate"), " vestibulum lorem.")
#'
#' ### Stretched buttons and links
#'
#' card(
#'   header = "Card with stretched button",
#'   p("Notice when you hover over the card, the button also detects ",
#'     "the hover."),
#'   buttonInput(
#'     id = "go",
#'     label = "Go go go",
#'     stretch = TRUE
#'   ) %>%
#'     background("blue")
#' ) %>%
#'   width(20)
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
buttonInput <- function(id, label, ..., stretch = FALSE, download = FALSE,
                        tooltip = NULL) {
  assert_id()
  assert_label()

  dep_attach({
    component <- (if (download) tags$a else tags$button)(
      class = str_collate(
        "yonder-button",
        "btn btn-grey",
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
      ...,
      autocomplete = "off"
    )

    tag_tooltip_add(component, tooltip)
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
linkInput <- function(id, label, ..., stretch = FALSE, download = FALSE,
                      tooltip = NULL) {
  assert_id()
  assert_label()

  dep_attach({
    component <- (if (download) tags$a else tags$button)(
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
      label,
      ...
    )

    tag_tooltip_add(component, tooltip)
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
#' @param values A vector of values specifying the values of each button in the
#'   group, defaults to `labels`.
#'
#' @param enable One of `values` indicating individual buttons to enable or
#'   `TRUE` to enable the entire input, defaults to `NULL`.
#'
#' @param disable One of `values` indicating individual buttons to disable or
#'   `TRUE` to disable the entire input, defaults to `NULL`.
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
#'   id = "group2",
#'   choices = c("Button 1", "Button 2", "Button 3")
#' ) %>%
#'   background("blue") %>%
#'   width("1/3")
#'
buttonGroupInput <- function(id, choices = NULL, values = choices, ...) {
  args <- list(...)

  if ("labels" %in% names(args)) {
    warning(
      "invalid argument in `buttonGroupInput()`, ",
      "`labels` has been deprecated, please use `choices`"
    )

    choices <- args$labels
    if (is.null(values)) {
      values <- args$labels
    }
    args$labels <- NULL
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

  dep_attach({
    buttons <- map_buttons(choices, values)

    bg <- tags$div(
      class = "yonder-button-group btn-group",
      id = id,
      role = "group",
      buttons,
      unnamed_values(args)
    )

    tag_attributes_add(bg, named_values(args))
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
        class = "btn btn-grey",
        value = value,
        label
      )
    }
  )
}
