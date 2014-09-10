/**
 * Module Build
 *
 * @author potanin@UD
 * @version 0.0.2
 * @param grunt
 */
module.exports = function( grunt ) {

  grunt.initConfig({

    // Load Package Data.
    package: grunt.file.readJSON( 'package.json' ),

    // Run Mocha Tests.
    mochacli: {
      options: {
        require: [ 'should' ],
        reporter: 'list',
        ui: 'exports'
      },
      all: [ 'test/*.js' ]
    },

    // Watch Files and Trigger Tasks.
    watch: {
      options: {
        interval: 1000,
        debounceDelay: 500
      },
      tests: {
        files: [
          'gruntfile.js',
          'bin/*.js',
          'lib/*.js',
          'test/*.js'
        ],
        tasks: [ 'test' ]
      }
    }

  });

  // Automatically Load Tasks
  require( 'load-grunt-tasks' )( grunt, {
    pattern: 'grunt-*',
    config: './package.json',
    scope: [ 'devDependencies', 'dependencies' ]
  });

  // Show elapsed time
  require( 'time-grunt' )(grunt);

  // Load Custom Tasks.
  grunt.loadTasks( 'lib/tasks' );

  grunt.registerTask( 'default', 'View information', function() {
    console.log( 'starting server' );
  });

  // Run Tests
  grunt.registerTask( 'test', [ 'mochacli' ] );

  grunt.registerTask( 'start', function() {
    console.log( 'starting server' );
  });

  grunt.registerTask( 'stop', function() {
    console.log( 'stop server' );
  });

  grunt.registerTask( 'info', function() {
    console.log( 'info server' );
  });

  grunt.registerTask( 'reload', function() {
    console.log( 'reload server' );
  });

  grunt.registerTask( 'list', function() {
    console.log( 'list server' );
  });

  grunt.registerTask( 'deplay', function() {
    console.log( 'fake deploying server...' );
  });

};