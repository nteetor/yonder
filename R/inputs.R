textualInput <- function(id, label, value, placeholder, readonly, help, type,
                         ...) {
  tags$div(
    class = "dull-textual-input dull-input form-group row",
    id = id,
    tags$label(
      class = "col-sm-2 col-form-label",
      label
    ),
    tags$div(
      class = "col-sm-10",
      tags$input(
        class = "form-control",
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
      }
    ),
    ...
  )
}

#' Textual nputs
#'
#' Textual inputs.
#'
#' @param id A character string specifying the id of the textual input, defaults
#'   to `NULL`.
#'
#' @param label A character string specifying a label for the input, defaults to
#'   `NULL`.
#'
#' @param value A character string or a value coerced to a character string
#'   specifying the default value of the textual input.
#'
#' @param placeholder A character string specifying placeholder text for the
#'   input, defaults to `NULL`, in which case there is no placeholder text.
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
#'
#' }
#'
#'
textInput <- function(id, label, value = NULL, placeholder = NULL,
                      readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "text", ...)
}

#' @rdname textInput
#' @export
searchInput <- function(id, label, value = NULL, placeholder = NULL,
                        readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "search", ...)
}

#' @rdname textInput
#' @export
emailInput <- function(id, label, value = NULL, placeholder = NULL,
                       readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "email", ...)
}

#' @rdname textInput
#' @export
urlInput <- function(id, label, value = NULL, placeholder = NULL,
                     readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "url", ...)
}

#' @rdname textInput
#' @export
telephoneInput <- function(id, label, value = NULL, placeholder = NULL,
                           readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "tel", ...)
}

#' @rdname textInput
#' @export
passwordInput <- function(id, label, value = NULL, placeholder = NULL,
                          readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "password", ...)
}

#' @rdname textInput
#' @export
numberInput <- function(id, label, value = NULL, placeholder = NULL,
                        readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "number", ...)
}

# @rdname textInput
# @export
dateInput <- function(id, label, value = NULL, placeholder = NULL,
                      readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "date", ...)
}

# @rdname textInput
# @export
datetimeInput <- function(id, label, value = NULL, placeholder = NULL,
                          readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "datetime-local", ...)
}

# @rdname textInput
# @export
monthInput <- function(id, label, value = NULL, placeholder = NULL,
                       readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "month", ...)
}

# @rdname textInput
# @export
weekInput <- function(id, label, value = NULL, placeholder = NULL,
                      readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "week", ...)
}

# @rdname textInput
# @export
timeInput <- function(id, label, value = NULL, placeholder = NULL,
                      readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "time", ...)
}

#' @rdname textInput
#' @export
colorInput <- function(id, label, value = NULL, placeholder = NULL,
                       readonly = FALSE, help = NULL, ...) {
  textualInput(id, label, value, placeholder, readonly, help, "color", ...)
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
#' stub
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
      class = "form-group row",
      tags$legend(
        class = "col-form-legend col-sm-2",
        legend
      ),
      tags$div(
        class = "col-sm-10",
        inputs
      )
    ),
    attrs
  )
}

