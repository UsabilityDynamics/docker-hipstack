<?php

$_data =  array(
  "ok" => true,
  "data" => array(
    "hhvm" => defined('HHVM_VERSION') ? true : false,
    "server" => $_SERVER,
    "env" => $_ENV,
    "request" => $_REQUEST
  )
);

die( json_encode( $_data, true ) );
