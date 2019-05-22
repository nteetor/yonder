#' Popovers
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
#' @param id A character string specifying the id of a popover's target tag
#'   element.
#'
#' @param popover The popover element to show, typically a call to `popover()`.
#'
#' @param placement One of `"top"`, `"left"`, `"bottom"`, or `"right"`
#'   specifying where the popover is positioned relative to the target tag
#'   element indicated by `id`, defaults to `"top"`.
#'
#' @param duration A positive integer specifying the duration of the popover in
#'   seconds or `NULL`, in which case the popover is not automatically removed.
#'   When `NULL` the popover must be removed with `closePopover()`.
#'
#' @inheritParams collapsePane
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
#' @family components
#' @export
#' @examples
#'
#' ### Examples
#'
#' # Please see example application above.
#'
popover <- function(..., title = NULL) {
  if (!is.null(title)) {
    title <- tags$h3(class = "popover-header", title)
  }

  args <- list(...)

  component <- tags$div(
    class = "popover",
    role = "tooltip",
    tags$div(class = "arrow"),
    title,
    tags$div(
      class = "popover-body",
      unnamed_values(args)
    )
  )

  component <- tag_attributes_add(component, named_values(args))

  attach_dependencies(component)
}

#' @rdname popover
#' @export
showPopover <- function(id, popover, placement = "top", duration = NULL,
                        session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()
  assert_possible(placement, c("right", "left", "top", "bottom"))
  assert_duration()

  content <- coerce_content(popover)

  session$sendCustomMessage("yonder:popover", list(
    type = "show",
    data = list(
      id = id,
      content = content,
      placement = placement,
      duration = if (!is.null(duration)) duration * 1000
    )
  ))
}

#' @rdname popover
#' @export
closePopover <- function(id, session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  session$sendCustomMessage("yonder:popover", list(
    type = "close",
    data = list(
      id = id
    )
  ))
}
