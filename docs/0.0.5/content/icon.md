---
this: icon
filename: R/icons.R
layout: page
roxygen:
  title: Icon elements
  description: |-
    Include an icon in your application. For now only Font Awesome icons are
    included.
  parameters:
  - name: name
    description: A character string specifying the name of the icon.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  - name: set
    description: |-
      A character string specifying the icon set to choose from, defaults
      to `"NULL"`, in which case all icon sets are searched.
  sections: ~
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - type: source
    value: |2-


      if (interactive()) {
        shinyApp(
          ui = container(
            center = TRUE,
            selectInput(
              id = "name",
              choices = unique(icons$name)
            ) %>%
              margin(3),
            div(
              htmlOutput("icon")
            ) %>%
              margin(3) %>%
              display("flex") %>%
              flex(direction = "column", align = "center")
          ),
          server = function(input, output) {
            output$icon <- renderUI({
              icon(input$name) %>%
                font(size = "8x")
            })
          }
        )
      }

      if (interactive()) {
        shinyApp(
          ui = container(
            lapply(
              unique(icons$set),
              function(s) {
                div(
                  lapply(
                    unique(icons[icons$set == s, ]$name),
                    function(nm) {
                      icon(nm, set = s) %>%
                        margin(2)
                    }
                  )
                ) %>%
                  display("flex") %>%
                  flex(wrap = TRUE)
              }
            )
          ),
          server = function(input, output) {

          }
        )
      }
  - type: code
    value:
    - |-
      if (interactive()) {
          shinyApp(ui = container(center = TRUE, selectInput(id = "name", choices = unique(icons$name)) %>% margin(3), div(htmlOutput("icon")) %>% margin(3) %>% display("flex") %>% flex(direction = "column", align = "center")), server = function(input, output) {
              output$icon <- renderUI({
                  icon(input$name) %>% font(size = "8x")
              })
          })
      }
    - |-
      if (interactive()) {
          shinyApp(ui = container(lapply(unique(icons$set), function(s) {
              div(lapply(unique(icons[icons$set == s, ]$name), function(nm) {
                  icon(nm, set = s) %>% margin(2)
              })) %>% display("flex") %>% flex(wrap = TRUE)
          })), server = function(input, output) {
          })
      }
---
