textualInput <- function(id, value, placeholder, readonly, help, type,
                         size = NULL, ...) {
  if (!is.null(size)) {
    size <- switch(size, small = "sm", large = "lg")
  }

  tags$div(
    class = "dull-textual-input",
    id = id,
    tags$input(
      class = collate(
        "form-control",
        if (!is.null(size)) paste0("form-control-", size)
      ),
      type = type,
      value = value,
      placeholder = placeholder,
      readonly = if (readonly) NA
    ),
    if (!is.null(help)) {
      tags$small(
        class = "form-text text-muted",
        help
      )
    },
    tags$div(class = "invalid-feedback"),
    ...
  )
}

#' Textual inputs
#'
#' Textual inputs.
#'
#' @param id A character string specifying the id of the textual input, defaults
#'   to `NULL`.
#'
#' @param value A character string or a value coerced to a character string
#'   specifying the default value of the textual input.
#'
#' @param placeholder A character string specifying placeholder text for the
#'   input, defaults to `NULL`, in which case there is no placeholder text.
#'
#' @param size One of `"small"` or `"large"` specifying the size transformation
#'   of the input, defaults to `NULL`, in which case the input's size is
#'   unchanged.
#'
#' @param readonly If `TRUE`, the textual input is read-only preventing
#'   modification of the value, defaults `FALSE`.
#'
#' @param help A character string specifying the help text of the textual input,
#'   defaults to `NULL`, in which case no help text is added.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @family inputs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           p("For best results open in a browser") %>%
#'             font(weight = "bold")
#'         )
#'       ),
#'       row(
#'         col(
#'           h6("Text input:"),
#'           textInput(id = "text"),
#'           h6("Search input:"),
#'           searchInput(id = "search"),
#'           h6("Email input:"),
#'           emailInput(id = "email"),
#'           h6("URL input:"),
#'           urlInput(id = "url"),
#'           h6("Telephone input:"),
#'           telephoneInput(id = "tel"),
#'           h6("Password input:"),
#'           passwordInput(id = "pass"),
#'           h6("Number input:"),
#'           numberInput(id = "num") %>%
#'             background("green")
#'         ),
#'         col(
#'           verbatimTextOutput("values")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$values <- renderPrint({
#'         list(
#'           text = input$text, search = input$search, email = input$email,
#'           url = input$url, telephone = input$tel, password = input$pass,
#'           number = input$num
#'          )
#'       })
#'     }
#'   )
#' }
#'
#'
textInput <- function(id, value = NULL, placeholder = NULL, size = NULL,
                      readonly = FALSE, help = NULL, ...) {
  textualInput(id, value, placeholder, readonly, help, "text", size = size, ...)
}

#' @rdname textInput
#' @export
searchInput <- function(id, value = NULL, placeholder = NULL, size = NULL,
                        readonly = FALSE, help = NULL, ...) {
  textualInput(id, value, placeholder, readonly, help, "search", size = size, ...)
}

#' @rdname textInput
#' @export
emailInput <- function(id, value = NULL, placeholder = NULL, size = NULL,
                       readonly = FALSE, help = NULL, ...) {
  textualInput(id, value, placeholder, readonly, help, "email", size = size, ...)
}

#' @rdname textInput
#' @export
urlInput <- function(id, value = NULL, placeholder = NULL, size = NULL,
                     readonly = FALSE, help = NULL, ...) {
  textualInput(id, value, placeholder, readonly, help, "url", size = size, ...)
}

#' @rdname textInput
#' @export
telephoneInput <- function(id, value = NULL, placeholder = NULL, size = NULL,
                           readonly = FALSE, help = NULL, ...) {
  textualInput(id, value, placeholder, readonly, help, "tel", size = size, ...)
}

#' @rdname textInput
#' @export
passwordInput <- function(id, value = NULL, placeholder = NULL, size = NULL,
                          readonly = FALSE, help = NULL, ...) {
  textualInput(id, value, placeholder, readonly, help, "password", size = size, ...)
}

#' @rdname textInput
#' @export
numberInput <- function(id, value = NULL, placeholder = NULL, size = NULL,
                        readonly = FALSE, help = NULL, ...) {
  textualInput(id, value, placeholder, readonly, help, "number", size = size, ...)
}

