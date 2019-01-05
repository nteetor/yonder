#' Display a popover
#'
#' Popovers are small windows of content associated with a tag element. Use
#' `popover()` to construct the element and `showPopover()` to add it to any tag
#' element with an HTML id. Popovers are great for explaining inputs and giving
#' hints to the users. Popovers are hidden with `closePopover()`.
#'
#' @param ... Character strings or tag elements specifying the content of the
#'   popover or additional named arguments passed as HTML attributes to the
#'   parent element.
#'
#' @param title A character string specifying a title for the popover, defaults
#'   to `NULL`, in which case a title is not added.
#'
#' @param target A character string specifying the id of the element where the
#'   popover is shown.
#'
#' @param popover The popover element to show, typically a call to `popover()`.
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
#' @param id A character string specifying the HTML id of a popover's target tag
#'   element.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @section Example application:
#'
#' ```R
#' ui <- container(
#'   buttonInput("showHelp", "Help!"),
#'   div(
#'     id = "textBlock1",
#'     "Sociis natoque penatibus et magnis"
#'   ) %>%
#'     padding(3)
#' ) %>%
#'   display("flex") %>%
#'   flex(justify = "around")
#'
#' server <- function(input, output) {
#'   observeEvent(input$showHelp, ignoreInit = TRUE, {
#'     showPopover(
#'       target = "textBlock1",
#'       popover(title = "Hint", "I am a <div> element!"),
#'       placement = "bottom",
#'       duration = 4
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family content
#' @export
#' @examples
#'
#' ### Examples
#'
#' # Please see example application above.
#'
popover <- function(..., title = NULL) {
  title <- if (!is.null(title) && !is_tag(title)) {
    tags$h3(class = "popover-header", title)
  }

  args <- list(...)
  elems <- elements(args)
  attrs <- attribs(args)

  this <- tags$div(
    class = "popover",
    role = "tooltip",
    tags$div(class = "arrow"),
    title,
    tags$div(
      class = "popover-body",
      elems
    )
  )

  this <- tagConcatAttributes(this, attrs)

  this <- attachDependencies(
    this,
    c(yonderDep(), shinyDep(), bootstrapDep())
  )

  this
}

#' @rdname popover
#' @export
showPopover <- function(target, popover, placement = "right", duration = NULL,
                        session = getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop(
      "function `showPopover()` must be called in a reactive context",
      call. = FALSE
    )
  }

  if (!re(placement, "right|left|top|bottom")) {
    stop(
      "invalid `showPopover()` arugment, `placement` must be one of ",
      '"top", "right", "bottom", or "left"',
      call. = FALSE
    )
  }

  session$sendCustomMessage("yonder:popover", list(
    type = "show",
    data = list(
      target = target,
      content = HTML(as.character(popover)),
      placement = placement,
      duration = if (!is.null(duration)) duration * 1000
    )
  ))
}

#' @rdname popover
#' @export
closePopover <- function(id, session = getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop(
      "function `closePopover()` must be called in a reactive context",
      call. = FALSE
    )
  }

  session$sendCustomMessage("yonder:popover", list(
    type = "close",
    data = list(
      id = id
    )
  ))
}
