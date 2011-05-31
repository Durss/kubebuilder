<?php
require_once("secure.php");
$errorCheckDetails = "";
$errorCheckCode = 0;
$userName = "";
$userKey = "";
$_UID = -1;
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
		$node = $flux->xpath("/user/games/g[@game='kube']");
		$points = $node[0]->xpath("//g/i[@key='Score']");
		$zones = $node[0]->xpath("//g/i[@key='Carte']");
		$points = intval(preg_replace("[\D]", "", $points[0]->asXML()));
		$zones = intval(preg_replace("[\D]", "", $zones[0]->asXML()));
		if ($flux->getName() == "error") {
			$errorCheckDetails = $flux->asXML();
			$errorCheckCode = 1;
		}else {
			$userName = (string) $flux->attributes()->name;
			$errorCheckCode = 0;
			include 'connection.php';
			$sql = 'SELECT `key` FROM `users` WHERE id='.$uid;
			$res = mysql_fetch_assoc(mysql_query($sql));
			if ($res === false) {
				$sql = 'INSERT INTO `users` (`id`,`name`,`name_low`,`key`,`level`,`points`,`zones`) VALUES ('.$uid.', "'.$userName.'", "'.secure_string(strtolower($userName)).'", "'.$userKey.'", 1, '.$points.', '.$zones.')';
				mysql_query($sql);
			}else {
				//Test here just for retro-compatibility for users already registered.
				if (strlen($res['key']) == 0) {
					$sql = 'UPDATE `users` SET `key`="'.$userKey.'", `points`='.$points.', `zones`='.$zones.' WHERE id='.$uid;
				}else {
					$sql = 'UPDATE `users` SET `points`='.$points.', `zones`='.$zones.' WHERE id='.$uid;
					$userKey = $res['key'];
				}
				mysql_query($sql);
			}
			$_UID = $uid;
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