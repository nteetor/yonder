#' Page navigation
#'
#' A reactive input styled as a navigation control. The navigation input can be
#' styled as links, tabs, or pills. A nav input is paired with [navContent()]
#' and [showPane()] to create tabbed user interfaces.
#'
#' @param choices A character vector or list of tag elements specifying the
#'   navigation items of the navigation input.
#'
#' @param values A character vector specifying custom values for each navigation
#'   item, defaults to `labels`.
#'
#' @param fill One of `TRUE` or `FALSE` specifying if the nav input fills the
#'   width of its parent element. If `TRUE`, the space is divided evenly among
#'   the nav items.
#'
#' @param appearance One of `"links"`, `"pills"`, or `"tabs"` specifying the
#'   appearance of the nav input, defaults to `"links"`.
#'
#' @section Reactive value:
#'
#' A click on a navigation link triggers a single character string.
#'
#' A click on a dropdown item triggers a character vector of two values, the
#' value of the nav link and the value of the dropdown item.
#'
#' @template input
#' @export
#' @examples
#'
#' ### Nav styled as tabs
#'
#' navInput(
#'   id = "tabs1",
#'   choices = c(
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
#'   id = "tabs2",
#'   choices = paste("Tab", 1:3),
#'   appearance = "pills"
#' )
#'
#' ### Nav with dropdown
#'
#' navInput(
#'   id = "tabs3",
#'   choices = list(
#'     "Tab 1",
#'     menuInput(
#'       id = NULL,  # <- ignored
#'       label = "Tab 2",
#'       choices = c(
#'         "Action",
#'         "Another action"
#'       )
#'     ),
#'     "Tab 2"
#'   ),
#'   values = c("tab1", "tab2", "tab3")
#' )
#'
#' ### Full width nav input
#'
#' navInput(
#'   id = "tabs4",
#'   choices = paste("Tab", 1:5),
#'   values = paste0("tab", 1:5),
#'   appearance = "pills",
#'   fill = TRUE
#' )
#'
#' ### Centering a nav input
#'
#' navInput(
#'   id = "tabs5",
#'   choices = paste("Tab", 1:3)
#' ) %>%
#'   flex(justify = "center")
#'
navInput <- function(id, choices, values = choices, ..., appearance = "links",
                     fill = FALSE) {
  if (!is.null(appearance) && !re(appearance, "links|pills|tabs", FALSE)) {
    stop(
      "invalid `navInput()` argument, `appearance` must be one of ",
      '"links", "pills", or "tabs"',
      call. = FALSE
    )
  }

  values <- vapply(
    values,
    function(x) if (is_tag(x)) x$children[[1]]$children[[1]] else x,
    character(1)
  )

  element <- tags$ul(
    class = collate(
      "yonder-nav",
      "nav",
      if (fill) "nav-fill",
      if (!is.null(appearance)) paste0("nav-", appearance)
    ),
    id = id,
    Map(
      base = choices,
      value = values,
      active = c(TRUE, rep.int(FALSE, length(choices) - 1)),
      navItem
    )
  )

  attachDependencies(
    element,
    c(yonderDep(), shinyDep(), bootstrapDep())
  )
}

navItem <- function(base, value, active) {
  if (is.character(base)) {
    base <- tags$li(
      class = "nav-item",
      tags$button(
        class = collate(
          "nav-link btn btn-link",
          if (active) "active"
        ),
        href = "#",
        value = value,
        base
      )
    )

    return(base)
  }

  if (tagHasClass(base, "yonder-menu")) {
    base$children[[1]]$attribs$class <- "nav-link btn btn-link dropdown-toggle"
    base$children[[1]]$attribs$type <- NULL
    base$children[[1]]$attribs$value <- value

    if (active) {
      base$children[[1]] <- tagAddClass(base$children[[1]], "active")
    }

    base$name <- "li"
    base$attribs$id <- NULL
    base <- tagAddClass(base, "nav-item")

    return(base)
  }

  stop(
    "invalid `navInput()` arguments, could not construct nav items from ",
    "`choices` and `values`",
    call. = FALSE
  )
}

#' Navigation panes
#'
#' These functions pair with [navInput()]. Use `navContent()` and `navPane()` to
#' create the pane layout. To show a new pane use `showPane()` in the server
#' function.
#'
#' @param ... For **navContent**, any number of nav panes or named arguments
#'   passed as HTML attributes to the parent element.
#'
#'   For **navPane**, named attributes passed as HTML elements to the parent
#'   element.
#'
#' @param id A character string specifying the id of the nav pane.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @section App with pills:
#'
#' ```R
#' ui <- container(
#'   navInput(
#'     id = "tabs",
#'     choices = paste("Tab", 1:3),
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
#'     choices = list(
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
#'     choices = paste("Tab", 1:3),
#'     values = paste0("pane", 1:3)
#'   ),
#'   row(
#'     column(
#'       navContent(
#'         navPane(
#'           id = "pane1_1",
#'           "Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
#'           "venenatis vestibulum. Praesent commodo cursus magna, vel ",
#'           "scelerisque nisl consectetur et. Vivamus sagittis lacus vel ",
#'           "augue laoreet rutrum faucibus dolor auctor."
#'         ),
#'         navPane(
#'           id = "pane2_1",
#'           "Nullam quis risus eget urna mollis ornare vel eu leo. ",
#'           "Maecenas faucibus mollis interdum. Praesent commodo cursus ",
#'           "magna, vel scelerisque nisl consectetur et."
#'         ),
#'         navPane(
#'           id = "pane3_1",
#'           "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
#'           "Vivamus sagittis lacus vel augue laoreet rutrum faucibus ",
#'           "dolor auctor. Etiam porta sem malesuada magna mollis euismod."
#'         )
#'       )
#'     ),
#'     column(
#'       navContent(
#'         navPane(
#'           id = "pane1_2",
#'           "Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
#'           "venenatis vestibulum. Praesent commodo cursus magna, vel ",
#'           "scelerisque nisl consectetur et. Vivamus sagittis lacus vel ",
#'           "augue laoreet rutrum faucibus dolor auctor."
#'         ),
#'         navPane(
#'           id = "pane2_2",
#'           "Nullam quis risus eget urna mollis ornare vel eu leo. ",
#'           "Maecenas faucibus mollis interdum. Praesent commodo cursus ",
#'           "magna, vel scelerisque nisl consectetur et."
#'         ),
#'         navPane(
#'           id = "pane3_2",
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
#'     showPane(paste0(input$tabs, "_1"))
#'     showPane(paste0(input$tabs, "_2"))
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
#' # Please see the sample applications above for examples demoing
#' # `showPane()` and `afterPane()`.
#'
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

#' @rdname navContent
#' @export
navPane <- function(id, ...) {
  pane <- tags$div(
    class = "tab-pane fade",
    role = "tab-panel",
    id = id,
    ...
  )

  pane <- attachDependencies(
    pane,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  pane
}

#' @rdname navContent
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

hidePane <- function(id, session = getDefaultReactiveDomain()) {
  if (is.null(session)) {

  }

  if (!is.character(id)) {

  }

  session$sendCustomMessage("yonder:pane", list(
    type = "hide",
    data = list(
      target = id
    )
  ))
}
