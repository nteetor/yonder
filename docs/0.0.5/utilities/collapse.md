---
this: collapse
filename: R/collapse.R
layout: page
roxygen:
  title: Collapsible sections
  description: |-
    The `collapse()` function allows you to make a tag element collapsible. The
    state of the element, shown or hidden, is toggled using `hideCollapse()`,
    `showCollapse()`, and `toggleCollapse()`.
  parameters:
  - name: tag
    description: A tag element.
  - name: id
    description: |-
      A character string specifying an HTML id. Pass this id to the
      `*Collapse()` functions to hide or show the collapsible element.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      collapsible div.
  sections: ~
  return: ~
  family: utilities
  name: ~
  rdname: ~
  examples:
  - title: Making an element collapsible
    source: |-
      # On the server side you will need to call `hideCollapse` or
      # `toggleCollapse`
      card(
        '"The Time Traveller (for so it will be convenient to speak
          of him) was expounding a recondite matter to us. His grey eyes
          shone and twinkled, and his usually pale face was flushed and
          animated. The fire burned brightly, and the soft radiance of
          the incandescent lights in the lilies of silver caught the
          bubbles that flashed and passed in our glasses."'
      ) %>%
        background("grey") %>%
        collapse("an-html-id")  # pass this id to the `*Collapse` function
    output:
    - |-
      <div class="card bg-grey" data-collapse-id="an-html-id">
        <div class="card-body">
          <p class="card-text">"The Time Traveller (for so it will be convenient to speak
          of him) was expounding a recondite matter to us. His grey eyes
          shone and twinkled, and his usually pale face was flushed and
          animated. The fire burned brightly, and the soft radiance of
          the incandescent lights in the lilies of silver caught the
          bubbles that flashed and passed in our glasses."</p>
        </div>
      </div>
---
