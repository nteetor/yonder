---
this: navPane
filename: R/nav.R
layout: page
include: ~
roxygen:
  title: Navigation panes
  description: |-
    These functions pair with [navInput()](/yonder/0.0.5/inputs/navInput.html). Use `navContent()` and `navPane()` to
    create the pane layout. To show a new pane use `showPane()` in the server
    function.
  parameters:
  - name: '...'
    description: |-
      For **navContent**, any number of nav panes or named arguments
      passed as HTML attributes to the parent element.

      For **navPane**, named attributes passed as HTML elements to the parent
      element.
  - name: id
    description: A character string specifying the id of a nav pane.
  - name: session
    description: A reactive context, defaults to [getDefaultReactiveDomain()](/yonder/0.0.5/getDefaultReactiveDomain.html).
  sections:
  - title: App with pills
    body: |-
      ```R
      ui <- container(
        navInput(
          id = "tabs",
          choices = paste("Tab", 1:3),
          values = paste0("pane", 1:3),
          appearance = "pills"
        ),
        navContent(
          navPane(
            id = "pane1",
            "Nullam tristique diam non turpis.",
            "Cum sociis natoque penatibus et magnis dis parturient montes, ",
            "nascetur ridiculus mus.",
            "Etiam laoreet quam sed arcu.",
            "Curabitur vulputate vestibulum lorem."
          ),
          navPane(
            id = "pane2",
            "Praesent fermentum tempor tellus.",
            "Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.",
            "Phasellus lacus.",
            "Nam euismod tellus id erat."
          ),
          navPane(
            id = "pane3",
            "Nullam eu ante vel est convallis dignissim.",
            "Phasellus at dui in ligula mollis ultricies.",
            "Fusce suscipit, wisi nec facilisis facilisis, est dui ",
            "fermentum leo, quis tempor ligula erat quis odio.",
            "Donec hendrerit tempor tellus."
          )
        )
      )

      server <- function(input, output) {
        observeEvent(input$tabs, {
          showPane(input$tabs)
        })
      }

      shinyApp(ui, server)
      ```
  - title: App with dropdown
    body: |-
      ```R
      ui <- container(
        navInput(
          id = "tabs",
          choices = list(
            "Tab 1",
            dropdown(
              label = "Tab 2",
              buttonInput("action", "Action"),
              buttonInput("another", "Another action")
            ),
            "Tab 3"
          ),
          values = paste0("pane", 1:3),
          appearance = "tabs"
        ),
        navContent(
          navPane(
            id = "pane1",
            "Donec at pede.",
            "Pellentesque tristique imperdiet tortor.",
            "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
          ),
          navPane(
            id = "pane2",
            "Nullam tristique diam non turpis.",
            "Cras placerat accumsan nulla.",
            "Donec at pede."
          ),
          navPane(
            id = "pane3",
            "Phasellus purus.",
            "Etiam laoreet quam sed arcu.",
            "Donec pretium posuere tellus."
          )
        )
      )

      server <- function(input, output) {
        observeEvent(input$tabs, {
          showPane(input$tabs)
        })

        observeEvent(c(input$action, input$another), {
          if (input$action > 0 || input$another > 0) {
            showPane("pane2")
          }
        })
      }

      shinyApp(ui, server)
      ```
  - title: App with multiple sets of panes
    body: |-
      ```R
      ui <- container(
        navInput(
          id = "tabs",
          choices = paste("Tab", 1:3),
          values = paste0("pane", 1:3)
        ),
        row(
          column(
            navContent(
              navPane(
                id = "pane1_1",
                "Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
                "venenatis vestibulum. Praesent commodo cursus magna, vel ",
                "scelerisque nisl consectetur et. Vivamus sagittis lacus vel ",
                "augue laoreet rutrum faucibus dolor auctor."
              ),
              navPane(
                id = "pane2_1",
                "Nullam quis risus eget urna mollis ornare vel eu leo. ",
                "Maecenas faucibus mollis interdum. Praesent commodo cursus ",
                "magna, vel scelerisque nisl consectetur et."
              ),
              navPane(
                id = "pane3_1",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                "Vivamus sagittis lacus vel augue laoreet rutrum faucibus ",
                "dolor auctor. Etiam porta sem malesuada magna mollis euismod."
              )
            )
          ),
          column(
            navContent(
              navPane(
                id = "pane1_2",
                "Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
                "venenatis vestibulum. Praesent commodo cursus magna, vel ",
                "scelerisque nisl consectetur et. Vivamus sagittis lacus vel ",
                "augue laoreet rutrum faucibus dolor auctor."
              ),
              navPane(
                id = "pane2_2",
                "Nullam quis risus eget urna mollis ornare vel eu leo. ",
                "Maecenas faucibus mollis interdum. Praesent commodo cursus ",
                "magna, vel scelerisque nisl consectetur et."
              ),
              navPane(
                id = "pane3_2",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                "Vivamus sagittis lacus vel augue laoreet rutrum faucibus ",
                "dolor auctor. Etiam porta sem malesuada magna mollis euismod."
              )
            )
          )
        )
      )

      server <- function(input, output) {
        observeEvent(input$tabs, {
          showPane(paste0(input$tabs, "_1"))
          showPane(paste0(input$tabs, "_2"))
        })
      }

      shinyApp(ui, server)
      ```
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <p>Please see the sample applications above for examples demoing <code>showPane()</code> and <code>afterPane()</code>.</p>
---
