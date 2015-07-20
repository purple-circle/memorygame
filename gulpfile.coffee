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
lessSrc = 'src/less/**/*.less'

gulp.task 'coffeelint', ->
  gulp
    .src(coffeeSrc)
    .pipe(plumber({errorHandler}))
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())
    .on('error', gutil.log)

gulp.task 'coffee', ['coffeelint'], ->
  gulp
    .src(coffeeSrc)
    .pipe(plumber({errorHandler}))
    .pipe(coffee())
    .pipe(ngAnnotate())
    .on('error', gutil.log)
    .pipe(gulp.dest('build/js'))

gulp.task 'less', ->
  gulp
    .src(lessSrc)
    .pipe(plumber({errorHandler}))
    .pipe(less())
    .pipe(concat('style.css'))
    .pipe(gulp.dest('build/css'))


gulp.task 'autoprefixer', ['less'], ->
  gulp
    .src('build/css/*.css')
    .pipe(postcss([autoprefixer(browsers: ['last 50 version'])]))
    .pipe gulp.dest('build/css')


gulp.task "partials", ->
  gulp
    .src('src/templates/**/*.html')
    .pipe(ngTemplates())
    .pipe(gulp.dest("build/templates"))


gulp.task 'buildcss', ['autoprefixer']

gulp.task 'default', ['autoprefixer', 'coffee', 'partials', 'watch']

gulp.task 'watch', ->
  gulp.watch 'src/less/**/*.less', ['buildcss']
  gulp.watch 'src/coffee/**/*.coffee', ['coffee']
  gulp.watch 'src/templates/**/*.html', ['partials']


