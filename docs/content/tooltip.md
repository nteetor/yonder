---
name: tooltip
title: Button or link tooltips
description: Use `tooltip()` to contruct a tooltip for a button or link input.
parameters:
- name: '...'
  description: |-
    Character strings or tag elements (such as `em` or `b`) specifying
    the contents of the tooltip.
- name: placement
  description: |-
    One of `"top"`, `"right"`, `"bottom"`, or `"left"`
    specifying what side of the tag element the tooltip appears on.
- name: fade
  description: |-
    One of `TRUE` or `FALSE` specifying if the tooltip fades in when
    shown and fades out when hidden, defaults to `TRUE`.
family: content
export: ''
examples:
- title: Link with tooltip
  body:
  - type: code
    content: |-
      linkInput(
        id = "link1",
        "A link",
        tooltip = tooltip("But, with a tooltip!")
      )
    output: <button class="yonder-link btn btn-link" id="link1" data-animation="true"
      data-html="true" data-placement="top" title="But, with a tooltip!" data-toggle="tooltip">A
      link</button>
rdname: tooltip
sections: []
layout: doc
---
