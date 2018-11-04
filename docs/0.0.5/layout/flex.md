---
this: flex
filename: R/flex.R
layout: page
requires: ~
roxygen:
  title: Flex layout
  description: |-
    Use `flex()` to control how a flex container tag element places its flex
    items or child tag elements. For more on turning a tag element into a flex
    container see [display()](/yonder/0.0.5/design/display.html). By default tag elements within a flex container
    are treated as flex items.
  parameters:
  - name: .tag
    description: A tag element.
  - name: direction
    description: |-
      A [responsive](/yonder/0.0.5/responsive.html) argument. One of `"row"` or `"column"`
      specifying the placement of flex items, defaults to `NULL`. If `"row"`
      items are placed vertically, if `"column"` items are placed horizontally.
      Browsers place items vertically by default.
  - name: reverse
    description: |-
      A [responsive](/yonder/0.0.5/responsive.html) argument. One of `TRUE` or `FALSE` specifying
      if flex items are placed in reverse order, defaults to `NULL`. If `TRUE`
      items are placed from right to left when `direction` is `"row"` or bottom
      to top when `direction` is `"column"`.
  - name: justify
    description: |-
      A [responsive](/yonder/0.0.5/responsive.html) argument. One of `"start"`, `"end"`,
      `"center"`, `"between"`, or `"around"` specifying how items are
      horizontally aligned, defaults to `NULL`. See the **justify** section below
      for more on how the different values affect horizontal spacing.
  - name: align
    description: |-
      A [responsive](/yonder/0.0.5/responsive.html) argument. One of `"start"`, `"end"`, `"center"`,
      `"baseline"`, or `"stretch"` specifying how items are vertically aligned,
      defaults to `NULL`. See the **align** section below for more on how the
      different values affect vertical spacing.
  - name: wrap
    description: |-
      A [responsive](/yonder/0.0.5/responsive.html) argument. One of `TRUE` or `FALSE` specifying
      whether to wrap flex items inside the flex containter, `.tag`, defaults
      to `NULL`. If `TRUE` items wrap inside the container, if `FALSE` items will
      not wrap. See the **wrap** section below for more.
  sections: []
  return: ~
  family: layout
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Different <code>direction</code>s</h3>
  - type: markdown
    value: |
      <p>Many of <code>flex()</code>'s arguments are viewport responsive and below we will see how useful this can be. On small screens the flex items are placed vertically and can occupy the full width of the mobile device. On medium or larger screens the items are placed horizontally once again.</p>
  - type: source
    value: |2-

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
  - type: output
    value: |-
      <div class="d-flex flex-column flex-md-row bg-grey border">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
  - type: markdown
    value: |
      <p><em>Resize the browser for this example.</em></p>
  - type: markdown
    value: |
      <p>You can keep items as a column by specifying only <code>&quot;column&quot;</code>.</p>
  - type: source
    value: |2-

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
  - type: output
    value: |-
      <div class="d-flex flex-column">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
  - type: markdown
    value: |
      <h3>Spacing items with <code>justify</code></h3>
  - type: markdown
    value: |
      <p>Below is a series of examples showing how to change the horizontal alignment of your flex items. Let's start by pushing items to the beginning of their parent container.</p>
  - type: source
    value: |2-

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
  - type: output
    value: |-
      <div class="d-flex justify-content-start">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
  - type: markdown
    value: |
      <p>We can also push items to the <strong>end</strong>.</p>
  - type: source
    value: |2-

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
  - type: output
    value: |-
      <div class="d-flex justify-content-end">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
  - type: markdown
    value: |
      <p>Without using a table layout we can <strong>center</strong> items.</p>
  - type: source
    value: |2-

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
  - type: output
    value: |-
      <div class="d-flex justify-content-center">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
  - type: markdown
    value: |
      <p>You can also put space <strong>between</strong> items</p>
  - type: source
    value: |2-

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
  - type: output
    value: |-
      <div class="d-flex justify-content-between">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
  - type: markdown
    value: |
      <p>... or put space <strong>around</strong> items.</p>
  - type: source
    value: |2-

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
  - type: output
    value: |-
      <div class="d-flex justify-content-around">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
  - type: markdown
    value: |
      <p><em>The &quot;between&quot; and &quot;around&quot; values come from the original CSS values &quot;space-between&quot; and &quot;space-around&quot;.</em></p>
  - type: markdown
    value: |
      <h3>Wrap onto new lines</h3>
  - type: markdown
    value: |
      <p>Using flexbox we can also control how items wrap onto new lines.</p>
  - type: source
    value: |2-

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
  - type: output
    value: |-
      <div class="d-flex flex-wrap">
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
        <div class="p-3 border">A flex item</div>
      </div>
---
