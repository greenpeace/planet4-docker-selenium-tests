var gulp = require('gulp');
var watch = require('gulp-watch');
var spawn = require('child_process').spawn;

gulp.task('default', ['watch']);

gulp.task('watch', function () {
  return gulp.watch('src/**/*.php', ['make'])
});

gulp.task('make', function () {
  var make=spawn('make', ['build', 'run', 'exec'])

  make.stdout.on('data', (data) => {
    process.stdout.write(`${data}`);
  });

  make.stderr.on('data', (data) => {
    console.log(`stderr: ${data}`);
  });

  make.on('close', (code) => {
    console.log(`child process exited with code ${code}`);
  });
});
