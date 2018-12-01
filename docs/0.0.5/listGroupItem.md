---
this: listGroupItem
filename: R/list-group.R
layout: page
requires: ~
roxygen:
  title: List group thruputs
  description: |-
    A way of handling and outlining content as a list. List groups function
    similarly to checkbox groups. A list group returns a reactive vector of
    values from its active (selected) list group items. List group items are
    selected or unselected by clicking on them.
  parameters:
  - name: '...'
    description: |-
      For `listGroupThruput()`, additional named arguments passed on as
      HTML attributes to the parent list group element.

      For `listGroupItem()`, the text or HTML content of the list group item.

      For `renderListGroup()`, any number of expressions which return a
      `listGroupItem()` or calls to `listGroupItem()`.
  - name: multiple
    description: |-
      One of `TRUE` or `FALSE` specifyng if multiple list group
      items may be selected, defaults to `TRUE`.
  - name: flush
    description: |-
      One of `TRUE` or `FALSE` specifying if the list group is
      rendered without a border, defaults to `FALSE`. Removing the list group
      border is useful when rendering a list group inside a custom parent
      container, e.g. inside a `card()`.
  - name: value
    description: |-
      A character string specifying the value of the list group item,
      defaults to `NULL`, in which case the list group item has no value. List
      group items without a value are not actionable, i.e. they cannot be
      selected.
  - name: selected
    description: |-
      `TRUE` or `FALSE` specifying if the list group item is
      selected by default, defaults to `FALSE`.
  - name: disabled
    description: |-
      `TRUE` or `FALSE` specifying if the list group item can be
      selected, defaults to `FALSE`.
  - name: env
    description: |-
      The environment in which to evalute the expressions based to
      `renderListGroup()`.
  sections: []
  return: ~
  family: ~
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Getting started</h3>
  - type: source
    value: |2-

      listGroupThruput(
        id = NULL,
        listGroupItem(
          rangeInput(NULL)
        )
      )
  - type: output
    value: |-
      <div class="yonder-list-group list-group" data-multiple="true">
        <a class="list-group-item">
          <div class="yonder-range bg-grey">
            <input class="range" type="text" data-type="single" data-min="0" data-max="100" data-step="1" data-from="0" data-prettify-separator="," data-grid="TRUE" data-grid-num="4"/>
          </div>
        </a>
      </div>
  - type: markdown
    value: |
      <h3>Fancier list items</h3>
  - type: source
    value: |2-

      lessons <- list(
        stars = c(
          "The stars and moon are far too bright",
          "Their beam and smile splashing o'er all",
          "To illuminate while turning my sight",
          "From the shadows wherein deeper shadows fall"
        ),
        joy = c(
          "A single step, her hand aloft",
          "More than a step, a joyful bound",
          "The moment, precious, small, soft",
          "And within a truth was found"
        )
      )

      listGroupThruput(
        id = NULL,
        multiple = FALSE,
        listGroupItem(
          value = "stars",
          h5("Stars"),
          lessons[["stars"]][1]
        ),
        listGroupItem(
          value = "joy",
          h5("Joy"),
          lessons[["joy"]][1]
        )
      )
  - type: output
    value: |-
      <div class="yonder-list-group list-group" data-multiple="false">
        <a class="list-group-item list-group-item-action" data-value="stars">
          <h5>Stars</h5>
          The stars and moon are far too bright
        </a>
        <a class="list-group-item list-group-item-action" data-value="joy">
          <h5>Joy</h5>
          A single step, her hand aloft
        </a>
      </div>
---
