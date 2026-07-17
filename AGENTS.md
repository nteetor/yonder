# yonder

## Documentation

- Rebuild the package namespace and documentation with `devtools::document()`. 

## Testing

- Run the R suite with `Rscript -e 'devtools::test()'` (or `devtools::test()` in
  the session). Scope a run with `devtools::test(filter = "multi-select")`.
- The client-side DOM harness is separate: `npm run test-dom`
  regenerates the R-rendered fixtures (`srcts/tests/gen-html.R`) and
  runs `srcts/tests/test-bindings.mjs` in jsdom.
- Both the harness and e2e load the committed bundles in `inst/www/` —
  run `npm run build` first whenever `srcts/` or the SCSS changed.

## CSS / Bootstrap

- When a custom component needs a Bootstrap component's look, style our
  own class from Bootstrap variables/tokens (`--bs-*`, Sass vars like
  `$input-focus-*`) rather than adding the Bootstrap component class
  (e.g. `.form-control`). Component classes carry layout assumptions
  (display, single-line heights, padding) that fight custom layouts;
  the variables give the same visual surface without the baggage.
