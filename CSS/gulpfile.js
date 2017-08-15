/* GULP */
var gulp = require("gulp");

/* PACKAGES */
var clean = require("gulp-clean-css"),
    sass = require("gulp-sass"),
    concat = require("gulp-concat");

/* DIRECTORIES */
var scssFiles = "scss/*.scss",
    cssLocal = "./css",
    cssFiles = cssLocal + "/*.css",
    cssDest = "../inst/www/css";

/* TASKS */
gulp.task("sass", function() {
  return gulp.src(scssFiles)
    .pipe(sass().on("error", sass.logError))
    .pipe(gulp.dest(cssLocal));
});

gulp.task("clean", function() {
  return gulp.src(cssFiles)
    .pipe(concat("dull.min.css"))
    .pipe(clean({
      compatibility: "ie9"
    }))
    .pipe(gulp.dest(cssDest));
});

gulp.task("default", ["sass", "clean"]);
