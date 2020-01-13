#!/bin/bash

DIR="pkgdown"
INPUT="index.Rmd"
OUTPUT="index.md"

Rscript -e "\
library(withr)
library(rmarkdown)
"

Rscript -e "\
withr::with_dir('$DIR', {
  rmarkdown::render(
    input = '$INPUT',
    output_file = '$OUTPUT',
    quiet = TRUE
  )
})
"

if [ -f pkgdown/index.html ]; then
    rm pkgdown/index.html
fi

Rscript -e "\
suppressPackageStartupMessages(
suppressWarnings(
suppressMessages(
  pkgdown::build_site(
    pkg = '.',
    override = list(
      destination = '$DIR/site'
    ),
    devel = TRUE,
    preview = TRUE
  )
)))
" > /dev/null
