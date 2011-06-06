<?php
header("Content-type: text/xml; charset=UTF-8");
header("Cache-Control: no-store, no-cache, must-revalidate"); // HTTP/1.1
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache"); // HTTP/1.0 

require_once('../constants.php');
require_once('../connection.php');
require_once('../secure.php');
require_once('../getUserInfos.php');

$result = 0;
$listNodes = "";
if (isset($_UID, $_UNAME)) {
	if (isset($_POST['lid'])) {
		$sql = "SELECT kubes FROM `kubebuilder_lists` WHERE id=".intval($_POST['lid']);
		$request = mysql_query($sql);
		$sqlKubes = "SELECT *FROM kubebuilder_kubes WHERE";//TODO
		$entry = mysql_fetch_assoc($request);
		$kubes = explode(",", $entry["kubes"]);
		for ($i = 0; $i < count($kubes); $i++) {
		
		}
	}else {
		$result = "Post";
	}
	mysql_close();
}else {
	$result = "Auth";
}

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n";
echo "<root>\r\n";
echo "	<result>".$result."</result>\r\n";
echo "	<lists>\r\n";
echo "		".$listNodes;
echo "	</lists>\r\n";
echo "</root>";

?>