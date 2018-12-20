---
name: responsive
title: Responsive arguments
description: |-
  A responsive argument may be a single value or a named list. Possible names
  includes `default` or `xs`, `sm`, `md`, `lg`, and `xl`. Specifying a single
  unnamed value is equivalent to specifying `default` or `xs`. The possible
  values will be described in the specific help page. Most responsive arguments
  will default to `NULL` in which case no corresponding style is applied.

  Responsive arguments allow you to apply styles to tag elements based on the
  size of the viewport. This is important when developing applications for both
  web and mobile.  Specifying a single unnamed value the style will be applied
  for all viewport sizes. Use the names above to apply a style for viewports of
  that size and larger. For example, specifying `list(default = x, md = y)`
  will apply `x` on extra small and small viewports, but for medium, large, and
  extra large viewports `y` is applied.

  Styles for larger viewports take precedance. See below for details about each
  breakpoint.

  **extra small**

  How: pass a single value, use name `xs`, or use name `default`.

  When: the style is always applied, unless supplanted by a style for any other
  viewport size.

  **small**

  How: use name `sm`.

  When: the style is applied when the viewport is at least 576px wide, think
  landscape phones.

  **medium**

  How: use name `md`.

  When: the style is applied when the viewport is at least 768px wide, think
  tablets.

  **large**

  How: use name `lg`.

  When: the style is applied when the viewport is at least 992px wide, think
  laptop or smaller desktops.

  **extra large**

  How: use name `xl`.

  When: the style is applied when the viewport is at least 1200px wide, think
  large desktops.
layout: doc
---
