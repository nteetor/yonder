---
this: flex
filename: R/flex.R
layout: page
roxygen:
  title: Flex layout
  description: |-
    Use `flex()` to control how a flex container tag element places its flex
    items or child tag elements. For more on turning a tag element into a flex
    container see [display()](/yonder/0.0.5/display().html). By default tag elements within a flex container
    are treated as flex items.
  parameters:
  - name: tag
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
      whether to wrap flex items inside the flex containter, `tag`, defaults
      to `NULL`. If `TRUE` items wrap inside the container, if `FALSE` items will
      not wrap. See the **wrap** section below for more.
  sections:
  - title: '`direction`'
    body: |-
      Because horizontal placement the browser default you may not often use
      `flex(.., direction = "row")`.  The responsive arguments are potentially more
      useful as shown in the following example. On small screens the flex items are
      placed vertically and can occupy the full width of the mobile device. On
      medium or larger screens the items are placed horizontally once again.

      ```
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
          direction = list(xs = "column", md = "row")
        ) %>%
        background("grey") %>%
        border()
      ```

      Here is a simpler example of a flex container with its children placed into
      columns.

      ```
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
        flex(direction = "column")
      ```
  - title: '`justify`'
    body: |-
      Below you can see how the possible `justify` values change the horizontal
      spacing of items within a flex container element.

      `"start"`

      `| Item 1 | Item 2 | Item 3 | ================= |`

      `"end"`

      `| ================= | Item 1 | Item 2 | Item 3 |`

      `"center"`

      `| ======= | Item 1 | Item 2 | Item 3 | ======= |`

      `"between"`

      `| Item 1 | ======= | Item 2 | ======= | Item 3 |`

      `"around"`

      `| == | Item 1 | == | Item 2 | == | Item 3 | == |`
  - title: '`align`'
    body: |-
      Below you can see how the possible `align` values change the vertial spacing
      of items within a flex container element.

      **`"start"`**

      ```
      | Item 1 | Item 2 | Item 3 | ================== |
      |        |        |        |                    |
      |        |        |        |                    |
      ```

      **`"end"`**,

      ```
      |        |        |        |                    |
      |        |        |        |                    |
      | Item 1 | Item 2 | Item 3 | ================== |
      ```

      **`"center"`**

      ```
      |        |        |        |                    |
      | Item 1 | Item 2 | Item 3 | ================== |
      |        |        |        |                    |
      ```

      **`"baseline"`**

      ```
      | Item 1 | Item 2 | Item 3 | ================== |
      |        |        |        |                    |
      |        |        |        |                    |
      ```

      **`"stretch"`**

      ```
      | It     | It     | It     | ================== |
      |   em   |   em   |   em   |                    |
      |      1 |      2 |      3 |                    |
      ```
  - title: '`wrap`'
    body: |-
      **`FALSE`**

      ```
      | Item | Item | Item | Item | Item | Item |
      | 1    | 2    | 3    | 4    | 5    | 6    |
      ```

      **`TRUE`**

      ```
      | Item 1 | Item 2 | Item 3 | Item 4 | === |
      | Item 5 | Item 6 | ===================== |
      ```
  return: ~
  family: layout
  name: ~
  rdname: ~
  examples: []
---
