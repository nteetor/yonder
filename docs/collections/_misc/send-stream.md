---
layout: page
slug: send-stream
roxygen:
  rdname: streamOutput
  name: sendStream
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: stream.R
  source:
  - sendStream <- function(id, content, session = getDefaultReactiveDomain()) {
  - '  if (!is.character(id)) {'
  - '    stop('
  - '      "invalid `sendStream` argument, `id` must be a character string",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  session$sendProgress("dull-stream", list(id = id, content = content))'
  - '}'
---
