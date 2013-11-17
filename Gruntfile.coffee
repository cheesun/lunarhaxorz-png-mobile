module.exports = (grunt) ->
  grunt.initConfig
    copy:
      main:
        files: [
          expand: true
          flatten: true
          src: ['src/*.html', 'src/*.js', 'src/*.css', 'src/*.xml']
          dest: 'target/'
        ]
    coffee:
      compile:
        files: [
          expand: true
          cwd: 'src'
          src: '**/*.coffee'
          dest: 'target'
          ext: '.js'
        ]
#      options:
#        sourceMap: true
    coffeelint:
      app: 'src/**/*.coffee'
      options:
        max_line_length:
          level: 'warn'
    watch:
      files: ['Gruntfile.coffee', 'src/**/*.*']
      tasks: ['coffeelint', 'coffee', 'copy']

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['watch']
