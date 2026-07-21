# yonder

## Documenting

- Rebuild the package namespace and documentation with `devtools::document()`. 
- Run roxygen examples with `devtools::run_examples()`.

## Checking (R CMD check)

- Check the package with `devtools::check()`

## Testing

- Run the R suite with `Rscript -e 'devtools::test()'` (or `devtools::test()` in
  the session). Scope a run with `devtools::test(filter = "multi-select")`.
- The client-side DOM harness is separate: `npm run test-dom`
  regenerates the R-rendered fixtures (`srcts/tests/gen-html.R`) and
  runs `srcts/tests/test-bindings.mjs` in jsdom.
- Both the harness and e2e load the committed bundles in `inst/www/` —
  run `npm run build` first whenever `srcts/` or the SCSS changed.

## Code design and style

- When defining top-level functions, use the following format. The `function`
  keyword is on its own line, required arguments are placed ahead of `...`,
  optional arguments are placed after `...`.
  ```r
  function_name <-
    function(
      argument_required,
      ...,
      argument_optional = c("value1", "value2"),
      argument_ignored_by_default = NULL
    ) {
      
    }
  ```

- When defining optional function arguments avoid boolean values and prefer
  character values. The argument name combined with the possible value describes
  the argument's effect. 

## CSS

### Bootstrap classes

- When a custom component needs a Bootstrap component's look, style our
  own class from Bootstrap variables/tokens (`--bs-*`, Sass vars like
  `$input-focus-*`) rather than adding the Bootstrap component class
  (e.g. `.form-control`). Component classes carry layout assumptions
  (display, single-line heights, padding) that fight custom layouts;
  the variables give the same visual surface without the baggage.
