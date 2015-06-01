<?php

header("Content-type: image/png");

$width = 700;
$height = 400;

$image = imagecreate($width,$height);
$background = imagecolorallocate($image, 255, 255, 255);
$foreground = imagecolorallocate($image,0,0,0);

 $black = imagecolorallocate($image, 0, 0, 0);

///////////////////////////////////////////////////////

//Horizontal line

$x1 = 0;
$y1 = $height / 2;

$x2 = $width;
$y2 = $height / 2;

imagestring($image, 5, 5, 1, "Test", $foreground);
imageline($image, $x1, $y1, $x2, $y2, $black);
///////////////////////////////////////////////////////





///////////////////////////////////////////////////////

//Vertical line

$x1 = 0;
$y1 = $height / 2;

$x2 = $width;
$y2 = $height / 2;

imagestring($image, 5, 5, 1, "Test", $foreground);
imageline($image, $x1, $y1, $x2, $y2, $black);
///////////////////////////////////////////////////////


imagepng($image);

?>




















