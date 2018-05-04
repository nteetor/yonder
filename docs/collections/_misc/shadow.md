---
layout: page
slug: shadow
roxygen:
  rdname: ~
  name: shadow
  doctype: ~
  title: Add shadows to tag elements
  description: |-
    The `shadow` utility applies a shadow to a tag element. Elements with a
    shadow may appear to pop off the page. The material design set of components,
    used on Android and for Google applications, commonly uses shadowing.
    Although `"none"` is an allowed `size`, most elements do not have a shadow by
    default.
  parameters:
  - name: tag
    description: A tag element.
  - name: size
    description: |-
      One of `"none"`, `"small"`, `"regular"`, or `"large"` specifying
      the amount of shadow added, defaults to `"regular"`.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = tagList(
          navbar(brand = "Navbar") %>%
            background("cyan", +1) %>%
            shadow("small"),
          container(
            "Cras mattis consectetur purus sit amet fermentum. Donec sed ",
            "odio dui. Lorem ipsum dolor sit amet, consectetur adipiscing ",
            "elit. Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
            "venenatis vestibulum."
          ) %>%
            padding(3)
        ),
        server = function(input, output) {

        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: utilities.R
  source: "shadow <- function(tag, size = \"regular\") {\n    if (!re(size, \"none|small|regular|large\",
    len0 = FALSE)) {\n        stop(\"invalid `shadow()` argument, `size` must be one
    of \", \n            \"\\\"none\\\", \\\"small\\\", \\\"regular\\\", or \\\"large\\\"\",
    \n            call. = FALSE)\n    }\n    size <- switch(size, none = \"none\",
    small = \"sm\", regular = NULL, \n        large = \"lg\")\n    tagAddClass(tag,
    paste0(c(\"shadow\", size), collapse = \"-\"))\n}"
---
