---
name: navbar
title: Page and content navigation
description: |-
  Add a navigation bar to your application with `navbar()`. Navigation bars may
  include a tab toggle (useful for multi-page applications), inline forms
  (perhaps a search feature or login item), or character strings to add simple
  text. Navbars are responsive and will collapse on small screens, think mobile
  device. A button is automatically added to toggle between the collapsed and
  expanded states.
parameters:
- name: '...'
  description: |-
    A tab toggle, inline forms, or text to add to include as part of
    the navigation bar.
- name: brand
  description: |-
    A tag element or text placed on the left end of the navbar,
    defaults to `NULL`, in which case nothing is added.
family: layout
export: ''
examples:
- title: Navbar with tabs
  body:
  - type: code
    content: |-
      div(
        navbar(
          brand = "Navbar",
          navInput(
            id = "tabs",
            choices = c("Home", "About", "Our process")
          ) %>%
            margin(right = "auto"),
          formInput(
            inline = TRUE,
            id = "navForm",
            searchInput("search", placeholder = "Search") %>%
              margin(right = c(sm = 2)),
            submit = submitInput("Search") %>%
              background("amber")
          )
        ) %>%
          background("teal"),
        container(
          navContent(
            navPane(
              h3("Home")
            ),
            navPane(
              h3("About")
            ),
            navPane(
              h3("The process")
            )
          )
        )
      )
    output: |-
      <div>
        <nav class="navbar navbar-expand-lg navbar-light bg-teal">
          <a class="navbar-brand" href="#">Navbar</a>
          <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navContent-715-626" aria-controls="navContent-715-626" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navContent-715-626">
            <ul class="yonder-nav nav mr-auto navbar-nav" id="tabs">
              <li class="nav-item">
                <button class="nav-link btn btn-link" value="Home">Home</button>
              </li>
              <li class="nav-item">
                <button class="nav-link btn btn-link" value="About">About</button>
              </li>
              <li class="nav-item">
                <button class="nav-link btn btn-link" value="Our process">Our process</button>
              </li>
            </ul>
            <form class="yonder-form form-inline" id="navForm">
              <div class="yonder-textual mr-sm-2" id="search">
                <input class="form-control" type="search" placeholder="Search"/>
                <div class="invalid-feedback"></div>
              </div>
              <button class="yonder-submit btn btn-amber" role="button" value="Search">Search</button>
            </form>
          </div>
        </nav>
        <div class="container-fluid">
          <div class="tab-content">
            <div class="tab-pane fade" role="tab-panel" id="&lt;h3&gt;Home&lt;/h3&gt;"></div>
            <div class="tab-pane fade" role="tab-panel" id="&lt;h3&gt;About&lt;/h3&gt;"></div>
            <div class="tab-pane fade" role="tab-panel" id="&lt;h3&gt;The process&lt;/h3&gt;"></div>
          </div>
        </div>
      </div>
rdname: navbar
sections: []
layout: doc
---
