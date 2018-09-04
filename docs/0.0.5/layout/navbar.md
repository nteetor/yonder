---
this: navbar
filename: R/navbar.R
layout: page
roxygen:
  title: Page and content navigation
  description: |-
    Add a navigation bar to your application with `navbar()`. Navigation bars may
    include a tab toggle (useful for multi-page applications), inline forms
    (perhaps a search feature or login item), or character strings to add simple
    text. Navbars are responsive and will collapse on small screens, think mobile
    device. A button is automatically added to toggle between the collapsed and
    expanded states.
  parameters:
  - name: '...'
    description: |-
      A tab toggle, inline forms, or text to add to include as part of
      the navigation bar.
  - name: brand
    description: |-
      A tag element or text placed on the left end of the navbar,
      defaults to `NULL`, in which case nothing is added.
  sections: ~
  return: ~
  family: layout
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      if (interactive()) {
        shinyApp(
          ui = tagList(
            navbar(
              brand = "Navbar",
              tabTabs("myTabs", c("Home", "About", "Our process")) %>%
                margin(right = "auto"),
              formInput(
                inline = TRUE,
                id = "navForm",
                searchInput("search", placeholder = "Search") %>%
                  margin(right = c(sm = 2)),
                submit = submitInput("Search") %>%
                  background("amber")
              )
            ) %>%
              background("teal"),
            container(
              tabContent(
                tabs = "myTabs",
                tabPane(
                  h3("Home")
                ),
                tabPane(
                  h3("About")
                ),
                tabPane(
                  h3("The process")
                )
              )
            )
          ),
          server = function(input, output) {
          }
        )
      }
    output: []
---
