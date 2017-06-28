#' Forms
#'
#' @description
#'
#' A reactive `forms$form` is a new reactive input. A form's reactive value is a
#' list of all the reactive inputs within it. Reactive form groups within a
#' form, those form groups *which have an ID*, cause the form's value to take on
#' a nested structure. See details for more information.
#'
#' `forms$inline` is an inline equivalent of `forms$form`. Inline forms are
#' handy for rendering small, compact forms.
#'
#' `forms$group` helps visually organization and structure a form. On the
#' server side, a `forms$group` with an `id` argument becomes a reactive list
#' value comprised of its underlying reactive inputs.
#'
#' @usage
#'
#' forms$form(...)
#'
#' forms$inline(...)
#'
#' forms$group(..., state = NULL, fieldset = FALSE, label = NULL)
#'
#' @param state One of `"success"`, `"warning"`, or `"danger"`, specifying the
#'   state of the form group, defaults to `NULL` in `forms$group`, is required
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
#' @param ... Named arguments passed as HTML attributes to the parent element.
#'
#' **`forms$group`**, argument is any number of form inputs, labels, form
#' text.
#'
#' **`forms$form`** and **`forms$inline`**, any number of inputs, form
#' groups, labels, or other elements to include in the form.
#'
#' @param id A character string specifying the HTML id of a button to update.
#'
#' @param session A `ShinySession` object, defaults to the default reactive
#'   domain, see [getDefaultReactiveDomain].
#'
#' @details
#'
#' **The value of a form**
#'
#' Below is a small sample form,
#'
#' ```
#' forms$form(
#'   id = "register",
#'   forms$group(
#'     id = "names",
#'     inputs$text(
#'       id = "first",
#'       label = "First name"
#'     ),
#'     inputs$text(
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
#' forms$form(
#'   id = "register",
#'   forms$group(
#'     id = "names",
#'     inputs$text(
#'       id = "first",
#'       label = "First name"
#'     ),
#'     inputs$text(
#'       id = "last",
#'       label = "Last name"
#'     )
#'   ),
#'   forms$group(
#'     id = "contact",
#'     inputs$telephone(
#'       id = "mobile",
#'       label = "Cell phone"
#'     ),
#'     inputs$telephone(
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
#' @aliases form inline
#' @format NULL
#' @name forms
#' @export
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       forms$form(
#'         id = "user",
#'         submit = TRUE,
#'         forms$group(
#'           id = "names",
#'           label = "Form group",
#'           inputs$text(id = "first", placeholder = "first name"),
#'           inputs$text(id = "last", placeholder = "last name")
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
#'         print(inputs$first)
#'       })
#'     }
#'   )
#' }
#'
forms <- list()

forms$form <- function(..., submit = TRUE) {
  tags$form(
    class = "dull-form",
    ...,
    bootstrap()
  )
}

forms$inline <- function(...) {
  # note this is `forms$form`, not `tags$form`
  forms$form(
    class = "form-inline",
    ...
  )
}

forms$group <- function(..., state = NULL, fieldset = FALSE, legend = NULL) {
  if (!is.null(state) && !(state %in% c("success", "warning", "danger"))) {
    stop(
      'invalid `forms$group` argument, `state` must be one of "success", ',
      '"warning", or "danger"',
      call. = FALSE
    )
  }

  if (!fieldset && !is.null(legend)) {
    warning(
      "if `forms$group` argument `fieldset` is FALSE, `legend` has no effect",
      call. = FALSE
    )
  }

  (if (fieldset) tags$fieldset else tags$div)(
    class = collate(
      "dull-form-group form-group",
      if (!is.null(state)) paste0("has-", state)
    ),
    if (fieldset && !is.null(legend)) {
      tags$legend(class = "col-form-legend", legend)
    },
    ...,
    bootstrap()
  )
}

#' @rdname forms
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


