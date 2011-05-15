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
	$sql = "SELECT id FROM users WHERE name_low='".secure_string(strtolower($_POST['userName']))."'";
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
if (isset($_POST['orderBy']) && $_POST['orderBy'] == 'date')
	$order = "ORDER BY `kubes`.`date` DESC, `kubes`.`score` ASC";
else
	$order = "ORDER BY `kubes`.`score` DESC, `kubes`.`date` DESC";
	
if (isset($_POST['ownerId']) && $_POST['ownerId'] == intval($_POST['ownerId']))
	$where = "WHERE uid=".intval($_POST['ownerId']);
else
	$where = "";

if (isset($_POST['start']) && isset($_POST['length']))
{
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
$sql = "SELECT COUNT(*) as `total` FROM kubes ".$where;
$query = mysql_query($sql);
$res = mysql_fetch_assoc($query);
$totalKubes = intval($res["total"]);

$req = "SELECT * FROM kubes ".$where." ".$order." LIMIT ".$start.",".$length;
$kubes = mysql_query($req);
$kubeNodes = "";
$uidCache = array();//Prevents from unnecessary SQL calls to get user's informations.
if(mysql_num_rows($kubes) == 0 && $resultCode === 0) {
	$resultCode = "NoResultsForThisUser";
}
while ($kube = mysql_fetch_assoc($kubes))
{
	if(!isset($uidCache[$kube['uid']])) {
		$req = "SELECT name FROM users WHERE id=".$kube['uid'];
		$user = mysql_fetch_assoc(mysql_query($req));
		$uidCache[$kube['uid']] = $user;
	}else {
		//If user's informations have already been loaded, just load them back from cache.
		$user = $uidCache[$kube['uid']];
	}
	
	if (isset($_UID)) {
		$req = "SELECT COUNT(kid) as `total` FROM evaluation WHERE kid=".$kube['id']." AND uid=".$_UID;
		$uvote = mysql_fetch_assoc(mysql_query($req));
		$voted = intval($uvote['total']) > 0? true : false;
	}else {
		$voted = true;
	}
	
	$fileName = "../../kubes/".$kube['file'].".kub";
	$handle = fopen($fileName, "r");
	$fileContent = base64_encode(fread($handle, filesize($fileName)));
	fclose($handle);
	$kubeNodes .= "\t\t<kube id=\"".$kube['id']."\" uid=\"".$kube['uid']."\" name=\"".htmlspecialchars(utf8_encode($kube['name']))."\" pseudo=\"".htmlspecialchars(utf8_encode($user['name']))."\" date=\"".strtotime ($kube['date'])."\" votes=\"".$kube['score']."\" voted=\"".$voted."\"><![CDATA[".$fileContent."]]></kube>\r\n";
}

// Retour du xml

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n";
echo "<root>\r\n";
echo "	<result>".$resultCode."</result>\r\n";
echo "	<pagination startIndex='".$start."' total='".$totalKubes."' />\r\n";
echo "	<kubes>\r\n";
echo $kubeNodes;
echo "	</kubes>\r\n";
echo "</root>";

mysql_close();

?>