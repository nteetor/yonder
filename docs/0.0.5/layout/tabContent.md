---
this: tabContent
filename: R/tabs.R
layout: page
roxygen:
  title: Tabbable content
  description: |-
    Create a set of tabs for controlling tab content. Tabs are separated from
    content and panes for flexible placement. In the examples below you can see
    how this allows tabs to be used inside [card()](/yonder/0.0.5/card().html)s. The flexibility also allows
    tabs to be added to navbars. When building tabbed content be sure to create a
    pane for each label in your tabs and link tabs to content by the `id` and
    `tabs` arguments, see below.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the tabs, to connect a set
      of tabs to content pass the same value to `tabContent` as `tabs`. Tabs do
      have a reactive value, by default the label of the active tab. To `values`
      to specify custom values.
  - name: tabs
    description: A character string specifying the id of a set of tabs.
  - name: labels
    description: A character vector specifying the labels of the tabs.
  - name: values
    description: |-
      A character vector specifying a custom value for each tab,
      defaults to `labels`.
  - name: active
    description: |-
      One of `values` specifying which tab is initially shown,
      defaults to `values[1](/yonder/0.0.5/1.html)`.`
  - name: '...'
    description: |-
      For **tabContent**, calls to `tabPane` or named arguments passed
        as HTML attributes to the parent element.

        For **tabPane**, any number of tag elements or named arguments passed as
        HTML attributes to the parent element.

        For **tabTabs**, additional named arguments passed as HTML attributes to
        the parent element.
  sections: ~
  return: ~
  family: layout
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      tabTabs(
        id = "myTabs",
        labels = c("Home", "About", "Posts"),
        values = c("home", "about", "blog")
      )
      tabContent(
        tabs = "myTabs",
        tabPane(
          tags$h1("Pane 1"),
          tags$p("Lorem Dapibus Malesuada Cras Cursus")
        ),
        tabPane(
          tags$h1("Pane 2"),
          tags$p("Magna Aenean Mattis Ultricies Ridiculus")
        )
      )
      if (interactive()) {
        shinyApp(
          ui = container(
            card(
              header = tabTabs(
                id = "tabs",
                labels = c("Home", "Profile", "Contact"),
              ),
              tabContent(
                tabs = "tabs",
                tabPane(
                  "Vestibulum id ligula porta felis euismod semper. Cras justo
                   odio, dapibus ac facilisis in, egestas eget quam."
                ),
                tabPane(
                  "Duis mollis, est non commodo luctus, nisi erat porttitor ligula,
                   eget lacinia odio sem nec elit. Aenean eu leo quam. Pellentesque
                   ornare sem lacinia quam venenatis vestibulum."
                ),
                tabPane(
                  "Donec ullamcorper nulla non metus auctor fringilla. Nullam id
                   dolor id nibh ultricies vehicula ut id elit."
                )
              )
            ) %>%
              margin(4) %>%
              width(50)
          ),
          server = function(input, output) {
            observe({
              showAlert(input$tabs, duration = 2, color = "grey")
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                default = 4,
                card(
                  p("Nullam quis risus eget urna mollis ornare vel eu leo. Nullam
                  id dolor id nibh ultricies vehicula ut id elit.")
                ) %>%
                  background("grey")
              ),
              column(
                tabTabs(
                  id = "myTabs",
                  labels = c("Home", "About", "Posts")
                ) %>%
                  margin(bottom = 5),
                tabContent(
                  tabs = "myTabs",
                  tabPane(
                    h4("This is home."),
                    p("Pellentesque dapibus suscipit ligula.  Donec ",
                      "posuere augue in quam.  Etiam vel tortor ",
                      "sodales tellus ultricies commodo.  Suspendisse ",
                      "potenti.  Aenean in sem ac leo mollis blandit."),
                    p("Donec neque quam, dignissim in, mollis nec, ",
                      "sagittis eu, wisi.  Phasellus lacus.  Etiam ",
                      "laoreet quam sed arcu.  Phasellus at dui in ligula",
                      "mollis ultricies.  Integer placerat tristique nisl.")
                  ),
                  tabPane(
                    h4("All about."),
                    p("Pellentesque dapibus suscipit ligula. ",
                      "Phasellus neque orci, porta a, aliquet quis, semper a, massa. ",
                      "Nullam tristique diam non turpis. ",
                      "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.")
                  ),
                  tabPane(
                    h4("Blog items."),
                    p("Nullam tempus.  Mauris ac felis vel velit ",
                      "tristique imperdiet.  Donec at pede.  Etiam vel ",
                      "neque nec dui dignissim bibendum.  Vivamus id ",
                      "enim.  Phasellus neque orci, porta a, aliquet ",
                      "quis, semper a, massa.  Phasellus purus.")
                  )
                )
              )
            ) %>%
              padding(3)
          ),
          server = function(input, output) {
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            tabTabs(
              id = "toplevel",
              labels = c("Home", "Explore")
            ),
            tabContent(
              tabs = "toplevel",
              tabPane(
                card(
                  header = tabTabs(
                    id = "cardtabs",
                    labels = c("This", "That", "Other")
                  ),
                  tabContent(
                    tabs = "cardtabs",
                    tabPane(
                      p("A card")
                    ),
                    tabPane(),
                    tabPane()
                  )
                )
              ),
              tabPane(
                p("Another tab")
              )
            )
          ),
          server = function(input, output) {
          }
        )
      }
    output:
    - |-
      <ul class="yonder-tabs nav nav-tabs" role="tablist" id="myTabs">
        <li class="nav-item">
          <a class="nav-link active" data-tabs="tab" data-value="home" aria-selected="true">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" data-tabs="tab" data-value="about" aria-selected="false">About</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" data-tabs="tab" data-value="blog" aria-selected="false">Posts</a>
        </li>
      </ul>
    - |-
      <div class="tab-content" data-tabs="myTabs">
        <div class="tab-pane fade" role="tab-panel">
          <h1>Pane 1</h1>
          <p>Lorem Dapibus Malesuada Cras Cursus</p>
        </div>
        <div class="tab-pane fade" role="tab-panel">
          <h1>Pane 2</h1>
          <p>Magna Aenean Mattis Ultricies Ridiculus</p>
        </div>
      </div>
---
