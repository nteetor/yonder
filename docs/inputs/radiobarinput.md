---
name: radiobarInput
title: Radiobar input
description: A stylized radio input.
inheritParams: checkboxInput
parameters:
- name: choices
  description: |-
    A character vector or list of tag elements specifying the
    labels of the input's choices.
- name: values
  description: |-
    A vector specifying the values of the input's choices,
    defaults to `choices`.
- name: selected
  description: |-
    One of `values` specifying the input's default selected
    choice, defualts to `values[[1]]`.
family: inputs
export: ''
examples:
- title: Radiobars
  body:
  - type: code
    content: |-
      radiobarInput(
        id = "radiobar1",
        choices = c(
          "fusce sagittis",
          "libero non molestie",
          "magna orci",
          "ultrices dolor"
        ),
        selected = "ultrices dolor"
      ) %>%
        background("grey")
    output: |-
      <div class="yonder-radiobar btn-group btn-group-toggle d-flex" id="radiobar1" data-toggle="buttons">
        <label class="btn btn-grey">
          <input name="radiobar1" type="radio" value="fusce sagittis" autocomplete="off"/>
          fusce sagittis
        </label>
        <label class="btn btn-grey">
          <input name="radiobar1" type="radio" value="libero non molestie" autocomplete="off"/>
          libero non molestie
        </label>
        <label class="btn btn-grey">
          <input name="radiobar1" type="radio" value="magna orci" autocomplete="off"/>
          magna orci
        </label>
        <label class="btn active btn-grey">
          <input name="radiobar1" type="radio" value="ultrices dolor" checked autocomplete="off"/>
          ultrices dolor
        </label>
      </div>
rdname: radiobarInput
sections: []
layout: doc
---
