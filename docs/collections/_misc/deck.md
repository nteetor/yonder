---
layout: page
slug: deck
roxygen:
  rdname: card
  name: deck
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: |
    deck(
      card(
        title = "Nullam tristique",
        "Fusce sagittis, libero non molestie mollis, magna orci ultrices dolor, at vulputate neque nulla lacinia eros.",
        "Nunc rutrum turpis sed pede.",
        footer = "Cras placerat accumsan nulla."
      ),
      card(
        title = "Integer placerat",
        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec hendrerit tempor tellus.",
        footer = "Cras placerat accumsan nulla."
      ),
      card(
        title = "Phasellus neque",
        "Donec at pede. Etiam vel neque nec dui dignissim bibendum.",
        footer = "Cras placerat accumsan nulla."
      )
    )
  aliases: ~
  family: ~
  export: yes
  filename: card.R
  source: |-
    deck <- function(...) {
        tags$div(class = "card-deck", ...)
    }
---
