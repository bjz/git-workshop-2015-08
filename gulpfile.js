'use strict';

var gulp        = require('gulp');

var del         = require('del');
var ghPages     = require('gulp-gh-pages');
var plumber     = require('gulp-plumber');
var prompt      = require('gulp-prompt');
var sass        = require('gulp-sass');
var sourcemaps  = require('gulp-sourcemaps');
var tildify     = require('tildify');
var util        = require('gulp-util');

// Build

gulp.task('build:sass', function() {
  return gulp.src('./src/styles/**/*.scss')
    .pipe(sourcemaps.init())
    .pipe(sass({ outputStyle: 'compressed' }).on('error', sass.logError))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./tmp/styles'));
});

gulp.task('build:images', function() {
  return gulp.src('./images/**/*')
    .pipe(gulp.dest('./tmp/images'));
});

gulp.task('build:pages', ['build:images'], function() {
  return gulp.src('./src/pages/**/*.html')
    .pipe(gulp.dest('./tmp'));
});

gulp.task('build', ['build:sass', 'build:pages']);

// Watcher

gulp.task('watch', ['build'], function() {
  var index_path = tildify(__dirname + '/tmp/index.html');
  util.log('Homepage built to', util.colors.magenta(index_path));
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
    .pipe(ghPages({
      remoteUrl: 'git@github.com:bjz/git-workshop-2015-08.git',
    }));
});

// Cleaning

gulp.task('clean:build', function(cb) { del(['./tmp', './.publish'], cb); });
gulp.task('clean:npm', function(cb) { del(['./node_modules']); });

// Default

gulp.task('default', ['watch']);
