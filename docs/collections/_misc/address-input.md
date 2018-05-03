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
  - name: placeholders
    description: |-
      If `TRUE`, placeholder text is added to all the address
      input fields, defaults to `TRUE`.
  - name: abbreviate
    description: |-
      If `TRUE`, state abbreviations are used instead of state
      names, defaults to `TRUE`.
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
  source:
  - addressInput <- function(id) {
  - '  ids <- ID(rep.int("address", 5))'
  - '  tags$div('
  - '    class = "dull-address-input", id = id, tags$div('
  - '      class = "form-group",'
  - '      tags$label('
  - '        `for` = ids[[1]], class = "col-form-label",'
  - '        "Address"'
  - '      ), tags$input('
  - '        type = "text", class = "form-control",'
  - '        id = ids[[1]], placeholder = "Street address, P.O. box"'
  - '      )'
  - '    ),'
  - '    tags$div('
  - '      class = "form-group", tags$label('
  - '        `for` = ids[[2]],'
  - '        class = "form-control-label sr-only", "Address line 2"'
  - '      ),'
  - '      tags$input('
  - '        type = "text", class = "form-control",'
  - '        id = ids[[2]], placeholder = "Apartment, floor, unit"'
  - '      )'
  - '    ),'
  - '    tags$div(class = "form-row", tags$div('
  - '      class = "form-group col-md-6 mt-auto",'
  - '      tags$label('
  - '        class = "form-control-label", `for` = ids[[3]],'
  - '        "City"'
  - '      ), tags$input('
  - '        type = "text", class = "form-control",'
  - '        id = ids[[3]]'
  - '      )'
  - '    ), tags$div('
  - '      class = "form-group col-md-3",'
  - '      tags$label('
  - '        class = "form-control-label", `for` = ids[[4]],'
  - '        "State"'
  - '      ), tags$input('
  - '        type = "text", class = "form-control",'
  - '        id = ids[[4]]'
  - '      )'
  - '    ), tags$div('
  - '      class = "form-group col-md-3 mt-auto",'
  - '      tags$label('
  - '        class = "form-control-label", `for` = ids[[5]],'
  - '        "Zip"'
  - '      ), tags$input('
  - '        type = "text", class = "form-control",'
  - '        id = ids[[5]]'
  - '      )'
  - '    ))'
  - '  )'
  - '}'
---
