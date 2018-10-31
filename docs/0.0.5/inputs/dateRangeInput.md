---
this: dateRangeInput
filename: R/datetime.R
layout: page
roxygen:
  title: Date inputs
  description: |-
    A date time picker. Alternatively, use the date time range picker to select
    a range of dates. The value of the date range picker is always two dates.
  parameters:
  - name: id
    description: A character specifying the id of the datetime input.
  - name: choices
    description: |-
      Date objects or character strings specifying the set of
      dates the user may choose from, defaults to `NULL` in which case the user
      may choose any date.
  - name: selected
    description: |-
      Date objects or character strings specifying the dates
      selected by default in the date input, defaults `NULL` in which case no
      dates are selected by default.
  - name: min,max
    description: |-
      Date objects or character strings in the format `YYYY-mm-dd`
      specifying the minimum and maximum date that can be selecetd, both
      default to `NULL` in which case there is no minimum or maximum value
      respectively.
  - name: multiple
    description: |-
      One of `TRUE` or `FALSE` specifying whether multiple dates
      may be selected, if `TRUE` the user may select multiple dates and a vector
      of one or more dates is returned as the reactive value.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  sections: []
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Preselect a date</h3>
  - type: source
    value: |2-

      dateInput(
        id = NULL,
        selected = Sys.Date() + 1
      )
  - type: output
    value: <input class="yonder-date form-control" type="text" data-default-date="2018-11-01"
      data-date-format="Y-m-d"/>
  - type: markdown
    value: |
      <h3>Set a min and max</h3>
  - type: source
    value: |2-

      dateInput(
        id = NULL,
        min = Sys.Date() - 3,
        max = Sys.Date() + 3
      )
  - type: output
    value: <input class="yonder-date form-control" type="text" data-min-date="2018-10-28"
      data-max-date="2018-11-03" data-date-format="Y-m-d"/>
  - type: markdown
    value: |
      <h3>Select multiple dates</h3>
  - type: source
    value: |2-

      dateInput(
        id = NULL,
        choices = Sys.Date() + seq(-6, 6, by = 2),
        selected = Sys.Date() + 1,
        multiple = TRUE
      )
  - type: output
    value: <input class="yonder-date form-control" type="text" data-default-date="2018-11-01"
      data-enable="2018-10-25\,2018-10-27\,2018-10-29\,2018-10-31\,2018-11-02\,2018-11-04\,2018-11-06"
      data-date-format="Y-m-d" data-mode="multiple"/>
  - type: markdown
    value: |
      <h3>Date ranges</h3>
  - type: source
    value: |2-

      dateRangeInput(
        id = NULL,
        selected = c(Sys.Date(), Sys.Date() + 3)
      )
  - type: output
    value: <input class="yonder-date form-control" type="text" data-default-date="2018-10-31\,2018-11-03"
      data-date-format="Y-m-d" data-mode="range"/>
---
