---
this: img
filename: R/tags.R
layout: page
roxygen:
  title: Responsive images and figures
  description: |-
    A small update to `tags$img` and `tags$figure`. Create responsive images with
    `img`. `figure` has specific arguments for an image child element and image
    caption.
  parameters:
  - name: src
    description: A character string specifying the source of the image.
  - name: image
    description: An `<img>` tag, typically a call to `img`.
  - name: caption
    description: |-
      A character string specifying the image caption, defaults to
      `NULL`.
  - name: '...'
    description: |-
      Additional tag elements or named arguments passed as HTML attributes
      to the parent element.
  sections: ~
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      if (interactive()) {
        shinyApp(
          ui = container(
            img("https://upload.wikimedia.org/wikipedia/commons/1/18/Grey_Square.svg") %>%
              float("left") %>%
              rounded(),
            img("https://upload.wikimedia.org/wikipedia/commons/1/18/Grey_Square.svg") %>%
              float("right") %>%
              rounded()
          ),
          server = function(input, output) {
          }
        )
      }
      # Thank you to Wikimedia Commons
      # Grey square provided by Johannes Rössel (Own work) [Public domain]
      if (interactive()) {
        shinyApp(
          ui = container(
            figure(
              image = rounded(img("http://bit.ly/2qchbEB")),
              caption = "Stock cat photo."
            )
          ),
          server = function(input, output) {
          }
        )
      }
    output: []
---
