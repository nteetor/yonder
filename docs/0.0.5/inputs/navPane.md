---
this: navPane
filename: R/tabs.R
layout: page
roxygen:
  title: Page navigation
  description: |-
    Create a set of tabs for controlling tab content. Tabs are separated from
    content and panes for flexible placement. In the examples below you can see
    how this allows tabs to be used inside [card()](/yonder/0.0.5/content/card.html)s. The flexibility also allows
    tabs to be added to navbars. When building tabbed content be sure to create a
    pane for each label in your tabs and link tabs to content by the `id` and
    `tabs` arguments, see below.
  parameters:
  - name: id
    description: A character string specifying the id of a pane.
  - name: labels
    description: |-
      A character vector specifying the labels of the navigation
      items.
  - name: values
    description: |-
      A character vector specifying custom values for each navigation
      item, defaults to `labels`.
  - name: fill
    description: |-
      One of `TRUE` or `FALSE` specifying if the nav input fills the
      width of its parent element. If `TRUE`, the space is divided evenly among
      the nav items.
  - name: appearance
    description: |-
      One of `"pills"` or `"tabs"` specifying the appearance of
      the nav input.
  - name: '...'
    description: |-
      For **navContent**, calls to `navPane()` or named arguments passed
      as HTML attributes to the parent element.

      For **navInput** and **navPane**, any number of tag elements or named
      arguments passed as HTML attributes to the parent element.
  sections:
  - title: App with pills
    body: |-
      ```R
      ui <- container(
        navInput(
          id = "tabs",
          items = paste("Tab", 1:3),
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
          items = list(
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
          items = paste("Tab", 1:3),
          values = paste0("pane", 1:3)
        ),
        row(
          column(
            navContent(
              navPane(
                id = "pane1",
                "Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
                "venenatis vestibulum. Praesent commodo cursus magna, vel ",
                "scelerisque nisl consectetur et. Vivamus sagittis lacus vel ",
                "augue laoreet rutrum faucibus dolor auctor."
              ),
              navPane(
                id = "pane2",
                "Nullam quis risus eget urna mollis ornare vel eu leo. ",
                "Maecenas faucibus mollis interdum. Praesent commodo cursus ",
                "magna, vel scelerisque nisl consectetur et."
              ),
              navPane(
                id = "pane3",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                "Vivamus sagittis lacus vel augue laoreet rutrum faucibus ",
                "dolor auctor. Etiam porta sem malesuada magna mollis euismod."
              )
            )
          ),
          column(
            navContent(
              navPane(
                id = "pane1",
                "Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
                "venenatis vestibulum. Praesent commodo cursus magna, vel ",
                "scelerisque nisl consectetur et. Vivamus sagittis lacus vel ",
                "augue laoreet rutrum faucibus dolor auctor."
              ),
              navPane(
                id = "pane2",
                "Nullam quis risus eget urna mollis ornare vel eu leo. ",
                "Maecenas faucibus mollis interdum. Praesent commodo cursus ",
                "magna, vel scelerisque nisl consectetur et."
              ),
              navPane(
                id = "pane3",
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
          showPane(input$tabs)
        })
      }

      shinyApp(ui, server)
      ```
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Nav styled as tabs</h3>
  - type: source
    value: |2-

      navInput(
        id = "tabs",
        items = c(
          "Tab 1",
          "Tab 2",
          "Tab 3"
        ),
        appearance = "tabs"
      )
  - type: output
    value: |-
      <ul class="yonder-nav nav nav-tabs" id="tabs">
        <li class="nav-item">
          <a class="nav-link active" href="#" data-value="Tab 1">Tab 1</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 2">Tab 2</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 3">Tab 3</a>
        </li>
      </ul>
  - type: markdown
    value: |
      <h3>Nav styled as pills</h3>
  - type: source
    value: |2-

      navInput(
        id = "tabs",
        items = paste("Tab", 1:3),
        appearance = "pills"
      )
  - type: output
    value: |-
      <ul class="yonder-nav nav nav-pills" id="tabs">
        <li class="nav-item">
          <a class="nav-link active" href="#" data-value="Tab 1">Tab 1</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 2">Tab 2</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 3">Tab 3</a>
        </li>
      </ul>
  - type: markdown
    value: |
      <h3>Nav with dropdown</h3>
  - type: source
    value: |2-

      navInput(
        id = "tabs",
        items = list(
          "Tab 1",
          dropdown(
            label = "Tab 2",
            buttonInput("action", "Action"),
            buttonInput("another", "Another action")
          ),
          "Tab 2"
        )
      )
  - type: output
    value: |-
      <ul class="yonder-nav nav" id="tabs">
        <li class="nav-item">
          <a class="nav-link active" href="#" data-value="Tab 1">Tab 1</a>
        </li>
        <li class="dropdown nav-item">
          <a class="nav-link dropdown-toggle" data-toggle="dropdown" aria-haspop="true" aria-expanded="false" data-value="Tab 2" role="button" href="#">Tab 2</a>
          <div class="dropdown-menu">
            <button class="yonder-button dropdown-item" type="button" role="button" id="action">Action</button>
            <button class="yonder-button dropdown-item" type="button" role="button" id="another">Another action</button>
          </div>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 2">Tab 2</a>
        </li>
      </ul>
---
