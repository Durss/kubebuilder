<?php
header("Content-type: text/xml; charset=UTF-8");
require_once('../constants.php');
require_once('../connection.php');
require_once('../secure.php');
require_once('../getUserInfos.php');

if (isset($_UID, $_UNAME)) {
	if (isset($_POST['name'])) {
		$name = secure_string($_POST['name']);
		$sql = "INSERT INTO `kubebuilder_lists` (`name`, `uid`) VALUES ('".$name."', ".$_UID.")";
		$request = mysql_query($sql);
		$result = $request === false? "Sql" : 0;
		mysql_close();
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