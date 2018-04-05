'use strict';

const gulp = require('gulp');
const sass = require('gulp-sass');
const elm = require('gulp-elm');
const server = require('pushstate-server');

const ELM_SRC = './src/**/*.elm';
const ELM_BUNDLE = 'main.js';
const SASS_SRC = './src/**/*.scss';
const SASS_MAIN = './src/style.scss';
const HTML_SRC = './static/index.html';
const OUTPUT = './build/';

gulp.task('styles', function() {
  gulp
    .src(SASS_MAIN)
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest(OUTPUT));
});

gulp.task('copy-index-html', function() {
  gulp.src(HTML_SRC).pipe(gulp.dest(OUTPUT));
});

gulp.task('elm-init', elm.init);

gulp.task('elm-bundle', ['elm-init'], function() {
  return gulp
    .src(ELM_SRC)
    .pipe(
      elm.bundle(ELM_BUNDLE, { debug: true }).on('error', e => console.log(e))
    )
    .pipe(gulp.dest(OUTPUT));
});

gulp.task('start-server', function() {
  server.start({
    port: 3000,
    directory: OUTPUT
  });
});

gulp.task('start', function() {
  gulp.start('styles');
  gulp.start('copy-index-html');
  gulp.start('start-server');
  gulp.start('elm-bundle');
  gulp.watch(SASS_MAIN, ['styles']);
  gulp.watch(SASS_SRC, ['styles']);
  gulp.watch(HTML_SRC, ['copy-index-html']);
  gulp.watch(ELM_SRC, ['elm-bundle']);
});