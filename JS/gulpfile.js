/* GULP */
var gulp = require("gulp");

/* PLUGINS */
var jslint = require("gulp-jshint"),
    eslint = require("gulp-eslint"),
    concat = require("gulp-concat"),
    rename = require("gulp-rename"),
    uglify = require("gulp-uglify"),
    watch = require("gulp-watch"),
    babel = require('gulp-babel');

/* FILE LOCATIONS */
var jsFiles = "src/*.js",
    jsDest = "../inst/www/dull";

/* TASKS */

// jslint
gulp.task("jslint", function() {
  return gulp.src(jsFiles)
  	.pipe(jslint())
  	.pipe(jslint.reporter("fail"));
});

// eslint
gulp.task("eslint", function() {
  return gulp.src(jsFiles)
  	.pipe(eslint())
  	.pipe(eslint.format());
//	.pipe(eslint.failAfterError());
});

// concat & minify
gulp.task("scripts", function() {
  return gulp.src(jsFiles)
  	.pipe(concat("dull.js"))
  	.pipe(babel({ presets: ["es2015"] }))
  	.pipe(gulp.dest("."))
  	.pipe(rename("dull.min.js"))
  	.pipe(uglify())
  	.pipe(gulp.dest(jsDest));
});

// minify ion range slider
gulp.task("ion", function() {
    return gulp.src("../inst/www/ion-range-slider/js/ion-range-slider.js")
	.pipe(rename("ion-range-slider.min.js"))
	.pipe(uglify())
	.pipe(gulp.dest("../inst/www/ion-range-slider/js"));
});

// default
gulp.task("default", ["eslint", "scripts"]);

