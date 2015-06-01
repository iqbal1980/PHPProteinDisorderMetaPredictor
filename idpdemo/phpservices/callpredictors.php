


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
        
	$fastaArray = preg_split("/[\n|\r][\n|\r]+/", $fastasInput);
		//beautyPrint($fastaArray);
	$arraySize = count($fastaArray);	
	$jsonOutPut = "";
	$jsonOutPut .= "[";
	$i = 0;
        foreach ($fastaArray as $value) { 
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
 
	}
	$jsonOutPut .= "]";
	echo $jsonOutPut;
	//echo beautyPrint($jsonOutPut);
}



$fastas2 = "

>gi|15674251 chromosomal replication initiation protein
MTENEQIFWNRVLELAQSQLKQATYEFFVHDARLLKVDKHIATIYLDQMKELFWEKNLKDVILTAGFEVY
NAQISVDYVFEEDLMIEQNQTKINQKPKQQALNSLPTVTSDLNSKYSFENFIQGDENRWAVAASIAVANT
PGTTYNPLFIWGGPGLGKTHLLNAIGNSVLLENPNARIKYITAENFINEFVIHIRLDTMDELKEKFRNLD
LLLIDDIQSLAKKTLSGTQEEFFNTFNALHNNNKQIVLTSDRTPDHLNDLEDRLVTRFKWGLTVNITPPD
FETRVAILTNKIQEYNFIFPQDTIEYLAGQFDSNVRDLEGALKDISLVANFKQIDTITVDIAAEAIRARK
QDGPKMTVIPIEEIQAQVGKFYGVTVKEIKATKRTQNIVLARQVAMFLAREMTDNSLPKIGKEFGGRDHS
TVLHAYNKIKNMISQDESLRIEIETIKNKIK
>gi|15674252 DNA polymerase III subunit beta
MIQFSINRTLFIHALNTTKRAISTKNAIPILSSIKIEVTSTGVTLTGSNGQISIENTIPVSNENAGLLIT
SPGAILLEASFFINIISSLPDISINVKEIEQHQVVLTSGKSEITLKGKDVDQYPRLQEVSTENPLILKTK
LLKSIIAETAFAASLQESRPILTGVHIVLSNHKDFKAVATDSHRMSQRLITLDNTSADFDVVIPSKSLRE
FSAVFTDDIETVEVFFSPSQILFRSEHISFYTRLLEGNYPDTDRLLMTEFETEVVFNTQSLRHAMERAFL
ISNATQNGTVKLEITQNHISAHVNSPEVGKVNEDLDIVSQSGSDLTISFNPTYLIESLKAIKSETVKIHF
LSPVRPFTLTPGDEEESFIQLITPVRTN
>gi|15674253 hypothetical protein SPy0004
MYQIGSFVEMKKPHACVIKETGKKANQWKVLRVGADIKIQCTNCQHVIMMSRYDFERKLKKVLQP
>gi|15674254 putative GTP-binding protein
MALTAGIVGLPNVGKSTLFNAITKAGAEAANYPFATIDPNVGMVEVPDERLQKLTELITPKKTVPTTFEF
TDIAGIVKGASRGEGLGNKFLANIREIDAIVHVVRAFDDENVMREQGREDAFVDPIADIDTINLELILAD
LESINKRYARVEKMARTQKDKESVAEFNVLQKIKPVLEDGKSARTIEFTEDEAKVVKGLFLLTTKPVLYV
ANVDEDKVANPDGIDYVKQIRDFAATENAEVVVISARAEEEISELDDEDKEEFLEAIGLTESGVDKLTRA
AYHLLGLGTYFTAGEKEVRAWTFKRGIKAPQAAGIIHSDFERGFIRAVTMSYDDLMTYGSEKAVKEAGRL
REEGKEYVVQDGDIMEFRFNV
>gi|15674255 peptidyl-tRNA hydrolase
MVKMIVGLGNPGSKYEKTKHNIGFMAIDNIVKNLDVTFTDDKNFKAQIGSTFINHEKVYFVKPTTFMNNS
GIAVKALLTYYNIDITDLIVIYDDLDMEVSKLRLRSKGSAGGHNGIKSIIAHIGTQEFNRIKVGIGRPLK
GMTVINHVMGQFNTEDNIAISLTLDRVVNAVKFYLQENDFEKTMQKFNG
>gi|15674256 putative transcription-repair coupling factor
MDILELFSQNKKVQSWHSGLTTLGRQLVMGLSGSSKTLAIASAYLDDQKKIVVVTSTQNEVEKLASDLSS
LLDEELVFQFFADDVAAAEFIFASMDKALSRIETLQFLRNPKSQGVLIVSLSGLRILLPNPDVFTKSQIQ
LTVGEDYDSDTLTKQLMTIGYQKVSQVISPGEFSRRGDILDIYEITQELPYRLEFFGDDIDSIRQFHPET
QKSFEQLEGIFINPASDLIFEVSDFQRGIEQLEKALQTAQDDKKSYLEDVLAVSKNGFKHKDIRKFQSLF
YEKEWSLLDYIPKGTPIFFDDFQKLVDKNARFDLEIANLLTEDLQQGKALSNLNYFTDNYRELRHYKPAT
FFSNFHKGLGNIKFDQMHQLTQYAMQEFFNQFPLLIDEIKRYQKNQTTVIVQVESQYAYERLEKSFQDYQ
FRLPLVSANQIVSRESQIVIGAISSGFYFADEKLALITEHEIYHKKIKRRARRSNISNAERLKDYNELAV
GDYVVHNVHGIGRFLGIETIQIQGIHRDYVTIQYQNSDRISLPIDQISSLSKYVSADGKEPKINKLNDGR
FQKTKQKVARQVEDIADDLLKLYAERSQQKGFSFSPDDDLQRAFDDDFAFVETEDQLRSIKEIKADMESM
QPMDRLLVGDVGFGKTEVAMRAAFKAVNDHKQVAVLVPTTVLAQQHYENFKARFENYPVEVDVLSRFRSK
KEQAETLERVRKGQIDIIIGTHRLLSKDVVFSDLGLIVIDEEQRFGVKHKETLKELKTKVDVLTLTATPI
PRTLHMSMLGIRDLSVIETPPTNRYPVQTYVLENNPGLVREAIIREMDRGGQIFYVYNKVDTIEKKVAEL
QELVPEASIGFVHGQMSEIQLENTLIDFINGDYDVLVATTIIETGVDISNVNTLFIENADHMGLSTLYQL
RGRVGRSNRIAYAYLMYRPDKVLTEVSEKRLEAIKGFTELGSGFKIAMRDLSIRGAGNILGASQSGFIDS
VGFEMYSQLLEQAIASKQGKTTVRQKGNTEINLQIDAYLPDDYIADERQKIDIYKRIREIQSREDYLNLQ
DELMDRFGEYPDQVAYLLEIALLKHYMDNAFAELVERKNNQVIVRFEVTSLTYFLTQDYFEALSKTHLKA
KISEHQGKIDIVFDVRHQKDYRILEELMLFGERLSEIKIRKNNSVFK
>gi|15674257 hypothetical protein SPy0009
MKRIVGEIMRLDKYLKVSRLIKRRSVAKEVADKGRIKVNGILAKSSTNIKLNDHIEISFGNKLLTVRVIE
IKDSTKKEDALKMYEIISETRITLNEEA
>gi|15674258 putative cell division protein (DivIC)
MKKPSIVQLNNHYIKKENLKKKFEEEESQKRNRFMGWILVSMMFLFILPTYNLVKSYVDFEKQNQQVVKL
KKEYNELSESTKKEKQLAERLKDDNFVKKYARAKYYLSREGEMIYPIPGLLPK
>gi|15674259 hypothetical protein SPy0012
MRKLLAAMLMTFFLTPLPVISTEKKLIFSKNAVYQLKQDVVQSTQFYNQIPSNPNLYQETCAYKDSDLTL
PAGRLGVNQPLLIKSLVLNKESLPVFELADGTYVEANRQLIYDDIVLNQVDIDSYFWTQKKLRLYSAPYV
LGTQTIPSSFLFAQKVHATQMAQTNHGTYYLIDDKGWASQEDLVQFDNRMLKVQEMLLQKYNNPNYSIFV
KQLNTQTSAGINADKKMYAASISKLAPLYIVQKQLQKKKLAENKTLTYTKDVNHFYGDYDPLGSGKISKI
ADNKDYRVEDLLKAVAQQSDNVATNILGYYLCHQYDKAFRSEIKALSGIDWDMEQRLLTSRSAANMMEAI
YHQKGQIISYLSNTEFDQQRITKNITVPVAHKIGDAYDYKHDVAIVYGNTPFILSIFTNKSTYEDITAIA
DDVYGILK
								
