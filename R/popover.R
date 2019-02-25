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
#' @inheritParams updateInput
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

  element <- tags$div(
    class = "popover",
    role = "tooltip",
    tags$div(class = "arrow"),
    title,
    tags$div(
      class = "popover-body",
      elems
    )
  )

  element <- tagConcatAttributes(element, attrs)

  attachDependencies(element, yonderDep())
}

#' @rdname popover
#' @export
showPopover <- function(target, popover, placement = "top", duration = NULL,
                        session = getDefaultReactiveDomain()) {
  if (!is.character(target)) {
    stop(
      "invalid `showPopover()` argument, `target` must be a character string",
      call. = FALSE
    )
  }

  if (is.null(session)) {
    stop(
      "invalid `showPopover()` argument, `session` is NULL",
      call. = FALSE
    )
  }

  if (!re(placement, "right|left|top|bottom", len0 = FALSE)) {
    stop(
      "invalid `showPopover()` arugment, `placement` must be one of ",
      '"top", "right", "bottom", or "left"',
      call. = FALSE
    )
  }

  if (!is.null(duration)) {
    if (!is.numeric(duration) || duration < 0) {
      stop(
        "invalid `showPopover()` argument, `duration` must be a positive ",
        "integer",
        call. = FALSE
      )
    }
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
  if (!is.character(id)) {
    stop(
      "inavlid `closePopover()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  if (is.null(session)) {
    stop(
      "invalid `closePopover()` argument, `session` is NULL",
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