#' Login input
#'
#' Username
#'
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
#'     }
#'   )
#' }
loginInput <- function(id, ...) {
  ids <- ID(rep.int("login", 2))

  tags$div(
    class = "dull-login-input col",
    id = id,
    tags$div(
      class = "form-group",
      tags$label(
        class = "form-control-label",
        # `for` = ids[[1]],
        "Username"
      ),
      tags$input(
        type = "text",
        class = "form-control"
        # id = ids[[1]]
      )
    ),
    tags$div(
      class = "form-group",
      tags$label(
        class = "form-control-label",
        # `for` = ids[[2]],
        "Password"
      ),
      tags$input(
        type = "password",
        class = "form-control"
        # id = ids[[2]]
      )
    ),
    tags$div(
      class = "row justify-content-center",
      tags$div(
        class = "col col-auto",
        tags$button(
          class = "btn btn-primary",
          "Login"
        )
      )
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
#' @param placeholders If `TRUE`, placeholder text is added to all the address
#'   input fields, defaults to `TRUE`.
#'
#' @param abbreviate If `TRUE`, state abbreviations are used instead of state
#'   names, defaults to `TRUE`.
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
addressInput <- function(id, placeholders = TRUE, abbreviate = TRUE) {
  ids <- ID(rep.int("address", 5))

  tags$div(
    class = "dull-address-input",
    id = id,
    tags$div(
      class = "form-group",
      tags$label(
        `for` = ids[[1]],
        class = "col-form-label",
        "Address Line 1"
      ),
      tags$input(
        type = "text",
        class = "form-control",
        id = ids[[1]],
        placeholder = if (placeholders) "Street address"
      )
    ),
    tags$div(
      class = "form-group",
      tags$label(
        `for` = ids[[2]],
        class = "form-control-label",
        "Address Line 2"
      ),
      tags$input(
        type = "text",
        class = "form-control",
        id = ids[[2]],
        placeholder = if (placeholders) "Apartment or unit"
      )
    ),
    tags$div(
      class = "form-row",
      tags$div(
        class = "form-group col-md-6",
        tags$label(
          class = "form-control-label",
          `for` = ids[[3]],
          "City or town"
        ),
        tags$input(
          type = "text",
          class = "form-control",
          id = ids[[3]]
        )
      ),
      tags$div(
        class = "form-group col-md-4",
        tags$label(
          class = "form-control-label",
          `for` = ids[[4]],
          "State, province, or region"
        ),
        tags$input(
          type = "text",
          class = "form-control",
          id = ids[[4]]
        )
      ),
      tags$div(
        class = "form-group col-md-2",
        tags$label(
          class = "form-control-label",
          `for` = ids[[5]],
          "Zip or postal code"
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

#' Group inputs, combination button, dropdown, and text input
#'
#' A group input is a combination reactive input which may consist of one or two
#' buttons, dropdowns, static addons, or any combination of these elements.
#' Static addons, specified with `left` and `right` may be used to ensure an
#' group input's reactive value always has a certain prefix or suffix. These
#' static addons render with a shaded background to help indicated this behavior to the user.
#' Buttons and dropdowns may be included to control when the group input's
#' reactive value updates. See Details for more information.
#'
#' @param id A character string specifying the id of the group input.
#'
#' @param placeholder A character string specifying placeholder text for the
#'   input group, defaults to `NULL`.
#'
#' @param value A character string specifying an initial value for the input
#'   group, defaults to `NULL`.
#'
#' @param left,right A character vector specifying static addons or
#'   [buttonInput] or [dropdownInput] elements specifying dynamic addons.
#'   Addon's affect the reactive value of the group input, see the Details
#'   section below for more information.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   parent element.
#'
#' @details
#'
#' ** `left` is character or `right` is character **
#'
#' If `left` or `right` are character vectors, then the group input functions
#' like a text input. The value will update and trigger a reactive event when
#' the text box is modified. The group input's reactive value is the
#' concatention of the static addons specified by `left` or `right` and the
#' value of the text input.
#'
#' ** `left` is button or `right` is button **
#'
#' The button does not change the value of the group input. However, the input
#' no longer triggers event when the text box is updated. Instead the value
#' is updated when a button is clicked. Static addons are still applied to the
#' group input value.
#'
#' ** `left` is a dropdown or `right` is a dropdown **
#'
#' The value of the group input does chance depending on the clicked dropdown
#' menu item. The value of the input group is the concatentation of the
#' dropdown input value, the value of the text input, and any static addons.
#'
#' @family inputs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           groupInput(
#'             id = "buttongroup",
#'             left = "@",
#'             placeholder = "Username"
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
#'       output$value <- renderText({
#'         input$buttongroup
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
#'           groupInput(
#'             id = "groupinput",
#'             placeholder = "Search terms",
#'             right = buttonInput(
#'               id = "button",
#'               label = "Go!"
#'             )
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
#'       output$value <- renderText({
#'         input$groupinput
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
#'           groupInput(
#'             id = "groupinput",
#'             left = c("$", "0.00")
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
#'       output$value <- renderText({
#'         input$groupinput
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
#'           groupInput(
#'             id = "groupinput",
#'             left = "@",
#'             placeholder = "Username",
#'             right = buttonInput(
#'               id = "right",
#'               label = "Search"
#'             )
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
#'       output$value <- renderText({
#'         input$groupinput
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
#'           groupInput(
#'             id = "groupinput",
#'             left = dropdownInput(
#'               id = "dropdown",
#'               label = "Title",
#'               choices = c("Mrs.", "Miss", "Mr.", "none"),
#'               values = c("Mrs. ", "Miss ", "Mr. ", "")
#'             ),
#'             placeholder = "First name",
#'             right = "!"
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
#'       output$value <- renderText({
#'         input$groupinput
#'       })
#'     }
#'   )
#' }
#'
groupInput <- function(id, placeholder = NULL, value = NULL, left = NULL,
                       right = NULL, ...) {
  if (!is.null(left) && !is.character(left) && !tagIs(left, "button") &&
      !tagHasClass(left, "dull-dropdown-input")) {
    stop(
      "invalid `groupInput` argument, `left` must be a character string, ",
      "buttonInput(), or dropdownInput()",
      call. = FALSE
    )
  }

  if (!is.null(right) && !is.character(right) && !tagIs(right, "button") &&
      !tagHasClass(right, "dull-dropdown-input")) {
    stop(
      "invalid `groupInput` argument, `right` must be a character string, ",
      "buttonInput(), or dropdownInput()",
      call. = FALSE
    )
  }

  tags$div(
    class = "dull-group-input input-group",
    id = id,
    if (!is.null(left)) {
      if (is.character(left)) {
        lapply(left, function(l) tags$span(class = "input-group-addon left-addon", l))
      } else {
        tags$span(
          class = "input-group-btn left-group",
          left
        )
      }
    },
    ...,
    tags$input(
      type = "text",
      class = "form-control",
      placeholder = placeholder,
      value = value
    ),
    if (!is.null(right)) {
      if (is.character(right)) {
        lapply(right, function(r) tags$span(class = "input-group-addon right-addon", r))
      } else {
        tags$span(
          class = "input-group-btn right-group",
          right
        )
      }
    }
  )
}
