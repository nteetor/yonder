# yonder 0.2.0

## Breaking changes

* Select input `selected` behaviour has been reverted, `selected` will once
  again default to the first choice unless otherwise specified

## Bug fixes

* Select input will correctly start with the default value specified by
  `selected`

## New features

* Chip input argument `stack` added to control the ordering of selected chips

## Minor improvements

* Upgraded to Bootstrap 4.4.1

# yonder 0.1.2

## Breaking changes

* Select inputs no longer default to the first possible value
* The `column()` function's `width` argument now accepts the values: `1:12`,
  `"content"`, and `"equal"`. The new `"content"` value is equivalent to the
  previous value `"auto"`. `"equal"` is the new default and the placeholder
  value, so as to allow `column(width = c(xs = 2, lg = "equal"))`.
* The `modal()` function no longer includes a `title` argument, instead use
  `header`

## Bug fixes

* Added javascript polyfill for Internet Explorer NodeList forEach method (#158)
* Arguments passed to `alert()` are now evaluated in the correct environment
  (#171)
* The function `updateRadiobarInput()` correctly selects a new choice if only
  `selected` is specified (#155)
* The function `updateMenuInput()` correctly selects a new choice if only
  `selected` is specified
* The function `updateTextInput()` correctly passes `valid` and `invalid`
  feedback
* Display headings no longer ignore elements passed as arguments (#164)
* Input update functions now correctly handle named values passed as `selected`
  by removing names (#170)

## New features

* Button input tooltips may now be updated with `updateButtonInput()`
* The update input functions may now remove all of an input's choices by passing
  a zero-length value as `choices`
* The new `updateFormInput()` may be used to trigger a form submission from
  the server (#160)
* The new `webpage()` function may be used as the top-level element of an
  application
* `AsIs` character vectors are now concatenated with `<br>` when passing
  character values as choices or labels (#159)

## Major improvements

* Web resources are no longer attached to each element, instead they are
  only attached to the top-most parent element

## Minor improvements

* The documentation for select inputs no longer mentions the `multiple` argument
  (#167)
* Added `placeholder` argument to chip inputs
* The `collapsePane()` function now includes the argument `animate` to
  optionally prevent animation when toggling a collapsible pane
* A menu input's label may now be updated with `updateMenuInput()`
* Darkened the default grey color (#162)
* Link inputs now inherit their text align property (#163)


# yonder 0.1.1

* Initial CRAN release
