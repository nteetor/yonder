---
this: scroll
filename: R/design.R
layout: page
roxygen:
  title: Vertical and horizontal scroll
  description: |-
    Many of the applications you build depsite a complex layout will still fit
    onto a single page. To help scroll long content along side shorter content
    use the `scroll()` utility function.
  parameters:
  - name: .tag
    description: A tag element.
  - name: direction
    description: |-
      One of `"x"` or `"y"` specifying which direction to scroll
      the tag's content, defaults to `"y"`, in which case vertical scroll is
      applied.
  sections: ~
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h2>A simple scroll</h2>
  - type: source
    value: |2-

      div(
        lapply(
          rep("Integer placerat tristique nisl.", 20),
          p
        )
      ) %>%
        height(50) %>%
        scroll()
  - type: output
    value: |-
      <div class="h-50 scroll-y">
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
      </div>
---
