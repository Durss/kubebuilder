<?php
$errorCheckDetails = "";
$errorCheckCode = 0;
$userName = "";
$userKey = "";
if (isset($_GET['pubkey'], $_GET['uid']))
{
	$pubkey = $_GET['pubkey'];
	$uid = intval($_GET['uid']);
	$appname = "kube-builder";
	$appkey = "0dfd8d1282b6626ded46eb458bc3bb6c";
	$key = md5($appkey.$pubkey);
	$url = "http://muxxu.com/app/xml?app=".$appname."&xml=user&id=".$uid."&key=".$key;
	$userKey = md5($appkey.$uid.$pubkey.time());
	
	if($flux = simplexml_load_file($url))
	{
		if ($flux->getName() == "error") {
			$errorCheckDetails = $flux->asXML();
			$errorCheckCode = 1;
		}else {
			$userName = $flux->attributes()->name[0];
			$errorCheckCode = 0;
			include 'connection.php';
			$sql = 'SELECT `key` FROM `users` WHERE id='.$uid;
			$res = mysql_fetch_assoc(mysql_query($sql));
			if ($res === false) {
				$sql = 'INSERT INTO `users` (`id`,`name`,`name_low`,`key`,`level`) VALUES ('.$uid.', "'.$userName.'", "'.strtolower($userName).'", "'.$userKey.'", 1)';
				mysql_query($sql);
			}else {
				$userKey = $res['key'];
			}
		}
	}

	else
	{
		$errorCheckDetails = "xml_access";
		$errorCheckCode = 1;
	}
}

else
{
	$errorCheckDetails = "undefined_variable";
	$errorCheckCode = 1;
}

?>