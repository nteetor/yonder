#' Buttons and button groups
#'
#' @description
#'
#' Buttons, submit and reset buttons. A button's reactive value is a list of two
#' items. The first item is `count`, the number of clicks on the button. The
#' second item is `value`, the HTML data-value attribute of the button which may
#' be set with the `value` argument.
#'
#' @param id A character string specifying the id of the button, button group,
#'  or submit button, defaults to `NULL`. If specified, a reactive value is
#'  available to the shiny server function.
#'
#' @param label A character string or tag elements to use as a button label or a
#'   character vector specifying labels for a button group, defaults to `NULL`.
#'
#' @param value A character string specifying a value for the button or a
#'   character vector specifying values for a button group, defaults to
#'   `NULL`.
#'
#' @param context Used to specify the visual context of the button, one of
#'   `"primary"`, `"secondary"`, `"success"`, `"info"`, `"warning"`, `"danger"`,
#'   or `"link"`, defaults to `"secondary"`.
#'
#'   Primary buttons are blue, secondary buttons are white and grey, buttons for
#'   success are green, informative buttons are a lighter blue, warning buttons
#'   are yellow, and buttons for danger are red. Specifying `"link"` makes a
#'   button render with the appearance of a link.
#'
#' @param outline If `TRUE`, the button's background is transparent, `context`
#'   is preserved, defaults to `FALSE`.
#'
#' @param block If `TRUE`, the button is block-level instead of inline, defaults
#'   to `FALSE`. A block-level element will occupy the entire space of its
#'   parent element, thereby creating a "block."
#'
#' @param disabled If `TRUE`, the button renders in a disabled state, defaults
#'   to `FALSE`.
#'
#' @param ... Named arguments passed as HTML attributes to the parent element.
#'
#' @seealso
#'
#' For more about block-level elements please refer to the block-level elements
#' MDN
#' [reference section](https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements).
#'
#' For more about buttons and button groups please refer to the bootstrap
#' [reference section](https://v4-alpha.getbootstrap.com/components/input-group/#button-addons).
#'
#' @family inputs
#' @export
#' @examples
#' button("Primary", context = "primary")
#'
#' button("Secondary")
#'
#' button("Success", context = "success")
#'
#' button("Info", context = "info", outline = TRUE)
#'
#' button("\u2715", context = "warning")
#'
#' button("Danger!", context = "danger", disable = TRUE)
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       listGroup(
#'         listGroupItem(
#'           inlineForm(
#'             button(
#'               id = "clicker1",
#'               "Simple button"
#'             )
#'           ),
#'           badge = badge(id = "badge1", 0)
#'         ),
#'         listGroupItem(
#'           inlineForm(
#'             button(
#'               id = "clicker2",
#'               label = "Click me!",
#'             )
#'           ),
#'           badge = badge(id = "badge2", 0)
#'         ),
#'         listGroupItem(
#'           button(
#'             id = "reset",
#'             label = "Reset",
#'             context = "primary"
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$badge1 <- renderBadge(input$clicker1$count)
#'
#'       output$badge2 <- renderBadge(
#'         value = {
#'           input$clicker2$count
#'         },
#'         context = {
#'           if (input$clicker2$count > 5) {
#'             "warning"
#'           } else {
#'             "default"
#'           }
#'         }
#'       )
#'
#'       observeEvent(input$reset, {
#'         updateButton("clicker1", count = 0)
#'         updateButton("clicker2", count = 0)
#'       })
#'     }
#'   )
#'
#'   shinyApp(
#'     ui = container(
#'       button(
#'         id = "group",
#'         label = c("First", "Second", "Third"),
#'         value = c("first", "second", "third")
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         print(input$group)
#'       })
#'     }
#'   )
#' }
#'
button <- function(label = NULL, value = NULL, context = "secondary",
                   outline = FALSE, block = FALSE, disabled = FALSE, ...,
                   id = NULL) {
  if (!(context %in% c("primary", "secondary", "link")) &&
      bad_context(context)) {
    stop(
      'invalid `button` `context`, expecting one of "primary", "secondary", ',
      '"success", "info", "warning", "danger", or "link"',
      call. = FALSE
    )
  }

  tags$button(
    class = collate(
      "dull-button",
      "dull-input",
      "btn",
      paste0("btn-", if (outline) "outline-", context),
      if (block) "btn-block"
    ),
    type = "button",
    role = "button",
    `data-count` = 0,
    `data-value` = value,
    label,
    ...,
    id = id
  )
}

#' @rdname button
#' @export
submit <- function(label = NULL, outline = FALSE, block = FALSE, ...) {
  tags$button(
    class = collate(
      "dull-submit",
      "btn",
      paste0("btn-", if (outline) "outline-", context),
      if (block) "btn-block"
    ),
    # done to avoid the way Shiny handles submit buttons, will be
    # moved to HTML attribute `type` once shiny app is connected
    `data-type` = "submit",
    role = "button",
    label
  )
}

#' @rdname button
#' @export
updateButton <- function(id, count = NULL, context = NULL,
                         session = getDefaultReactiveDomain()) {
  if (bad_context(context, extra = c("primary", "secondary", "link"))) {
    stop(
      'invalid `updateButton` `context`, expecting one of "primary", "secondary", ',
      '"success", "info", "warning", "danger", or "link"',
      call. = FALSE
    )
  }

  if (!(is.null(count) || is.numeric(count))) {
    stop("invalid `updateButton` `count`, must be NULL or numeric", call. = FALSE)
  }

  if (!is.null(count) && count < 0) {
    stop("invalid `updateButton` `count`, must be greater than 0", call. = FALSE)
  }

  session$sendInputMessage(
    id,
    list(
      count = count,
      context = if (!is.null(context)) paste0("btn-", context)
    )
  )
}

# shiny::registerInputHandler(
#   type = "dull.button",
#   force = TRUE,
#   fun = function(val, shinysession, name) {
#     # hacky way around the initial 0 value of `button`
#     class(val) <- c(class(val), "dullButtonValue")
#     val
#   }
# )

# assignInNamespace(
#   "isNullEvent",
#   function(value) {
#     is.null(value) ||
#       (inherits(value, "shinyActionButtonValue") && value == 0) ||
#       (inherits(value, "dullButtonValue") && value$count == 0)
#   },
#   ns = "shiny"
# )
