---
this: height
filename: R/design.R
layout: page
requires: ~
roxygen:
  title: Tag element height
  description: |-
    Utility function to change a tag element's height. Height is specified
    relative to the font size of page (browser default is 16px), relative to
    their parent element, or relative to the element's content.
  parameters:
  - name: .tag
    description: A tag element.
  - name: size
    description: |-
      A character string or number specifying the height of the tag
      element. Possible values:

      An integer between 1 and 20, in which case the height of the element is
      relative to the font size of the page.

      "full", in which case the element's height is a percentage of its parent's
      height. The height of the parent element must also be specified.
      Percentages do not account for margins or padding and may cause an element
      to extend beyond its parent.

      "auto", in which case the element's height is determined by the browser.
      The browser will take into account the height, padding, margins, and border
      of the tag element's parent to keep the element from extending beyond its
      parent.

      "screen", in which case the element's height is determined by the height of
      the viewport.
  sections: []
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Relative heights</h3>
  - type: source
    value: |2-

      div(
        lapply(
          seq(2, 20, by = 2),
          function(h) {
            div() %>%
              height(h) %>%  # <-
              border("black") %>%
              margin(t = 3)
          }
        )
      )
  - type: output
    value: |-
      <div>
        <div class="h-2 border border-black m-3 mt-3"></div>
        <div class="h-4 border border-black m-3 mt-3"></div>
        <div class="h-6 border border-black m-3 mt-3"></div>
        <div class="h-8 border border-black m-3 mt-3"></div>
        <div class="h-10 border border-black m-3 mt-3"></div>
        <div class="h-12 border border-black m-3 mt-3"></div>
        <div class="h-14 border border-black m-3 mt-3"></div>
        <div class="h-16 border border-black m-3 mt-3"></div>
        <div class="h-18 border border-black m-3 mt-3"></div>
        <div class="h-20 border border-black m-3 mt-3"></div>
      </div>
---
