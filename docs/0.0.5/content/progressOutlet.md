---
this: progressOutlet
filename: R/progress.R
layout: page
roxygen:
  title: Progress bars
  description: |-
    Create simple or composite progress bars. To create a composite progress bar
    pass multiple calls to `bar` to a progress output. Each `bar` component has
    its own id, value, label, and attributes. Furthermore, utility functions may
    be applied to individual bars for added customization.
  parameters:
  - name: id
    description: A character string specifying the HTML id of a progress output.
  - name: '...'
    description: |-
      One or more `bar` elements passed to a progress output or named
      arguments passed as HTML attributes to the parent element.
  - name: value
    description: |-
      An integer between 0 and 100 specifying the initial value
      of a bar.
  - name: label
    description: |-
      A character string specifying the label of a bar, defaults to
      `NULL`, in which case a label is not added.
  - name: striped
    description: |-
      If `TRUE`, the progress bar has a striped gradient, defaults
      to `FALSE`.
  - name: session
    description: A reactive context, defaults to [getDefaultReactiveDomain()](/yonder/0.0.5/getDefaultReactiveDomain().html).
  sections: ~
  return: ~
  family: content
  name: ~
  rdname: ~
  examples: []
---
