---
name: badgeElement
title: Badges
description: Small highlighted content which scales to its parent's size.
parameters:
- name: '...'
  description: |-
    Named arguments passed as HTML attributes to the parent
    element or tag elements passed as children.
details: |-
  Use [replaceElement()] and [removeElement()] to modify the contents of a
  badge.
family: rendering
export: ''
examples:
- title: Possible colors
  body:
  - type: code
    content: |-
      colors <- c(
        "red", "purple", "indigo", "blue", "cyan", "teal", "green",
        "yellow", "amber", "orange", "grey", "white"
      )

      div(
        lapply(colors, function(color) {
          badgeElement(color) %>%
            background(color) %>%
            margin(2)
        })
      ) %>%
        display("flex") %>%
        flex(wrap = TRUE)
    output: |-
      <div class="d-flex flex-wrap">
        <span class="yonder-element badge badge-red m-2">red</span>
        <span class="yonder-element badge badge-purple m-2">purple</span>
        <span class="yonder-element badge badge-indigo m-2">indigo</span>
        <span class="yonder-element badge badge-blue m-2">blue</span>
        <span class="yonder-element badge badge-cyan m-2">cyan</span>
        <span class="yonder-element badge badge-teal m-2">teal</span>
        <span class="yonder-element badge badge-green m-2">green</span>
        <span class="yonder-element badge badge-yellow m-2">yellow</span>
        <span class="yonder-element badge badge-amber m-2">amber</span>
        <span class="yonder-element badge badge-orange m-2">orange</span>
        <span class="yonder-element badge badge-grey m-2">grey</span>
        <span class="yonder-element badge badge-white m-2">white</span>
      </div>
rdname: badgeElement
sections: []
layout: doc
---
