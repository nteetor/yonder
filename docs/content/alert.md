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
- name: title
  description: |-
    A character string or tag element specifying a heading for the
    alert, defaults to `NULL`, in which case a title is not added.
family: content
export: ''
examples:
- title: Default alert
  body:
  - type: code
    content: alert("Donec at pede.")
    output: <div class="alert alert-grey fade show" role="alert">Donec at pede.</div>
- title: A more complex alert
  body:
  - type: code
    content: |-
      alert(
        p("Etiam vel tortor sodales"),
        hr(),
        p("Fusce commodo.")
      ) %>%
        background("amber")
    output: |-
      <div class="alert fade show alert-amber" role="alert">
        <p>Etiam vel tortor sodales</p>
        <hr/>
        <p>Fusce commodo.</p>
      </div>
rdname: alert
sections: []
layout: doc
---
