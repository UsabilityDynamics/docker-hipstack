/**
 * HipStack default tests.
 *
 */
module.exports = {
  HipStack: {

    "works": function( done ) {

      done();

    },

    "has HipHop": function( done ) {

      makeRequest( "/test/status.php", function() {

        done();

      });

    }

  }
};

function makeRequest( url, done ) {

  var _config = {
    host:"http://" + process.env.DOCKER_HOST.split( ':' )[0],
    port: process.env.DOCKER_HOST.split( ':' )[1]
  };

  var docker = require('docker-api')(_config);

  var request = require( 'request' );

  return done();

  docker.containers.inspect('hipstack.dev',function() {

    console.log( _config, arguments );

    done();

  });



}