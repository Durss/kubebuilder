<?php
	include 'php/constants.php';
	include 'php/connection.php';
	include 'php/checkUser.php';
	
	$sql = "SELECT COUNT(uid) as total FROM `evaluation` WHERE DATE(date) = DATE(NOW()) AND uid=".$_UID;
	$req = mysql_query($sql);
	$errorSql = $req !== false;
	$results = mysql_fetch_assoc($req);
	$votesDone = $results["total"];
	
	//Converts act var into multiple GET vars if necessary.
	//If the following act var is past :
	//act=value_var1=value1_var2=value2
	//then $_GET["act"] value will only be "value" and two
	//GET vars named "var1" and "var2" will be created with
	//the corresponding value.
	if (isset($_GET["act"])) {
		$params = explode("_", $_GET["act"]);
		$_GET["act"] = $params[0];
		for ($i = 1; $i < count($params); $i++) {
			list($var, $value) = explode("=", $params[$i]);
			$_GET[$var] = $value;
		}
	}
	$swf = isset($_GET["act"]) && $_GET["act"] == "editor"? "kubeBuilder.swf" : "kubeRank.swf";
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
	<head>
		<title>KubeBuilder</title>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<link rel="shortcut icon" href="./favicon_new.ico" />
		<style type="text/css">
            html, body {
                height: 100%;
                overflow: hidden;
                margin:0;
                padding:0;
            }
            body {
                background: #4CA5CD;
                font: 86% Arial, "Helvetica Neue", sans-serif;
                margin: 0;
            }
		</style>
		
		<script type="text/javascript" src="js/swfobject.js"></script>
    </head>
    <body>
<?php
	if ($errorCheckCode == 0) {

?>
		<div id="content">
			<p>Pour voir cette page vous devez posséder la version 10.1+ du plugin Flash Player!<br /><a href="http://get.adobe.com/fr/flashplayer/">Installer la dernière version</a></p>
		</div>
		
		<script type="text/javascript">
			// <![CDATA[
			var so = new SWFObject('swf/<?php echo $swf ?>?v=1.6', 'content', '860', '500', '10.1', '#4CA5CD');
			so.useExpressInstall('swf/expressinstall.swf');
			so.addParam('menu', 'false');
			so.addParam('allowFullScreen', 'true');
			so.addVariable("configXml", "xml/config.xml?v=1.2");
<?php
	if (isset($_GET["uid"], $_GET["pubkey"])) {
		echo "\t\t\tso.addVariable('uid', '".$_GET['uid']."');\r\n";
		echo "\t\t\tso.addVariable('uname', '".$_GET['name']."');\r\n";
		echo "\t\t\tso.addVariable('pubkey', '".$_GET['pubkey']."');\r\n";
		echo "\t\t\tso.addVariable('key', '".$userKey."');\r\n";
		echo "\t\t\tso.addVariable('votesTotal', '".MAX_VOTES_PER_DAY."');\r\n";
		echo "\t\t\tso.addVariable('votesDone', '".$votesDone."');\r\n";
		if(isset($_GET["kid"])) {
			$sql = "SELECT * FROM kubes WHERE id=".intval($_GET["kid"]);
			$req = mysql_query($sql);
			if($req !== false) {
				$kube = mysql_fetch_assoc($req);
				if ($kube !== false) {
					$req = "SELECT name FROM users WHERE id=".$kube['uid'];
					$user = mysql_fetch_assoc(mysql_query($req));
					
					if(isset($_UID)) {
						$req = "SELECT COUNT(kid) as `total` FROM evaluation WHERE kid=".$kube['id']." AND uid=".$_UID;
						$uvote = mysql_fetch_assoc(mysql_query($req));
						$voted = intval($uvote['total']) > 0? true : false;
					}else {
						$voted = true;
					}
					
					$fileName = "kubes/".$kube['file'].".kub";
					$handle = fopen($fileName, "r");
					$fileContent = base64_encode(fread($handle, filesize($fileName)));
					fclose($handle);
					$xml = "<kube id=\"".$kube['id']."\" uid=\"".$kube['uid']."\" name=\"".htmlspecialchars(utf8_encode($kube['name']))."\" pseudo=\"".htmlspecialchars(utf8_encode($user['name']))."\" date=\"".strtotime ($kube['date'])."\" votes=\"".$kube['score']."\" voted=\"".$voted."\"><![CDATA[".$fileContent."]]></kube>";
					echo "\t\t\tso.addVariable('directKube', '".urlencode($xml)."');\r\n";
				}
			}
		}
	}
?>
			so.write('content');
			/*]]>*/
        </script>
<?php

	} else if($errorSql) {
		echo "Une erreur est survenue. Essayez de recharger la page, si le problème persiste merci de contactez Durss.";
	} else {
?>
		<center>
			Redirection vers l'application en cours.<br />
			Si vous n'êtes pas automatiquement redirigez, <a href="http://muxxu.com/a/kube-builder" target="_self">cliquez ici</a>.
		</center>
		<script type="text/javascript">
			function redirect() {
				document.location.href = "http://muxxu.com/a/kube-builder";
			}
			setTimeout(redirect, 5000);
        </script>
		
<?php
	}
?>
    </body>
</html>