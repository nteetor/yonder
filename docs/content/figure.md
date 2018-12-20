---
name: figure
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
family: content
export: ''
layout: doc
---
