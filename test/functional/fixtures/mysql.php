<?php
header( 'content-type: application/json' );
$ses = mysqli_connect("localhost","hipstack", "hipstack", "hipstack");

if(!$ses){
  die( json_encode( array( "ok" => false, "message" => "Connection did not work." ) ) );
}

die( json_encode( array( "ok" => true, "message" => "Connection to MySQL worked." ) ) );