#' @rdname textInput
#' @export
colorInput <- function(id, value = NULL, placeholder = NULL, size = NULL,
                       readonly = FALSE, help = NULL, ...) {
  textualInput(id, value, placeholder, readonly, help, "color", size = size, ...)
}

#' Group and label multiple inputs
#'
#' Use `fieldset` to associate and label inputs. Good for screen readers and
#' other assitive technologies.
#'
#' @param legend A character string specifying the fieldset's legend.
#'
#' @param ... Any number of inputs to group or named arguments passed as HTML
#'   attributes to the parent element.
#'
#' @export
#' @examples
#'
fieldset <- function(legend, ...) {
  if (!is.character(legend)) {
    stop(
      "invalid `fieldset` argument, `legend` must be a character string",
      call. = FALSE
    )
  }

  args <- list(...)
  attrs <- attribs(args)
  inputs <- elements(args)

  tagConcatAttributes(
    tags$fieldset(
      class = "form-group",
      tags$legend(
        class = "col-form-legend",
        legend
      ),
      tags$div(
        inputs
      )
    ),
    attrs
  )
}

#' Login input
#'
#' A complex input which consists of a username field and a password field.
#'
#' @param id A character string specifying the HTML id of the login input.
#'
#' @param ... Additional named arguments passed as HTML attibutes to the login
#'   input.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           loginInput(
#'             id = "login"
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("value")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderPrint({
#'         input$login
#'       })
#'
#'     }
#'   )
#' }
#'
loginInput <- function(id, ...) {
  ids <- ID(rep.int("login", 2))

  tags$div(
    class = "dull-login-input col",
    id = id,
    tags$div(
      class = "form-group",
      tags$label(
        class = "form-control-label",
        `for` = ids[[1]],
        "Username"
      ),
      tags$input(
        id = ids[[1]],
        type = "text",
        class = "form-control"
      )
    ),
    tags$div(
      class = "form-group",
      tags$label(
        class = "form-control-label",
        `for` = ids[[2]],
        "Password"
      ),
      tags$input(
        id = ids[[1]],
        type = "password",
        class = "form-control"
      )
    ),
    tags$button(
      class = "btn btn-primary",
      "Login"
    ),
    ...
  )
}

#' Address input
#'
#' An address input which includes a street field, apartment or unit field, city
#' field, state field, and a zip code field.
#'
#' @param id A character string specifying the id of the address input.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           tags$form(
#'             addressInput("address")
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("value")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderPrint({
#'         input$address
#'       })
#'     }
#'   )
#' }
#'
addressInput <- function(id) {
  ids <- ID(rep.int("address", 5))

  tags$div(
    class = "dull-address-input",
    id = id,
    tags$div(
      class = "form-group",
      tags$label(
        `for` = ids[[1]],
        class = "col-form-label",
        "Address"
      ),
      tags$input(
        type = "text",
        class = "form-control",
        id = ids[[1]],
        placeholder = "Street address, P.O. box"
      )
    ),
    tags$div(
      class = "form-group",
      tags$label(
        `for` = ids[[2]],
        class = "form-control-label sr-only",
        "Address line 2"
      ),
      tags$input(
        type = "text",
        class = "form-control",
        id = ids[[2]],
        placeholder = "Apartment, floor, unit"
      )
    ),
    tags$div(
      class = "form-row",
      tags$div(
        class = "form-group col-md-6 mt-auto",
        tags$label(
          class = "form-control-label",
          `for` = ids[[3]],
          "City"
        ),
        tags$input(
          type = "text",
          class = "form-control",
          id = ids[[3]]
        )
      ),
      tags$div(
        class = "form-group col-md-3",
        tags$label(
          class = "form-control-label",
          `for` = ids[[4]],
          "State"
        ),
        tags$input(
          type = "text",
          class = "form-control",
          id = ids[[4]]
        )
      ),
      tags$div(
        class = "form-group col-md-3 mt-auto",
        tags$label(
          class = "form-control-label",
          `for` = ids[[5]],
          "Zip"
        ),
        tags$input(
          type = "text",
          class = "form-control",
          id = ids[[5]]
        )
      )
    )
  )
}
