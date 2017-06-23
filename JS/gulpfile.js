/* GULP */
var gulp = require("gulp");

/* PLUGINS */
var jslint = require("gulp-jshint"),
    concat = require("gulp-concat"),
    rename = require("gulp-rename"),
    uglify = require("gulp-uglify"),
    watch = require("gulp-watch");

/* FILE LOCATIONS */
var jsFiles = "src/*.js",
    jsDest = "../inst/www/js";

/* TASKS */

// lint
gulp.task("lint", function() {
    return gulp.src(jsFiles)
	.pipe(jslint())
	.pipe(jslint.reporter("fail"));
});

// concat & minify
gulp.task("scripts", function() {
    return gulp.src(jsFiles)
	.pipe(concat("dull.js"))
	.pipe(gulp.dest("."))
	.pipe(rename("dull.min.js"))
	.pipe(uglify())
	.pipe(gulp.dest(jsDest));
});

// default
gulp.task("default", ["lint", "scripts"]);

