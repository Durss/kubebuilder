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
	$sql = "SELECT `id`, `name`, `kubes` FROM `kubebuilder_lists` WHERE `uid`=".$_UID;
	$request = mysql_query($sql);
	while ($entry = mysql_fetch_assoc($request)) {
		$listNodes .= "\t\t<l id='".$entry["id"]."' kubes='".$entry["kubes"]."'>".htmlspecialchars(utf8_encode($entry["name"]))."</l>\r\n";
	}
	mysql_close();
}else {
	$result = "Auth";
}

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n";
echo "<root>\r\n";
echo "	<result>".$result."</result>\r\n";
echo "	<lists>\r\n";
echo $listNodes;
echo "	</lists>\r\n";
echo "</root>";

?>