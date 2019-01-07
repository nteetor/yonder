---
name: tooltip
title: Tooltips
description: |-
  Add a tooltip to a tag element. Tooltips may be placed above, below, left, or
  right of an element.
parameters:
- name: .tag
  description: A tag element.
- name: text
  description: The tooltip text.
- name: placement
  description: |-
    One of `"top"`, `"right"`, `"bottom"`, or `"left"`
    specifying what side of the tag element the tooltip appears on.
family: content
export: ''
examples:
- title: Tooltips galore
  body:
  - type: code
    content: |-
      formGroup(
        label = tags$label(
          "An exciting input",
          tooltip(span(icon("info-circle")), "What is exciting here?")
        ),
        radioInput(
          id = "radios",
          choices = c("Ready", "Set", "Go")
        )
      )
    output: |-
      <div class="form-group">
        <label>
          <label>
            An exciting input
            <span data-toggle="tooltip" data-placement="top" title="What is exciting here?">
              <i class="fa fa-info-circle"></i>
            </span>
          </label>
        </label>
        <div class="yonder-radio" id="radios">
          <div class="custom-control custom-radio">
            <input class="custom-control-input" type="radio" id="radio-703-137" name="radios" value="Ready" checked/>
            <label class="custom-control-label" for="radio-703-137">Ready</label>
          </div>
          <div class="custom-control custom-radio">
            <input class="custom-control-input" type="radio" id="radio-726-378" name="radios" value="Set"/>
            <label class="custom-control-label" for="radio-726-378">Set</label>
          </div>
          <div class="custom-control custom-radio">
            <input class="custom-control-input" type="radio" id="radio-468-236" name="radios" value="Go"/>
            <label class="custom-control-label" for="radio-468-236">Go</label>
          </div>
          <div class="invalid-feedback"></div>
        </div>
      </div>
- title: Describing links (link inputs)
  body:
  - type: code
    content: |-
      div(
        p("Nunc rutrum turpis sed pede."),
        p(
          "Donec posuere augue in ",
          linkInput(NULL, "quam.") %>%
            tooltip("This is bound to do something")
        ),
        p(
          "Etiam vel tortor sodales ",
          linkInput(NULL, "tellus") %>%
            tooltip("Tell us more?"),
          " ultricies commodo."
        )
      )
    output: "<div>\n  <p>Nunc rutrum turpis sed pede.</p>\n  <p>\n    Donec posuere
      augue in \n    <button class=\"yonder-link btn btn-link\" data-toggle=\"tooltip\"
      data-placement=\"top\" title=\"This is bound to do something\">quam.</button>\n
      \ </p>\n  <p>\n    Etiam vel tortor sodales \n    <button class=\"yonder-link
      btn btn-link\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Tell us
      more?\">tellus</button>\n     ultricies commodo.\n  </p>\n</div>"
rdname: tooltip
sections: []
layout: doc
---
