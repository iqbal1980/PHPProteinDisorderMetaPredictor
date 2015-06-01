


<?php

//ini_set('display_errors', 1);
//ini_set("max_execution_time", 0);
//ini_set("memory_limit", "10000M");
//java -jar VSL2.jar -s:



$fastas = trim($_POST['fastas']);
$fastas = preg_replace("/\>(.*)$/m", "", $fastas);
$ip = $_SERVER['REMOTE_ADDR'];


function beautyPrint($input) {
echo "<br/><pre>";
var_dump($input);
echo "</pre><br/>";
}

function callVSL2($myFastas) {

	$output = array();
	$timeNow = time();
	$fileNameOnly = "tmp_file_".(md5($timeNow.$ip)).".txt";

	$fullFileName = "/tmp/ram/$fileNameOnly";
	clearstatcache();
	
	$pipe = fopen($fullFileName, "c+") or die("can't open file");
	fwrite($pipe,$myFastas);

	chdir("/tmp/ram");
	$test1 = `mkfifo $fileNameOnly & ls`;

	chdir("/tmp/ram/VSL2");
	$test2 = "[";
	$test2 .= `java -jar VSL2.jar -s:/tmp/ram/$fileNameOnly | grep -E '([0-9]+)(\t|[ ]+)([A-Z])(\t|[ ]+)(0)(\.)([0-9]+)'` ;
	$test2 = preg_replace("/([0-9]+)(\t|[ ]+)([A-Z])(\t|[ ]+)(0)(\.)([0-9]+)(\t|[ ]+)(\.|D)$/m","[$1,\"$3\",$5$6$7]",$test2);
	$test2 = preg_replace("/\n/m",",",$test2);
	$test2 = preg_replace("/,( )*$/m","  ]",$test2);
		

	//echo $test2;
	chdir("/tmp/ram");
	$testExec = `rm $fileNameOnly`;

	fclose($pipe);
	return $test2;
}


function callIUPred($myFastas) {	
	$output = array();
	$timeNow = time();
	$fileNameOnly = "tmp_file_".(md5($timeNow.$ip)).".txt";

	$fullFileName = "/tmp/ram/$fileNameOnly";
	clearstatcache();
	
	$pipe = fopen($fullFileName, "c+") or die("can't open file");
	fwrite($pipe,$myFastas);

	chdir("/tmp/ram");
	$test1 = `mkfifo $fileNameOnly & ls`;

	chdir("/tmp/ram/iupred");
	$test2 = "[";
	$test2 .= `./iupred ../$fileNameOnly long | grep -E '([0-9]+)( )([A-Z])(\t|[ ]+)(0)(\.)([0-9]+)' `;
	$test2 = preg_replace("/([0-9]+)( )([A-Z])(\t|[ ]+)(0)(\.)([0-9]+)/m","[$1,\"$3\",$5$6$7]",$test2);
	$test2 = preg_replace("/\n/m",",",$test2);
	$test2 = preg_replace("/,( )*$/m","]",$test2);

	//echo $test2;
	chdir("/tmp/ram");
	$testExec = `rm $fileNameOnly`;

	fclose($pipe);
	return $test2;
}

 

function getFastasAndPredict($fastasInput,$operationType) {
        
	$value = $fastasInput;
	//beautyPrint($value);
	$arraySize = 1;	
	$jsonOutPut = "";
	$jsonOutPut .= "";
	$i = 0;
        //foreach ($fastaArray as $value) { 
			$i++;
			
			$title = "RANDOM_".(time());
			$matches = array();
			preg_match("/\>.*$/m", $value, $matches);
			
			if(trim($matches[0]) != "") {
				$title = $matches[0];
				$titlesArray = explode("|",$title);
				$title = $titlesArray[0]."_".$titlesArray[1]."_".$titlesArray[2];
				$title = str_replace(" ","_",$title);
			}
			
			
			$jsonOutPut .= '{ "title"  : "'.$title.'" , "data" : ';
			$value = preg_replace("/\>(.*)$/m", "", trim($value));			
			

			
			if($operationType == "iupred") {
				$jsonOutPut .= callIUPred($value);
			}  

			if($operationType == "vsl2") {
				$jsonOutPut .= callVSL2($value);
			} 
			
			 
			if($i == $arraySize) {
				$jsonOutPut .= "}";
			} else {
				$jsonOutPut .= "},";			
			}
 
	//}
	$jsonOutPut .= "";
	echo $jsonOutPut;
	//echo beautyPrint($jsonOutPut);
}



/*
if($currentOperation == "iupred") {
	callIUPred($fastas);
} 

if($currentOperation == "vsl2") {
	callVSL2($fastas);
}
*/




$fasta2 =">tr|Q7KN04|Q7KN04_DROME Fat-spondin OS=Drosophila melanogaster GN=fat-spondin PE=2 SV=1
MGQSLPLLIRLIVVIWLTISMVTACPRAPTHLNHGRRTRGDNGYKLIVADGPNGYVPGKT
YNLLLLGSRTHLKVQHFTHFTITAEAHTGARRPQAASPRRVGRFQLFSDSLTQFNDRCVN
TVSEADDLPKTEVQVMWVAPESGSGCVSLSAMVYEGPRAWFADDGNLSTVICERKPDAAA
AQKECCACDEAKYSFVFEGIWSNETHPKDYPFAIWLTHFSDVIGASHESNFSFWGENHIA
TAGFRSLAEWGSPAALETELRANGPKLRTLIKAAGLWYPNVNQNTSSKFRVDRKHPKVSL
VSMFGPSPDWVVGISGLDLCTEDCSWKESMDFDLFPWDAGTDSGISYMSPNSETQPPERM
YRITTMYPEDPRAPFYNPKSREMTPLAKLYLRREKIVSRNCDDEFLQALQLEVSDDAEEQ
DTRAECRVGDYSAWSPCSVSCGKGIRMRSRQYLYPAAADQNKCARQLVAKEMCVAAIPEC
ADGPAQSKDRDDDEGENLANSQSLVGSNGEGAGLCKTSPWSVWSECSASCGIGITMRTRT
FVNHLGRKRCPHITIVEKNKCMRPDCTYEQVELPDPQCPTSQWSDWSPCSSTCGRGVTIR
TRLLLLENGPDKESCTQRMELHQQKECVNPIDCHINAEQAKDICVQAPDPGPCRGTYMRY
AYDPQNQHCYSFTYGGCRGNRNNFLTENDCLNTCNVLRSPYSSRVDQPRACVLSDWSVWS
PCSVSCGVGVSESRRYVVTEPQNGGQPCSKRLVKSRSCAMPAC";

$fasta2 = $fastas;

$currentOperation = "vsl2";
$currentOperation = trim($_POST['operation']); 
//$currentOperation = "vsl2";


getFastasAndPredict($fasta2,$currentOperation);

 
 



 
?>


 
