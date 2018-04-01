#' Static and actionable alerts
#'
#' Use `showAlert` to let the user know of successes or to call attention to
#' problems. While alerts are static by default they can also be made
#' actionable. Actionable alerts can be used for undoing or redoing an action
#' and more.
#'
#' @param text A character string specifying the message text of the alert.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   alert element.
#'
#' @param duration A positive integer or `NULL` specifying the duration of the
#'   alert, by default the alert is removed after 4 seconds. If `NULL` the
#'   alert is not automatically removed.
#'
#' @param color A character string specifying the color of the alert,
#'   for possible colors see [background].
#'
#' @param action A character string specifying a reactive id. If specified a
#'   button is added to the alert. If clicked the reactive value
#'   `input[[action]]` is set to `TRUE`. When the alert is removed
#'   `input[[action]]` is reset to `NULL`.
#'
#'
#' @seealso
#'
#' Boostrap 4 alert documentation:
#' \url{https://getbootstrap.com/docs/4.0/components/alerts/}
#'
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       buttonInput("show", "Alert!") %>%
#'         margins(3)
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$show, {
#'         color <- sample(c("teal", "red", "orange", "blue"), 1)
#'         showAlert("Alert", color = color)
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
#'             id = "text",
#'             right = buttonInput("clear", fontAwesome("times")) %>%
#'               background("red", -1)
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("value")
#'         )
#'       ) %>%
#'         margins(3)
#'     ),
#'     server = function(input, output) {
#'       oldValue <- NULL
#'
#'       output$value <- renderPrint(input$text)
#'
#'       observeEvent(input$clear, {
#'         oldValue <<- input$text
#'         updateValues("text", "")
#'         showAlert("Undo clear.", color = "yellow", action = "undo")
#'       })
#'
#'       observeEvent(input$undo, {
#'         updateValues("text", oldValue)
#'       })
#'     }
#'   )
#' }
#'
showAlert <- function(text, ..., duration = 4, color = NULL, action = NULL) {
  domain <- getDefaultReactiveDomain()

  if (is.null(domain)) {
    stop(
      "function `showAlert()` must be called in a reactive context",
      call. = FALSE
    )
  }

  if (!is.null(color) && !(color %in% .colors)) {
    stop(
      "invalid `showAlert()` argument, unrecognized `color` , see ?background ",
      "for possible values",
      call. = FALSE
    )
  }

  text <- as.character(text)

  if (length(text) != 1) {
    stop(
      "invalid `showAlert()` argument, expecting `text` to be a character ",
      "string",
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

  args <- list(...)
  attrs <- attribs(args)

  domain$sendInputMessage("alert-container", list(
    type = "show",
    data = list(
      text = text,
      duration = if (!is.null(duration)) duration * 1000,
      color = color,
      action = action,
      attrs = if (length(attrs)) attrs
    )
  ))
}

#' @rdname showAlert
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       buttonInput("add", "Alert") %>%
#'         margins(3),
#'       buttonInput("first", "Remove first alert"),
#'       buttonInput(
#'         id = "reds",
#'         label = "Remove red alerts",
#'         alt = "the red ones offend the aesthetic"
#'       ),
#'       buttonInput("alert", "Remove 'Alert' alerts")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$add, {
#'         color <- sample(c("grey", "teal", "purple", "yellow", "red"), 1)
#'         showAlert("Alert", duration = NULL, color = color)
#'       })
#'
#'       observeEvent(input$first, {
#'         closeAlert(1)
#'       })
#'
#'       observeEvent(input$reds, {
#'         closeAlert(class = "alert-red")
#'       })
#'
#'       observeEvent(input$alert, {
#'         closeAlert("Alert")
#'       })
#'     }
#'   )
#' }
#'
#' # this is a variation of the second example
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           groupInput(
#'             id = "text",
#'             right = buttonInput("clear", fontAwesome("times")) %>%
#'               background("red", -1)
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("value")
#'         )
#'       ) %>%
#'         margins(3)
#'     ),
#'     server = function(input, output) {
#'       oldValue <- NULL
#'
#'       output$value <- renderPrint(input$text)
#'
#'       observeEvent(input$clear, {
#'         oldValue <<- input$text
#'         updateValues("text", "")
#'         showAlert(
#'           text = "Undo clear.",
#'           color = "yellow",
#'           action = "undo",
#'           duration = NULL
#'         )
#'       })
#'
#'       observeEvent(input$undo, {
#'         updateValues("text", oldValue)
#'         closeAlert(1)
#'       })
#'     }
#'   )
#' }
#'
closeAlert <- function(...) {
  domain <- getDefaultReactiveDomain()

  if (is.null(domain)) {
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

  domain$sendInputMessage("alert-container", list(
    type = "close",
    data = list(
      text = elems[vapply(elems, is.character, logical(1))],
      index = indeces,
      attrs = attrs
    )
  ))
}
