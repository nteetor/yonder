#' Page navigation inputs
#'
#' A reactive input styled as a navigation control. The navigation input can be
#' styled as links, tabs, or pills. A nav input is paired with [navContent()]
#' and [showNavPane()] to create tabbed user interfaces. Observers and reactives
#' are triggered when a nav choice or menu item is clicked. The reactive value
#' of a nav input is `NULL` or a singleton character string. The value of any
#' menus in the nav input must be retrieved with its own reactive id.
#'
#' @inheritParams checkboxInput
#'
#' @param choices A character vector or list of tag elements specifying the
#'   navigation items of the input.
#'
#' @param values A character vector specifying the values of the input's
#'   chocies, defaults to `choices`.
#'
#' @param selected One of `values` specifying which choice is selected by
#'   default, defaults to `values[[1]]`.
#'
#' @param fill One of `TRUE` or `FALSE` specifying if the nav input fills the
#'   width of its parent element. If `TRUE`, the space is divided evenly among
#'   the nav items.
#'
#' @param appearance One of `"links"`, `"pills"`, or `"tabs"` specifying the
#'   appearance of the nav input, defaults to `"links"`.
#'
#' @section Including a menu:
#'
#' Use the reactive id of any nav menus to know when a menu item is clicked.
#'
#' ```R
#' ui <- navInput(
#'   id = "navigation",
#'   choices = list(
#'     "Item 1",
#'     "Item 2",
#'     menuInput(
#'       id = "navMenu",  # <-
#'       label = "Item 3",
#'       choices = c("Choice 1", "Choice 2")
#'     )
#'   ),
#'   values = c("item1", "item2", "item3")
#' )
#'
#' server <- function(input, output) {
#'   observeEvent(input$navMenu, {
#'     cat(paste("Click menu item:", input$navMenu, "\n"))
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
#'   id = "tabs1",
#'   choices = c(
#'     "Tab 1",
#'     "Tab 2",
#'     "Tab 3"
#'   ),
#'   selected = "Tab 1",
#'   appearance = "tabs"
#' )
#'
#' ### Nav styled as pills
#'
#' navInput(
#'   id = "tabs2",
#'   choices = paste("Tab", 1:3),
#'   selected = "Tab 1",
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
#'       id = "menu1",
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
navInput <- function(id, choices = NULL, values = choices,
                     selected = values[[1]], ..., appearance = "links",
                     fill = FALSE) {
  assert_id()
  assert_selected(length = 1)
  assert_possible(appearance, c("links", "pills", "tabs"))

  dep_attach({
    items <- map_navitems(choices, values, selected)

    tags$ul(
      class = str_collate(
        "yonder-nav",
        "nav",
        if (fill) "nav-fill",
        if (appearance != "links") paste0("nav-", appearance)
      ),
      id = id,
      items,
      ...
    )
  })
}

#' @rdname navInput
#' @export
updateNavInput <- function(id, choices = NULL, values = choices,
                           selected = NULL, enable = NULL, disable = NULL,
                           session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_selected(length = 1)
  assert_session()

  items <- map_navitems(choices, values, selected)

  content <- coerce_content(items)
  selected <- coerce_selected(selected)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)

  session$sendInputMessage(id, list(
    content = content,
    selected = selected,
    enable = enable,
    disable = disable
  ))
}

map_navitems <- function(choices, values, selected) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }

  selected <- values %in% selected

  Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      if (is_tag(choice) && tag_class_re(choice, "yonder-menu")) {
        choice$children[[1]] <- tag_class_remove(
          choice$children[[1]],
          paste0("btn-(?:", paste0(possible_colors, collapse = "|"), ")")
        )
        choice$children[[1]] <- tag_class_add(
          choice$children[[1]],
          "nav-link btn-link"
        )
        choice$children[[1]]$attribs$type <- NULL
        choice$children[[1]]$attribs$value <- value

        if (select) {
          choice$children[[1]] <- tag_class_add(choice$children[[1]], "active")
        }

        choice$name <- "li"
        choice <- tag_class_add(choice, "nav-item")

        return(choice)
      }

      tags$li(
        class = "nav-item",
        tags$button(
          class = str_collate(
            "nav-link",
            "btn",
            "btn-link",
            if (select) "active"
          ),
          value = value,
          choice
        )
      )
    }
  )
}

#' Navigation panes
#'
#' These functions pair with [navInput()]. Use `navContent()` and `navPane()` to
#' create the pane layout. To show a new pane use `showNavPane()` from within an
#' observer. `showNavPane()` will also hide a previously active pane. If needed
#' you can hide an active pane with `hideNavPane()`. `hideNavPane()` is useful
#' when you do not have a new pane to show, but want to hide the current active
#' pane.
#'
#' @param ... For **navContent**, any number of nav panes passed as child
#'   elements to the nav parent element or named arguments passed as HTML
#'   attributes to the parent element.
#'
#'   For **navPane**, any number of unnamed arguments passed as tag elements to
#'   the parent element or named arguments passed as HTML elements to the
#'   parent element.
#'
#' @param id A character string specifying the id of the nav pane.
#'
#' @param fade One of `TRUE` or `FALSE` specifying if the pane fades in when
#'   shown and fades out when hidden, defaults to `TRUE`.
#'
#' @inheritParams collapsePane
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
#'     showNavPane(input$tabs)
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
#'     showNavPane(input$tabs)
#'   })
#'
#'   observeEvent(c(input$action, input$another), {
#'     if (input$action > 0 || input$another > 0) {
#'       showNavPane("pane2")
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
#'   columns(
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
#'     showNavPane(paste0(input$tabs, "_1"))
#'     showNavPane(paste0(input$tabs, "_2"))
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family components
#' @export
#' @examples
#'
#' ### Examples
#'
#' # Because these are server-side utilities please see the example applications
#' # above.
#'
navContent <- function(...) {
  dep_attach({
    tags$div(class = "tab-content", ...)
  })
}

#' @rdname navContent
#' @export
navPane <- function(id, ..., fade = TRUE) {
  dep_attach({
    tags$div(
      class = str_collate(
        "tab-pane",
        if (fade) "fade"
      ),
      role = "tab-panel",
      id = id,
      ...
    )
  })
}

#' @rdname navContent
#' @export
showNavPane <- function(id, session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  session$sendCustomMessage("yonder:pane", list(
    type = "show",
    data = list(
      target = id
    )
  ))
}

#' @rdname navContent
#' @export
hideNavPane <- function(id, session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  session$sendCustomMessage("yonder:pane", list(
    type = "hide",
    data = list(
      target = id
    )
  ))
}
