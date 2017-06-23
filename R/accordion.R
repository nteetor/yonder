#' Accordions
#'
#' Accordion collapsible content. `panel` is a helper function to facilitate
#' building accordion panels, see details for more information.
#'
#' @param ... `panel`s converted into accordion panels or named arguments passed
#'   as HTML attributes to the accordion parent element.
#'
#'   **Note**, a `panel` or custom panel named `show` will render in an open
#'   state rather than the default collapsed state.
#'
#' @param heading A panel heading, character string or tag element(s).
#'
#' @param body Body content for the panel, character string or tag element(s).
#'
#' @details
#'
#' `panel` is little more than a thin wrapper around `list` to ensure each
#' accordion panel has a heading and a body. If you want more customization over
#' accordion panels you may ignore `panel` and pass unnamed tag elements. When
#' creating custom panels be sure to follow the `data-target`, `data-toggle`
#' conventions, for more on how to build custom accordions check out the
#' Bootstrap
#' [collapse reference](https://v4-alpha.getbootstrap.com/components/collapse/).
#'
#' `accordion` will generate an HTML id if one is not specified and child panels
#' are assigned IDs based on the id of the accordion parent.
#'
#' @export
#' @examples
#' accordion(
#'   panel(
#'     "Heading 1",
#'     "Body text"
#'   ),
#'   panel(
#'     "Heading 2",
#'     "Body text"
#'   ),
#'   panel(
#'     "Heading 3",
#'     "Body text"
#'   )
#' )
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
        function(parentID, childID, pan, name) {
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
                  pan$heading
                )
              )
            ),
            tags$div(
              id = childID,
              class = collate(
                "collapse",
                if (name == "show") "show"
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
        panels,
        elodin(panels)
      )
    },
    bootstrap()
  )

  acc$attribs <- c(acc$attribs, attrs)
  acc
}

#' @rdname accordion
#' @export
panel <- function(heading, body) {
  p <- list(heading = heading, body = body)
  attr(p, "class") <- "panel"
  p
}
