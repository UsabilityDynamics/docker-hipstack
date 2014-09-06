<?php

$_data =  array(
  "ok" => true,
  "data" => array(
    "server" => $_SERVER,
    "env" => $_ENV,
    "request" => $_REQUEST
  )
);

die( json_encode( $_data, true ) );