<?php
ini_set('display_errors', 1);
ini_set("max_execution_time", 0);
ini_set("memory_limit", "10000M");
error_reporting(E_ALL ^ E_NOTICE);

 
function getFASTA($name) {
	$url = "http://www.uniprot.org/uniprot/".($name).".fasta";
	//echo $url;
    $ch = curl_init(); 
    curl_setopt($ch, CURLOPT_URL, $url); 
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); 
    $output = curl_exec($ch); 
	echo $output;
    curl_close($ch);   
}

/*
function getUnreviewedUniprotEntries($name){

}
*/


$sanitizedProteinName = htmlspecialchars($_GET['protein_entry']);

echo ( getFASTA($sanitizedProteinName) );


?>