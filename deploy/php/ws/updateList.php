<?php
header("Content-type: text/xml; charset=UTF-8");
header("Cache-Control: no-store, no-cache, must-revalidate"); // HTTP/1.1
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache"); // HTTP/1.0 

require_once('../constants.php');
require_once('../connection.php');
require_once('../secure.php');
require_once('../getUserInfos.php');

if (isset($_UID, $_UNAME)) {
	if (isset($_POST['kid'], $_POST['lid'], $_POST['act']) && ($_POST['act'] == "del" || $_POST['act'] == "add")) {
		$sql = "SELECT kubes, uid FROM `kubebuilder_lists` WHERE id=".intval($_POST["lid"]);
		$request = mysql_query($sql);
		$entry = mysql_fetch_assoc($request);
		if ($entry["uid"] != $_UID) {
			$result = "NotYourList";
		}else {
			if ($_POST['act'] == "del") {
				$kubes = str_replace(intval($_POST['kid']).",", "", $entry["kubes"]);
				$sql = "UPDATE `kubebuilder_lists` SET kubes = '".$kubes."' WHERE id=".intval($_POST["lid"]);
			}else{
				$sql = "UPDATE `kubebuilder_lists` SET kubes = CONCAT(kubes,'".intval($_POST['kid']).",') WHERE id=".intval($_POST["lid"]);
			}
			$request = mysql_query($sql);
			$result = $request === false? "Sql" : 0;
		}
	}else {
		$result = "Post";
	}
}else {
	$result = "Auth";
}

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n";
echo "<root>\r\n";
echo "	<result>".$result."</result>\r\n";
echo "</root>";

mysql_close();
?>