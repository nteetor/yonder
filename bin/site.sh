#!/bin/bash

DIR=$(pwd)
DIR_PKGDOWN="$DIR/pkgdown"

INPUT="index.Rmd"
OUTPUT="index.md"

if [ $(basename $DIR) != "yonder" ]; then
    echo "Must be called from top-level of project"
    exit 1
fi

if [[ $# -eq 0 || $* == *--index* ]]; then
    Rscript -e "\
    withr::with_dir('$DIR_PKGDOWN', {
      rmarkdown::render(
        input = '$INPUT',
        output_file = '$OUTPUT'
      )
    })
    "

    if [ -f $DIR_PKGDOWN/index.html ]; then
        rm $DIR_PKGDOWN/index.html
    fi
fi

if [[ $# -eq 0 || $* == *--document* ]]; then
    Rscript -e "\
    devtools::document('$DIR')
    "
fi

if [[ $# -eq 0 || $* == *--site* ]]; then
    # Rscript -e "renv::install('nteetor/pkgdown@master-nt-yonder')" &&
    Rscript -e "\
    pkgdown::build_site(
      pkg = '$DIR',
      override = list(
        destination = '$DIR_PKGDOWN/site'
      ),
      devel = TRUE,
      lazy = TRUE,
      examples = FALSE,
      preview = FALSE
    )
    "

    open $DIR_PKGDOWN/site/index.html
fi
