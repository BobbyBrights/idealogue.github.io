gulp = require 'gulp'
del = require 'del'
stylus = require 'gulp-stylus'
bootstrap = require 'bootstrap-styl'
jade = require 'gulp-jade'
stream = require 'combined-stream'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
marked = require 'marked'
_ = require 'lodash'
helpers = require './_lib/helpers'

paths =
  js: [
    'node_modules/jquery/dist/jquery.min.js'
  ]

gulp.task 'clean:js', (cb) ->
  del 'assets/site.js', cb

gulp.task 'clean:css', (cb) ->
  del 'assets/site.css', cb

gulp.task 'clean:views', (cb) ->
  del '*.html', cb

gulp.task 'js', ['clean:js'], ->
  s = stream.create()
  s.append gulp.src ['_scripts/*.js'].concat(paths.js)
  s.append gulp.src('_scripts/site.coffee').pipe(coffee().on('error', console.log))
  s
    .pipe concat('site.js')
    .pipe gulp.dest('assets')

gulp.task 'css', ['clean:css'], ->
  s = stream.create()
  s.append gulp.src('_styles/*.css')
  s.append gulp.src('_styles/site.styl').pipe(stylus(use: bootstrap()).on('error', console.log))
  s
    .pipe concat('site.css')
    .pipe gulp.dest('assets')

gulp.task 'views', ['clean:views'], ->
  delete require.cache[__dirname + "/_views/data.coffee"];
  data = _.assign {}, require('./_views/data'), helpers,
    marked: marked
    _: _
  gulp.src('_views/index.jade')
    .pipe jade(pretty: true, data: data).on('error', console.log)
    .pipe gulp.dest('.')

gulp.task 'watch', ['default'], ->
  gulp.watch ['_scripts/**/*'].concat(paths.js), ['js']
  gulp.watch '_styles/**/*', ['css']
  gulp.watch '_views/**/*', ['views']

gulp.task 'default', ['js', 'css', 'views']

