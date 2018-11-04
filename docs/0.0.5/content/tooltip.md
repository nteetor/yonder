---
this: tooltip
filename: R/tooltip.R
layout: page
include: ~
roxygen:
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
  sections: []
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Tooltips galore</h3>
  - type: source
    value: |2-

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
  - type: output
    value: |-
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
            <input class="custom-control-input" type="radio" id="radio-239-57" name="radios" data-value="Ready" checked/>
            <label class="custom-control-label" for="radio-239-57">Ready</label>
          </div>
          <div class="custom-control custom-radio">
            <input class="custom-control-input" type="radio" id="radio-257-813" name="radios" data-value="Set"/>
            <label class="custom-control-label" for="radio-257-813">Set</label>
          </div>
          <div class="custom-control custom-radio">
            <input class="custom-control-input" type="radio" id="radio-282-111" name="radios" data-value="Go"/>
            <label class="custom-control-label" for="radio-282-111">Go</label>
          </div>
          <div class="invalid-feedback"></div>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Describing links (link inputs)</h3>
  - type: source
    value: |2-

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
  - type: output
    value: "<div>\n  <p>Nunc rutrum turpis sed pede.</p>\n  <p>\n    Donec posuere
      augue in \n    <span class=\"yonder-link\" data-toggle=\"tooltip\" data-placement=\"top\"
      title=\"This is bound to do something\">quam.</span>\n  </p>\n  <p>\n    Etiam
      vel tortor sodales \n    <span class=\"yonder-link\" data-toggle=\"tooltip\"
      data-placement=\"top\" title=\"Tell us more?\">tellus</span>\n     ultricies
      commodo.\n  </p>\n</div>"
---
