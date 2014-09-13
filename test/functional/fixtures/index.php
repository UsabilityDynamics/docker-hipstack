<?php
/**
 * Generic test response.
 *
 */

$_response = array(
  "ok" => true,
  "message" => "Test root here."
);

header( 'content-type: application/json' );
die( json_encode( $_response, JSON_PRETTY_PRINT ) );