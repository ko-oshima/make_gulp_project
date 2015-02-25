'use strict'; 
var config = require('../config').less; 
var LESS_DIR = config.src; 
var CSS_DIR = config.dest; 
 
var path = require('path'); 
 
var gulp = require('gulp'); 
var logger = require('gulp-logger'); 
var filter = require('gulp-filter'); 
var lessc = require('gulp-less'); 
 
gulp.task('less', function() { 
    gulp.src(path.join(LESS_DIR, '**/*.less'), { base: LESS_DIR }) 
        .pipe(filter([ '*', '!**/_*.less' ])) 
        .pipe(lessc()) 
        .pipe(gulp.dest(CSS_DIR)) 
        .pipe(logger({ beforeEach: '[less] wrote: ' })); 
}); 
