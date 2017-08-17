#' Accordion panels
#'
#' Similar to `collapse`, `accordion` is a way to hide content. An accordion
#' is made up of multiple panels. As one panel is toggled open other panels
#' are closed. A page may render with multiple panels open, but once toggled
#' only one panel will remain open. `accordionPanel` is a helper function to
#' facilitate building the accordion's panels.
#'
#' @param ... For **accordion**, any number of `accordionPanel`s or named
#'   arguments passed as HTML attributes to the parent element.
#'
#'   For **accordionPanel**, any number of elements to include in the panel or
#'   named arguments passed as HTML attributes to the parent element.
#'
#' @param label A character string specifying the accordion panel's header.
#'
#' @param collapsed If `TRUE`, the accordion panel renders in the collapsed
#'   state, defaults to `TRUE`.
#'
#' @details
#'
#' `accordion` will generate an HTML id if an `id` argument is not passed in
#' `...` and child panels are assigned IDs based on the id of the accordion
#' parent.
#'
#' @seealso
#'
#' For more information on accordion's, please refer to
#' [https://v4-alpha.getbootstrap.com/components/collapse/](https://v4-alpha.getbootstrap.com/components/collapse/).
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       accordion(
#'         accordionPanel(
#'           "Option 1",
#'           "What do you think of option 1?",
#'           collapse = FALSE
#'         ),
#'         accordionPanel(
#'           "Option 2",
#'           "What do you think of option 2?"
#'         ),
#'         accordionPanel(
#'           "Option 3",
#'           "What do you think of option 3?"
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
accordion <- function(...) {
  args <- list(...)
  attrs <- attribs(args)
  panels <- elements(args)

  if (length(panels)) {
    attrs$id <- attrs$id %||% ID("accordion")
  }

  tagConcatAttributes(
    tags$div(
      class = "accordion",
      role = "tablist",
      lapply(
        panels,
        function(p) {
          # this is horrendous
          p$children[[1]]$children[[1]]$children[[1]]$attribs$`data-parent` <-
            paste0("#", attrs$id)
          p
        }
      ),
      bootstrap()
    ),
    attrs
  )
}

#' @rdname accordion
#' @export
accordionPanel <- function(label, ..., collapsed = TRUE) {
  args <- list(...)
  attrs <- attribs(args)
  body <- content(args)

  headingId <- ID("panel-heading")
  collapseId <- ID("panel-collapse")

  tagConcatAttributes(
    tags$div(
      class = "card",
      tags$div(
        class = "card-header",
        id = headingId,
        role = "tab",
        tags$h5(
          class = "mb-0",
          tags$a(
            class = collate(
              if (collapsed) "collapsed"
            ),
            `data-toggle` = "collapse",
            href = paste0("#", collapseId),
            `aria-expanded` = if (collapsed) "false" else "true",
            `aria-controls` = collapseId,
            header
          )
        )
      ),
      tags$div(
        class = collate(
          "collapse",
          if (!collapsed) "show"
        ),
        id = collapseId,
        `aria-labelledby` = headingId,
        role = "tabpanel",
        tags$div(
          class = "card-block",
          body
        )
      ),
      bootstrap()
    ),
    attrs
  )
}
