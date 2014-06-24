gulp     = require "gulp"
prefixer = require "gulp-autoprefixer"
bower    = require "gulp-bower-files"
clean    = require "gulp-clean"
coffee   = require "gulp-coffee"
concat   = require "gulp-concat"
connect  = require "gulp-connect-multi"
jade     = require "gulp-jade"
mincss   = require "gulp-minify-css"
plumber  = require "gulp-plumber"
sass     = require "gulp-ruby-sass"
connect  = connect()

gulp.task "jade", ->
  gulp.src "src/jade/*.jade"
    .pipe jade({pretty: true})
    .pipe gulp.dest "dst/"

gulp.task "coffee", ->
  gulp.src "src/coffee/*.coffee"
    .pipe coffee()
    .pipe gulp.dest "dst/js/"

gulp.task "concat", ->
  gulp.src "src/sass/*.sass"
    .pipe concat "style.sass"
    .pipe gulp.dest "src/sass/tmp/"

gulp.task "sass", ->
  gulp.src "src/sass/tmp/*.sass"
    .pipe plumber()
    .pipe sass()
    .pipe prefixer 'last 2 version'
    .pipe mincss()
    .pipe gulp.dest "dst/css/"

gulp.task "bower", ->
  bower({ directory: "bower_components"})
    .pipe gulp.dest "dst/lib/"

gulp.task "clean", ->
  gulp.src "dst/"
    .pipe clean()

gulp.task "connect", connect.server({
    root: ["dst/"]
    port: 3939
    livereload: true
    open:
      browser: "Google Chrome Canary"
  })

gulp.task "watch", ->
  gulp.watch "src/jade/**", ["jade"]
  gulp.watch "src/coffee/**", ["coffee"]
  gulp.watch "src/sass/**", ["concat", "sass"]


## Tasks
# Default task
gulp.task "default", ["clean", "concat", "sass", "coffee", "jade", "bower", "connect", "watch"]