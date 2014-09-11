<?php
header( 'content-type: application/json' );

$_GET["host"] = $_GET["host"] ? $_GET["host"] : 'localhost';
$_GET["user"] = $_GET["user"] ? $_GET["user"] : 'root';
$_GET["password"] = $_GET["password"] ? $_GET["password"] : 'root';
$_GET["database"] = $_GET["database"] ? $_GET["database"] : 'hipstack';

$ses = mysqli_connect( $_GET["host"],$_GET["user"], $_GET["password"], $_GET["database"] );


if(!$ses){

  $_result = array(
    "ok" => false,
    "message" => "Connection did not work.",
    "creds" => $_GET
  );

} else {

  $_result = array(
    "ok" => true,
    "message" => "Connection to MySQL worked.",
    "creds" => $_GET
  );

}

die( json_encode( $_result, JSON_PRETTY_PRINT ) );
