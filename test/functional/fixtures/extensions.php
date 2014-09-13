<?php
/**
 *
 */

$_response = array(
  "ok" => true,
  "message" => "PHP extensions.",
  "extensions" => get_loaded_extensions()
);

header( 'content-type: application/json' );
die( json_encode( $_response, JSON_PRETTY_PRINT ) );