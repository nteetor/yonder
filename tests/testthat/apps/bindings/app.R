# Test app exercising every bsides input binding. Driven by
# tests/testthat/test-bindings-e2e.R via {shinytest2}.
#
# Server-side update_*() calls are triggered from tests with
# Shiny.setInputValue("do_<action>", ..., {priority: "event"}).

library(yonder)
library(bslib)

shinyApp(
  ui = page_fluid(
    input_button(id = "btn", text = "Count"),
    input_link(id = "lnk", label = "Go"),
    input_checkbox(id = "chk", choice = "Include"),
    input_checkbox_group(id = "chkgrp", choices = c("A", "B", "C")),
    input_radio_group(id = "rad", choices = c("R1", "R2")),
    input_range(id = "rng"),
    input_select(id = "sel", choices = c("S1", "S2", "S3")),
    input_text(id = "txt"),
    input_text_group(id = "txtgrp", left = "$"),
    input_list_group(id = "lst", choices = paste("Item", 1:3)),
    input_menu(id = "mnu", text = "Menu", choices = c("One", "Two")),
    input_form(
      id = "frm",
      input_text(id = "frmtext"),
      form_submit_button(label = "Submit", value = "go")
    ),
    modal_dialog(id = "mdl", "Hello modal")
  ),
  server = function(input, output, session) {
    trigger <- function(id, handler) {
      observeEvent(input[[id]], handler(), ignoreInit = TRUE)
    }

    trigger("do_update_button", \() update_button("btn", text = "Updated"))
    trigger("do_update_link", \() update_link("lnk", label = "NewLink"))
    trigger("do_update_checkbox", \() update_checkbox("chk", value = TRUE))
    trigger(
      "do_update_checkbox_group",
      \() update_checkbox_group("chkgrp", select = "B")
    )
    trigger(
      "do_update_radio",
      \() update_radio_group("rad", choices = c("N1", "N2"), select = "N1")
    )
    trigger("do_update_range", \() update_range("rng", value = 30))
    trigger("do_update_select", \() update_select("sel", select = "S3"))
    trigger("do_update_text", \() update_text("txt", value = "from-server"))
    trigger(
      "do_update_text_group",
      \() update_text_group("txtgrp", value = "77")
    )
    trigger(
      "do_update_list_group",
      \() update_list_group("lst", select = c("Item 1", "Item 3"))
    )
    trigger(
      "do_update_menu",
      \() update_menu_input("mnu", label = "Picked", select = "Two")
    )
    trigger("do_submit_form", \() submit_form("frm", "go"))
    trigger("do_show_modal", \() modal_show("mdl"))
    trigger("do_hide_modal", \() modal_hide())
  }
)
