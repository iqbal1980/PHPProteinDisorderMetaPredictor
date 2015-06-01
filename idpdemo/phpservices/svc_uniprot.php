
<?php
ini_set('display_errors', 1);
ini_set("max_execution_time", 0);
ini_set("memory_limit", "10000M");
error_reporting(E_ALL ^ E_NOTICE);


//http://www.uniprot.org/uniprot/?query=spondin&format=list&columns=id
function getReviewedUniprotEntries($name) {

	//$url = "http://www.uniprot.org/uniprot/?query=".($name)."&format=tab&columns=id,reviewed,protein%20names,organism";
	$url = "http://www.uniprot.org/uniprot/?query=".($name)."&format=tab&columns=id,protein%20names";
	$fp = fopen($url, "r") or die("Impossible de lire la ligne de commande");
	echo '<ul>';
	while (!feof($fp)) {
		$line = fgets($fp);
		$line = preg_replace("/(^[A-Za-z0-9]+)( |\t)+/","<input type=\"checkbox\" id=\"checkbox_$1\" value=\"checkbox_$1\"/><b><a href=\"javascript:loadStuff('$1');\" id=\"UP_SP_$1\" class=\"proteinIdClass draggable\">  $1</a></b>",$line);
		//$line = preg_replace("/\n/","<br/>",$line);
		echo "<li>$line</li>";
	}
	echo '</ul>';
	fclose($fp);
}

/*
function getUnreviewedUniprotEntries($name){

}
*/


$sanitizedProteinName = htmlspecialchars($_GET['protein_name']);

echo ( getReviewedUniprotEntries($sanitizedProteinName) );


?>