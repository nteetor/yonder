---
layout: page
slug: card
roxygen:
  rdname: ~
  name: card
  doctype: ~
  title: Cards, blocks of content
  description: |-
    Create blocks of content with `card`. `deck` is used to group and add padding
    is placed around any number of cards. Additionally, grouping cards with
    `deck` has the benefit of aligning the footer of each card.
  parameters:
  - name: '...'
    description: |-
      For **card**, character strings, tag elements, or list groups to
        include as the body of a card or additional named arguments passed as HTML
        attributes to the parent element.

        For **deck**, any number of cards or additional named arguments passed as
        HTML attributes to the parent element.
  - name: header
    description: |-
      A character string or tag element specifying the header of the
      card, defaults to `NULL`, in which case a header is not added.
  - name: title
    description: |-
      A character string or tag element specifying the title of the
      card, defaults to `NULL`, in which case a title is not added.
  - name: subtitle
    description: |-
      A character string or tag element specifying the subtitle of
      the card, defaults to `NULL`, in which case a subtitle is not added.
  - name: image
    description: |-
      An [img()] element specifying an image to add to the card,
      defaults to `NULL`, in which case an image is not added.
  - name: footer
    description: |-
      A character string or tag element specifying the footer of the
      card, defaults to `NULL`, in which case a footer is not added.
  sections: ~
  examples:
  - card("Praesent fermentum tempor tellus.")
  - |-
    card(
      title = "Mauris mollis tincidunt felis.",
      subtitle = "Phasellus at dui in ligula mollis ultricies.",
      "Nullam tempus. Mauris mollis tincidunt felis.",
      "Nullam libero mauris, consequat quis, varius et, dictum id, arcu."
    )
  - |-
    card(
      listGroupThruput(
        id = NULL,
        listGroupItem(
          "Pellentesque tristique imperdiet tortor."
        ),
        listGroupItem(
          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
        ),
        listGroupItem(
          "Phasellus purus."
        )
      )
    )
  - |-
    card(
      header = "Nunc rutrum turpis sed pede.",
      title = "Sed bibendum.",
      "Etiam vel neque nec dui dignissim bibendum. Etiam vel neque nec dui dignissim bibendum.",
      buttonInput(id = NULL, label = "Phasellus purus")
    )
  - |-
    card(
      header = tabTabs(
        id = "myCardTabs",
        labels = c("Phasellus", "Donec", "Fusce")
      ),
      tabContent(
        tabs = "myCardTabs",
        tabPane(
          "Phasellus purus. Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus."
        ),
        tabPane(
          "Donec at pede. Praesent augue."
        ),
        tabPanel(
          "Fusce suscipit, wisi nec facilisis facilisis, est dui fermentum leo, quis tempor ligula erat quis odio."
        )
      )
    )
  - |
    card(
      header = div("Donec pretium posuere tellus.") %>%
        background("teal"),
      "Donec hendrerit tempor tellus.",
      "Cras placerat accumsan nulla."
    )
  aliases: ~
  family: ~
  export: yes
  filename: card.R
  source: "card <- function(..., header = NULL, title = NULL, subtitle = NULL, \n
    \   image = NULL, footer = NULL) {\n    args <- list(...)\n    attrs <- attribs(args)\n
    \   title <- if (!is.null(title)) {\n        if (is_tag(title)) {\n            tagAddClass(title,
    \"card-title\")\n        }\n        else {\n            tags$h5(class = \"card-title\",
    title)\n        }\n    }\n    subtitle <- if (!is.null(subtitle)) {\n        if
    (is_tag(subtitle)) {\n            tagAddClass(subtitle, \"card-subtitle\")\n        }\n
    \       else {\n            tags$h6(class = \"card-subtitle\", subtitle)\n        }\n
    \   }\n    isListGroup <- function(x) tagHasClass(x, \"list-group\")\n    body
    <- lapply(dropNulls(c(list(title, subtitle), elements(args))), \n        function(el)
    {\n            if (isListGroup(el)) {\n                return(tagAddClass(el,
    \"list-group-flush\"))\n            }\n            tags$div(class = \"card-body\",
    if (!is_tag(el)) {\n                tags$p(class = \"card-text\", el)\n            }\n
    \           else {\n                el\n            })\n        })\n    if (length(body))
    {\n        body <- Reduce(x = body[-1], init = list(body[[1]]), \n            function(acc,
    el) {\n                if (isListGroup(acc[[length(acc)]])) {\n                  c(acc,
    list(el))\n                }\n                else {\n                  acc[[length(acc)]][[\"children\"]]
    <- c(acc[[length(acc)]][[\"children\"]], \n                    el$children)\n
    \                 acc\n                }\n            })\n    }\n    header <-
    if (!is.null(header)) {\n        if (is_tag(header)) {\n            if (tagHasClass(header,
    \"nav-tabs\")) {\n                tags$div(class = \"card-header\", tagAddClass(header,
    \n                  \"card-header-tabs\"))\n            }\n            else {\n
    \               tagAddClass(header, \"card-header\")\n            }\n        }\n
    \       else {\n            tags$div(class = \"card-header\", header)\n        }\n
    \   }\n    image <- if (!is.null(image)) {\n        tagAddClass(image, \"card-img-top\")\n
    \   }\n    footer <- if (!is.null(footer)) {\n        if (is_tag(footer)) {\n
    \           tagAddClass(footer, \"card-footer\")\n        }\n        else {\n
    \           tags$div(class = \"card-footer\", footer)\n        }\n    }\n    tags$div(class
    = \"card\", header, body, footer)\n}"
---
