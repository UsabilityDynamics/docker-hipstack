/**
 * HipStack default tests.
 *
 */
module.exports = {
  HipStack: {
    "Testing /test/mysql.php": checkAsset( "/test/mysql.php" )
  }
};


/**
 *
 * checkAsset( "/test/index.php" )
 *
 * @param url
 * @returns {Function}
 */
function checkAsset( url ) {

  var request = require( 'request' );

  var _url = [ 'http://127.0.0.1' ];

  if( process.env.CI_HIPSTACK_CONTAINER_PORT ) {
    _url.push( ':', process.env.CI_HIPSTACK_CONTAINER_PORT )
  } else {
    _url.push( ':', 49180 );
  }

  return function( done ) {
    // console.log( 'checkURL', url );

    _url.push( url );

    _url = _url.join( '' );

    console.log( 'url', _url );

    request({
      url: _url,
      json: true,
      method: 'GET',
      qs: {
        host: 'localhost',
        user: 'root',
        password: '',
        database: 'hipstack'
      }
    }, function( error, req, body ) {

      if( error ) {
        return done( error );
      }

      body.should.have.property( 'ok', true );
      body.should.have.property( 'message' );
      req.headers.should.have.property( 'via', 'hipstack/v1.0.0' );
      req.headers.should.have.property( 'content-type', 'application/json' );

      return done();

    });

  }

}
