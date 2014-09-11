<?php
header( 'content-type: application/json' );
die( json_encode( $_SERVER ) );