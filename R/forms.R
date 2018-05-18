#' Form inputs
#'
#' @description
#'
#' Form inputs are a new reactive input. Form inputs are an alternative to
#' shiny's submit buttons. A form input is comprised of any number of
#' inputs. The value of these inputs will not change until the form input's
#' submit button is clicked. A form input has no value.
#'
#' **Important** if `id` or `submit` are `NULL` the form input will not freeze
#' its child inputs. This can be useful if you want to use a `formInput()`
#' solely for page layout.
#'
#' @param id A character string specifying an id for the form input.
#'
#' @param ... Any number of inputs, tags, or additional named arguments passed
#'   as HTML attributes to the parent element.
#'
#' @param submit A submit button or tags containing a submit button. The submit
#'   button will trigger the update of input form elements. Defaults to
#'   [submitInput()].
#'
#' @param inline One of `TRUE` or `FALSE`, if `TRUE` the form and its child
#'   elements are rendered in a horizontal row, defaults to `FALSE`. On small
#'   viewports, think mobile device, `inline` has no effect and the form will
#'   span multiple lines.
#'
#' @details
#'
#' When `inline` is `TRUE` you may want to adjust the right margin of each child
#' element for viewports larger than mobile, `margin(<TAG>, right = c(sm = 2))`,
#' more information at [margin()]. You only need to apply extra space for larger
#' viewports because inline forms do not take effect on small viewports.
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
#'             tags$label("Email"),
#'             emailInput(
#'               id = "email",
#'               placeholder = "Email"
#'             ),
#'             tags$label("Password"),
#'             passwordInput(
#'               id = "password",
#'               placeholder = "Password"
#'             ),
#'             tags$label("Radio"),
#'             radioInput(
#'               id = "options",
#'               choices = c(
#'                 "Option one",
#'                 "Option two",
#'                 "Option three"
#'               )
#'             ),
#'             tags$label("Checkbox"),
#'             checkboxInput(
#'               id = "checkbox",
#'               choice = "Simple checkbox"
#'             ) %>%
#'               margin(bottom = 2)
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
#'           h5("A form input"),
#'           p("Elements are non-reactive"),
#'           formInput(
#'             id = "myform",
#'             textInput(id = "text"),
#'             rangeInput(id = "range")
#'           ) %>%
#'             border("grey", -1) %>%
#'             padding(3) %>%
#'             margin(bottom = 3),
#'           h5("This input is unaffected"),
#'           textInput(id = "standalone")
#'         ),
#'         col(
#'           h5("Form elements values:"),
#'           verbatimTextOutput("elements") %>%
#'             padding(c(0, 0, 3, 0)),
#'           h5("Unaffected text input value:"),
#'           textOutput("unaffected")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$elements <- renderPrint(list(
#'         text = input$text,
#'         range = input$range
#'       ))
#'
#'       output$unaffected <- renderPrint(input$standalone)
#'     }
#'   )
#' }
#'
formInput <- function(id, ..., submit = submitInput(), inline = FALSE) {
  tags$form(
    class = collate(
      "dull-form-input",
      if (inline) "form-inline"
    ),
    id = id,
    ...,
    submit,
    include("core")
  )
}

#' Add labels, help text, and formatting to inputs
#'
#' Form groups are a way of labelling an input. Form rows are similar to
#' [row()]s, but include additional styles intended for forms. The flexibility
#' provided by form rows and groups means you can confidently develop shiny
#' applications for devices and screens of varying sizes.
#'
#' @param label A character string specifying a label for the input or `NULL`
#'   in which case a label is not added.
#'
#' @param input A tag element specifying the input to label.
#'
#' @param help A character string specifying help text for the input, defaults
#'   to `NULL`, in which case help text is not added.
#'
#' @param ... For **formGroup**, additional named arguments passed as HTML
#'   attributes to the parent element.
#'
#'   For **formRow**, any number of `formGroup`s or additional named arguments
#'   passed as HTML attributes to the parent element.
#'
#' @param default,sm,md,lg,xl These arguments are taken directly from [col()]
#'   because `formGroup`s can replicate column behaviour in order to build
#'   highly flexible forms. To best understand these arguments please refer to
#'   the `col` help page.
#'
#' @export
#' @examples
#'
#' # to see this example in action adjust your browser window
#' # from large to small, notice how the form elements expand?
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           md = 6,
#'           card(
#'             formRow(
#'               formGroup(
#'                 md = 6,
#'                 label = "Email",
#'                 emailInput(
#'                   id = "email",
#'                   placeholder = "e@@mail.com"
#'                 )
#'               ),
#'               formGroup(
#'                 md = 6,
#'                 label = "Password",
#'                 passwordInput(
#'                   id = "password",
#'                   placeholder = "123456"
#'                 ),
#'                 help = "Please consider something
#'                   better than 123456"
#'               )
#'             ),
#'             formGroup(
#'               label = "Username",
#'               groupInput(
#'                 id = "username",
#'                 left = "@@"
#'               )
#'             ),
#'             buttonInput(
#'               id = "go",
#'               label = "Go!"
#'             ) %>%
#'               background("blue")
#'           ) %>%
#'             margin(3) %>%
#'             background("grey", +2)
#'         ) %>%
#'           margin("auto")
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
formGroup <- function(label, input, help = NULL,..., default = NULL, sm = NULL,
                      md = NULL, lg = NULL, xl = NULL) {
  if (!is_tag(input)) {
    stop(
      "invalid `formGroup()` argument, expecting `input` to be a tag element",
      call. = FALSE
    )
  }

  build <- col(default = default, sm = sm, md = md, lg = lg, xl = xl)

  extra <- if (build$attribs$class != "col") {
    sub("^col\\s+", "", build$attribs$class)
  }

  tags$div(
    class = collate(
      "form-group",
      extra
    ),
    label,
    input,
    if (!is.null(help)) {
      tags$small(
        class = "form-text text-muted",
        help
      )
    },
    include("core")
  )
}

#' @rdname formGroup
#' @export
formRow <- function(...) {
  tags$div(
    class = "form-row",
    ...,
    include("core")
  )
}
