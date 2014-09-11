<?php
header( 'content-type: application/json' );

$_response = array(
  "ok" => true,
  "message" => "Test root here."
);

die( json_encode( $_response, JSON_PRETTY_PRINT ) );