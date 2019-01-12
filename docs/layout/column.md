---
name: column
title: Grid layout
description: |-
  These functions are the foundation of any application. Grid elements are
  nested as follows: `container() > columns() > column() ~ column()`. A
  `column()` may be created with an explicit width, 1 through 12. To fit a
  column automatically to its content use `width = "auto"`. To divide the space
  in a row evenly amongst all columns leave `width` as `NULL`. For examples and
  usage tips see the sections below.
parameters:
- name: '...'
  description: |-
    Any number of tags elements passed as child elements or named
    arguments passed as HTML attributes to the parent element.
- name: width
  description: |-
    A [responsive](responsive.html) argument. One of `1:12` or `"auto"`, defaults to
    `NULL`.
- name: centered
  description: |-
    One of `TRUE` or `FALSE` specifying how a container fills the
    browser or viewport window. If `TRUE` the container is responsively
    centered, otherwise, if `FALSE`, the container occupies the entire width of
    the viewport, defaults to `FALSE`.
family: layout
export: ''
examples:
- title: Equal width columns
  body:
  - type: code
    content: |-
      container(
        columns(
          column(
            "Aliquam erat volutpat."
          ),
          column(
            "Mauris mollis tincidunt felis."
          ),
          column(
            "Cum sociis natoque penatibus et magnis dis parturient montes,",
            "nascetur ridiculus mus."
          )
        )
      )
    output: |-
      <div class="container-fluid">
        <div class="row">
          <div class="col">Aliquam erat volutpat.</div>
          <div class="col">Mauris mollis tincidunt felis.</div>
          <div class="col">
            Cum sociis natoque penatibus et magnis dis parturient montes,
            nascetur ridiculus mus.
          </div>
        </div>
      </div>
- title: ' Shiny''s panel with sidebar layout'
  body:
  - type: code
    content: |-
      container(
        columns(
          column(
            width = 4,
            card(
              title = "Sidebar",
              formGroup(
                label = "Control 1",
                selectInput("control1", "...")
              ),
              formGroup(
                label = "Control 2",
                selectInput("control2", "...")
              ),
              formGroup(
                label = "Control 3",
                selectInput("control3", "...")
              )
            )
          ),
          column(
            d4("Main panel")
          )
        )
      )
    output: |-
      <div class="container-fluid">
        <div class="row">
          <div class="col-4">
            <div class="card">
              <div class="card-body">
                <h5 class="card-title">Sidebar</h5>
                <div class="form-group">
                  <label>Control 1</label>
                  <div class="yonder-select" id="control1">
                    <select class="custom-select">
                      <option value="..." selected>...</option>
                    </select>
                    <div class="invalid-feedback"></div>
                  </div>
                </div>
                <div class="form-group">
                  <label>Control 2</label>
                  <div class="yonder-select" id="control2">
                    <select class="custom-select">
                      <option value="..." selected>...</option>
                    </select>
                    <div class="invalid-feedback"></div>
                  </div>
                </div>
                <div class="form-group">
                  <label>Control 3</label>
                  <div class="yonder-select" id="control3">
                    <select class="custom-select">
                      <option value="..." selected>...</option>
                    </select>
                    <div class="invalid-feedback"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col">
            <h1 class="display-4">Main panel</h1>
          </div>
        </div>
      </div>
- title: Mobile friendly grids
  body:
  - type: text
    content: Use `column()`s [responsive](responsive.html) `width` argument to make
      mobile friendly applications.
    output: ~
  - type: code
    content: |-
      container(
        columns(
          column(
            width = c(sm = 4),
            "Mauris ac felis vel velit tristique imperdiet."
          ),
          column(
            width = c(sm = 4),
            "Nam vestibulum accumsan nisl."
          ),
          column(
            width = c(sm = 4),
            "Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus."
          )
        )
      )
    output: |-
      <div class="container-fluid">
        <div class="row">
          <div class="col-sm-4">Mauris ac felis vel velit tristique imperdiet.</div>
          <div class="col-sm-4">Nam vestibulum accumsan nisl.</div>
          <div class="col-sm-4">Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.</div>
        </div>
      </div>
  - type: text
    content: or
    output: ~
  - type: code
    content: |-
      container(
        columns(
          column(
            width = c(sm = 4),
            "Aenean in sem ac leo mollis blandit."
          ),
          column(
            width = c(sm = 8),
            "Nulla posuere. In id erat non orci commodo lobortis."
          )
        )
      )
    output: |-
      <div class="container-fluid">
        <div class="row">
          <div class="col-sm-4">Aenean in sem ac leo mollis blandit.</div>
          <div class="col-sm-8">Nulla posuere. In id erat non orci commodo lobortis.</div>
        </div>
      </div>
- title: Fit columns to their content
  body:
  - type: code
    content: |-
      container(
        columns(
          column(),
          column(
            width = "auto",
            "Cras placerat accumsan nulla. Aenean in sem ac leo mollis blandit."
          ),
          column()
        )
      )
    output: |-
      <div class="container-fluid">
        <div class="row">
          <div class="col"></div>
          <div class="col-auto">Cras placerat accumsan nulla. Aenean in sem ac leo mollis blandit.</div>
          <div class="col"></div>
        </div>
      </div>
rdname: column
sections: []
layout: doc
---
