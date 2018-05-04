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
  examples: ''
  aliases: ~
  family: ~
  export: yes
  filename: card.R
  source: "card <- function(..., header = NULL, title = NULL, subtitle = NULL, \n
    \   image = NULL, footer = NULL) {\n    args <- list(...)\n    attrs <- attribs(args)\n
    \   isListGroup <- function(x) tagHasClass(x, \"list-group\")\n    elems <- lapply(elements(args),
    function(el) {\n        if (isListGroup(el)) {\n            return(tagAddClass(el,
    \"list-group-flush\"))\n        }\n        tags$div(class = \"card-body\", if
    (!is_tag(el)) {\n            tags$p(class = \"card-text\", el)\n        }\n        else
    {\n            el\n        })\n    })\n    if (length(elems)) {\n        elems
    <- Reduce(x = elems[-1], init = list(elems[[1]]), \n            function(acc,
    el) {\n                if (isListGroup(acc[[length(acc)]])) {\n                  c(acc,
    list(el))\n                }\n                else {\n                  acc[[length(acc)]][[\"children\"]]
    <- c(acc[[length(acc)]][[\"children\"]], \n                    el$children)\n
    \                 acc\n                }\n            })\n    }\n    header <-
    if (!is.null(header)) {\n        if (is_tag(header)) {\n            if (tagHasClass(header,
    \"nav-tabs\")) {\n                tags$div(class = \"card-header\", tagAddClass(header,
    \n                  \"card-header-tabs\"))\n            }\n            else {\n
    \               tagAddClass(header, \"card-header\")\n            }\n        }\n
    \       else {\n            tags$div(class = \"card-header\", header)\n        }\n
    \   }\n    title <- if (!is.null(title)) {\n        if (is_tag(title)) {\n            tagAddClass(title,
    \"card-title\")\n        }\n        else {\n            tags$h5(class = \"card-title\",
    title)\n        }\n    }\n    subtitle <- if (!is.null(subtitle)) {\n        if
    (is_tag(subtitle)) {\n            tagAddClass(subtitle, \"card-subtitle\")\n        }\n
    \       else {\n            tags$h6(class = \"card-subtitle\", subtitle)\n        }\n
    \   }\n    image <- if (!is.null(image)) {\n        tagAddClass(image, \"card-img-top\")\n
    \   }\n    footer <- if (!is.null(footer)) {\n        if (is_tag(footer)) {\n
    \           tagAddClass(footer, \"card-footer\")\n        }\n        else {\n
    \           tags$div(class = )\n        }\n    }\n    tags$div(class = \"card\",
    header, image, if (!is.null(title) || \n        !is.null(subtitle)) {\n        tags$div(class
    = \"card-body\", title, subtitle)\n    }, elems, footer)\n}"
---
