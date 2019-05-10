---
name: alert
title: Alert boxes
description: |-
  Use an alert element to let the user know of successes or to call attention
  to problems.
parameters:
- name: '...'
  description: |-
    Character strings specifying the text of the alert or additional
    named arguments passed as HTML attributes to the alert element.
- name: dismissible
  description: |-
    One of `TRUE` or `FALSE` specifying if the alert may be
    dismissed by the user, deafults to `TRUE`.
- name: fade
  description: |-
    One of `TRUE` or `FALSE` specifying if the alert fades out or
    immediately disappears when dismissed, defaults to `TRUE`.
family: content
export: ''
examples:
- title: Default alert
  body:
  - type: code
    content: |-
      alert("Donec at pede.") %>%
        background("blue")
    output: |-
      <div class="alert alert-dismissible fade show alert-blue" role="alert">
        Donec at pede.
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
- title: A more complex alert
  body:
  - type: code
    content: |-
      alert(
        h4("Etiam vel tortor sodales"),
        hr(),
        p("Fusce commodo.")
      ) %>%
        background("amber")
    output: |-
      <div class="alert alert-dismissible fade show alert-amber" role="alert">
        <h4 class="alert-heading">Etiam vel tortor sodales</h4>
        <hr/>
        <p>Fusce commodo.</p>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
rdname: alert
sections: []
layout: doc
---
