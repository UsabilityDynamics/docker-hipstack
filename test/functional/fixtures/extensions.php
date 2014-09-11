<?php
header( 'content-type: application/json' );

$_response = array(
  "ok" => true,
  "extensions" => get_loaded_extensions()
);

die( json_encode( $_response, JSON_PRETTY_PRINT ) );