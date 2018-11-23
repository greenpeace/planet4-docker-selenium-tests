var gulp = require('gulp')

var exec = require('child_process').exec
var phplint = require('gulp-phplint');
var spawn = require('child_process').spawnSync
var saneWatch = require('gulp-sane-watch')

gulp.task('default', () => {
  saneWatch('src/tests/**/*.php', function (file,path) {
    const make = exec('make exec EXEC="vendor/bin/phpunit --debug -v ' +  path.replace(__dirname + '/src/','') + "/" + file + '"')

    make.stdout.on('data', (data) => {
      process.stdout.write(`${data}`)
    })

    make.stderr.on('data', (data) => {
      console.log(`stderr: ${data}`)
    })

    make.on('close', (code) => {
      console.log(`child process exited with code ${code}`)
      // gulp.start('clean')
    })
  });
});

gulp.task('clean', () => {
  spawn('make', ['run'])
})
