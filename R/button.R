#' Button inputs and submit buttons
#'
#' Button inputs and submit buttons. A submit button generated with `submit`
#' will not freeze reactive inputs unlike shiny's `submitButton`.
#'
#' @param id A character string specifying the id of the button input.
#'
#' @param text A character string specifying the label text of the button input.
#'
#' @param context One of `"primary"`, `"secondary"`, `"success"`, `"info"`,
#'   `"warning"`, `"danger"`, `"light"`, `"dark"`, or `"link"` specifying the
#'   visual context of the button input, defaults to `"secondary"`.
#'
#' @param outline If `TRUE`, the button's visual context is applied to the
#'   border of the button instead of the background, defaults to `FALSE`.
#'
#' @param block If `TRUE`, the button is block-level instead of inline, defaults
#'   to `FALSE`. A block-level element will occupy the entire width of its
#'   parent element, thereby creating a "block."
#'
#' @param disabled If `TRUE`, the button renders in a disabled state, defaults
#'   to `FALSE`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @seealso
#'
#' Bootstrap 4 button documentation:
#' \url{https://getbootstrap.com/docs/4.0/components/buttons/}
#'
#' @family inputs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           buttonInput(
#'             id = "button",
#'             label = "C-c-c-click me!"
#'           )
#'         ),
#'         col(
#'           display4(
#'             textOutput("clicks")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$clicks <- renderText({
#'         input$button
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           buttonInput(
#'             id = "change",
#'             text = "Change other button",
#'             context = "success"
#'           )
#'         ),
#'         col(
#'           buttonInput(
#'             id = "button",
#'             text = "Button",
#'             outline = TRUE
#'           )
#'         ),
#'         col(
#'           display4(
#'             textOutput("value")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$change, {
#'         updateButtonInput(
#'           id = "button",
#'           text = paste("Button", input$change)
#'         )
#'
#'         resetButtonInput("button")
#'       })
#'
#'       output$value <- renderText({
#'         input$button
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       fluid = FALSE,
#'       buttonInput(
#'         id = "button",
#'         text = list(
#'           "Increment badge",
#'           badgeOutput(
#'             id = "badge",
#'             content = 0
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$badge <- renderBadge({
#'         input$button
#'       })
#'     }
#'   )
#' }
#'
buttonInput <- function(id, text, context = "secondary", outline = FALSE,
                        block = FALSE, ...) {
  if (!re(context, "primary|secondary|success|info|warning|danger|light|dark|link", FALSE)) {
    stop(
      "invalid `buttonInput` argument, `context` must be one of ",
      '"primary", "secondary", "success", "info", "warning", "danger", ',
      '"light", "dark", or "link"',
      call. = FALSE
    )
  }

  tags$button(
    class = collate(
      "dull-button-input",
      "dull-input",
      "btn",
      paste0("btn-", if (outline) "outline-", context),
      if (block) "btn-block"
    ),
    type = "button",
    role = "button",
    `data-clicks` = 0,
    text,
    id = id,
    ...
  )
}

#' @rdname buttonInput
#' @export
updateButtonInput <- function(id, label,
                              session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      label = label
    )
  )
}

#' @rdname buttonInput
#' @export
validateButtonInput <- function(id, state,
                                session = getDefaultReactiveDomain()) {
  if (!re(state, "valid|secondary|success|info|warning|danger", len0 = FALSE)) {
    stop(
      "invalid `validateButtonInput` argument, `state` expecting one of ",
      '"valid", "success", "warning", or "danger"',
      call. = FALSE
    )
  }

  session$sendInputMessage(
    id,
    list(
      state = state
    )
  )
}

#' @rdname buttonInput
#' @export
disableButtonInput <- function(id, session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      disable = TRUE
    )
  )
}

#' @rdname buttonInput
#' @export
enableButtonInput <- function(id, session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      enable = TRUE
    )
  )
}

#' @rdname buttonInput
#' @export
resetButtonInput <- function(id, session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      reset = TRUE
    )
  )
}

#' @rdname buttonInput
#' @export
submit <- function(label = "Submit", outline = FALSE, block = FALSE, ...) {
  tags$button(
    class = collate(
      "dull-submit",
      "btn",
      paste0("btn-", if (outline) "outline-", "primary"),
      if (block) "btn-block"
    ),
    # done to avoid the way Shiny handles submit buttons, will be
    # moved to HTML attribute `type` once shiny app is connected
    `data-type` = "submit",
    role = "button",
    label,
    ...
  )
}
