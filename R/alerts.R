#' Alerts
#'
#' @description
#'
#' Contextual notifications. Alerts are defined in the UI of an application.
#' They are rendered and shown using the `renderAlert` function. Alerts
#' optionally include a dismiss button. For fully programmatic control over
#' the state of the alert the dismiss button may be excluded.
#'
#' It is important to remember alerts are both outputs and inputs, albeit very
#' simple inputs. The input value of an alert becomes `TRUE` when the alert is
#' dismissed, otherwise the value is `NULL`.
#'
#' @param text A character string or tag element(s) specifying the body content
#'   of the alert, defaults to `NULL`.
#'
#' @param heading A character string specifying text to use as a heading for the
#'   alert, defaults to `NULL`.
#'
#'   `h4` is the default heading tag. To use a different heading level tag
#'   specify custom HTML. Be sure to include the HTML class `alert-heading`,
#'   e.g. `tags$h3(class = "alert-heading", "My alert heading")`.
#'
#' @param context One of `"success"`, `"info"`, `"warning"`, or `"danger"`
#'   specifying the visual context of the alert, defaults to `NULL`.
#'
#'   By default, success alerts are green, informative alerts are blue, warning
#'   alerts are yellow, and danger alerts are red.
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
#'   to an invisible state, and a return value of `NULL` leaves the state as is.
#'
#'   It is important to note, once an alert is dismissed the alert element is
#'   removed from the page. Thus, the rendering function, no matter the return
#'   value, will no longer have an effect. To avoid this functionality set
#'   `dismissible` to `FALSE`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @details
#'
#' As an input, an alert will return `TRUE` when it is dismissed, otherwise its
#' input value remains `NULL`.
#'
#' As an ouput, an alert may be hidden or shown using `renderAlert`.
#'
#' @seealso
#'
#' For more information on bootstrap alerts please refer to the
#' [reference page](https://v4-alpha.getbootstrap.com/components/alerts/).
#'
#' @export
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       alert(
#'         id = "popup",
#'         text = "Hey! We even asked nicely.",
#'         context = "info",
#'         icon = fontAwesome("check")
#'       ),
#'       button(id = "show", "Don't click me, please")
#'     ),
#'     server = function(input, output) {
#'       output$popup <- renderAlert({
#'         input$show$count %% 2
#'       })
#'     }
#'   )
#'
#'   shinyApp(
#'     ui = container(
#'       alert(id = "alert", "Test alert")
#'     ),
#'     server = function(input, output) {
#'       output$alert <- renderAlert(TRUE)
#'
#'       observeEvent(input$alert, {
#'         print("User dismissed the alert")
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
