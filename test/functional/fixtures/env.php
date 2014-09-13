<?php
/**
 * Test Environment Variables
 *
 * For obvious reasons this should not be mounted when in production.
 *
 */

$_response = array(
  "ok" => true,
  "message" => "Showing all environment variables passed through request stack.",
  "env" => $_ENV,
  "server" => $_SERVER,

);

header( 'content-type: application/json' );
die( json_encode( $_response, JSON_PRETTY_PRINT ) );