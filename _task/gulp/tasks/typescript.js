var gulp = require('gulp');
var typescript = require('gulp-typescript');
var concat = require('gulp-concat');
var config = require('../config');

// js を圧縮する
var jsmin = require('gulp-jsmin');


gulp.task('typescript', function(){
  // 対象となるファイルを全部指定
  gulp.src([config.tsc.src])
    .pipe(typescript(config.tsc.options))
    // jsプロパティを参照
    .js
//    // ファイルをひとまとめに
//    .pipe(concat(config.tsc.destname))
    // ファイルを圧縮する
    .pipe(jsmin())
    .pipe(gulp.dest(config.js.dest));
});