>sp|Q9ULV1|FZD4_HUMAN Frizzled-4 OS=Homo sapiens GN=FZD4 PE=1 SV=2
MAWRGAGPSVPGAPGGVGLSLGLLLQLLLLLGPARGFGDEEERRCDPIRISMCQNLGYNV
TKMPNLVGHELQTDAELQLTTFTPLIQYGCSSQLQFFLCSVYVPMCTEKINIPIGPCGGM
CLSVKRRCEPVLKEFGFAWPESLNCSKFPPQNDHNHMCMEGPGDEEVPLPHKTPIQPGEE
CHSVGTNSDQYIWVKRSLNCVLKCGYDAGLYSRSAKEFTDIWMAVWASLCFISTAFTVLT
FLIDSSRFSYPERPIIFLSMCYNIYSIAYIVRLTVGRERISCDFEEAAEPVLIQEGLKNT
GCAIIFLLMYFFGMASSIWWVILTLTWFLAAGLKWGHEAIEMHSSYFHIAAWAIPAVKTI
VILIMRLVDADELTGLCYVGNQNLDALTGFVVAPLFTYLVIGTLFIAAGLVALFKIRSNL
QKDGTKTDKLERLMVKIGVFSVLYTVPATCVIACYFYEISNWALFRYSADDSNMAVEMLK
IFMSLLVGITSGMWIWSAKTLHTWQKCSNRLVNSGKVKREKRGNGWVKPGKGSETVV

