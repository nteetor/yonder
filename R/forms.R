#' Forms
#'
#' @description
#'
#' Forms are a new reactive input. A form's reactive value is a list of all the
#' reactive inputs within it. Reactive form groups, when `id` is specified,
#' within a form cause the form's value to take on a nested structure. See
#' details for more information.
#'
#' `formGroup` helps visually organization and structure a form. On the
#' server side, a `formGroup` with an `id` argument becomes a reactive list
#' value comprised of its underlying reactive inputs.
#'
#' @param id A character string specifying an id for the form or form group,
#'   defaults to `NULL`. If specified a form or form group becomes a reactive
#'   input. A reactive form group will modify its parent form's input.
#'
#'   For `updateFormGroup`, a character string specifying the id of a form
#'   group to update.
#'
#' @param inline If `TRUE`, the form is rendered inline, inline forms are handy
#'   for rendering small, compact forms, defaults to `FALSE`.
#'
#' @param state One of `"success"`, `"warning"`, or `"danger"`, specifying the
#'   state of the form group, defaults to `NULL` in `formGroup`, is required
#'   for `updateFormGroup`.
#'
#' @param fieldset If `TRUE`, the form group is rendered inside a `<fieldset>`
#'   instead of a `<div>`, defaults to `FALSE`. When building a form group
#'   multiple inputs it is recommended to set `fieldset` to `TRUE` so that
#'   `label` properly renders as a `<legend>`.
#'
#' @param label A character vector specifying a label for the form group, if
#'   `fieldset` is `TRUE`, the label is rendered inside a `<legend>` element
#'   instead of a `<label>` element, defaults to `NULL`.
#'
#' @param ... Input elements, labels, or other tag elements or named arguments
#'   passed as HTML attributes to the parent element.
#'
#' @param session The `session` object passed to a shiny server function,
#'   defaults to [shiny::getDefaultReactiveDomain()].
#'
#' @details
#'
#' ** The value of a form **
#'
#' Below is a small sample form,
#'
#' ```
#' form(
#'   id = "register",
#'   formGroup(
#'     id = "names",
#'     textInput(
#'       id = "first",
#'       label = "First name"
#'     ),
#'     textInput(
#'       id = "last",
#'       label = "Last name"
#'     )
#'   )
#' )
#' ```
#'
#' The initial value of this form, as would be printed from a shiny server
#' function.
#'
#' ```
#' input
#' input$register
#' input$register$names
#' input$register$names$first
#' NULL
#'
#' input$register$names$last
#' NULL
#' ```
#'
#' Here is a longer form based on the one above,
#'
#' ```
#' form(
#'   id = "register",
#'   formGroup(
#'     id = "names",
#'     textInput(
#'       id = "first",
#'       label = "First name"
#'     ),
#'     textInput(
#'       id = "last",
#'       label = "Last name"
#'     )
#'   ),
#'   formGroup(
#'     id = "contact",
#'     telephoneInput(
#'       id = "mobile",
#'       label = "Cell phone"
#'     ),
#'     telephoneInput(
#'       id = "home",
#'       label = "Home phone"
#'     )
#'   )
#' )
#' ```
#'
#' Below is the initial value of this larger form,
#'
#' ```
#' input
#' input$register
#' input$register$names
#' input$register$names$first
#' NULL
#'
#' input$register$names$last
#' NULL
#'
#' input$register$contact
#' input$register$contact$mobile
#' NULL
#'
#' input$register$contact$home
#' NULL
#' ```
#'
#' ** Inputs within a form **
#'
#' Any reactive inputs within a **reactive** form, a form with an `id`, will not
#' trigger an obesrver or reactive expression nor do they take a value other
#' than `NULL`.
#'
#' @seealso
#'
#' For more information on forms and form groups please refer to the online
#' bootstrap
#' [reference page](https://v4-alpha.getbootstrap.com/components/forms/).
#'
#' @family forms
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       form(
#'         id = "user",
#'         submit = TRUE,
#'         formGroup(
#'           id = "names",
#'           label = "Form group",
#'           textInput(id = "first", placeholder = "first name"),
#'           textInput(id = "last", placeholder = "last name")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         print(input$user)
#'       })
#'
#'       # Note the observer triggers on application startup,
#'       # value is NULL, and then does not trigger again.
#'       observe({
#'         print(input$first)
#'       })
#'     }
#'   )
#' }
#'
form <- function(..., inline = FALSE) {
  tags$form(
    class = collate(
      "dull-form",
      if (inline) "form-inline"
    ),
    ...,
    bootstrap()
  )
}

#' @rdname form
#' @export
formGroup <- function(..., state = NULL, fieldset = FALSE, legend = NULL) {
  if (!is.null(state) && !(state %in% c("success", "warning", "danger"))) {
    stop(
      'invalid `formGroup` argument, `state` must be one of "success", ',
      '"warning", or "danger"',
      call. = FALSE
    )
  }

  if (!fieldset && !is.null(legend)) {
    warning(
      "if `formGroup` argument `fieldset` is FALSE, `legend` has no effect",
      call. = FALSE
    )
  }

  (if (fieldset) tags$fieldset else tags$div)(
    class = collate(
      "dull-form-group",
      "form-group",
      if (!is.null(state)) paste0("has-", state)
    ),
    if (fieldset && !is.null(legend)) {
      tags$legend(class = "col-form-legend", legend)
    },
    ...,
    bootstrap()
  )
}

#' @rdname form
#' @export
updateFormGroup <- function(id, state, session = getDefaultReactiveDomain()) {
  if (!(state %in% c("success", "warning", "danger"))) {
    stop(
      'invalid `updateFormGroup` argument, `state` must be one of "success", ',
      '"warning", or "danger"',
      call. = FALSE
    )
  }

  session$sendInputMessage(
    id,
    list(
      state = if (!is.null(state)) paste0("has-", state)
    )
  )
}
