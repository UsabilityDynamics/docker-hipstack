<?php
header( 'content-type: application/json' );

$ses = mysqli_connect( $_GET["host"],$_GET["user"], $_GET["password"], $_GET["database"] );


if(!$ses){
  $_result = array( "ok" => false, "message" => "Connection did not work." );
} else {
  $_result = array( "ok" => true, "message" => "Connection to MySQL worked." );
}

die( json_encode( $_result, JSON_PRETTY_PRINT ) );
