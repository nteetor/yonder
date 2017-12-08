#' Validate an input
#'
#' `validateEvent` is triggered by an input. A handler function may raise an
#' error, warning, or return. If an error is raised using the input is marked as
#' invalid and the reactive input value is frozen. While the value is invalid
#' and remains frozen it will not trigger observers or reactive expressions.
#'
#' @param trigger The input to trigger the validation handler. Unlike
#'   `observeEvent` this may not be an event and instead must be a single
#'   reactive input value.
#'
#' @param handler An expression or function, may contain reactive values.
#'
#' @param priority A numeric value specifying the priority of the validation.
#'   All validations are already highly prioritized, but this may be used
#'   to reorder validations.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       fluid = FALSE,
#'       textInput(
#'         id = "text",
#'         label = "Please enter some text"
#'       )
#'     ),
#'     server = function(input, output) {
#'       validateEvent(input$text, {
#'         if (input$text == "") {
#'           stop("this field is required")
#'         }
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       fluid = FALSE,
#'       div(
#'         h5("Where to?"),
#'         selectInput(
#'           id = "dropdown",
#'           options = c("(pick one)", "Home", "Work", "Store")
#'         ),
#'         h5("In what?"),
#'         radioInput(
#'           id = "npr",
#'           choices = c("Car", "Bus", "Bike")
#'         ),
#'         h5("Pickup pizza?"),
#'         checkboxInput(
#'           id = "pizza",
#'           choice = "Absolutely!"
#'         )
#'       ) %>%
#'        padding(4)
#'     ),
#'     server = function(input, output) {
#'       validateEvent(input$dropdown, {
#'         if (is.null(input$dropdown) || input$dropdown == "(pick one)") {
#'           stop("please select a choice")
#'         }
#'       })
#'
#'       validateEvent(input$npr, {
#'         if (is.null(input$npr)) {
#'           stop("field is required")
#'         }
#'       })
#'
#'       validateEvent(input$pizza, {
#'         if (is.null(input$pizza)) {
#'           stop("")
#'         }
#'       })
#'     }
#'   )
#' }
#'
validateEvent <- function(trigger, handler, priority = 0,
                          domain = getDefaultReactiveDomain(), initial = TRUE) {
  priority <- priority + 9999
  parent <- parent.frame()

  call <- as.list(substitute(trigger))

  if (length(call) == 3) {
    if (call[[2]] != "input") {
      stop(
        "currently, `validateEvent` argument `trigger` must be a single ",
        "input value, e.g. `input$fields`",
        call. = FALSE
      )
    }
  }

  i <- as.character(call[[3]])

  triggerFunc <- shiny::exprToFunction(trigger, parent, FALSE)
  triggerFunc <- wrapFunctionLabel(triggerFunc, "validateTrigger", ..stacktraceon = TRUE)

  handlerFunc <- shiny::exprToFunction(handler, parent, FALSE)
  handlerFunc <- wrapFunctionLabel(handlerFunc, "validateHandler", ..stacktraceon = TRUE)

  label <- sprintf(
    "validateEvent(%s)",
    paste(deparse(body(triggerFunc)), collapse = "\n")
  )

  initialized <- FALSE

  o <- observe({
    if (.subset2(domain$input, "impl")$isFrozen(i)) {
      .subset2(domain$input, "impl")$thaw(i)
    }

    e <- triggerFunc()

    if (!initial && !initialized) {
      initialized <<- TRUE
      return()
    }

    tryCatch({
      isolate(handlerFunc())
      domain$sendInputMessage(i, list(validate = TRUE))
    }, error = function(e) {
      .subset2(domain$input, "impl")$freeze(i)
      domain$sendInputMessage(i, list(invalidate = e$message %||% ""))
    })

  }, label = label, suspended = FALSE, priority = priority, domain = domain,
  autoDestroy = TRUE, ..stacktraceon = FALSE)

  invisible(o)
}
