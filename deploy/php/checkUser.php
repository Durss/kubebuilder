<?php
require_once("secure.php");
require_once("constants.php");
$errorCheckDetails = "";
$errorCheckCode = 0;
$userName = "";
$userKey = "";
$_UID = -1;
$_LANG = "fr";
$_INFO_READ = 0;
$_LEVEL = 0;
if (isset($_GET['pubkey'], $_GET['uid']))
{
	$pubkey = $_GET['pubkey'];
	$uid = intval($_GET['uid']);
	$key = md5(APP_KEY.$pubkey);
	$url = "http://muxxu.com/app/xml?app=".APP_NAME."&xml=user&id=".$uid."&key=".$key;
	$userKey = md5(APP_KEY.$uid.$pubkey.time());
	if($flux = simplexml_load_file($url))
	{
		$node = $flux->xpath("/user/games/g[@game='kube']");
		if(count($node) > 0) {
			$points = $node[0]->xpath("i[@key='Score']");
			$zones = $node[0]->xpath("i[@key='Carte']");
			$points = intval(preg_replace("[\D]", "", $points[0]->asXML()));
			$zones = intval(preg_replace("[\D]", "", $zones[0]->asXML()));
		}else {
			$points = 0;
			$zones = 0;
		}
		
		$_LANG = $flux->attributes()->lang;
		
		if ($flux->getName() == "error") {
			$errorCheckDetails = $flux->asXML();
			$errorCheckCode = 1;
		}else {
			$userName = (string) $flux->attributes()->name;
			$errorCheckCode = 0;
			include 'connection.php';
			$sql = 'SELECT `key`, `infoRead`, `level` FROM `kubebuilder_users` WHERE id='.$uid;
			$res = mysql_fetch_assoc(mysql_query($sql));
			if ($res === false) {
				$sql = 'INSERT INTO `kubebuilder_users` (`id`,`name`,`name_low`,`key`,`points`,`zones`) VALUES ('.$uid.', "'.$userName.'", "'.secure_string(strtolower($userName)).'", "'.$userKey.'", '.$points.', '.$zones.')';
				mysql_query($sql);
			}else {
				//Test here just for retro-compatibility for users already registered.
				if (strlen($res['key']) == 0) {
					$sql = 'UPDATE `kubebuilder_users` SET `key`="'.$userKey.'", `points`='.$points.', `zones`='.$zones.' WHERE id='.$uid;
				}else {
					$sql = 'UPDATE `kubebuilder_users` SET `points`='.$points.', `zones`='.$zones.' WHERE id='.$uid;
					$userKey = $res['key'];
				}
				mysql_query($sql);
				$_INFO_READ = $res['infoRead'];
				$_LEVEL = $res['level'];
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