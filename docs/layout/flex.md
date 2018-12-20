---
name: flex
title: Flex layout
description: |-
  Use `flex()` to control how a flex container tag element places its flex
  items or child tag elements. For more on turning a tag element into a flex
  container see [display()]. By default tag elements within a flex container
  are treated as flex items.
parameters:
- name: .tag
  description: A tag element.
- name: direction
  description: |-
    A [responsive] argument. One of `"row"` or `"column"`
    specifying the placement of flex items, defaults to `NULL`. If `"row"`
    items are placed vertically, if `"column"` items are placed horizontally.
    Browsers place items vertically by default.
- name: reverse
  description: |-
    A [responsive] argument. One of `TRUE` or `FALSE` specifying
    if flex items are placed in reverse order, defaults to `NULL`. If `TRUE`
    items are placed from right to left when `direction` is `"row"` or bottom
    to top when `direction` is `"column"`.
- name: justify
  description: |-
    A [responsive] argument. One of `"start"`, `"end"`,
    `"center"`, `"between"`, or `"around"` specifying how items are
    horizontally aligned, defaults to `NULL`. See the **justify** section below
    for more on how the different values affect horizontal spacing.
- name: align
  description: |-
    A [responsive] argument. One of `"start"`, `"end"`, `"center"`,
    `"baseline"`, or `"stretch"` specifying how items are vertically aligned,
    defaults to `NULL`. See the **align** section below for more on how the
    different values affect vertical spacing.
- name: wrap
  description: |-
    A [responsive] argument. One of `TRUE` or `FALSE` specifying
    whether to wrap flex items inside the flex containter, `.tag`, defaults
    to `NULL`. If `TRUE` items wrap inside the container, if `FALSE` items will
    not wrap. See the **wrap** section below for more.
examples:
- title: '## Different `direction`s'
  body:
  - code: ''
    output: []
- title: Many of `flex()`'s arguments are viewport responsive and below we will see
    how useful this can be. On small screens the flex items are placed vertically
    and can occupy the full width of the mobile device. On medium or larger screens
    the items are placed horizontally once again.
  body:
  - code: |-
      div(
        div("A flex item") %>%
          padding(3) %>%
          border(),
        div("A flex item") %>%
          padding(3) %>%
          border(),
        div("A flex item") %>%
          padding(3) %>%
          border()
      ) %>%
        display("flex") %>%
        flex(
          direction = list(xs = "column", md = "row")  # <-
        ) %>%
        background("grey") %>%
        border()
    output: |-
      <div class="d-flex flex-column flex-md-row bg-grey border">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
- title: '*Resize the browser for this example.*'
  body:
  - code: ''
    output: []
- title: You can keep items as a column by specifying only `"column"`.
  body:
  - code: |-
      div(
        div("A flex item") %>%
          padding(3) %>%
          border(),
        div("A flex item") %>%
          padding(3) %>%
          border(),
        div("A flex item") %>%
           padding(3) %>%
           border()
      ) %>%
        display("flex") %>%
        flex(direction = "column")  # <-
    output: |-
      <div class="d-flex flex-column">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
- title: '## Spacing items with `justify`'
  body:
  - code: ''
    output: []
- title: Below is a series of examples showing how to change the horizontal alignment
    of your flex items. Let's start by pushing items to the beginning of their parent
    container.
  body:
  - code: |-
      div(
        replicate(
          div("A flex item") %>%
            padding(3) %>%
            border(),
          n = 5,
          simplify = FALSE
        )
      ) %>%
        display("flex") %>%
        flex(justify = "start")  # <-
    output: |-
      <div class="d-flex justify-content-start">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
- title: We can also push items to the **end**.
  body:
  - code: |-
      div(
        replicate(
          div("A flex item") %>%
            padding(3) %>%
            border(),
          n = 5,
          simplify = FALSE
        )
      ) %>%
        display("flex") %>%
        flex(justify = "end")  # <-
    output: |-
      <div class="d-flex justify-content-end">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
- title: Without using a table layout we can **center** items.
  body:
  - code: |-
      div(
        replicate(
          div("A flex item") %>%
            padding(3) %>%
            border(),
          n = 5,
          simplify = FALSE
        )
      ) %>%
        display("flex") %>%
        flex(justify = "center")  # <-
    output: |-
      <div class="d-flex justify-content-center">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
- title: You can also put space **between** items
  body:
  - code: |-
      div(
        replicate(
          div("A flex item") %>%
            padding(3) %>%
            border(),
          n = 5,
          simplify = FALSE
        )
      ) %>%
        display("flex") %>%
        flex(justify = "between")  # <-
    output: |-
      <div class="d-flex justify-content-between">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
- title: '... or put space **around** items.'
  body:
  - code: |-
      div(
        replicate(
          div("A flex item") %>%
            padding(3) %>%
            border(),
          n = 5,
          simplify = FALSE
        )
      ) %>%
        display("flex") %>%
        flex(justify = "around")  # <-
    output: |-
      <div class="d-flex justify-content-around">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
- title: '*The "between" and "around" values come from the original CSS values "space-between"
    and "space-around".*'
  body:
  - code: ''
    output: []
- title: '## Wrap onto new lines'
  body:
  - code: ''
    output: []
- title: Using flexbox we can also control how items wrap onto new lines.
  body:
  - code: |-
      div(
        replicate(
          div("A flex item") %>%
            padding(3) %>%
            border(),
          n = 5,
          simplify = FALSE
        )
      ) %>%
        display("flex") %>%
        flex(wrap = TRUE)
    output: |-
      <div class="d-flex flex-wrap">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
family: layout
export: ''
layout: doc
---
