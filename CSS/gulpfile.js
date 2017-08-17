/* GULP */
var gulp = require("gulp");

/* PACKAGES */
var css = require("gulp-clean-css"),
    clean = require("gulp-clean"),
    sass = require("gulp-sass"),
    concat = require("gulp-concat");

/* DIRECTORIES */
var scssFiles = "scss/*.scss",
    cssLocal = "./css",
    cssFiles = cssLocal + "/*.css",
    cssDest = "../inst/www/css";

/* TASKS */
gulp.task("clean", function() {
  return gulp.src(cssFiles, {read: false})
    .pipe(clean());
});
  
gulp.task("sass", function() {
  return gulp.src(scssFiles)
    .pipe(sass().on("error", sass.logError))
    .pipe(gulp.dest(cssLocal));
});

gulp.task("concat", function() {
  return gulp.src(cssFiles)
    .pipe(concat("dull.min.css"))
    .pipe(css({
      compatibility: "ie9"
    }))
    .pipe(gulp.dest(cssDest));
});

 gulp.task("default", ["clean", "sass", "concat"]);
