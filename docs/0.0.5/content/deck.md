---
this: deck
filename: R/card.R
layout: page
include: ~
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
      An [img()](/yonder/0.0.5/content/img.html) element specifying an image to add to the card,
      defaults to `NULL`, in which case an image is not added.
  - name: footer
    description: |-
      A character string or tag element specifying the footer of the
      card, defaults to `NULL`, in which case a footer is not added.
  sections: []
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>A simple card</h3>
  - type: source
    value: |2-

      column(
        width = 4,
        card("Praesent fermentum tempor tellus.")
      )
  - type: output
    value: |-
      <div class="col-4">
        <div class="card">
          <div class="card-body">
            <p class="card-text">Praesent fermentum tempor tellus.</p>
          </div>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Adding a title, subtitle</h3>
  - type: source
    value: |2-

      column(
        width = 4,
        card(
          title = "Mauris mollis tincidunt felis.",
          subtitle = "Phasellus at dui in ligula mollis ultricies.",
          "Nullam tempus. Mauris mollis tincidunt felis.",
          "Nullam libero mauris, consequat quis, varius et, dictum id, arcu."
        )
      )
  - type: output
    value: |-
      <div class="col-4">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Mauris mollis tincidunt felis.</h5>
            <h6 class="card-subtitle">Phasellus at dui in ligula mollis ultricies.</h6>
            <p class="card-text">Nullam tempus. Mauris mollis tincidunt felis.</p>
            <p class="card-text">Nullam libero mauris, consequat quis, varius et, dictum id, arcu.</p>
          </div>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Styling cards</h3>
  - type: source
    value: |2-

      deck(
        card(
          header = div("Donec pretium posuere tellus") %>%
            background("teal"),
          "Donec hendrerit tempor tellus.",
          "Cras placerat accumsan nulla."
        ),
        card(
          "Aliquam posuere.",
          "Phasellus neque orci, porta a, aliquet quis, semper a, massa.",
          "Pellentesque dapibus suscipit ligula."
        ) %>%
          border("orange"),
        card(
          header = div("Phasellus lacus") %>%
            background("indigo"),
          "Etiam laoreet quam sed arcu.",
          "Etiam vel tortor sodales tellus ultricies commodo.",
          footer = "Nam euismod tellus id erat."
        ) %>%
            background("grey")
      )
  - type: output
    value: |-
      <div class="card-deck">
        <div class="card">
          <div class="bg-teal card-header">Donec pretium posuere tellus</div>
          <div class="card-body">
            <p class="card-text">Donec hendrerit tempor tellus.</p>
            <p class="card-text">Cras placerat accumsan nulla.</p>
          </div>
        </div>
        <div class="card border border-orange">
          <div class="card-body">
            <p class="card-text">Aliquam posuere.</p>
            <p class="card-text">Phasellus neque orci, porta a, aliquet quis, semper a, massa.</p>
            <p class="card-text">Pellentesque dapibus suscipit ligula.</p>
          </div>
        </div>
        <div class="card bg-grey">
          <div class="bg-indigo card-header">Phasellus lacus</div>
          <div class="card-body">
            <p class="card-text">Etiam laoreet quam sed arcu.</p>
            <p class="card-text">Etiam vel tortor sodales tellus ultricies commodo.</p>
          </div>
          <div class="card-footer">Nam euismod tellus id erat.</div>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Cards with list groups</h3>
  - type: source
    value: |2-

      column(
        width = 4,
        card(
          listGroupThruput(
            id = "important",
            flush = TRUE,
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
      )
  - type: output
    value: |-
      <div class="col-4">
        <div class="card">
          <div class="yonder-list-group list-group list-group-flush" data-multiple="true" id="important">
            <a class="list-group-item">Pellentesque tristique imperdiet tortor.</a>
            <a class="list-group-item">Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</a>
            <a class="list-group-item">Phasellus purus.</a>
          </div>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Tabbed content in cards</h3>
  - type: source
    value: |2-

      card(
        header = navInput(
          id = "tabs",
          choices = c("Tab 1", "Tab 2", "Tab 3"),
          appearance = "tabs"
        ),
        navContent(
          navPane(
            "Phasellus purus.",
            "Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.",
            "Phasellus purus."
          ),
          navPane(
            "Donec at pede. Praesent augue.",
            "Pellentesque tristique imperdiet tortor."
          ),
          navPane(
            "Fusce suscipit, wisi nec facilisis facilisis,",
            "est dui fermentum leo, quis tempor ligula erat quis odio.",
            "Donec hendrerit tempor tellus."
          )
        )
      )
  - type: output
    value: |-
      <div class="card">
        <div class="card-header">
          <ul class="yonder-nav nav nav-tabs card-header-tabs" id="tabs">
            <li class="nav-item">
              <a class="nav-link active" href="#" data-value="Tab 1">Tab 1</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#" data-value="Tab 2">Tab 2</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#" data-value="Tab 3">Tab 3</a>
            </li>
          </ul>
        </div>
        <div class="card-body">
          <div class="tab-content">
            <div class="tab-pane fade" role="tab-panel" id="Phasellus purus.">
              Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.
              Phasellus purus.
            </div>
            <div class="tab-pane fade" role="tab-panel" id="Donec at pede. Praesent augue.">Pellentesque tristique imperdiet tortor.</div>
            <div class="tab-pane fade" role="tab-panel" id="Fusce suscipit, wisi nec facilisis facilisis,">
              est dui fermentum leo, quis tempor ligula erat quis odio.
              Donec hendrerit tempor tellus.
            </div>
          </div>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Deck of cards</h3>
  - type: source
    value: |2-

      deck(
        card(
          title = "Nullam tristique",
          "Fusce sagittis, libero non molestie mollis, magna orci ultrices ",
          "dolor, at vulputate neque nulla lacinia eros.",
          "Nunc rutrum turpis sed pede.",
          footer = "Cras placerat accumsan nulla."
        ),
        card(
          title = "Integer placerat",
          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec ",
          "hendrerit tempor tellus.",
          footer = "Cras placerat accumsan nulla."
        ),
        card(
          title = "Phasellus neque",
          "Donec at pede. Etiam vel neque nec dui dignissim bibendum.",
          footer = "Cras placerat accumsan nulla."
        )
      )
  - type: output
    value: |-
      <div class="card-deck">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Nullam tristique</h5>
            <p class="card-text">Fusce sagittis, libero non molestie mollis, magna orci ultrices </p>
            <p class="card-text">dolor, at vulputate neque nulla lacinia eros.</p>
            <p class="card-text">Nunc rutrum turpis sed pede.</p>
          </div>
          <div class="card-footer">Cras placerat accumsan nulla.</div>
        </div>
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Integer placerat</h5>
            <p class="card-text">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec </p>
            <p class="card-text">hendrerit tempor tellus.</p>
          </div>
          <div class="card-footer">Cras placerat accumsan nulla.</div>
        </div>
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Phasellus neque</h5>
            <p class="card-text">Donec at pede. Etiam vel neque nec dui dignissim bibendum.</p>
          </div>
          <div class="card-footer">Cras placerat accumsan nulla.</div>
        </div>
      </div>
---
