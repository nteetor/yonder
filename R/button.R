#' Buttons, button groups and toolbars
#'
#' Button controls. `buttonGroup` and `buttonToolbar` are a means of grouping
#' buttons aesthetically.
#'
#' @param label A character vector or tag elements to use as the button label,
#'   defaults to `NULL`.
#'
#' @param context Used to specify the visual context of the button, one of
#'   `"primary"`, `"secondary"`, `"success"`, `"info"`, `"warning"`, `"danger"`,
#'   or `"link"`, defaults to `"secondary"`.
#'
#'   Primary buttons are blue, secondary buttons are white and grey, buttons for
#'   success are green, informative buttons are a lighter blue, warning buttons
#'   are yellow, and buttons for danger are red. Specifying `"link"` makes the
#'   button render with the appearance of a link.
#'
#' @param outline If `TRUE`, the button's background is transparent, `context`
#'   is preserved, defaults to `FALSE`.
#'
#' @param block If `TRUE`, the button is block-level instead of inline, defaults
#'   to `FALSE`.
#'
#'   A block-level element will occupy the entire space of its parent element,
#'   thereby creating a "block."
#'
#' @param disabled If `TRUE`, the button renders in a disabled state, defaults
#'   to `FALSE`.
#'
#' @param textual Optional textual input, see [`text`], to include as part of
#'   the button, defaults to `NULL`. If specified, the value of the button is
#'   the value of the text field.
#'
#' @param ... Named arguments passed as HTML attributes to the button parent
#'   element.
#'
#' @details
#'
#' When adding a textual component to a button it is recommended to use
#' placeholder text instead of a label.
#'
#' @seealso
#'
#' For more about block-level elements please refer to the
#' [block-level elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements)
#' MDN reference section.
#'
#' For more about input groups or buttons with text fields please refer to the
#' [button addons](https://v4-alpha.getbootstrap.com/components/input-group/#button-addons)
#' Bootstrap reference section.
#'
#' @export
#' @examples
#'
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
#' button(
#'   id = "search",
#'   "Go!",
#'   textual = inputs$text(
#'     placeholder = "search terms"
#'   )
#' )
#'
#' button(
#'   "Check date",
#'   textual = inputs$date()
#' )
#'
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       listGroup(
#'         listItem(
#'           tags$form(
#'             class = "form-inline",
#'           button(
#'             id = "simple",
#'             "Simple button"
#'           )
#'           ),
#'           badge = badge(id = "simpleClicks", 0)
#'         ),
#'         listItem(
#'           tags$form(
#'             class = "form-inline",
#'           button(
#'              id = "textual",
#'              label = "Textual button",
#'              textual = inputs$text(
#'                placeholder = "hello, world!"
#'              )
#'             )
#'           ),
#'           badge = badge(id = "textualClicks", 0)
#'         ),
#'         listItem(
#'           button(
#'             id = "reset",
#'             label = "Reset",
#'             context = "primary"
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$simpleClicks <- renderBadge(input$simple$count)
#'
#'       output$textualClicks <- renderBadge(
#'         value = {
#'           input$textual$count
#'         },
#'         context = {
#'           if (input$textual$count > 5) {
#'             "warning"
#'           } else {
#'             "default"
#'           }
#'         }
#'       )
#'
#'       observeEvent(input$reset, ignoreInit = TRUE, {
#'         updateButton("simple", count = 0)
#'         updateButton("textual", count = 0)
#'       })
#'     }
#'   )
#' }
#'
button <- function(label = NULL, context = "secondary", outline = FALSE,
                   block = FALSE, disabled = FALSE, textual = NULL, ...) {
  if (!(context %in% c("primary", "secondary", "link")) &&
      bad_context(context)) {
    stop(
      'invalid `button` `context`, expecting one of "primary", "secondary", ',
      '"success", "info", "warning", "danger", or "link"',
      call. = FALSE
    )
  }

  btn <- tags$button(
    type = "button",
    class = collate(
      "btn",
      paste0("btn-", if (outline) "outline-", context),
      if (block) "btn-block"
    ),
    disabled = if (disabled) NA,
    role = "button",
    label,
    bootstrap()
  )

  if (!is.null(textual)) {
    tags$div(
      class = "dull-button input-group",
      tags$span(
        class = "input-group-btn",
        btn
      ),
      `data-count` = 0,
      textual,
      ...
    )
  } else {
    tags$div(
      class = "dull-button input-group",
      `data-count` = 0,
      btn,
      ...
    )
  }
}

#' @export
#' @rdname button
updateButton <- function(id, count = NULL, context = NULL, session = getDefaultReactiveDomain()) {
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

#' Button groups and toolbars
#'
#' Group together buttons.
#'
#' @param ... Button elements passed to `buttonGroup` or button groups passed to
#'   `buttonToolbar`, or named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @param margins If `TRUE`, margins are added around button groups for better
#'   spacing, defaults to `TRUE`.
#'
#' @export
#' @examples
#' buttonGroup(
#'   button("Left"),
#'   button("Middle"),
#'   button("Right")
#' )
#'
buttonGroup <- function(...) {
  tags$div(
    class = "btn-group",
    role = "group",
    ...,
    bootstrap()
  )
}

#' @rdname buttonGroup
#' @export
buttonToolbar <- function(..., margins = TRUE) {
  args <- list(...)
  groups <- args[elodin(args) == ""]
  attrs <- args[elodin(args) != ""]

  groups <- c(
    lapply(
      groups[-length(groups)],
      function(x) {
        x$attribs$class <- collate(x$attribs$class, "mr-2")
        x
      }
    ),
    groups[[length(groups)]]
  )

  bar <- tags$div(
    class = "btn-toolbar",
    role = "toolbar",
    groups,
    bootstrap()
  )

  bar$attribs <- c(bar$attribs, attrs)
  bar
}

shiny::registerInputHandler(
  type = "dull.button",
  force = TRUE,
  fun = function(val, shinysession, name) {
    # hacky way around the initial 0 value of `button`
    class(val) <- c(class(val), "dullButtonValue")
    val
  }
)

assignInNamespace(
  "isNullEvent",
  function(value) {
    is.null(value) ||
      (inherits(value, "shinyActionButtonValue") && value == 0) ||
      (inherits(value, "dullButtonValue") && value$count == 0)
  },
  ns = "shiny"
)
