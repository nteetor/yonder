---
this: card
filename: R/card.R
layout: page
roxygen:
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
      An [img()](/yonder/0.0.5/img().html) element specifying an image to add to the card,
      defaults to `NULL`, in which case an image is not added.
  - name: footer
    description: |-
      A character string or tag element specifying the footer of the
      card, defaults to `NULL`, in which case a footer is not added.
  sections: ~
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      card("Praesent fermentum tempor tellus.")
      card(
        title = "Mauris mollis tincidunt felis.",
        subtitle = "Phasellus at dui in ligula mollis ultricies.",
        "Nullam tempus. Mauris mollis tincidunt felis.",
        "Nullam libero mauris, consequat quis, varius et, dictum id, arcu."
      )
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
      card(
        header = "Nunc rutrum turpis sed pede.",
        title = "Sed bibendum.",
        "Etiam vel neque nec dui dignissim bibendum. Etiam vel neque nec dui dignissim bibendum.",
        buttonInput(id = NULL, label = "Phasellus purus")
      )
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
      card(
        header = div("Donec pretium posuere tellus.") %>%
          background("teal"),
        "Donec hendrerit tempor tellus.",
        "Cras placerat accumsan nulla."
      )
    output: |-
      <div class="card">
        <div class="bg-teal card-header">Donec pretium posuere tellus.</div>
        <div class="card-body">
          <p class="card-text">Donec hendrerit tempor tellus.</p>
          <p class="card-text">Cras placerat accumsan nulla.</p>
        </div>
      </div>
---
