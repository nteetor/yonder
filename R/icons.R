globalVariables("icons")

#' Icon elements
#'
#' Include an icon in your application. For now only Font Awesome icons are
#' included.
#'
#' @param name A character string specifying the name of the icon.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @param set A character string specifying the icon set to choose from, defaults
#'   to `"NULL"`, in which case all icon sets are searched.
#'
#' @seealso
#'
#' For more on Font Awesome check out \url{https://fontawesome.com}.
#'
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       center = TRUE,
#'       selectInput(
#'         id = "name",
#'         choices = unique(icons$name)
#'       ) %>%
#'         margin(3),
#'       div(
#'         htmlOutput("icon")
#'       ) %>%
#'         margin(3) %>%
#'         display("flex") %>%
#'         flex(direction = "column", align = "center")
#'     ),
#'     server = function(input, output) {
#'       output$icon <- renderUI({
#'         icon(input$name) %>%
#'           font(size = "8x")
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       lapply(
#'         unique(icons$set),
#'         function(s) {
#'           div(
#'             lapply(
#'               unique(icons[icons$set == s, ]$name),
#'               function(nm) {
#'                 icon(nm, set = s) %>%
#'                   margin(2)
#'               }
#'             )
#'           ) %>%
#'             display("flex") %>%
#'             flex(wrap = TRUE)
#'         }
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
icon <- function(name, set = NULL, ...) {
  if (length(name) != 1) {
    stop(
      "invalid `icon()` argument, `name` must be a single character string",
      call. = FALSE
    )
  }

  if (!is.null(set)) {
    if (length(set) != 1) {
      stop(
        "invalid `icon()` argument, if specified `set` must be a single ",
        "character string",
        call. = FALSE
      )
    }

    if (!(set %in% icons$set)) {
      stop(
        "invalid `icon()` argument, unknown icon set",
        '"', set, '"',
        call. = FALSE
      )
    }
  }

  index <- which(
    icons$name == name & if (!is.null(set)) icons$set == set else TRUE
  )

  if (!length(index)) {
    stop(
      'in `icon()`, no icon found with name "', name, '"',
      if (!is.null(set)) paste0(' in set "', set, '"'),
      call. = FALSE
    )
  }

  icon <- icons[index[1], ]

  if (icon$set == "font awesome") {
    tags$i(
      class = collate(
        icon$prefix,
        sprintf("fa-%s", icon$name),
        "fa-fw"
      ),
      ...,
      include("font awesome")
      # include font awesome(?)
    )
  } else if (icon$set == "material design") {
    tags$i(
      class = "material-icons",
      ...,
      icon$name,
      include("material icons")
    )
  } else if (icon$set == "feather") {
    tags$i(
      `data-feather` = icon$name,
      ...,
      tags$script("feather.replace()"),
      include("feather")
    )
  }
}

#' Icon data
#'
#' Data frame of icon sets, keywords, names, and additional meta information.
#'
#' @format A data frame with 3563 rows and 4 columns:
#'
#' \describe{
#' \item{set}{the icon family name}
#' \item{keyword}{a keyword to identify the icon by}
#' \item{name}{the name of the icon}
#' \item{prefix}{used by the font awesome family}
#' }
#'
#' @keywords internal
#' @examples
#' icons
"icons"

#' A spinner
#'
#' Start or stop a spinner based on process progress.
#'
#' @param id A character specifying the id of the spinner output.
#'
#' @param type One of `"circle"`, `"cog"`, `"dots"`, or `"sync"` specifying the
#'   type of spinner, defaults to `"circle"`.
#'
#' @param pulse One of `TRUE` or `FALSE`, if `TRUE` the spinner rotates in 8
#'   discrete steps, defaults to `FALSE`.
#'
#' @param ... Additional named argument passed as HTML attributes to the
#'   parent element.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain())].
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         column(
#'           spinnerOutput("spin", pulse = TRUE),
#'           buttonInput("trigger", "Start/stop")
#'         ) %>%
#'           display("flex") %>%
#'           flex(justify = "around")
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$trigger, {
#'         if (input$trigger %% 2 == 1) {
#'           startSpinner("spin")
#'         } else {
#'           stopSpinner("spin")
#'         }
#'       })
#'     }
#'   )
#' }
#'
spinnerOutput <- function(id, type = "circle", pulse = FALSE, ...) {
  tags$i(
    class = collate(
      "dull-spinner-output",
      "fas",
      switch(
        type,
        circle = "fa-circle-notch",
        cog = "fa-cog",
        dots = "fa-spinner",
        sync = "fa-sync"
      ),
      if (pulse) "fa-pulse" else "fa-spin",
      "pause"
    ),
    id = id,
    ...,
    include("font awesome")
  )
}

#' @rdname spinnerOutput
#' @export
startSpinner <- function(id, session = getDefaultReactiveDomain()) {
  session$sendProgress("dull-spinner", list(
    id = id,
    action = "start"
  ))
}

#' @rdname spinnerOutput
#' @export
stopSpinner <- function(id, session = getDefaultReactiveDomain()) {
  session$sendProgress("dull-spinner", list(
    id = id,
    action = "stop"
  ))
}
