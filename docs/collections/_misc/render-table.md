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
  source:
  - renderTable <- function(expr, env = parent.frame(), quoted = FALSE) {
  - '  dfFunc <- shiny::exprToFunction(expr, env, quoted)'
  - '  function() {'
  - '    df <- dfFunc()'
  - '    if (is.null(df)) {'
  - '      return(list())'
  - '    }'
  - '    if (!is.data.frame(df)) {'
  - '      stop('
  - '        "invalid `renderTable` value, `expr` returned ",'
  - '        class(df), ", expecting data frame", call. = FALSE'
  - '      )'
  - '    }'
  - '    return(list(columns = as.list(colnames(df) %||% rep('
  - '      "",'
  - '      NCOL(df)'
  - '    )), data = jsonlite::toJSON(df)))'
  - '  }'
  - '}'
---
