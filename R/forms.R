#' Form and form group inputs
#'
#' Form inputs are a new reactive input. A form input's reactive value is a list
#' of all the reactive inputs within it. Additionally, form inputs suppress
#' the reactive nature of
#'
#' @param id A character string specifying an id for the form or form group,
#'   defaults to `NULL`. If specified a form or form group becomes a reactive
#'   input. A reactive form group will modify its parent form's input.
#'
#' @param ... Any number of inputs, other elements, or named arguments passed
#'   as HTML attributes to the parent element.
#'
#' @seealso
#'
#' For more information on forms and form groups please refer to the online
#' bootstrap [reference
#' page](https://v4-alpha.getbootstrap.com/components/forms/).
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
#'                 labels = c(
#'                   "Option one",
#'                   "Option two",
#'                   "Option three"
#'                 )
#'               )
#'             ),
#'             checkboxInput(
#'               id = "checkbox",
#'               title = "Checkbox",
#'               label = "Check me out"
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
#'         input$form
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

  tags$form(
    class = "dull-form-input",
    id = id,
    ...,
    tags$div(
      class = "form-group row",
      tags$div(
        class = "offset-sm-2 col-sm-10",
        submit()
      )
    ),
    bootstrap()
  )
}
