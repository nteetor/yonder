---
layout: page
slug: navbar
roxygen:
  rdname: ~
  name: navbar
  doctype: ~
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
  examples: |
    if (interactive()) {
      shinyApp(
        ui = tagList(
          navbar(
            brand = "Navbar",
            tabToggle("myTabs", c("Home", "About", "Our process")) %>%
              margins(c(0, "auto", 0, 0)),
            formInput(
              inline = TRUE,
              id = "navForm",
              searchInput("search", placeholder = "Search") %>%
                margins(sm = c(0, 2, 0, 0)),
              submit = submitInput("Search") %>%
                background("amber", +1)
            )
          ) %>%
            background("teal", +1),
          container(
            tabContent(
              toggle = "myTabs",
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
  aliases: ~
  family: ~
  export: yes
  filename: navbar.R
  source: "navbar <- function(..., brand = NULL) {\n    args <- list(...)\n    attrs
    <- attribs(args)\n    elems <- lapply(elements(args), function(arg) {\n        if
    (tagHasClass(arg, \"nav\")) {\n            arg <- tagDropClass(arg, \"nav-tabs|nav-pills\")\n
    \           arg <- tagAddClass(arg, \"navbar-nav\")\n        }\n        else if
    (tagIs(arg, \"form\")) {\n            if (!tagHasClass(arg, \"inline-form\"))
    {\n                warning(\"non-inline form element passed to `navbar()`\", \n
    \                 call. = FALSE)\n            }\n        }\n        else if (!is_tag(arg))
    {\n            arg <- tags$span(class = \"navbar-text\", arg)\n        }\n        arg\n
    \   })\n    brand <- if (!is.null(brand)) {\n        tags$a(class = \"navbar-brand\",
    href = \"#\", brand)\n    }\n    navContentId <- ID(\"navContent\")\n    this
    <- tags$nav(class = \"navbar navbar-expand-lg navbar-light\", \n        brand,
    tags$button(class = \"navbar-toggler\", type = \"button\", \n            `data-toggle`
    = \"collapse\", `data-target` = paste0(\"#\", \n                navContentId),
    `aria-controls` = navContentId, \n            `aria-expanded` = \"false\", `aria-label`
    = \"Toggle navigation\", \n            fontAwesome(\"bars\")), tags$div(class
    = \"collapse navbar-collapse\", \n            id = navContentId, elems), include(\"core\"))\n
    \   this <- tagConcatAttributes(this, attrs)\n    this\n}"
---
