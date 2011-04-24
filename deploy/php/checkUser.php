<?php
session_start();
if (isset($_GET['pubkey']) && isset($_GET['uid']))
{
	$pubkey = $_GET['pubkey'];
	$uid = $_GET['uid'];
	$appname = "kube-builder";
	$appkey = "0dfd8d1282b6626ded46eb458bc3bb6c";
	$key = md5($appkey.$pubkey);
	$url = "http://muxxu.com/app/xml?app=".$appname."&xml=user&id=".$uid."&key=".$key;
	
	if($flux = simplexml_load_file($url))
	{
		if ($flux->getName() == "error") {
			$_SESSION['error'] = $flux->asXML();
			$_SESSION['statut'] = 0;
		}else{
			$_SESSION['name'] = $flux['name']->asXML(); //Need ->asXML() or an weird exception is thrown. Impossible to store complex objects on session. $flux['name'] isn't a string but an object.
			$_SESSION['uid'] = $uid;
			$_SESSION['statut'] = 1;
			include 'connection.php';
			$req = 'INSERT `users` (`id`,`name`,`name_low`) VALUES ("'.$uid.'","'.$flux['name'].'","'.strtolower($flux['name']).'")';
			mysql_query($req);
		}
	}

	else
	{
		$_SESSION['error'] = "xml_access";
		$_SESSION['statut'] = 0;
	}
}

else
{
	$_SESSION['error'] = "undefined_variable";
	$_SESSION['statut'] = 0;
}

?>