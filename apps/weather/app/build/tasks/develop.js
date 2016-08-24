var gulp = require('gulp');
var nodemon = require('gulp-nodemon');
var livereload = require('gulp-livereload');

gulp.task('develop', function () {
  // listen for changes
	livereload.listen();

  nodemon({
    script: './bin/www', 
    watch: 'lib' 
  }).on('restart', function(){
    console.log('implement live reload');
  });
});