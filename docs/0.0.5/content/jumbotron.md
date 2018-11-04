---
this: jumbotron
filename: R/content.R
layout: page
include: ~
roxygen:
  title: Jumbotron
  description: Highlight messages.
  parameters:
  - name: title
    description: A character string specifying the jumbotron's title.
  - name: subtitle
    description: A character string specifying the jumbotron's subtitle.
  - name: '...'
    description: |-
      Additional tag elements or named arguments passed as HTML
      attributes to the parent element.
  - name: fluid
    description: |-
      One of `TRUE` or `FALSE` specifying if the jumbotron fills the
      width of its parent container, defaults to `FALSE`.
  sections: []
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h2>Landing page welcome</h2>
  - type: source
    value: |2-

      jumbotron(
        title = "Welcome, welcome!",
        subtitle = "This simple jumbotron-style component calls attention to a new feature",
        tags$p(
          "Here we can talk more about this excellently superb new feature.",
          "The best."
        )
      )
  - type: output
    value: |-
      <div class="jumbotron">
        <h1 class="display-3">Welcome, welcome!</h1>
        <p class="lead">This simple jumbotron-style component calls attention to a new feature</p>
        <hr class="my-4"/>
        <p>
          Here we can talk more about this excellently superb new feature.
          The best.
        </p>
      </div>
---
