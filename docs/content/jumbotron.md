---
name: jumbotron
title: Jumbotron
description: A showcase banner, good for front or splash pages.
parameters:
- name: '...'
  description: |-
    Tag elements passed as child elements or named arguments passed as
    HTML attributes to the parent element.
- name: title
  description: |-
    A character string specifying a title for the jumbotron,
    defaults to `NULL`, in which case a title is not added.
- name: subtitle
  description: |-
    A character string specifying a subtitle for the jumbotron,
    defaults to `NULL`, in which case a subtitle is not added.
family: content
export: ''
examples:
- title: Landing page welcome
  body:
  - type: code
    content: |-
      jumbotron(
        title = "Welcome, welcome!",
        subtitle = "Here we are showcasing the very showcase itself.",
        tags$p(
          "Now let's talk more about that superb new feature."
        )
      )
    output: |-
      <div class="jumbotron">
        <h1 class="display-3"></h1>
        <p class="lead">Here we are showcasing the very showcase itself.</p>
        <p>Now let's talk more about that superb new feature.</p>
      </div>
rdname: jumbotron
sections: []
layout: doc
---
