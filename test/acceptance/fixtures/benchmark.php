<?php
/**
 * Based off of http://www.php-benchmark-script.com/ but modified to output JSON response.
 *
 * wget https://gist.githubusercontent.com/andypotanin/bae0b8b40581e518e16d/raw/benchmark.php
 * php benchmark.php
 *
 * @version 1.1.0
 * @author potanin@UD
 */

/**
 * Humanize
 * @source http://php.net/manual/en/function.memory-get-usage.php
 * @param $size
 * @return string
 */
function convertMemoryUsage( $size ) {
  $unit = array( 'b', 'kb', 'mb', 'gb', 'tb', 'pb' );
  return @round( $size / pow( 1024, ( $i = floor( log( $size, 1024 ) ) ) ), 2 ) . ' ' . $unit[ $i ];
}

/**
 * @param int $count
 * @return string
 */
function test_Math( $count = 140000 ) {
  $time_start = microtime( true );
  $mathFunctions = array( "abs", "acos", "asin", "atan", "bindec", "floor", "exp", "sin", "tan", "pi", "is_finite", "is_nan", "sqrt" );
  foreach( $mathFunctions as $key => $function ) {
    if( !function_exists( $function ) ) unset( $mathFunctions[ $key ] );
  }
  for( $i = 0; $i < $count; $i++ ) {
    foreach( $mathFunctions as $function ) {
      $r = @call_user_func_array( $function, array( $i ) );
    }
  }
  return number_format( microtime( true ) - $time_start, 3 );
}

/**
 * @param int $count
 * @return string
 */
function test_StringManipulation( $count = 130000 ) {
  $time_start = microtime( true );
  $stringFunctions = array( "addslashes", "chunk_split", "metaphone", "strip_tags", "md5", "sha1", "strtoupper", "strtolower", "strrev", "strlen", "soundex", "ord" );
  foreach( $stringFunctions as $key => $function ) {
    if( !function_exists( $function ) ) unset( $stringFunctions[ $key ] );
  }
  $string = "the quick brown fox jumps over the lazy dog";
  for( $i = 0; $i < $count; $i++ ) {
    foreach( $stringFunctions as $function ) {
      $r = call_user_func_array( $function, array( $string ) );
    }
  }
  return number_format( microtime( true ) - $time_start, 3 );
}

/**
 * @param int $count
 * @return string
 */
function test_Loops( $count = 19000000 ) {
  $time_start = microtime( true );
  for( $i = 0; $i < $count; ++$i ) ;
  $i = 0;
  while( $i < $count ) ++$i;
  return number_format( microtime( true ) - $time_start, 3 );
}

/**
 * @param int $count
 * @return string
 */
function test_IfElse( $count = 9000000 ) {
  $time_start = microtime( true );
  for( $i = 0; $i < $count; $i++ ) {
    if( $i == -1 ) {
    } elseif( $i == -2 ) {
    } else if( $i == -3 ) {
    }
  }
  return number_format( microtime( true ) - $time_start, 3 );
}

// If not set will throw annoying warning.
date_default_timezone_set( 'America/Los_Angeles' );

$_response = array(
  "ok" => true,
  "start" => date( "Y-m-d H:i:s" ),
  "server" => isset( $_SERVER[ 'SERVER_NAME' ] ) ? $_SERVER[ 'SERVER_NAME' ] : null,
  "address" => isset( $_SERVER[ 'SERVER_ADDR' ] ) ? $_SERVER[ 'SERVER_ADDR' ] : null,
  "version" => PHP_VERSION,
  "platform" => PHP_OS,
  "memory" => array(
    "usage" => null,
    "peak" => null,
  ),
  "total" => 0,
  "tests" => array()
);

foreach( (array)get_defined_functions()[ 'user' ] as $user ) {
  if( preg_match( '/^test_/', $user ) ) {
    $_response[ 'total' ] += $result = $user();
    $_response[ 'tests' ][ $user ] = is_numeric( $result ) ? floatval( $result ) : $result;
  }
}

$_response[ 'memory' ][ 'usage' ] = function_exists( 'memory_get_usage' ) ? convertMemoryUsage( memory_get_usage() ) : null;
$_response[ 'memory' ][ 'peak' ] = function_exists( 'memory_get_peak_usage' ) ? convertMemoryUsage( memory_get_peak_usage() ) : null;

header( 'Cache-Control: no-cache, no-store, must-revalidate' );
header( 'Pragma: no-cache' );
header( 'Expires: 0' );
header( 'Content-Type: application/json' );

die( json_encode( $_response, JSON_PRETTY_PRINT ) );