>sp|Q61091|FZD8_MOUSE Frizzled-8 OS=Mus musculus GN=Fzd8 PE=1 SV=2
MEWGYLLEVTSLLAALAVLQRSSGAAAASAKELACQEITVPLCKGIGYNYTYMPNQFNHD
TQDEAGLEVHQFWPLVEIQCSPDLKFFLCSMYTPICLEDYKKPLPPCRSVCERAKAGCAP
LMRQYGFAWPDRMRCDRLPEQGNPDTLCMDYNRTDLTTAAPSPPRRLPPPPPPGEQPPSG
SGHSRPPGARPPHRGGSSRGSGDAAAAPPSRGGKARPPGGGAAPCEPGCQCRAPMVSVSS
ERHPLYNRVKTGQIANCALPCHNPFFSQDERAFTVFWIGLWSVLCFVSTFATVSTFLIDM
ERFKYPERPIIFLSACYLFVSVGYLVRLVAGHEKVACSGGAPGAGGAGGAGGAAAAGAGA
AGAGASSPGARGEYEELGAVEQHVRYETTGPALCTVVFLLVYFFGMASSIWWVILSLTWF
LAAGMKWGNEAIAGYSQYFHLAAWLVPSVKSIAVLALSSVDGDPVAGICYVGNQSLDNLR
GFVLAPLVIYLFIGTMFLLAGFVSLFRIRSVIKQQGGPTKTHKLEKLMIRLGLFTVLYTV
PAAVVVACLFYEQHNRPRWEATHNCPCLRDLQPDQARRPDYAVFMLKYFMCLVVGITSGV
WVWSGKTLESWRALCTRCCWASKGAAVGAGAGGSGPGGSGPGPGGGGGHGGGGGSLYSDV
STGLTWRSGTASSVSYPKQMPLSQV

