gulp = require('gulp')
plumber = require('gulp-plumber')

gutil = require('gulp-util')
coffee = require('gulp-coffee')

# Css
less = require('gulp-less')
minifycss = require('gulp-minify-css')
postcss = require('gulp-postcss')
autoprefixer = require('autoprefixer-core')

# Angular
ngTemplates = require('gulp-ng-templates')
ngAnnotate = require('gulp-ng-annotate')

# Code linting
coffeelint = require('gulp-coffeelint')

# Code minification
concat = require('gulp-concat')
uglify = require('gulp-uglify')

# Notifications for OSX
notify = require('gulp-notify')

errorHandler = notify.onError('Error: <%= error.message %>')

coffeeSrc = 'src/coffee/**/*.coffee'
coffeeServerSrc = 'src/server/**/*.coffee'

lessSrc = 'src/less/**/*.less'
cssDest = 'build/css'

autoprefixerConfig = browsers: ['last 50 version']

coffeelintTask = (src) ->
  gulp
    .src(src)
    .pipe(plumber({errorHandler}))
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())
    .on('error', gutil.log)


gulp.task 'coffeelint', ->
  coffeelintTask(coffeeSrc)


gulp.task 'coffeelint-server', ->
  coffeelintTask(coffeeServerSrc)


gulp.task 'coffee', ['coffeelint'], ->
  gulp
    .src(coffeeSrc)
    .pipe(plumber({errorHandler}))
    .pipe(coffee())
    .pipe(ngAnnotate())
    .on('error', gutil.log)
    .pipe(gulp.dest('build/js'))


gulp.task 'server-coffee', ['coffeelint-server'], ->
  gulp
    .src(coffeeServerSrc)
    .pipe(plumber({errorHandler}))
    .pipe(coffee())
    .on('error', gutil.log)
    .pipe(gulp.dest('build/server'))


gulp.task 'less', ->
  gulp
    .src(lessSrc)
    .pipe(plumber({errorHandler}))
    .pipe(less())
    .pipe(concat('style.css'))
    .pipe(gulp.dest(cssDest))


gulp.task 'autoprefixer', ['less'], ->
  gulp
    .src('build/css/*.css')
    .pipe(postcss([autoprefixer(autoprefixerConfig)]))
    .pipe gulp.dest(cssDest)


gulp.task "partials", ->
  gulp
    .src('src/templates/**/*.html')
    .pipe(ngTemplates())
    .pipe(gulp.dest('build/templates'))


gulp.task 'copy-views', ->
  gulp.src('src/server/views/**/*.ejs', {base: 'src/server/views'})
    .pipe(gulp.dest('build/server/views'))


gulp.task 'buildcss', ['autoprefixer']

gulp.task 'default', ['autoprefixer', 'coffee', 'server-coffee', 'partials', 'copy-views'], ->
  gulp.watch lessSrc, ['buildcss']
  gulp.watch coffeeSrc, ['coffee']
  gulp.watch coffeeServerSrc, ['server-coffee']
  gulp.watch 'src/templates/**/*.html', ['partials']
  gulp.watch 'src/server/views/**/*.ejs', ['copy-views']

