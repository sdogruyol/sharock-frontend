require! {
  child_process: {spawn}

  'prelude-ls': {union}

  gulp
  'gulp-util': gutil
  'run-sequence'
}

$ = require('gulp-load-plugins')()


# ----- default ------------------------------------------------------

run-webpack = (opt) ->
  defaults = [
    '--colors'
    '--progress'
    '--display-chunks'
  ]
  opt = union opt, defaults
  spawn 'webpack', opt, stdio: 'inherit'


gulp.task \webpack, [\webpack-preload], ->
  run-webpack []


gulp.task \webpack-watch, [\webpack-preload], ->
  run-webpack ['--watch']


gulp.task \webpack-preload, []


# ----- less ---------------------------------------------------------

gulp.task \less, ->
  gulp.src('src/*.less')
    .pipe $.plumber()
    .pipe $.less()
    .pipe gulp.dest('dist')


gulp.task \less-watch, ->
  gulp.watch 'src/*.less', [\less]


# ----- jade ---------------------------------------------------------

gulp.task \jade, ->
  gulp.src('src/*.jade')
    .pipe $.plumber()
    .pipe $.jade()
    .pipe gulp.dest('dist')


gulp.task \jade-watch, ->
  gulp.watch 'src/*.jade', [\jade]


# ----- server -------------------------------------------------------

gulp.task \server, ->
  spawn './bin/server', [], stdio: 'inherit'


# ----- build --------------------------------------------------------

gulp.task \build, [\webpack, \jade, \less]
gulp.task \build-watch, [\jade, \less]


# ----- watch --------------------------------------------------------

gulp.task \watch, ->
  run-sequence(
    \build-watch,
    \server,
    [\jade-watch, \less-watch, \webpack-watch]
  )


# ----- default ------------------------------------------------------

gulp.task \default, [\watch]
