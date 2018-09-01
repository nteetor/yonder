#' Collapsible sections
#'
#' The `collapse()` function allows you to make a tag element collapsible. The
#' state of the element, shown or hidden, is toggled using `hideCollapse()`,
#' `showCollapse()`, and `toggleCollapse()`.
#'
#' @param tag A tag element.
#'
#' @param id A character string specifying an HTML id. Pass this id to the
#'   `*Collapse()` functions to hide or show the collapsible element.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   collapsible div.
#'
#' @family utilities
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       center = TRUE,
#'       buttonInput("toggle", "Toggle the card") %>%
#'         margin(3),
#'       card(
#'         "\"The Time Traveller (for so it will be convenient to speak
#'          of him) was expounding a recondite matter to us. His grey eyes
#'          shone and twinkled, and his usually pale face was flushed and
#'          animated. The fire burned brightly, and the soft radiance of
#'          the incandescent lights in the lilies of silver caught the
#'          bubbles that flashed and passed in our glasses.\""
#'       ) %>%
#'         background("grey") %>%
#'         collapse("mycollapse")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$toggle, {
#'         toggleCollapse("mycollapse")
#'       })
#'     }
#'   )
#' }
#'
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       center = TRUE,
#'       buttonInput(
#'         id = "toggle",
#'         label = "Client-side toggle",
#'         `data-target` = "#mycollapse",
#'         `data-toggle` = "collapse"
#'       ) %>%
#'         margin(3),
#'       card(
#'         "If you do not need server-side control with the `*Collapse()`
#'          functions consider setting up a client-side collapse with
#'          `data-target` and `data-toggle='collapse'`, see
#'          https://getbootstrap.com/docs/4.1/components/collapse/
#'          for more about these attributes"
#'       ) %>%
#'         collapse("mycollapse")
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
collapse <- function(tag, id, ...) {
  args <- list(...)
  attrs <- attribs(args)
  elems <- elements(args)

  if (length(attrs)) {
    names(attrs) <- paste0("data-collapse-", names(attrs))
  }

  attrs$`data-collapse-id` <- id

  tag <- shiny::tagAppendChildren(tag, list = elems)
  tag <- shiny::tagAppendChild(tag, include("core"))
  tag <- tagConcatAttributes(tag, attrs)

  tag
}

#' @rdname collapse
#' @export
showCollapse <- function(id) {
  updateCollapse(id, "show")
}

#' @rdname collapse
#' @export
hideCollapse <- function(id) {
  updateCollapse(id, "hide")
}

#' @rdname collapse
#' @export
toggleCollapse <- function(id) {
  updateCollapse(id, "toggle")
}

# internal
updateCollapse <- function(id, type) {
  if (!re(type, "show|hide|toggle", len0 = FALSE)) {
    stop(
      'invalid `updateCollapse` argument, `action` must be one "show", ',
      '"hide", or "toggle"',
      call. = FALSE
    )
  }

  domain <- getDefaultReactiveDomain()

  if (is.null(domain)) {
    stop(
      "invalid call to `", sys.call(-1)[[1]], "()`, must be called within a ",
      "reactive context",
      call. = FALSE
    )
  }

  domain$sendCustomMessage("yonder:collapse", list(
    type = type,
    data = list(
      id = id
    )
  ))
}
