---
layout: page
slug: address-input
roxygen:
  rdname: ~
  name: addressInput
  doctype: ~
  title: Address input
  description: |-
    An address input which includes a street field, apartment or unit field, city
    field, state field, and a zip code field.
  parameters:
  - name: id
    description: A character string specifying the id of the address input.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              tags$form(
                addressInput("address")
              )
            ),
            col(
              verbatimTextOutput("value")
            )
          )
        ),
        server = function(input, output) {
          output$value <- renderPrint({
            input$address
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: textual.R
  source: "addressInput <- function(id) {\n    ids <- ID(rep.int(\"address\", 5))\n
    \   tags$div(class = \"dull-address-input\", id = id, tags$div(class = \"form-group\",
    \n        tags$label(`for` = ids[[1]], class = \"col-form-label\", \n            \"Address\"),
    tags$input(type = \"text\", class = \"form-control\", \n            id = ids[[1]],
    placeholder = \"Street address, P.O. box\")), \n        tags$div(class = \"form-group\",
    tags$label(`for` = ids[[2]], \n            class = \"form-control-label sr-only\",
    \"Address line 2\"), \n            tags$input(type = \"text\", class = \"form-control\",
    \n                id = ids[[2]], placeholder = \"Apartment, floor, unit\")), \n
    \       tags$div(class = \"form-row\", tags$div(class = \"form-group col-md-6
    mt-auto\", \n            tags$label(class = \"form-control-label\", `for` = ids[[3]],
    \n                \"City\"), tags$input(type = \"text\", class = \"form-control\",
    \n                id = ids[[3]])), tags$div(class = \"form-group col-md-3\", \n
    \           tags$label(class = \"form-control-label\", `for` = ids[[4]], \n                \"State\"),
    tags$input(type = \"text\", class = \"form-control\", \n                id = ids[[4]])),
    tags$div(class = \"form-group col-md-3 mt-auto\", \n            tags$label(class
    = \"form-control-label\", `for` = ids[[5]], \n                \"Zip\"), tags$input(type
    = \"text\", class = \"form-control\", \n                id = ids[[5]]))))\n}"
---
