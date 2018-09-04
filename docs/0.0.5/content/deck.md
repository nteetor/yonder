---
this: deck
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
    output:
    - |-
      <div class="card">
        <div class="card-body">
          <p class="card-text">Praesent fermentum tempor tellus.</p>
        </div>
      </div>
    - |-
      <div class="card">
        <div class="card-body">
          <h5 class="card-title">Mauris mollis tincidunt felis.</h5>
          <h6 class="card-subtitle">Phasellus at dui in ligula mollis ultricies.</h6>
          <p class="card-text">Nullam tempus. Mauris mollis tincidunt felis.</p>
          <p class="card-text">Nullam libero mauris, consequat quis, varius et, dictum id, arcu.</p>
        </div>
      </div>
    - |-
      <div class="card">
        <div class="yonder-list-group list-group list-group-flush" data-multiple="true">
          <a class="list-group-item">Pellentesque tristique imperdiet tortor.</a>
          <a class="list-group-item">Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</a>
          <a class="list-group-item">Phasellus purus.</a>
        </div>
      </div>
    - |-
      <div class="card">
        <div class="card-header">Nunc rutrum turpis sed pede.</div>
        <div class="card-body">
          <h5 class="card-title">Sed bibendum.</h5>
          <p class="card-text">Etiam vel neque nec dui dignissim bibendum. Etiam vel neque nec dui dignissim bibendum.</p>
          <button class="yonder-button btn btn-grey" type="button" role="button">Phasellus purus</button>
        </div>
      </div>
    - |-
      <div class="card">
        <div class="card-header">
          <ul class="yonder-tabs nav nav-tabs card-header-tabs" role="tablist" id="myCardTabs">
            <li class="nav-item">
              <a class="nav-link active" data-tabs="tab" data-value="Phasellus" aria-selected="true">Phasellus</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" data-tabs="tab" data-value="Donec" aria-selected="false">Donec</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" data-tabs="tab" data-value="Fusce" aria-selected="false">Fusce</a>
            </li>
          </ul>
        </div>
        <div class="card-body">
          <div class="tab-content" data-tabs="myCardTabs">
            <div class="tab-pane fade" role="tab-panel">Phasellus purus. Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.</div>
            <div class="tab-pane fade" role="tab-panel">Donec at pede. Praesent augue.</div>
            <div class="tab-pane" title="Fusce suscipit, wisi nec facilisis facilisis, est dui fermentum leo, quis tempor ligula erat quis odio." data-value="Fusce suscipit, wisi nec facilisis facilisis, est dui fermentum leo, quis tempor ligula erat quis odio."></div>
          </div>
        </div>
      </div>
    - |-
      <div class="card">
        <div class="bg-teal card-header">Donec pretium posuere tellus.</div>
        <div class="card-body">
          <p class="card-text">Donec hendrerit tempor tellus.</p>
          <p class="card-text">Cras placerat accumsan nulla.</p>
        </div>
      </div>
---
