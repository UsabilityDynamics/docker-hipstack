/**
 * HipStack default tests.
 *
 */
module.exports = {
  HipStack: {

    "Testing /functional": checkAsset( "/test/index.php" )

  }
};


function checkAsset( url ) {

  var request = require( 'request' );

  var _url = [ 'http://127.0.0.1' ];

  if( process.env.CI_HIPSTACK_CONTAINER_PORT ) {
    _url.push( ':', process.env.CI_HIPSTACK_CONTAINER_PORT )
  } else {
    _url.push( ':', 49180 );
  }

  return function( done ) {
    console.log( 'checkURL', url );

    _url.push( url );

    _url = _url.join( '' );

    console.log( 'url', _url );

    request({
      url: _url,
      json: true,
      method: 'GET'
    }, function( error, req, body ) {

      //req.should.have.property( 'headers' );
      //req.headers.should.have.property( 'content-type' );
      //req.headers.should.have.property( 'x-powered-by' );

      console.log( 'error', error );
      console.log( 'body', body );
      console.log( 'req.headers', req.headers );

      if( done ) {
        return done();
      }

    });

  }

}
