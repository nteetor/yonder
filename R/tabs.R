#' Page navigation
#'
#' Create a set of tabs for controlling tab content. Tabs are separated from
#' content and panes for flexible placement. In the examples below you can see
#' how this allows tabs to be used inside [card()]s. The flexibility also allows
#' tabs to be added to navbars. When building tabbed content be sure to create a
#' pane for each label in your tabs and link tabs to content by the `id` and
#' `tabs` arguments, see below.
#'
#' @param id A character string specifying the id of a pane.
#'
#' @param labels A character vector specifying the labels of the navigation
#'   items.
#'
#' @param values A character vector specifying custom values for each navigation
#'   item, defaults to `labels`.
#'
#' @param fill One of `TRUE` or `FALSE` specifying if the nav input fills the
#'   width of its parent element. If `TRUE`, the space is divided evenly among
#'   the nav items.
#'
#' @param appearance One of `"pills"` or `"tabs"` specifying the appearance of
#'   the nav input.
#'
#' @param ... For **navContent**, calls to `navPane()` or named arguments passed
#'   as HTML attributes to the parent element.
#'
#'   For **navInput** and **navPane**, any number of tag elements or named
#'   arguments passed as HTML attributes to the parent element.
#'
#' @section App with pills:
#'
#' ```R
#' ui <- container(
#'   navInput(
#'     id = "tabs",
#'     items = paste("Tab", 1:3),
#'     values = paste0("pane", 1:3),
#'     appearance = "pills"
#'   ),
#'   navContent(
#'     navPane(
#'       id = "pane1",
#'       "Nullam tristique diam non turpis.",
#'       "Cum sociis natoque penatibus et magnis dis parturient montes, ",
#'       "nascetur ridiculus mus.",
#'       "Etiam laoreet quam sed arcu.",
#'       "Curabitur vulputate vestibulum lorem."
#'     ),
#'     navPane(
#'       id = "pane2",
#'       "Praesent fermentum tempor tellus.",
#'       "Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.",
#'       "Phasellus lacus.",
#'       "Nam euismod tellus id erat."
#'     ),
#'     navPane(
#'       id = "pane3",
#'       "Nullam eu ante vel est convallis dignissim.",
#'       "Phasellus at dui in ligula mollis ultricies.",
#'       "Fusce suscipit, wisi nec facilisis facilisis, est dui ",
#'       "fermentum leo, quis tempor ligula erat quis odio.",
#'       "Donec hendrerit tempor tellus."
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   observeEvent(input$tabs, {
#'     showPane(input$tabs)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @section App with dropdown:
#'
#' ```R
#' ui <- container(
#'   navInput(
#'     id = "tabs",
#'     items = list(
#'       "Tab 1",
#'       dropdown(
#'         label = "Tab 2",
#'         buttonInput("action", "Action"),
#'         buttonInput("another", "Another action")
#'       ),
#'       "Tab 3"
#'     ),
#'     values = paste0("pane", 1:3),
#'     appearance = "tabs"
#'   ),
#'   navContent(
#'     navPane(
#'       id = "pane1",
#'       "Donec at pede.",
#'       "Pellentesque tristique imperdiet tortor.",
#'       "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
#'     ),
#'     navPane(
#'       id = "pane2",
#'       "Nullam tristique diam non turpis.",
#'       "Cras placerat accumsan nulla.",
#'       "Donec at pede."
#'     ),
#'     navPane(
#'       id = "pane3",
#'       "Phasellus purus.",
#'       "Etiam laoreet quam sed arcu.",
#'       "Donec pretium posuere tellus."
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   observeEvent(input$tabs, {
#'     showPane(input$tabs)
#'   })
#'
#'   observeEvent(c(input$action, input$another), {
#'     if (input$action > 0 || input$another > 0) {
#'       showPane("pane2")
#'     }
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @section App with multiple sets of panes:
#'
#' ```R
#' ui <- container(
#'   navInput(
#'     id = "tabs",
#'     items = paste("Tab", 1:3),
#'     values = paste0("pane", 1:3)
#'   ),
#'   row(
#'     column(
#'       navContent(
#'         navPane(
#'           id = "pane1",
#'           "Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
#'           "venenatis vestibulum. Praesent commodo cursus magna, vel ",
#'           "scelerisque nisl consectetur et. Vivamus sagittis lacus vel ",
#'           "augue laoreet rutrum faucibus dolor auctor."
#'         ),
#'         navPane(
#'           id = "pane2",
#'           "Nullam quis risus eget urna mollis ornare vel eu leo. ",
#'           "Maecenas faucibus mollis interdum. Praesent commodo cursus ",
#'           "magna, vel scelerisque nisl consectetur et."
#'         ),
#'         navPane(
#'           id = "pane3",
#'           "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
#'           "Vivamus sagittis lacus vel augue laoreet rutrum faucibus ",
#'           "dolor auctor. Etiam porta sem malesuada magna mollis euismod."
#'         )
#'       )
#'     ),
#'     column(
#'       navContent(
#'         navPane(
#'           id = "pane1",
#'           "Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
#'           "venenatis vestibulum. Praesent commodo cursus magna, vel ",
#'           "scelerisque nisl consectetur et. Vivamus sagittis lacus vel ",
#'           "augue laoreet rutrum faucibus dolor auctor."
#'         ),
#'         navPane(
#'           id = "pane2",
#'           "Nullam quis risus eget urna mollis ornare vel eu leo. ",
#'           "Maecenas faucibus mollis interdum. Praesent commodo cursus ",
#'           "magna, vel scelerisque nisl consectetur et."
#'         ),
#'         navPane(
#'           id = "pane3",
#'           "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
#'           "Vivamus sagittis lacus vel augue laoreet rutrum faucibus ",
#'           "dolor auctor. Etiam porta sem malesuada magna mollis euismod."
#'         )
#'       )
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   observeEvent(input$tabs, {
#'     showPane(input$tabs)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Nav styled as tabs
#'
#' navInput(
#'   id = "tabs",
#'   items = c(
#'     "Tab 1",
#'     "Tab 2",
#'     "Tab 3"
#'   ),
#'   appearance = "tabs"
#' )
#'
#' ### Nav styled as pills
#'
#' navInput(
#'   id = "tabs",
#'   items = paste("Tab", 1:3),
#'   appearance = "pills"
#' )
#'
#' ### Nav with dropdown
#'
#' navInput(
#'   id = "tabs",
#'   items = list(
#'     "Tab 1",
#'     dropdown(
#'       label = "Tab 2",
#'       buttonInput("action", "Action"),
#'       buttonInput("another", "Another action")
#'     ),
#'     "Tab 2"
#'   )
#' )
#'
navInput <- function(id, items, values = items, ..., fill = FALSE,
                     appearance = NULL) {
  if (!is.null(appearance) && !re(appearance, "pills|tabs", FALSE)) {
    stop(
      "invalid `navInput()` argument, `appearance` must be one of ",
      '"pills" or "tabs"',
      call. = FALSE
    )
  }

  values <- vapply(
    values,
    function(x) if (is_tag(x)) x$children[[1]]$children[[1]] else (x %||% ""),
    character(1)
  )

  tags$ul(
    class = collate(
      "yonder-nav",
      "nav",
      if (fill) "nav-fill",
      if (!is.null(appearance)) paste0("nav-", appearance)
    ),
    id = id,
    Map(
      label = items,
      value = values,
      active = c(TRUE, rep.int(FALSE, length(items) - 1)),
      function(label, value, active) {
        navItem(label, value, active)
      }
    )
  )
}

navItem <- function(base, value = NULL, active = FALSE) {
  value <- if (value != "") value

  if (is.character(base)) {
    base <- tags$li(
      class = "nav-item",
      tags$a(
        class = collate(
          "nav-link",
          if (active) "active"
        ),
        href = "#",
        `data-value` = value %||% base,
        base
      )
    )

    return(base)
  }

  if (tagHasClass(base, "dropdown")) {
    base$children[[1]]$name <- "a"
    base$children[[1]]$attribs$class <- "nav-link dropdown-toggle"
    base$children[[1]]$attribs$type <- NULL
    base$children[[1]]$attribs$`data-value` <- value %||% base$children[[1]]$children[[1]]
    base$children[[1]]$attribs$role <- "button"
    base$children[[1]]$attribs$href <- "#"

    if (active) {
      base$children[[1]] <- tagAddClass(base$children[[1]], "active")
    }

    base$name <- "li"
    base <- tagAddClass(base, "nav-item")

    return(base)
  }

  stop(
    "could not convert object to nav item",
    call. = FALSE
  )
}

#' @rdname navInput
#' @export
navContent <- function(...) {
  panes <- tags$div(
    class = "tab-content",
    ...
  )

  panes <- attachDependencies(
    panes,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  panes
}

#' @rdname navInput
#' @export
navPane <- function(id, ...) {
  pane <- tags$div(
    class = "tab-pane fade",
    role = "tab-panel",
    `data-id` = id,
    ...
  )

  pane <- attachDependencies(
    pane,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  pane
}

#' @rdname navInput
#' @export
showPane <- function(id, session = getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop(
      "`showPane()` must be called in a reactive environment",
      call. = FALSE
    )
  }

  if (!is.character(id)) {
    stop(
      "invalid `showPane()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  session$sendCustomMessage("yonder:pane", list(
    type = "show",
    data = list(
      target = id
    )
  ))
}