>sp|A2ARI4|LGR4_MOUSE Leucine-rich repeat-containing G-protein coupled receptor 4 OS=Mus musculus GN=Lgr4 PE=1 SV=1
MPGPLRLLCFFALGLLGSAGPSGAAPPLCAAPCSCDGDRRVDCSGKGLTAVPEGLSAFTQ
ALDISMNNITQLPEDAFKNFPFLEELQLAGNDLSFIHPKALSGLKELKVLTLQNNQLKTV
PSEAIRGLSALQSLRLDANHITSVPEDSFEGLVQLRHLWLDDNILTEVPVRPLSNLPTLQ
ALTLALNNISSIPDFAFTNLSSLVVLHLHNNKIKSLSQHCFDGLDNLETLDLNYNNLDEF
PQAIKALPSLKELGFHSNSISVIPDGAFAGNPLLRTIHLYDNPLSFVGNSAFHNLSDLHS
LVIRGASLVQWFPNLAGTVHLESLTLTGTKISSIPDDLCQNQKMLRTLDLSYNDIRDLPS
FNGCRALEEISLQRNQISLIKETTFQGLTSLRILDLSRNLIREIHSGAFAKLGTITNLDV
SFNELTSFPTEGLNGLNQLKLVGNFQLKDALAARDFANLRSLSVPYAYQCCAFWGCDSYA
NLNTEDNSPQDHSVTKEKGATDAANATSTAESEEHSQIIIHCTPSTGAFKPCEYLLGSWM
IRLTVWFIFLVALLFNLLVILTVFASCSSLPASKLFIGLISVSNLLMGIYTGILTFLDAV
SWGRFAEFGIWWETGSGCKVAGSLAVFSSESAVFLLTLAAVERSVFAKDVMKNGKSSHLR
QFQVAALVALLGAAIAGCFPLFHGGQYSASPLCLPFPTGETPSLGFTVTLVLLNSLAFLL
MAIIYTKLYCNLEKEDPSENSQSSMIKHVAWLIFTNCIFFCPVAFFSFAPLITAISISPE
IMKSVTLIFFPLPACLNPVLYVFFNPKFKDDWKLLKRRVTRKHGSVSVSISSQGGCGEQD
FYYDCGMYSHLQGNLTVCDCCESFLLTKPVSCKHLIKSHSCPVLTVASCQRPEAYWSDCG
TQSAHSDYADEEDSFVSDSSDQVQACGRACFYQSRGFPLVRYAYNLPRVRD
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
PCSVSCGVGVSESRRYVVTEPQNGGQPCSKRLVKSRSCAMPAC




MSATIKLESSDEQVFEVAREIAEMSVTVKHMLDDVDADSENAIPLPNVSGKILAKVIEWA
TYHHENPEPAPTADGADAAAAAADAKDQKRTDDISPWDKEFCDVEQPTLFELILAANYLD
IKPLLDLGCKSVANMIKGKSPEEIRKTFNIKNDFSPEEEEAIRKENEWCLDL";

 


$currentOperation = trim($_POST['operation']); 
/*
if($currentOperation == "iupred") {
	callIUPred($fastas);
} 

if($currentOperation == "vsl2") {
	callVSL2($fastas);
}
*/
$fastas2 = $fastas;

getFastasAndPredict($fastas2,$currentOperation);


/*

*/
 



 
?>


 
