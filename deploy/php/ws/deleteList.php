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
	if (isset($_POST['lid'])) {
		$name = secure_string($_POST['name']);
		$sql = "DELETE FROM `kubebuilder_lists` WHERE `id`=".intval($_POST['lid'])." AND `uid`=".$_UID."";
		$request = mysql_query($sql);
		$result = $request === false? "Sql" : 0;
		if ($result === 0) {
			header("Location: getLists.php?key=".$_GET['key']);
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

?>