---
layout: page
slug: render-table
roxygen:
  rdname: tableThruput
  name: renderTable
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: table.R
  source: "renderTable <- function(expr, env = parent.frame(), quoted = FALSE) {\n
    \   dfFunc <- shiny::exprToFunction(expr, env, quoted)\n    function() {\n        df
    <- dfFunc()\n        if (is.null(df)) {\n            return(list())\n        }\n
    \       if (!is.data.frame(df)) {\n            stop(\"invalid `renderTable` value,
    `expr` returned \", \n                class(df), \", expecting data frame\", call.
    = FALSE)\n        }\n        return(list(columns = as.list(colnames(df) %||% rep(\"\",
    \n            NCOL(df))), data = jsonlite::toJSON(df)))\n    }\n}"
---
