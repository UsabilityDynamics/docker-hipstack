<?php
header( 'content-type: application/json' );

$_response = array(
  "ok" => true,
  "message" => "env vars",
  "env" => $_ENV,
  "server" => $_SERVER,

);

die( json_encode( $_response, JSON_PRETTY_PRINT ) );