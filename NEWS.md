# yonder 0.2.0.9000

## Breaking changes

* `input_numeric()` now carries a bsides binding. Previously the input was
  driven by shiny's own `shiny.number` binding, and two behaviours change as a
  result. An emptied numeric input reports `NULL` where it used to report `NA`.

* `input_numeric()` passes `...` on as HTML attributes of the input element.
  The argument was previously accepted and silently discarded.

* Input bindings no longer use jQuery; they observe only native DOM
  events. Custom JavaScript that updates a bsides input and announces the
  change with jQuery (`$(el).trigger("change")`) must dispatch a native
  bubbling event instead:
  `el.dispatchEvent(new Event("change", { bubbles: true }))`. Server-side
  `update_*()` functions and Shiny's own machinery are unaffected. (The
  one exception is `input_form()`, which still listens to Shiny's
  jQuery-only `shiny:inputchanged` event through the page's jQuery.)

* Removed `fileInput()` in favor of the new `input_file()`. The two share
  the server value contract but nothing else; there is no deprecation
  shim. The bundled jQuery, Bootstrap 4, popper, and bs-custom-file-input
  assets went with it, along with the `yonder.deps` option they served.

* Removed `formGroup()` and `formRow()` in favor of the new `label`
  argument. Help text, previously `formGroup(help = )`, was dropped for now
  and will return in a later release.
* Removed design and style utilities in favor of {cascadess}.
* Removed the following in favor of bslib.
  * `card()`, use bslib::card.
  * `navInput()` and `navbar()`, use bslib::nav.
  * `column()`, use bslib::column.
  * `webpage()`, use bslib::page.
  * `popover()`, use bslib::popover.
  * `tooltip()`, use bslib::tooltip.
  * `switchInput()`, use bslib::input_switch.
* Renamed the `label` argument of `input_checkbox()`,
  `input_checkbox_group()`, and `input_radio_group()` to `choice_placement`,
  freeing `label` to mean label text everywhere. The argument continues to
  place a choice's text before or after its checkbox and is ignored when
  `appearance` is `"buttons"`.
* Renamed the `text` argument of `input_button()` and `input_menu()` to
  `label`, matching shiny's `actionButton()` and bslib. `update_button()`
  and `update_menu_input()` followed suit.

## New features

* New `input_file()`, `update_file()`, and `reset_file()`. By default
  files upload as soon as they are chosen; uploads travel over HTTP
  rather than the WebSocket, so the app stays responsive, and the server
  value is the familiar data frame of `name`, `size`, `type`, and
  `datapath`. Beyond `shiny::fileInput()` it adds drag and drop, paste
  (screenshots included), a cancel control for a batch in flight,
  per-file and batch progress, a collapsible file list whose summary
  line is a small template (`"{done}/{n} uploaded"`), a `height`
  argument for the drop zone, and client-side validation of size,
  `accept`, and `multiple` — the checks a drop or a paste would
  otherwise skip entirely. A batch's files upload concurrently, several
  at a time, and `input$<id>` is still set once per batch, in the order
  the files were chosen; the `bsides-file:progress` DOM event interleaves
  checkpoints from the files in flight, so a listener tracks each file's
  own figure and reads the batch fraction for the whole. Bookmark restore
  and directory upload are not supported.

* `input_file(upload_mode = "manual")` stages files instead of uploading
  them. Gestures accumulate a set — same-name additions replace, each
  row removable — and the input's Upload button starts the batch. A
  cancelled or failed batch returns to the staged set and retries whole,
  the file that failed marked in the list. New `file_upload_start()` and
  `file_upload_cancel()` drive a batch from the server, the twins of the
  Upload and Cancel buttons. Inside `input_form()` a staged batch starts
  when the form submits and the form withholds its own value until that
  upload finishes, so `input$<id>` is already set when an observer keyed
  on the submit runs. A failed or cancelled upload abandons the submit
  and leaves the set staged to retry. `upload_button = "none"` drops
  the input's own Upload button for apps where the batch starts
  elsewhere — a form's submit, or `file_upload_start()` — while the
  cancel control still appears in flight. `upload_max` caps how many
  files one batch may contain: a full staged set stops accepting files until
  one is removed, and a gesture selecting too many is rejected whole
  rather than trimmed.

* New `file_upload_status()`, `file_upload_progress()`,
  `file_upload_staged()`, and `file_upload_error()` read a file input's
  upload state ahead of its value, which is only ever set as an upload
  completes. Each is a reactive read of one companion input pushed by
  the component — an observer of the batch fraction does not re-run as
  the staged set is edited, and none of it touches `input$<id>`. Enable
  a submit while `nrow(file_upload_staged(id)) > 0`, or render a live
  progress line server-side. `file_upload_error()` returns a condition
  object covering validation rejections as well as transport failures:
  `conditionMessage()` for the headline, `$files` for a per-file frame
  of `name`, `reason`, and `limit`, and the class — `bsides_file_rejection`
  or `bsides_file_failure`, both inheriting `bsides_file_error` — to
  tell whether a staged set survived.

* New `update_numeric()`, the counterpart to `input_numeric()`. Update a
  numeric input's `value`, `min`, `max`, `step`, or disabled state from the
  server. The numeric input also gains its own binding, bringing it in line
  with the rest of the inputs.

* Inputs gain a `label` argument, the familiar way to label an input in
  shiny and bslib. A character string renders a standard label ahead of the
  input. Group inputs, whose choices no single `<label for>` can name, are
  labelled with a `<fieldset>` and `<legend>` instead.
* New `floating_label()`. Passing `floating_label("text")` as an input's
  `label` renders Bootstrap's floating label, which starts inside the input
  and floats up once the input is focused or filled. Floating labels are
  limited to the text, numeric, select, and text group inputs; the other
  inputs signal an error rather than quietly falling back to a standard
  label.

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
