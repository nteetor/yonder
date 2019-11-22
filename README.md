# yonder <img src="man/figures/logo.png" align="right" width=120 height=139 alt=""/>

An opinionated [shiny](https://github.com/rstudio/shiny) framework.

[![can we build it?](https://travis-ci.org/nteetor/yonder.svg?branch=master)](https://travis-ci.org/nteetor/yonder)

## Introduction

yonder is designed to make building pragmatic applications fun and rewarding. On
the UI side yonder features new reactive inputs such as `navInput()`,
`chipInput()` and `menuInput()`, as well as the latest Bootstrap components. On
the server side yonder includes tools for showing alerts and toasts, displaying
modal and popovers, hiding and showing panes of content, and more!

## Examples

For examples of inputs and elements built using yonder please check out
the documentation, https://nteetor.github.io/yonder/.

## Installation

You may install a stable version of yonder from CRAN.

```R
install.packages("yonder")
```

Alternatively, the development version of yonder may be installed from GitHub.

```R
# install.packages("remotes")
remotes::install_github("nteetor/yonder")
```

## Related work

* https://github.com/rstudio/shiny, the big kahuna
* https://github.com/Appsilon/shiny.semantic, build shiny applications with the
  Semantic UI library
* https://github.com/daattali/shinyjs, use JavaScript calls and events from the
  R side of shiny
* https://github.com/andrewsali/shinycssloaders, improved CSS loading animations
  for shiny
* https://github.com/merlinoa/shinyFeedback, give users validation feedback
* https://github.com/ericrayanderson/shinymaterial, build shiny apps on top of material design
