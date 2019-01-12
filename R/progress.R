#' Progress bars
#'
#' Create simple or composite progress bars. To create a composite progress bar
#' pass multiple calls to `bar` to a progress output. Each `bar` component has
#' its own id, value, label, and attributes. Furthermore, utility functions may
#' be applied to individual bars for added customization.
#'
#' @param id A character string specifying the id of the progress outlet or
#'   progress bar.
#'
#'   For **bar**, specifying an id allows you to update an existing bar in a
#'   progress outlet with `showBar()`. If `id` is `NULL`, `showBar()` will
#'   append instead of replace a progress bar.
#'
#' @param ... For **progressOutlet**, one or more `bar` elements to include by
#'   default.
#'
#'   For **progressOutlet** and **bar**, additional named arguments passed as
#'   HTML attributes to the parent element.
#'
#' @param value An integer between 0 and 100 specifying the initial value
#'   of a bar.
#'
#' @param label A character string specifying the label of a bar, defaults to
#'   `NULL`, in which case a label is not added.
#'
#' @param striped If `TRUE`, the progress bar has a striped gradient, defaults
#'   to `FALSE`.
#'
#' @param outlet A character string specifying the id of a progress outlet.
#'
#' @param bar A bar element, typically a call to `bar()`.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @section Example application:
#'
#' ```R
#' ui <- container(
#'   progressOutlet("tasks"),
#'   buttonInput(
#'     id = "inc",
#'     "Increment progress"
#'   ) %>%
#'     margin(top = 3)
#' ) %>%
#'   flex(direction = "column")
#'
#' server <- function(input, output) {
#'   observeEvent(input$inc, ignoreInit = TRUE, {
#'     showBar(
#'       id = "tasks",
#'       bar(
#'         id = "laundry",
#'         value = min(100, input$inc * 10)
#'       ) %>%
#'         background("amber")
#'     )
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
#' ### Striped variant
#'
#' progressOutlet(
#'   id = "progress1",
#'   bar(
#'     id = "task1",
#'     value = 41,
#'     striped = TRUE  # <-
#'   ) %>%
#'     background("blue")
#' )
#'
#' ### Labeled bars
#'
#' progressOutlet(
#'   id = "progress2",
#'   bar(
#'     id = "task2",
#'     value = 64,
#'     label = "Trees planted"  # <-
#'   ) %>%
#'     background("green")
#' )
#'
#' ### Multiple bars
#'
#' progressOutlet(
#'   id = "progress3",
#'   bar(
#'     id = "task3",
#'     value = 40
#'   ) %>%
#'     background("red"),
#'   bar(
#'     id = "task4",
#'     value = 20
#'   ) %>%
#'     background("orange")
#' )
#'
progressOutlet <- function(id, ...) {
  this <- tags$div(
    id = id,
    class = "yonder-progress progress",
    ...
  )

  attachDependencies(
    this,
    yonderDep()
  )
}

#' @rdname progressOutlet
#' @export
bar <- function(id, value, label = NULL, striped = FALSE, ...) {
  if (!is.character(id) && !is.null(id)) {
    stop(
      "invalid `bar()` argument, `id` must be a character string ",
      "or NULL",
      call. = FALSE
    )
  }

  value <- round(value)

  tags$div(
    class = collate(
      "progress-bar",
      if (striped) "progress-bar-striped"
    ),
    id = id,
    role = "progressbar",
    style = paste0("width: ", value, "%"),
    `aria-valuemin` = "0",
    `aria-valuemax` = "100",
    label,
    ...
  )
}

#' @rdname progressOutlet
#' @export
showBar <- function(outlet, bar, session = getDefaultReactiveDomain()) {
  session$sendProgress("yonder-progress", list(
    type = "show",
    data = list(
      outlet = outlet,
      content = HTML(as.character(bar))
    )
  ))
}
