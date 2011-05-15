<?php
$key = isset($_GET['key'])? $_GET['key'] : 'none';
$sqlUser = "SELECT * FROM `users` WHERE `key`='".mysql_real_escape_string($key)."'";
$queryUser = mysql_query($sqlUser);
if($queryUser !== false) {
	$resUser = mysql_fetch_assoc($queryUser);
	if($resUser !== false) {
		$_UID = intval($resUser["id"]);
		$_UNAME = $resUser["name"];
		$_POINTS = $resUser["points"];
		$_ZONES = $resUser["zones"];
		$_RIGHTS = $resUser["level"];
	}
}

?>