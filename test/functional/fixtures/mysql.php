<?php
header( 'content-type: application/json' );

$ses = mysqli_connect("localhost","hipstack", "hipstack", "hipstack");


if(!$ses){
  $_result = array( "ok" => false, "message" => "Connection did not work." );
} else {
  $_result = array( "ok" => true, "message" => "Connection to MySQL worked." );
}

die( json_encode( $_result, JSON_PRETTY_PRINT ) );
