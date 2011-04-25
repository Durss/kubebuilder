<?php
header("Content-type: text/xml");
		
// Vérification des variables envoyées en POST 
session_start();

$resultCode = 0;
//TODO gérer les cas d'erreurs SQL

//If a user name is specified gets its ID to search its kubes.
if (isset($_POST['userName']) && strlen($_POST['userName']) > 0) {
	$sql = "SELECT uid FROM users WHERE name_low = '%".secure_string(strtolower($_POST['userName']))."'%";
	$res = mysql_query($sql);
	if (mysql_num_rows($result) > 0) {
		$user = mysql_fetch_assoc($res);
		$_POST['ownerId'] = $user['uid'];
	}
}

//Build request
if (isset($_POST['orderBy']) && $_POST['orderBy'] == 'date')
	$order = "ORDER BY `kubes`.`date` DESC, `kubes`.`date` DESC";
else
	$order = "ORDER BY `kubes`.`score` DESC, `kubes`.`date` DESC";
	
if (isset($_POST['ownerId']) && $_POST['ownerId'] == intval($_POST['ownerId']))
	$where = "WHERE uid='".$_POST[ownerId]."'";
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

// Connection Mysql et récupération de la liste des kubes
include '../connection.php';

//Gets the number of results
$sql = "SELECT COUNT(*) as `total` FROM kubes ".$where;
$query = mysql_query($sql);
$res = mysql_fetch_assoc($query);
$totalKubes = intval($res["total"]);

$req = "SELECT * FROM kubes ".$where." ".$order." LIMIT ".$start.",".$length;
$kubes = mysql_query($req);
$kubeNodes = "";

while ($kube = mysql_fetch_assoc($kubes))
{
	$req = "SELECT name FROM users WHERE id=".$kube['uid'];
	$user = mysql_fetch_assoc(mysql_query($req));
	$fileName = "../../kubes/".$kube['file'].".kub";
	$handle = fopen($fileName, "r");
	$fileContent = base64_encode(fread($handle, filesize($fileName)));
	fclose($handle);
	$kubeNodes .= "\t\t<kube id=\"".$kube['id']."\" uid=\"".$kube['uid']."\" name=\"".htmlspecialchars(utf8_encode($kube['name']))."\" pseudo=\"".htmlspecialchars(utf8_encode($user['name']))."\" date=\"".strtotime ($kube['date'])."\" votes=\"".$kube['score']."\"><![CDATA[".$fileContent."]]></kube>\r\n";
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

?>