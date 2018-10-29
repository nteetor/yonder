#' Static and actionable alerts
#'
#' Use `showAlert` to let the user know of successes or to call attention to
#' problems. While alerts are static by default they can also be made
#' actionable. Actionable alerts can be used for undoing or redoing an action
#' and more.
#'
#' @param ... Character strings specifying the text of the alert or additional
#'   named arguments passed as HTML attributes to the alert element.
#'
#' @param title A character string or tag element specifying a heading for the
#'  alert, defaults to `NULL`, in which case a title is not added.
#'
#' @param alert An alert tag element, typically a call to `alert()`.
#'
#' @param duration A positive integer or `NULL` specifying the duration of the
#'   alert, by default the alert is removed after 4 seconds. If `NULL` the
#'   alert is not automatically removed.
#'
#' @param action A character string specifying a reactive id. If specified a
#'   button is added to the alert. When this button is clicked a reactive value
#'   is triggered, `input[[action]]` is set to `TRUE`. When the alert is removed
#'   `input[[action]]` is reset to `NULL`.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @section Displaying an alert:
#'
#' ```R
#' ui <- container(
#'   buttonInput("show", "Alert!") %>%
#'     margin(3)
#' )
#'
#' server <- function(input, output) {
#'   observeEvent(input$show, {
#'     color <- sample(c("teal", "red", "orange", "blue"), 1)
#'
#'     showAlert(
#'       alert("Alert") %>% background(color)
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @section Reacting to alerts:
#'
#' ```R
#' ui <- container(
#'   row(
#'     column(
#'       groupInput(
#'         id = "text",
#'         right = buttonInput("clear", icon("times")) %>%
#'           background("red")
#'       )
#'     ),
#'     column(
#'       verbatimTextOutput("value")
#'     )
#'   ) %>%
#'     margin(3)
#' )
#'
#' server <- function(input, output) {
#'   oldValue <- NULL
#'
#'   output$value <- renderPrint(input$text)
#'
#'   observeEvent(input$clear, ignoreInit = TRUE, {
#'     oldValue <<- input$text
#'     updateValues("text", "")
#'
#'     showAlert(
#'       alert("Undo clear.") %>%
#'         background("yellow"),
#'       action = "undo"
#'     )
#'   })
#'
#'   observeEvent(input$undo, {
#'     updateValues("text", oldValue)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @section Removing alerts:
#'
#' ```R
#' ui <- container(
#'   buttonInput("add", "Alert") %>%
#'     margin(3),
#'   buttonInput("first", "Remove first alert"),
#'   buttonInput(
#'     id = "reds",
#'     label = "Remove red alerts",
#'     alt = "the red ones offend the aesthetic"
#'   ),
#'   buttonInput("alert", "Remove 'Alert' alerts")
#' )
#'
#' server <- function(input, output) {
#'   observeEvent(input$add, {
#'     color <- sample(c("teal", "purple", "yellow", "red"), 1)
#'     showAlert(
#'       alert("Alert") %>%
#'         background(color),
#'       duration = NULL
#'     )
#'   })
#'
#'   observeEvent(input$first, {
#'     closeAlert(1)
#'   })
#'
#'   observeEvent(input$reds, {
#'     closeAlert(class = "alert-red")
#'   })
#'
#'   observeEvent(input$alert, {
#'     closeAlert("Alert")
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family content
#' @export
#' @examples
#'
#' ### Default alert
#'
#' alert("Donec at pede.")
#'
#' ### Adding more
#'
#' alert(
#'   p("Etiam vel tortor sodales"),
#'   hr(),
#'   p("Fusce commodo.") %>%
#'     margin(bottom = 0)
#' ) %>%
#'   background("amber")
#'
alert <- function(..., title = NULL) {
  title <- if (!is.null(title) && !is_tag(title)) {
    tags$h4(class = "alert-heading", title)
  } else {
    title
  }

  tags$div(
    class = "alert alert-grey fade show",
    role = "alert",
    title,
    ...
  )
}

#' @rdname alert
#' @export
showAlert <- function(alert, duration = 4, action = NULL,
                      session = getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop(
      "function `showAlert()` must be called in a reactive context",
      call. = FALSE
    )
  }

  if (!is.null(duration)) {
    if (!is.numeric(duration) || duration <= 0) {
      stop(
        "invalid `showAlert()` argument, expecting `duration` to be a positive ",
        "integer or NULL",
        call. = FALSE
      )
    }
  }

  session$sendInputMessage("alert-container", list(
    type = "show",
    data = list(
      content = HTML(as.character(alert)),
      duration = if (!is.null(duration)) duration * 1000,
      action = action
    )
  ))
}

#' @rdname alert
#' @export
closeAlert <- function(..., session = getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop(
      "function `closeAlert()` must be called in a reactive context",
      call. = FALSE
    )
  }

  args <- dots_list(...)
  elems <- elements(args)
  attrs <- attribs(args)

  indeces <- elems[vapply(elems, is.numeric, logical(1))]

  if (length(indeces)) {
    if (any(unlist(indeces) %% 1 != 0)) {
      stop(
        "invalid `closeAlert()` argument, indeces must be whole numbers",
        call. = FALSE
      )
    }

    indeces <- lapply(indeces, `-`, 1)
  }

  if (!is.null(attrs[["class"]]) && length(attrs[["class"]]) > 1) {
    attrs[["class"]] <- paste(attrs[["class"]], collapse = " ")
  }

  session$sendInputMessage("alert-container", list(
    type = "close",
    data = list(
      text = elems[vapply(elems, is.character, logical(1))],
      index = indeces,
      attrs = attrs
    )
  ))
}
