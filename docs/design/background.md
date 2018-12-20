---
name: background
title: Tag element background color
description: Use `background()` to modify the background color of a tag element.
parameters:
- name: .tag
  description: A tag element.
- name: color
  description: |-
    One of `"red"`, `"purple"`, `"indigo"`, `"blue"`, `"cyan"`,
    `"teal"`, `"green"`, `"yellow"`, `"amber"`, `"orange"`, `"grey"`,
    `"white"`, or `"transparent"` character string specifying the background
    color.
family: design
export: ''
examples:
- title: '## Modifying input elements'
  body:
  - code: |-
      checkbarInput(
        id = NULL,
        choices = c(
          "Nunc rutrum turpis sed pede.",
          "Etiam vel neque.",
          "Lorem ipsum dolor sit amet."
        )
      ) %>%
        background("cyan")
    output: |-
      <div class="yonder-checkbar btn-group btn-group-toggle" data-toggle="buttons">
        <label class="btn btn-cyan">
          <input type="checkbox" autocomplete="off" value="Nunc rutrum turpis sed pede."/>
          Nunc rutrum turpis sed pede.
        </label>
        <label class="btn btn-cyan">
          <input type="checkbox" autocomplete="off" value="Etiam vel neque."/>
          Etiam vel neque.
        </label>
        <label class="btn btn-cyan">
          <input type="checkbox" autocomplete="off" value="Lorem ipsum dolor sit amet."/>
          Lorem ipsum dolor sit amet.
        </label>
      </div>
- title: '## Possible colors'
  body:
  - code: |-
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
    output: |-
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
layout: doc
---
