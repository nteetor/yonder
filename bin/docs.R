#!/usr/bin/env Rscript

library(hyderogen)
library(rprojroot)
library(fs)

path_root <-  find_package_root_file()

path_iris <- file_create(path_temp("iris-json.js"))
cat(
  file = path_iris,
  paste0("var iris = ", jsonlite::toJSON(iris), ";")
)

site_assets <- c(
  path(path_root, c(
    "inst/www/jquery/jquery.min.js",
    "inst/www/popper/popper.min.js",
    "inst/www/bootstrap/css/bootstrap.min.css",
    "inst/www/bootstrap/js/bootstrap.min.js",
    "inst/www/ion-rangeslider/css/ion.rangeSlider.css",
    "inst/www/ion-rangeslider/css/ion.rangeSlider.skinFlat.css",
    "inst/www/ion-rangeslider/js/ion.rangeSlider.min.js",
    "inst/www/ion-rangeslider/img/sprite-skin-flat.png",
    "inst/www/yonder/js/yonder.min.js"
  )),
  path_iris
)

jekyll(
  path_root,
  build = TRUE,
  assets = site_assets
)
