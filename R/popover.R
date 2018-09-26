#' Display a popover
#'
#' Popovers are small windows of content associated with a tag element. Use
#' `showPopover()` to add a popover to any tag element with an HTML id. This
#' allows you to add explanations for inputs. Furthermore the [linkInput()]
#' makes adding popovers to semi-plain text possible. Popovers are hidden with
#' `closePopover()`.
#'
#' @param id A character string specifying the HTML id of a popover's target tag
#'   element.
#'
#' @param content A character string or tag element specifying the content of
#'   the popover.
#'
#' @param title A character string specifying a title for the popover, defaults
#'   to `NULL`, in which case a title is not added.
#'
#' @param placement One of `"top"`, `"left"`, `"bottom"`, or `"right"`
#'   specifying where the popover is positioned relative to the target tag
#'   element indicated by `id`.
#'
#' @param duration A positive integer specifying the duration of the popover
#'   in seconds or `NULL`, in which case the popover is not automatically
#'   removed. When `NULL` is specified the popover can be removed with
#'   `closePopover()`.
#'
#' @section Example application:
#'
#' ```R
#' ui <- container(
#'   buttonInput("click", "Button"),
#'   buttonInput("close", icon("times")) %>%
#'     background("red")
#' )
#'
#' server <- function(input, output) {
#'   observeEvent(input$click, {
#'     showPopover(
#'       id = "click",
#'       text = "This is a button!",
#'       placement = "bottom",
#'       duration = NULL
#'     )
#'   })
#'
#'   observeEvent(input$close, {
#'     closePopover("click")
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family server
#' @export
showPopover <- function(id, content, title = NULL, placement = "top",
                        duration = 4) {
  domain <- getDefaultReactiveDomain()

  if (is.null(domain)) {
    stop(
      "function `showPopover()` must be called in a reactive context",
      call. = FALSE
    )
  }

  domain$sendCustomMessage("yonder:popover", list(
    type = "show",
    id = id,
    data = list(
      content = HTML(content),
      title = title,
      placement = placement,
      duration = if (!is.null(duration)) duration * 1000
    )
  ))
}

#' @family utilities
#' @rdname showPopover
#' @export
closePopover <- function(id) {
  domain <- getDefaultReactiveDomain()

  if (is.null(domain)) {
    stop(
      "function `closePopover()` must be called in a reactive context",
      call. = FALSE
    )
  }

  domain$sendCustomMessage("yonder:popover", list(
    type = "close",
    id = id
  ))
}
