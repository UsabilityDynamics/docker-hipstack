#!/usr/bin/env node
//
// sudo DEBUG=docker:* supervisor -w ./ -- ./bin/hipstack.js start
//
// npm start
// npm stop
//
//

var dockerProxy = require( '../' );
var findUp  = require( 'findup-sync' );
var commander  = require( 'commander' );
var os = require( 'os' );
var fs = require( 'fs' );
var Docker = require( 'dockerode' );
var _ = require( 'lodash' );
var yaml_config = require('node-yaml-config');

function getList( settings ) {

  var _settings = getSettings( settings );

  var docker = new Docker({
    host: _settings.docker.host,
    port: _settings.docker.port
  });

  docker.listContainers({all: true}, function(err, containers) {
    console.log('ALL: ' + containers.length);
    console.log( require( 'util').inspect( optsc, { colors: true , depth:0, showHidden: false } ) );
  });


}
/**
 * Start Service.
 *
 * @param settings
 */
function startService( settings ) {
  console.log( 'startService!', process.env.NODE_ENV, settings.config );

  var _settings = getSettings( settings );


  var docker = new Docker({
    host: _settings.docker.host,
    port: _settings.docker.port
  });

  var _runConfig = {
    Image: '',
    Tty: true,
    Cmd: ['/bin/ls','/stuff'],
    Volumes:{
      "/stuff": {}
    }
  };

  console.log( require( 'util').inspect( _runConfig, { colors: true , depth:0, showHidden: false } ) );
  return;

  docker.createContainer( _runConfig, function(err, container) {

    container.attach({stream: true, stdout: true, stderr: true, tty: true}, function (err, stream) {
      stream.pipe(process.stdout);

      container.start({"Binds":["/home/vagrant:/stuff"]}, function (err, data) {
        console.log(data);
      });

    });


    container.attach({
      stream: true,
      stdout: true,
      stderr: true
    }, function (err, stream) {
      stream.pipe(process.stdout);
    });

  });



  // console.log( require( 'util').inspect( _settings, { colors: true , depth:1, showHidden: false } ) );

}

/**
 * Show Status
 *
 * @todo Get all active hipstack PIDs.
 * @param settings
 */
function getStatus( settings ) {
  console.log( 'getStatus!' );
}

/**
 * Stop Service
 *
 * @param settings
 */
function stopService( settings ) {
  console.log( 'Docker Proxy "stop" is not yet implemented.' );
}

function getSettings( settings ) {
  console.log( 'settings for', settings.environment );

  var _path;
  var _composer;
  var _package;
  var _config = {};

  if( 'string' === typeof settings.config ) {
    _path = require( 'path' ).join( __dirname, settings.config );
  }

  if( !_path ) {
    _path = findUp( 'hipstack.yml' )
  }

  if( !_path && fs.existsSync( process.cwd() + '/package.json' ) ) {
    _package = require( process.cwd() + '/package.json'  );
  }

  if( !_path && fs.existsSync( process.cwd() + '/composer.json' ) ) {

    _composer = require( process.cwd() + '/composer.json'  );

    if( 'string' === typeof _composer.config.hipstack ) {
      _path = require( 'path' ).join( process.cwd(), _composer.config.hipstack );
    }

    if( 'object' === typeof _composer.config.hipstack ) {
      _path = _composer.config.hipstack
    }

  }

  if( !_path ) {
    _path = require( 'path' ).join( __dirname, '../static/etc/hipstack.yml' );
  }

  if( 'object' === typeof _path ) {
    _config = _path;
  } else {

    try {

      _config = yaml_config.load( _path, settings.environment );

    } catch( error ) {
      console.error( "Can not load YML. %d in %s.", error.problemMark.line, _path );
    }

  }

  // console.log( require( 'util').inspect( _config, { colors: true , depth:0, showHidden: false } ) );

  if( _composer ) {
    _config._composer = _composer;
  }

  if( _package ) {
    _config._package = _package;
  }

  _.defaults( _config, {
    _path: _path,
    _pwd: process.cwd(),
    _module: process.mainModule.filename
  });

  // console.log( require( 'util').inspect( _config, { colors: true , depth:0, showHidden: false } ) );

  return _config;

}

commander._name = require( '../package' ).name;

commander
  .version( require( '../package' ).version )
  .option( '-q', 'quiet', 'Silence console output.' )

commander.command( 'start' )
  .option( '-e, --environment [environment]', 'Which environment to use.', process.env.NODE_ENV || 'production' )
  .option( '-p, --port [port]', 'Which port use for public proxy.', process.env.DOCKER_PROXY_API_PORT || process.env.PORT || 8080 )
  .option( '-h, --address [address]', 'IP address for public proxy.', process.env.DOCKER_PROXY_API_HOST || process.env.HOST || '0.0.0.0' )
  .option( '-c, --config [config]', 'Path to SSL certificates.', process.env.DOCKER_PROXY_CONFIG_FILE_PATH || null )
  .action( startService );

commander.command( 'status' )
  .option( '-e, --environment [environment]', 'Which environment to use.', process.env.NODE_ENV || 'production' )
  .option( '-w, --watch', 'Watch for changes.' )
  .action( getStatus );

commander.command( 'info' )
  .option( '-e, --environment [environment]', 'Which environment to use.', process.env.NODE_ENV || 'production' )
  .option( '-w, --watch', 'Watch for changes.' )
  .action(  getSettings );

commander.command( 'list' )
  .option( '-e, --environment [environment]', 'Which environment to use.', process.env.NODE_ENV || 'production' )
  .option( '-w, --watch', 'Watch for changes.' )
  .action(  getList );

commander.command( 'install' )
  .option( '-e, --environment [environment]', 'Which environment to use.', process.env.NODE_ENV || 'production' )
  .option( '-w, --watch', 'Watch for changes.' )
  .action( require( '../lib/tasks/install' ) );

commander.command( 'stop' )
  .option( '-e, --environment [environment]', 'Which environment to use.', process.env.NODE_ENV || 'production' )
  .option( '-f, --force', 'Force stop.' )
  .action( stopService );


if( process.argv.length === 2 ) {
  process.argv.push('--help' );
}

commander.parse( process.argv );
