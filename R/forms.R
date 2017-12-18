#' Form inputs
#'
#' Form inputs are a new reactive input. A form input's reactive value is a list
#' of all the reactive inputs within it. Additionally, form inputs suppress
#' the reactive nature of their child inputs.
#'
#' @param id A character string specifying an id for the form input, defaults to
#'   `NULL`.
#'
#' @param ... Any number of inputs, other elements, or additional named
#'   arguments passed as HTML attributes to the parent element.
#'
#' @seealso
#'
#' Bootstrap 4 forms documentation:
#' \url{https://getbootstrap.com/docs/4.0/components/forms/}
#'
#' @family inputs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           formInput(
#'             id = "form",
#'             emailInput(
#'               id = "email",
#'               label = "Email",
#'               placeholder = "Email"
#'             ),
#'             passwordInput(
#'               id = "password",
#'               label = "Password",
#'               placeholder = "Password"
#'             ),
#'             fieldset(
#'               legend = "Radios",
#'               radioInput(
#'                 id = "options",
#'                 choices = c(
#'                   "Option one",
#'                   "Option two",
#'                   "Option three"
#'                 )
#'               )
#'             ),
#'             checkboxInput(
#'               id = "checkbox",
#'               label = "Checkbox",
#'               choice = "Check me out"
#'             )
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("value")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderPrint({
#'         str(input$form)
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
#'           formInput(
#'             id = "real",
#'             tags$label("Real name"),
#'             textInput(
#'               id = "first",
#'               label = "First name"
#'             ),
#'             textInput(
#'               id = "last",
#'               label = "Last name"
#'             )
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("realvalue")
#'         ),
#'         col(
#'           formInput(
#'             id = "nickname",
#'             tags$label("Nickname"),
#'             textInput(
#'               id = "first",
#'               label = "First name"
#'             ),
#'             textInput(
#'               id = "last",
#'               label = "Last name"
#'             )
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("nickvalue")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$realvalue <- renderPrint({
#'         str(input$real)
#'       })
#'
#'       output$nickvalue <- renderPrint({
#'         str(input$nickname)
#'       })
#'     }
#'   )
#' }
#'
#'
formInput <- function(id, ...) {
  if (!is.character(id)) {
    stop(
      "invalid `formInput` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  #
  # the hackiest work around I've put together
  #
  shiny::registerInputHandler(
    type = "dull.form.element",
    force = TRUE,
    fun = function(x, session, name) {
      NULL
    }
  )

  tags$form(
    class = "dull-form-input",
    id = id,
    ...,
    tags$div(
      class = "form-group",
      submitInput()
    ),
    bootstrap()
  )
}
