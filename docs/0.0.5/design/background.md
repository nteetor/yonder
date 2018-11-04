---
this: background
filename: R/design.R
layout: page
include: ~
roxygen:
  title: Tag element background color
  description: Use `background()` to change the background color of a tag element.
  parameters:
  - name: .tag
    description: A tag element.
  - name: color
    description: |-
      A character string specifying the background color, see below
      for all possible values.
  sections: []
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Modifying input elements</h3>
  - type: source
    value: |2-

      checkbarInput(
        id = NULL,
        choices = c(
          "Nunc rutrum turpis sed pede.",
          "Etiam vel neque.",
          "Lorem ipsum dolor sit amet."
        )
      ) %>%
        background("cyan")
  - type: output
    value: |-
      <div class="yonder-checkbar btn-group btn-group-toggle" data-toggle="buttons">
        <label class="btn btn-cyan">
          <input type="checkbox" autocomplete="off" data-value="Nunc rutrum turpis sed pede."/>
          <span>Nunc rutrum turpis sed pede.</span>
        </label>
        <label class="btn btn-cyan">
          <input type="checkbox" autocomplete="off" data-value="Etiam vel neque."/>
          <span>Etiam vel neque.</span>
        </label>
        <label class="btn btn-cyan">
          <input type="checkbox" autocomplete="off" data-value="Lorem ipsum dolor sit amet."/>
          <span>Lorem ipsum dolor sit amet.</span>
        </label>
      </div>
  - type: markdown
    value: |
      <h3>Possible colors</h3>
  - type: source
    value: |2-

      colors <- c(
        "red", "purple", "indigo", "blue", "cyan", "teal", "green",
        "yellow", "amber", "orange", "grey", "white"
      )

      div(
        lapply(
          colors,
          background,
          .tag = div() %>%
            padding(5) %>%
            margin(2)
        )
      ) %>%
        display("flex") %>%
        flex(wrap = TRUE)
  - type: output
    value: |-
      <div class="d-flex flex-wrap">
        <div class="p-5 m-2 bg-red"></div>
        <div class="p-5 m-2 bg-purple"></div>
        <div class="p-5 m-2 bg-indigo"></div>
        <div class="p-5 m-2 bg-blue"></div>
        <div class="p-5 m-2 bg-cyan"></div>
        <div class="p-5 m-2 bg-teal"></div>
        <div class="p-5 m-2 bg-green"></div>
        <div class="p-5 m-2 bg-yellow"></div>
        <div class="p-5 m-2 bg-amber"></div>
        <div class="p-5 m-2 bg-orange"></div>
        <div class="p-5 m-2 bg-grey"></div>
        <div class="p-5 m-2 bg-white"></div>
      </div>
---
