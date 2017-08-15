/* GULP */
var gulp = require("gulp");

/* PACKAGES */
var clean = require("gulp-clean-css"),
    concat = require("gulp-concat");

/* DIRECTORIES */
var cssFiles = "styles/*.css",
    cssDest = "../inst/www/css";

/* TASKS */
gulp.task("clean-css", function() {
  return gulp.src(cssFiles)
    .pipe(concat("dull.min.css"))
    .pipe(clean({
      compatibility: "ie9"
    }))
    .pipe(gulp.dest(cssDest));
});

gulp.task("default", ["clean-css"]);
