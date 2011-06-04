<?php
header("Content-type: text/xml");

// Connection Mysql et récupération de la liste des kubes
include '../constants.php';
include '../connection.php';
include '../getUserInfos.php';
include '../secure.php';
		
$resultCode = 0;
//TODO gérer les cas d'erreurs SQL

//If a user name is specified gets its ID to search its kubes.
if (isset($_POST['userName']) && strlen($_POST['userName']) > 0) {
	$sql = "SELECT id FROM kubebuilder_users WHERE name_low='".secure_string(strtolower($_POST['userName']))."'";
	$req = mysql_query($sql);
	if ($req !== false && mysql_num_rows($req) > 0) {
		$user = mysql_fetch_assoc($req);
		$_POST['ownerId'] = $user['id'];
	}else {
		$_POST['ownerId'] = -1;
		$resultCode = "UserNotFound";
	}
}

//Build request
if (isset($_POST['orderBy']) && $_POST['orderBy'] == 'date') {
	$order = "ORDER BY `date` DESC, `score` ASC";
}else {
	$order = "ORDER BY `score` DESC, `date` DESC";
}

$where = "WHERE locked=0 ";
if (isset($_POST['ownerId'])) {//Search by user ID
	$where .= "AND uid=".intval($_POST['ownerId']);
} else if (isset($_POST['kubeId'])) {//Search by kube ID
	$where .= "AND id=".intval($_POST['kubeId']);
}

if (isset($_POST['start']) && isset($_POST['length'])) {
	$start = floor(intval($_POST['start']));
	$length = floor(intval($_POST['length']));

	if ($length > 100 || $length <= 0)
	{
		$length = 50;
	}
}

else
{
	$start = 0;
	$length = 50;
}

//Gets the number of results
$sql = "SELECT COUNT(*) as `total` FROM kubebuilder_kubes ".$where;
$query = mysql_query($sql);
$res = mysql_fetch_assoc($query);
$totalKubes = intval($res["total"]);

/**
 * Gets the details about a kube
 */
function getKubeDetails($kube) {
	global $uidCache, $_UID;
	if(!isset($uidCache[$kube['uid']])) {
		$sqlUser = "SELECT name FROM kubebuilder_users WHERE id=".$kube['uid'];
		$user = mysql_fetch_assoc(mysql_query($sqlUser));
		$uidCache[$kube['uid']] = $user;
	}else {
		//If user's informations have already been loaded, just load them back from cache.
		$user = $uidCache[$kube['uid']];
	}
	
	if (isset($_UID)) {
		$sqlEval = "SELECT COUNT(kid) as `total` FROM kubebuilder_evaluation WHERE kid=".$kube['id']." AND uid=".$_UID;
		$uvote = mysql_fetch_assoc(mysql_query($sqlEval));
		$voted = intval($uvote['total']) > 0? "true" : "false";
	}else {
		$voted = "true";
	}
	
	return array("voted" => $voted, "user" => $user);
}

/**
 * Creates the XML node of a kube
 */
function createKubeNode($kube) {
	$details = getKubeDetails($kube);
	
	$fileName = "../../kubes/".$kube['file'].".kub";
	$handle = fopen($fileName, "r");
	$fileContent = base64_encode(fread($handle, filesize($fileName)));
	fclose($handle);
	return "\t\t<kube id=\"".$kube['id']."\" uid=\"".$kube['uid']."\" name=\"".htmlspecialchars(utf8_encode($kube['name']))."\" pseudo=\"".htmlspecialchars(utf8_encode($details['user']['name']))."\" date=\"".strtotime ($kube['date'])."\" votes=\"".$kube['score']."\" voted=\"".$details['voted']."\"><![CDATA[".$fileContent."]]></kube>\r\n";

}

$sqlList = "SELECT * FROM kubebuilder_kubes ".$where." ".$order." LIMIT ".$start.",".$length;
$kubes = mysql_query($sqlList);
$kubeNodes = "";
$lastKubesNode = "";
$uidCache = array();//Prevents from unnecessary SQL calls to get user's informations.
if(mysql_num_rows($kubes) == 0 && $resultCode === 0) {
	if (isset($_POST['kubeId'])) {
		$resultCode = "NoKubeAtThisIndex";
	}else if (isset($_POST['ownerId'])) {
		$resultCode = "NoResultsForThisUser";
	}
}
while ($kube = mysql_fetch_assoc($kubes)) {
	$kubeNodes .= createKubeNode($kube);
}

//If last added kubes asked, load them
if(isset($_POST["lastToLoad"]) && intval($_POST["lastToLoad"]) > 0) {
	$sqlLast = "SELECT * FROM kubebuilder_kubes WHERE locked=0 ORDER BY date DESC LIMIT 0,".intval($_POST["lastToLoad"]);
	$kubes = mysql_query($sqlLast);
	while ($kube = mysql_fetch_assoc($kubes)) {
		$kubeNodes .= createKubeNode($kube);
	}
}

// Retour du xml

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n";
echo "<root>\r\n";
echo "	<result>".$resultCode."</result>\r\n";
echo "	<pagination startIndex='".$start."' total='".$totalKubes."' />\r\n";
echo "	<kubes>\r\n";
echo $kubeNodes;
echo $lastKubesNode;
echo "	</kubes>\r\n";
echo "</root>";

mysql_close();

?>