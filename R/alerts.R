#' Alerts
#'
#' Provide the user with feedback with custom alert dialogs.
#'
#' @param text A character string or tagList
#'
#' @param heading A character vector specifying text to use as a heading for the
#'   alert, defaults to `NULL`.
#'
#'   `h4` is the default heading tag. To use a different heading level tag one
#'   may specify custom HTML. Be sure to include the HTML class `alert-heading`,
#'   e.g. `tags$h3(class = "alert-heading", "Level 3 Heading")`.
#'
#' @param context Used to specify the visual context of the alert, one of
#'   `"success"`, `"info"`, `"warning"`, or `"danger"`, defaults to `NULL`.
#'
#'   Alerts for success are green, informative alerts are blue, warning alerts
#'   are yellow, and alerts for danger are red.
#'
#' @param hidden If `TRUE`, the alert renders in an invisible state and may be
#'   toggled into a visible state using `renderAlert`, defaults to `TRUE`.
#'
#' @param dismissible If `TRUE`, the alert includes a button to dismiss the
#'   alert, defaults to `TRUE`.
#'
#' @param icon An optional alternate icon to use as the dismiss button, see
#'   [`icons`], defaults to `NULL`.
#'
#' @param show An expression which returns `TRUE`, `FALSE`, or `NULL`. When
#'   `TRUE` the alert toggles to a shown state, when `FALSE` the alert toggles
#'   to a invisible state, and finally a return value of `NULL` holds the
#'   alert in its current state.
#'
#'   It is important to note that once an alert is dismissed the alert element
#'   is removed from the page. Thus, the rendering function, no matter the
#'   return value, no longer has an effect. To avoid this funcationality set
#'   `dismissible` to `FALSE`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the alert
#'   element.
#'
#' @details
#'
#' As an input, an alert will return `TRUE` when it is dismissed, otherwise its
#' input value remains `NULL`.
#'
#' As an ouput, an alert may be hidden or shown using `renderAlert`.
#'
#' @export
#' @examples
#'
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       alert(
#'         id = "popup",
#'         text = "Hey! We even asked nicely.",
#'         context = "info",
#'         icon = icons$fa("check")
#'       ),
#'       button(id = "show", "Don't click me, please")
#'     ),
#'     server = function(input, output) {
#'       output$popup <- renderAlert({
#'         input$show$count %% 2
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       alert(id = "alert", "Test alert")
#'     ),
#'     server = function(input, output) {
#'       output$alert <- renderAlert(TRUE)
#'
#'       output$alert2 <- renderAlert(TRUE)
#'
#'       observeEvent(input$alert, {
#'         print(input$alert)
#'       })
#'     }
#'   )
#' }
#'
alert <- function(text = NULL, heading = NULL, context = NULL, hidden = TRUE,
                  dismissible = TRUE, icon = NULL, ...) {
  if (bad_context(context)) {
    stop(
      'invalid `alert` argument, `context` must be one of "success", "info", ',
      '"warning", or "danger"',
      call. = FALSE
    )
  }

  if (!is_tag(heading) && !is.null(heading)) {
    heading <- tags$h4(class = "alert-heading", heading)
  }

  tags$div(
    class = collate(
      "dull-alert",
      "alert",
      if (!is.null(context)) paste0("alert-", context),
      if (dismissible) "alert-dismissible fade show",
      if (hidden) "invisible"
    ),
    text,
    if (dismissible) {
      tags$button(
        type = "button",
        class = "close",
        `data-dismiss` = "alert",
        if (is.null(icon)) icons$fa("times-rectangle") else icon
      )
    },
    ...,
    bootstrap()
  )
}

#' @rdname alert
#' @export
renderAlert <- function(show = NULL,  env = parent.frame(), quoted = FALSE) {
  showFun <- shiny::exprToFunction(show, env, quoted)

  function() {
    list(
      show = showFun()
    )
  }
}
