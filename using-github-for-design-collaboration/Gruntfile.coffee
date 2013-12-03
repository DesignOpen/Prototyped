'use strict'
path = require('path')
lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet

folderMount = (connect, point) ->
  return connect.static(path.resolve(point))


module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    stylus:
      compile:
        options:
          compress: true
        files:
          'css/main.css': 'css/main.styl'
    jade:
      options:
        pretty: true
      compile:
        files:
          'index.html': 'index.jade'
    coffee:
      compile:
        files:
          'js/main.js': 'js/main.coffee'
    connect:
      livereload:
        options:
          hostname: '0.0.0.0'
          port: 9001
          middleware: (connect, options) ->
            return [lrSnippet, folderMount(connect, '.')]
    regarde:
      stylus:
        files: ['css/*.styl']
        tasks: ['mincss', 'livereload']
      jade:
        files: ['*.jade']
        tasks: ['mincss', 'livereload']
      coffee:
        files: ['js/*.coffee']
        tasks: ['coffee', 'livereload']
      image:
        files: ['img/*']
        tasks: ['livereload']

  grunt.registerTask 'mincss', 'Compiles Stylus, minifies it, and runs Jade', ()->
    grunt.task.run('stylus')
    grunt.config('jade.options.data.mincss', grunt.file.read('css/main.css'))
    grunt.task.run('jade')


  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-stylus')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-regarde')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-livereload')

  # Default task(s).
  grunt.registerTask('compile', ['coffee','mincss'])
  grunt.registerTask('default', ['compile', 'livereload-start', 'connect', 'regarde'])