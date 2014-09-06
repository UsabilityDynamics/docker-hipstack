#!/usr/bin/env node
//
// sudo DEBUG=docker:* supervisor -w ./ -- ./bin/hipstack.js start
//
// npm start
// npm stop
//
//

var dockerProxy = require( '../' );
var commander  = require( 'commander' );
var os = require( 'os' );

commander._name = require( '../package' ).name;

commander
  .version( require( '../package' ).version )
  .option( '-q', 'quiet', 'Silence console output.' )

commander.command( 'start' )
  .option( '-p, --port [port]', 'Which port use for public proxy.', process.env.DOCKER_PROXY_API_PORT || process.env.PORT || 8080 )
  .option( '-h, --address [address]', 'IP address for public proxy.', process.env.DOCKER_PROXY_API_HOST || process.env.HOST || '0.0.0.0' )
  .option( '-s, --silent [silent]', 'silence worker logs', process.env.DOCKER_PROXY_SILENT == 'false' ? false : true )
  .option( '-c, --config-path [configPath]', 'Path to SSL certificates.', process.env.DOCKER_PROXY_CONFIG_FILE_PATH || './static/etc/hipstack.yaml' )
  .action( startService );

commander.command( 'status' )
  .option( '-w, --watch', 'Watch for changes.' )
  .action( getStatus );

commander.command( 'stop' )
  .option( '-f, --force', 'Force stop.' )
  .action( stopService );


if( process.argv.length === 2 ) {
  process.argv.push('--help' );
}

commander.parse( process.argv );

/**
 * Start Service.
 *
 * @param settings
 */
function startService( settings ) {
  console.log( 'startService!', process.env.NODE_ENV );

  var _path = require( 'path' ).join( __dirname, '../static/etc/hipstack.yml');

  var _ = require('lodash');
  var yaml_config = require('node-yaml-config');

  var config = yaml_config.load( _path );

  _.defaults( config, {
    _pwd: process.cwd(),
    _module: process.mainModule.filename
  });

  console.log( require( 'util').inspect( config, { colors: true , depth:1, showHidden: false } ) );

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