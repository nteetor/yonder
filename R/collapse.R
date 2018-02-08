#' Collapsible sections
#'
#' `collapse` allows content to be hidden and toggled into a shown state.
#' The collapsed content is toggled by a button or may be toggled between hidden
#' and shown states using `toggleCollapse`. `showCollapse` and `hideCollapse`
#' are alternatives to `toggleCollapse` to change the state of collapsed content
#' to shown or hidden, respectively.
#'
#' @param button A button input, when clicked the button will hide or show the
#'   collapsable content.
#'
#' @param ... Additional named arguments passed as attributes to the parent
#'   element.
#'
#' @param id A character string specifying the id of a collapse section.
#'
#' @param session A `session` object passed to the shiny server function,
#'   defaults to [`getDefaultReactiveDomain()`].
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           buttonInput(
#'             id = "trigger",
#'             label = "The Time Machine"
#'           ) %>%
#'             background("purple", +1) %>%
#'             margins(2) %>%
#'             collapse(
#'               tags$div(
#'                 class  = "card card-block",
#'                 "\"The Time Traveller (for so it will be convenient to speak
#'                 of him) was expounding a recondite matter to us. His grey eyes
#'                 shone and twinkled, and his usually pale face was flushed and
#'                 animated. The fire burned brightly, and the soft radiance of
#'                 the incandescent lights in the lilies of silver caught the
#'                 bubbles that flashed and passed in our glasses.\""
#'               )
#'             )
#'         ),
#'         col(
#'           buttonInput(id = "toggle", "Toggle"),
#'           buttonInput(id = "hide", "Hide"),
#'           buttonInput(id = "show", "Show")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$toggle, {
#'         toggleCollapse("trigger")
#'       })
#'
#'       observeEvent(input$hide, {
#'         hideCollapse("trigger")
#'       })
#'
#'       observeEvent(input$show, {
#'         showCollapse("trigger")
#'       })
#'     }
#'   )
#' }
#'
collapse <- function(button, content, ...) {
  id <- ID("collapse")

  tags$div(
    `aria-expanded` = "false",
    tagAppendAttributes(
      button,
      `data-toggle` = "collapse",
      `data-target` = paste0("#", id),
      `aria-controls` = id
    ),
    tags$div(
      class = "collapse",
      id = id,
      content
    ),
    ...,
    includes()
  )
}

#' @rdname collapse
#' @export
showCollapse <- function(id, session = getDefaultReactiveDomain()) {
  updateCollapse(id, "show", session)
}

#' @rdname collapse
#' @export
hideCollapse <- function(id, session = getDefaultReactiveDomain()) {
  updateCollapse(id, "hide", session)
}

#' @rdname collapse
#' @export
toggleCollapse <- function(id, session = getDefaultReactiveDomain()) {
  updateCollapse(id, "toggle", session)
}

# internal
updateCollapse <- function(id, action, session) {
  if (!re(action, "show|hide|toggle", len0 = FALSE)) {
    stop(
      'invalid `updateCollapse` argument, `action` must be one "show", ',
      '"hide", or "toggle"',
      call. = FALSE
    )
  }

  session$sendCustomMessage(
    "dull:collapse",
    list(
      id = id,
      action = action
    )
  )
}
