---
this: sparklineOutput
filename: R/sparkline.R
layout: page
roxygen:
  title: Sparkline output
  description: Display concise, reactive inline bar, line, or dot charts.
  parameters:
  - name: id
    description: A character string specifying the id of the sparkline output.
  - name: type
    description: |-
      One of `"bar"`, `"dot"`, or `"dotline"` specifying the type of
      chart to render, defaults to `"bar"`.
  - name: labels
    description: |-
      If `TRUE`, the first and last value of the sparkline data
      are used as labels, defaults to `TRUE`.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  - name: expr
    description: |-
      An expression which returns a numeric vector specifying the
      values of the sparkline. These values will be scaled to 0 through 100.
  - name: env
    description: |-
      The environment in which to evaluate `expr`, defaults to the
      calling environment.
  - name: quoted
    description: |-
      One of `TRUE` or `FALSE` specifying if `expr` is a quoted
      expression.
  sections: ~
  return: ~
  family: outputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Bar chart</h3>
  - type: markdown
    value: |
      <p>In this example we pass a formatted string of values to <code>sparklineOutput</code>. However, in practice, you will use <code>renderSparkline</code> to update a sparkline output.</p>
  - type: source
    value: |2-

      sparklineOutput(
        id = NULL,
        type = "bar",
        "{30,20,44,50,90}"
      )
  - type: output
    value: <span class="yonder-sparkline sparks-bar" data-labels="true">{30,20,44,50,90}</span>
  - type: markdown
    value: |
      <h3>Dot chart</h3>
  - type: source
    value: |2-

      sparklineOutput(
        id = NULL,
        type = "dot",
        "{50,33,33,75,60,20}"
      )
  - type: output
    value: <span class="yonder-sparkline sparks-dot" data-labels="true">{50,33,33,75,60,20}</span>
  - type: markdown
    value: |
      <h3>Dotline chart</h3>
  - type: markdown
    value: |
      <p>Note that although in these examples the values passed are between 0 and 100, a requirement of the sparkline library used by yonder, when using <code>renderSparkline</code> values are scaled for you.</p>
  - type: source
    value: |2-

      sparklineOutput(
        id = NULL,
        type = "dotline",
        "{20,40,78,32,45,56,90,13,10}"
      )
  - type: output
    value: <span class="yonder-sparkline sparks-dotline" data-labels="true">{20,40,78,32,45,56,90,13,10}</span>
---
