# Generates component markup from the real R constructors for the DOM test
# harness (test-bindings.mjs). Run from the package root, normally via:
#
#   npm run test-dom
#
# Output lands in srcts/tests/html/ (gitignored; regenerated every run).

options(yonder.deps = FALSE)
suppressMessages(pkgload::load_all(quiet = TRUE))

out_dir <- file.path("srcts", "tests", "html")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

render <- function(name, tag) {
  path <- file.path(out_dir, paste0(name, ".html"))
  writeLines(as.character(htmltools::doRenderTags(tag)), path)
}

render("button", input_button(id = "btn", text = "Count"))
render("checkbox", input_checkbox(id = "chk", choice = "Include"))
render(
  "checkbox-group",
  input_checkbox_group(id = "chkgrp", choices = c("A", "B", "C"))
)
render(
  "form",
  input_form(
    id = "frm",
    input_text(id = "frmtext"),
    form_submit_button(label = "Submit", value = "go")
  )
)
render("link", input_link(id = "lnk", label = "Go"))
render(
  "list-group",
  input_list_group(id = "lst", choices = c("Item 1", "Item 2", "Item 3"))
)
render(
  "menu",
  input_menu(id = "mnu", text = "Menu", choices = c("One", "Two"))
)
render(
  "chip-group",
  input_chip_group(
    id = "cg",
    choices = c("Red", "Green", "Blue"),
    values = c("r", "g", "b")
  )
)
render(
  "chip-group-none",
  input_chip_group(
    id = "cg3",
    choices = c("Red", "Green", "Blue"),
    values = c("r", "g", "b"),
    select = NULL
  )
)
render(
  "chip-group-select",
  input_chip_group(
    id = "cg2",
    choices = c("Small", "Medium", "Large"),
    values = c("s", "m", "l"),
    select = "m",
    type = "warning"
  )
)
render(
  "multi-select",
  input_multi_select(
    id = "ms",
    choices = c("Red", "Green", "Blue"),
    values = c("r", "g", "b"),
    select = "r"
  )
)
render(
  "multi-select-free",
  input_multi_select(id = "msfree", edit = "free", placeholder = "Add a tag")
)
render(
  "radio-group",
  input_radio_group(id = "rad", choices = c("Veggie", "Meat"))
)
render("range", input_range(id = "rng"))
render("select", input_select(id = "sel", choices = c("S1", "S2", "S3")))
render("text-group", input_text_group(id = "txtgrp", left = "$"))
render("modal", modal_dialog(id = "mdl", "Hello modal"))

cat("wrote", length(dir(out_dir)), "files to", out_dir, "\n")
