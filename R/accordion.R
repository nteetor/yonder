#' Accordion panels
#'
#' @description
#'
#' Similar to `collapse`, `accordion` is a way to hide content. An accordion
#' is made up of multiple panels and at most one panel is open. There is one
#' exception, when the page renders multiple panels may start in the open state,
#' however once the user interacts with accordion the default behavior returns.
#'
#' `panel` is a helper function to facilitate building accordion panels and does
#' not have an explicit corresponding bootstrap class, see details for more
#' information.
#'
#' @param ... Any number of `panel`s, converted into accordion panels, or named
#'   arguments passed as HTML attributes to the parent element.
#'
#' @param header A character string specifying the header of the panel.
#'
#' @param body A character string or tag element(s) specifying the body content
#'   of the panel, defaults to `NULL`.
#'
#' @param collapsed If `TRUE`, the panel renders in the collapsed state,
#'   defaults to `TRUE`.
#'
#' @details
#'
#' `panel` is only a thin wrapper around `list` to ensure each accordion panel
#' has a heading and a body and to make other rendering options clearer. If you
#' want more customization over accordion panels you may ignore `panel` and pass
#' unnamed tag elements. When creating custom panels be sure to follow the
#' `data-target`, `data-toggle` conventions, for more on how to build custom
#' accordions check out the Bootstrap
#' [collapse reference](https://v4-alpha.getbootstrap.com/components/collapse/).
#'
#' `accordion` will generate an HTML id if an `id` argument is not passed in
#' `...` and child panels are assigned IDs based on the id of the accordion
#' parent.
#'
#' @seealso
#'
#' For more information on accordion's, please refer to the bootstrap
#' [reference page](https://v4-alpha.getbootstrap.com/components/collapse/).
#'
#' @export
#' @examples
#' accordion(
#'   panel(
#'     heading = "Group 1",
#'     "Body text of the first group."
#'   ),
#'   panel(
#'     heading = "Group 2",
#'     "Body text of the second group."
#'   ),
#'   panel(
#'     heading = "Group 3",
#'     "Body text of the third group."
#'   )
#' )
#'
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       accordion(
#'         panel(
#'           heading = "Option 1",
#'           "What do you think of option 1?",
#'           collapse = FALSE
#'         ),
#'         panel(
#'           heading = "Option 2",
#'           "What do you think of option 2?"
#'         ),
#'         panel(
#'           heading = "Option 3",
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

  panels <- args[elodin(args) %in% c("show", "")]
  attrs <- args[!(elodin(args) %in% c("show", ""))]

  if (is.null(attrs$id)) {
    attrs$id <- ID("accordion")
  }

  acc <- tags$div(
    role = "tablist",
    `aria-multiselectable` = "true",
    if (length(panels)) {
      Map(
        function(parentID, childID, pan) {
          if (class(pan) != "panel") {
            return(pan)
          }

          tags$div(
            class = "card",
            tags$div(
              class = "card-header",
              role = "tab",
              tags$h5(
                class = "mb-0",
                tags$a(
                  `data-toggle` = "collapse",
                  `data-parent` = paste0("#", parentID),
                  href = paste0("#", childID),
                  pan$header
                )
              )
            ),
            tags$div(
              id = childID,
              class = collate(
                "collapse",
                if (!pan$collapsed) "show"
              ),
              role = "tabpanel",
              tags$div(
                class = "card-block",
                pan$body
              )
            )
          )
        },
        attrs$id,
        paste0(attrs$id, "-", seq_along(panels)),
        panels
      )
    },
    bootstrap()
  )

  acc$attribs <- c(acc$attribs, attrs)
  acc
}

#' @rdname accordion
#' @export
panel <- function(header, body = NULL, collapsed = TRUE) {
  p <- list(header = header, body = body, collapsed = collapsed)
  attr(p, "class") <- "panel"
  p
}
