'use strict';

import gulp from 'gulp';
import pump from 'pump';
import babel from 'gulp-babel';
import concat from 'gulp-concat';
import eslint from 'gulp-eslint';
import sasslint from 'gulp-sass-lint';
import uglify from 'gulp-uglify';
import sass from 'gulp-sass';
import uglifycss from 'gulp-uglifycss';
import rename from 'gulp-rename';

gulp.task('dull-lint-js', (cb) => {
  pump(
    [
      gulp.src('src/js/*.js'),
      eslint(),
      eslint.format(),
      eslint.failAfterError()
    ],
    cb
  );
});

gulp.task('dull-concat-js', (cb) => {
  pump([
    gulp.src('src/js/*.js'),
    concat('dull.js'),
    babel({
      presets: ['env']
    }),
    gulp.dest('lib/js/')
  ], cb);
});

gulp.task('dull-uglify-js', (cb) => {
  pump([
    gulp.src('src/js/*.js'),
    concat('dull.min.js'),
    babel({
      presets: ['env']
    }),
    uglify(),
    gulp.dest('lib/js/')
  ], cb);
});

gulp.task('dull-js', ['dull-lint-js', 'dull-concat-js', 'dull-uglify-js']);

gulp.task('dull-lint-scss', (cb) => {
  pump(
    [
      gulp.src('src/scss/*.scss'),
      sasslint(),
      sasslint.format(),
      sasslint.failOnError()
    ],
    cb
  );
});

gulp.task('dull-concat-scss', (cb) => {
  pump(
    [
      gulp.src('src/scss/*.scss'),
      sass(),
      concat('dull.css'),
      gulp.dest('lib/css/')
    ],
    cb
  )
});

gulp.task('dull-uglify-css', (cb) => {
  pump(
    [
      gulp.src('lib/css/dull.css'),
      uglifycss(),
      rename('dull.min.css'),
      gulp.dest('lib/css/')
    ],
    cb
  );
});

gulp.task('dull-css', ['dull-lint-scss', 'dull-concat-scss', 'dull-uglify-css']);

gulp.task('dull', ['dull-js', 'dull-css']);

gulp.task('vend-dull-js', (cb) => {
  pump(
    [
      gulp.src('lib/js/dull.min.js'),
      gulp.dest('../inst/www/dull/js/')
    ],
    cb
  );
});

gulp.task('vend-dull-css', (cb) => {
  pump(
    [
      gulp.src('lib/css/dull.min.css'),
      gulp.dest('../inst/www/dull/css/')
    ],
    cb
  );
});

gulp.task('vend-dull', ['vend-dull-js', 'vend-dull-css']);

gulp.task('vend-bootstrap-js', (cb) => {
  pump(
    [
      gulp.src('node_modules/bootstrap/dist/js/bootstrap.min.js'),
      gulp.dest('../inst/www/bootstrap/js/')
    ],
    cb
  )
});

gulp.task('vend-bootstrap-css', (cb) => {
  pump(
    [
      gulp.src('node_modules/bootstrap/dist/css/bootstrap.min.css'),
      gulp.dest('../inst/www/bootstrap/css/')
    ],
    cb
  );
});

gulp.task('vend-bootstrap', ['vend-bootstrap-js', 'vend-bootstrap-css']);

gulp.task('vend-popper-js', (cb) => {
  pump([
    gulp.src('node_modules/popper.js/dist/umd/popper.min.js'),
    gulp.dest('../inst/www/popper/')
  ], cb);
});

gulp.task('vend-popper', ['vend-popper-js']);

gulp.task('vend-jquery-js', (cb) => {
  pump([
    gulp.src('node_modules/jquery/dist/jquery.min.js'),
    gulp.dest('../inst/www/jquery/')
  ], cb);
});

gulp.task('vend-jquery', ['vend-jquery-js']);

gulp.task('vend-ion-js', (cb) => {
  pump([
    gulp.src('node_modules/ion-rangeslider/js/ion.rangeSlider.min.js'),
    gulp.dest('../inst/www/ion-rangeslider/js/')
  ], cb);
});

gulp.task('vend-ion-css', (cb) => {
  pump([
    gulp.src([
      'node_modules/ion-rangeslider/css/ion.rangeSlider.css',
      'node_modules/ion-rangeslider/css/ion.rangeSlider.skinFlat.css'
    ]),
    uglifycss(),
    gulp.dest('../inst/www/ion-rangeslider/css/')
  ], cb);
});

gulp.task('vend-ion-img', (cb) => {
  pump([
    gulp.src('node_modules/ion-rangeslider/img/sprite-skin-flat.png'),
    gulp.dest('../inst/www/ion-rangeslider/img/')
  ], cb);
});

gulp.task('vend-ion', ['vend-ion-js', 'vend-ion-css', 'vend-ion-img']);

gulp.task('vend-font-awesome-css', (cb) => {
  pump([
    gulp.src('node_modules/@fortawesome/fontawesome/styles.css'),
    uglifycss(),
    rename('fontawesome.min.css'),
    gulp.dest('../inst/www/font-awesome/css/')
  ], cb)
});

gulp.task('vend-font-awesome-js', (cb) => {
  pump([
    gulp.src([
      'node_modules/@fortawesome/fontawesome-free-regular/index.js',
      'node_modules/@fortawesome/fontawesome-free-solid/index.js',
      'node_modules/@fortawesome/fontawesome-free-brands/index.js',
      'node_modules/@fortawesome/fontawesome/index.js',
    ]),
    concat('fontawesome.min.js'),
    uglify(),
    gulp.dest('../inst/www/font-awesome/js/')
  ], cb);
});

gulp.task('vend-font-awesome', ['vend-font-awesome-js', 'vend-font-awesome-css']);

gulp.task('vend-flatpickr-js', (cb) => {
  pump([
    gulp.src('node_modules/flatpickr/dist/flatpickr.min.js'),
    gulp.dest('../inst/www/flatpickr/js/')
  ], cb);
});

gulp.task('vend-flatpickr-css', (cb) => {
  pump([
    gulp.src('node_modules/flatpickr/dist/flatpickr.min.css'),
    gulp.dest('../inst/www/flatpickr/css/')
  ], cb);
});

gulp.task('vend-flatpickr', ['vend-flatpickr-js', 'vend-flatpickr-css']);

gulp.task('vend', ['vend-bootstrap', 'vend-popper', 'vend-jquery', 'vend-ion', 'vend-font-awesome']);
