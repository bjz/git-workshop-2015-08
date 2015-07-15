'use strict';

var gulp        = require('gulp');

var del         = require('del');
var elm         = require('gulp-elm');
var ghPages     = require('gulp-gh-pages');
var plumber     = require('gulp-plumber');
var prompt      = require('gulp-prompt');
var sass        = require('gulp-sass');
var tildify     = require('tildify');
var util        = require('gulp-util');
var watch       = require('gulp-watch');

// Build

gulp.task('build:elm-init', elm.init);

gulp.task('build:elm', ['build:elm-init'], function() {
  return gulp.src('./src/elm/Main.elm')
    .pipe(plumber())
    .pipe(elm.make({ filetype: 'js' }))
    .pipe(gulp.dest('./tmp/js'));
});

gulp.task('build:sass', function() {
  return gulp.src('./src/styles/**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./tmp/styles'));
});

gulp.task('build:pages', function() {
  return gulp.src('./src/pages/**/*.html')
    .pipe(gulp.dest('./tmp'));
});

gulp.task('build', ['build:elm', 'build:sass', 'build:pages']);

// Watcher

gulp.task('watch', ['build'], function() {
  var index_path = tildify(__dirname + '/tmp/index.html');
  util.log('Homepage built to', util.colors.magenta(index_path));
  gulp.watch(['./src/elm/**/*.elm', './elm-package.json'], ['build:elm']);
  gulp.watch(['./src/styles/**/*.scss'], ['build:sass']);
  gulp.watch(['./src/pages/**/*.html'], ['build:pages']);
});

// Github Deployment

gulp.task('readme', function() {
  return gulp.src('./README.md')
    .pipe(gulp.dest('./tmp'));
})

gulp.task('deploy', ['build', 'readme'], function() {
  return gulp.src('./tmp/**/*')
    .pipe(prompt.confirm('This will update the live site. Are you sure?'))
    .pipe(ghPages());
});

// Cleaning

gulp.task('clean', function(cb) { del(['./tmp', './.publish'], cb); });
gulp.task('clean:elm', function(cb) { del(['./elm-stuff']); });
gulp.task('clean:npm', function(cb) { del(['./elm-stuff']); });

// Default

gulp.task('default', ['watch']);
