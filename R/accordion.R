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
#' @param ... Any number of `accordionPanel`s or named arguments passed as HTML
#'   attributes to the parent element.
#'
#' @param header A character string specifying the header of an accordion panel.
#'
#' @param body A character string or tag element(s) specifying the body content
#'   of the panel, defaults to `NULL`.
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
accordionPanel <- function(header, body = NULL, collapsed = TRUE, ...) {
  # <div class="card">
  #   <div class="card-header" role="tab" id="headingOne">
  #     <h5 class="mb-0">
  #       <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
  #         Collapsible Group Item #1
  #       </a>
  #     </h5>
  #   </div>
  #
  #   <div id="collapseOne" class="collapse show" role="tabpanel" aria-labelledby="headingOne">
  #     <div class="card-block">
  #       Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
  #     </div>
  #   </div>
  # </div>

  headingId <- ID("panel-heading")
  collapseId <- ID("panel-collapse")

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
  )
}
