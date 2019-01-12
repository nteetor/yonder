#!/usr/bin/env Rscript

library(hyderogen)
library(rprojroot)
library(fs)

path_root <-  find_package_root_file()

iris_json <- tempfile("iris-json-", fileext = ".js")
cat(
  file = iris_json,
  paste0("var iris = ", jsonlite::toJSON(iris), ";")
)

site_assets <- c(
  path(path_root, c(
    "inst/www/jquery/jquery.min.js",
    "inst/www/popper/popper.min.js",
    "inst/www/bootstrap/css/bootstrap.min.css",
    "inst/www/bootstrap/js/bootstrap.min.js",
    "inst/www/chabudai/css/chabudai.min.css",
    "inst/www/chabudai/js/chabudai.min.js",
    "inst/www/file-saver/FileSaver.min.js",
    "inst/www/ion-rangeslider/css/ion.rangeSlider.css",
    "inst/www/ion-rangeslider/css/ion.rangeSlider.skinFlat.css",
    "inst/www/ion-rangeslider/js/ion.rangeSlider.min.js",
    "inst/www/yonder/js/yonder.min.js"
  )),
  iris_json
)

jekyll(
  path_root,
  build = TRUE,
  assets = site_assets
)
