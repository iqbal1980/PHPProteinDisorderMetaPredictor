<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);
echo "test";

$subject = $_GET["subject"];
$to = $_GET["to"];
$message = $_GET["message"];
$headers = 'From: donotreply@disney.com' . "\r\n" ;



echo  ">>>>".mail(  $to ,  $subject ,  $message, $headers );


?>