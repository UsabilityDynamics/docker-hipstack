<?php

if (!isset($_GET['type'])) {
  die("HipStack server is up.\n");
}

if (isset($_GET['type']) && $_GET['type'] === 'php') {
  die('PHP Version is ' . phpversion() . "\n");
}

if (isset($_GET['type']) && $_GET['type'] === 'apache') {
  die('Apache Version is ' . apache_get_version() . "\n");
}

if (isset($_GET['type']) && $_GET['type'] === 'pagespeed') {
  die('PageSpeed is not enabled.' . "\n");
}

if (isset($_GET['type']) && $_GET['type'] === 'hhvm') {

  if (defined('HHVM_VERSION')) {
    die('HHVM is enabled. (v' . HHVM_VERSION . ") \n");
  } else {
    die('Not using HHVM.' . "\n");

  }
}

