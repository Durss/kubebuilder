<?php
header("Content-type: text/xml; charset=UTF-8");
require_once('../constants.php');
require_once('../connection.php');
require_once('../secure.php');
require_once('../getUserInfos.php');

$result = 0;
$listNodes = "";
if (isset($_UID, $_UNAME)) {
	$sql = "SELECT id, name FROM `kubebuilder_lists` WHERE uid=".$_UID;
	$request = mysql_query($sql);
	while ($entry = mysql_fetch_assoc($request)) {
		$listNodes .= "<l id='".$entry["id"]."'>".utf8_encode($entry["name"])."</l>\r\n";
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