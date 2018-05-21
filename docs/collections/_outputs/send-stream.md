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
  family: outputs
  export: yes
  filename: stream.R
  source: "sendStream <- function(id, content, session = getDefaultReactiveDomain())
    {\n    if (!is.character(id)) {\n        stop(\"invalid `sendStream` argument,
    `id` must be a character string\", \n            call. = FALSE)\n    }\n    session$sendProgress(\"dull-stream\",
    list(id = id, content = content))\n}"
---
