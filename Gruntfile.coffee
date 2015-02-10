'use strict'

module.exports = (grunt) ->

  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)

  grunt.file.defaultEncoding = 'utf8'

  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"

    project:
      prod:   'build'
      dev:    'dev'
      tmp:    'tmp'
      coffee: 'coffee'
      jade:   'jade'
      sass:   'sass'

    coffeelint:
      files: ['<%= project.coffee %>/{,*/}*.coffee']

    coffee:
      compile:
        options:
          bare: true
        files: [
          expand: true
          flatten: false
          cwd: '<%= project.coffee %>'
          src: ['{,*/}*.coffee']
          dest: '<%= project.tmp %>/js'
          ext: '.js'
        ]

    fixmyjs:
      options:
        jshintrc: '.jshintrc'
        indentpref: 'spaces'
      fix:
        files: [
          expand: true
          flatten: false
          cwd: '<%= project.tmp %>/js'
          src: ['{,*/}*.js']
          dest: '<%= project.dev %>/js'
          ext: '.js'
        ]

    jade:
      js:
        options:
          amd: true
          client: true
          namespace: false
        files: [
          expand: true
          flatten: true
          cwd: '<%= project.jade %>/js'
          src: ['{,*/}*.jade']
          dest: '<%= project.dev %>/js/templates'
          ext: '.js'
        ]

      html:
        options:
          pretty: true
        files: [
          expand: true
          flatten: false
          cwd: '<%= project.jade %>/html'
          src: ['{,*/}*.jade']
          dest: '<%= project.dev %>'
          ext: '.html'
        ]

      build:
        options:
          pretty: false
          data:
            build: true
        files: [
          expand: true
          flatten: false
          cwd: '<%= project.jade %>/html'
          src: ['{,*/}*.jade']
          dest: '<%= project.dev %>'
          ext: '.html'
        ]

    sass:
      dist:
        options:
          style: 'expanded'
          compass: true
          noCache: true
          update: false
          unixNewlines: true
          trace: true
          sourcemap: 'none'
        files: [
          expand: true
          flatten: false
          cwd: '<%= project.sass %>'
          src: ['*.sass']
          dest: '<%= project.tmp %>/css'
          ext: '.css'
        ]

    autoprefixer:
      options:
        browsers: ['last 1 version']
      files:
        expand: true
        flatten: false
        cwd: '<%= project.tmp %>/css'
        src: ['*.css']
        dest: '<%= project.dev %>/css'
        ext: '.css'

    watch:
      script:
        files: ['<%= project.coffee %>/{,*/}*.coffee']
        tasks: ['scripts']

      sass:
        files: ['<%= project.sass %>/**/*.sass']
        tasks: ['styles']

      jadeToHtml:
        files: ['<%= project.jade %>/html/{,*/}*.jade']
        tasks: ['jade:html']

      jadeToJs:
        files: ['<%= project.jade %>/js/{,*/}*.jade']
        tasks: ['jade:js']

    clean:
      dist: ['<%= project.prod %>']

    browserSync:
      dev:
        bsFiles:
          src: '<%= project.dev %>/css/*.css'
        options:
          notify: true
          watchTask: true,
          port: 8183
          server:
            baseDir: ['<%= project.dev %>']

      dist:
        options:
          notify: false
          watchTask: false,
          port: 8184
          server:
            baseDir: ['<%= project.prod %>']

    requirejs:
      almond:
        options:
          optimize: 'uglify2'
          uglify2:
            warnings: false
            compress:
              sequences: true
              properties: true
              drop_debugger: true
              unused: true
              drop_console: true
          optimizeCss: 'standard'
          generateSourceMaps: true
          keepAmdefine: true
          preserveLicenseComments: false
          findNestedDependencies: true
          useStrict: true
          baseUrl: '<%= project.dev %>/js/lib'
          mainConfigFile: '<%= project.dev %>/js/config.js'
          name: 'almond'
          include: ['../main']
          out: '<%= project.prod %>/js/main.js'

    cssmin:
      dynamic:
        options:
          keepSpecialComments: 0
          report: 'gzip'
        files: [
          expand: true
          flatten: false
          cwd: '<%= project.dev %>/css'
          src: ['{,*/}*.css']
          dest: '<%= project.prod %>/css'
          ext: '.css'
        ]

    imagemin:
      dynamic:
        options:
          optimizationLevel: 3
        files: [
          expand: true
          cwd: '<%= project.dev %>/images'
          src: ['{,*/}*.{png,jpg,gif}']
          dest: '<%= project.prod %>/images'
        ]

    minifyHtml:
      dynamic:
        options:
          comments: false
          conditionals: true
          spare: false
          quotes: true
          cdata: false
          empty: false
        files: [
          expand: true
          cwd: '<%= project.dev %>'
          src: ['{,*/}*.html']
          dest: '<%= project.prod %>'
        ]

    concurrent:
      dev: [
        'scripts'
        'styles'
        'jade:js'
        'jade:html'
      ]

  grunt.registerTask 'default', [
    'concurrent:dev'
  ]

  grunt.registerTask 'scripts', [
    'coffeelint'
    'coffee'
    'fixmyjs:fix'
  ]

  grunt.registerTask 'styles', [
    'sass'
    'autoprefixer'
  ]

  grunt.registerTask 'build', [
    'clean'
    'default'
    'jade:build'
    'requirejs'
    'cssmin'
    'imagemin'
    'minifyHtml'
  ]

  grunt.registerTask 'server', [
    'default'
    'browserSync:dev'
    'watch'
  ]

  grunt.registerTask 'server:prod', [
    'build'
    'browserSync:dist'
  ]

  return
