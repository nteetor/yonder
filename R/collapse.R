#' Collapsible sections
#'
#' `collapse` allows content to be hidden and toggled into a shown state.
#' The collapsed content is toggled by a button. A collapsed section may be
#' toggled between hidden and shown using `toggleCollapse`, shown with
#' `showCollapse`, and hidden with `hideCollapse`.
#'
#' @param ... Any number of tag elements to include in the collapsible section
#'   or additional named arguments passed as attributes to the parent element.
#'
#' @param label A character string specifying the label of the collapse, passed
#'   to [`inputs$button`], defaults to `NULL`.
#'
#' @param context A character string specifying the visual context of the
#'   toggle button, passed to [`inputs$button`], defaults to `"secondary"`.
#'
#' @param id A character string specifying the id of a collapse section.
#'
#' @param session A `session` object passed to the shiny server function,
#'   defaults to [getDefaultReactiveDomain()].
#'
#' @details
#'
#' The `showCollapse`, `hideCollapse`, and `toggleCollapse` functions can be
#' used very similarly to the `update*` functions found in shiny. Because
#' collapse is not a reactive input a single `updateCollapse` function is not
#' included with dull nor did it make sense to create a `renderCollapse`
#' function as a collapse is not a reactive output.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           collapse(
#'             id = "book",
#'             label = "The Time Machine",
#'             tags$div(
#'               class  = "card card-block",
#'               "\"The Time Traveller (for so it will be convenient to speak
#'               of him) was expounding a recondite matter to us. His grey eyes
#'               shone and twinkled, and his usually pale face was flushed and
#'               animated. The fire burned brightly, and the soft radiance of
#'               the incandescent lights in the lilies of silver caught the
#'               bubbles that flashed and passed in our glasses.\""
#'             )
#'           )
#'         ),
#'         col(
#'           inputs$button(id = "toggle", "Toggle collapse"),
#'           inputs$button(id = "hide", "Only hide", context = "warning"),
#'           inputs$button(id = "show", "Only show", context = "info")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$toggle, {
#'         toggleCollapse("book")
#'       })
#'
#'       observeEvent(input$hide, {
#'         hideCollapse("book")
#'       })
#'
#'       observeEvent(input$show, {
#'         showCollapse("book")
#'       })
#'     }
#'   )
#' }
#'
collapse <- function(..., label = NULL, context = "secondary") {
  args <- list(...)
  content <- elements(args)
  attrs <- attribs(args)

  id <- attrs$id %||% ID("collapse")
  attrs$id <- NULL

  tagConcatAttributes(
    tags$div(
      `aria-expanded` = "false",
      tags$p(
        inputs$button(
          label = label,
          context = context,
          `data-toggle` = "collapse",
          `data-target` = paste0("#", id),
          `aria-controls` = id
        )
      ),
      tags$div(
        class = "collapse",
        id = id,
        content
      ),
      bootstrap()
    ),
    attrs
  )
}

updateCollapse <- function(id, action, session) {
  if (!re(action, "show|hide|toggle", len0 = FALSE)) {
    stop(
      'invalid `updateCollapse` argument, `action` must be one "show", ',
      '"hide", or "toggle"',
      call. = FALSE
    )
  }

  session$sendCustomMessage(
    "dull:updatecollapse",
    list(
      id = paste0("#", id),
      action = action
    )
  )
}

#' @rdname collapse
showCollapse <- function(id, session = getDefaultReactiveDomain()) {
  updateCollapse(id, "show", session)
}

#' @rdname collapse
hideCollapse <- function(id, session = getDefaultReactiveDomain()) {
  updateCollapse(id, "hide", session)
}

#' @rdname collapse
toggleCollapse <- function(id, session = getDefaultReactiveDomain()) {
  updateCollapse(id, "toggle", session)
}
