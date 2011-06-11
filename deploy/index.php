<?php

	include 'php/constants.php';
	include 'php/connection.php';
	include 'php/checkUser.php';
	
	$errorSql = false;
	if ($_UID != -1) {
		$sql = "SELECT COUNT(uid) as total FROM `kubebuilder_evaluation` WHERE DATE(date) = DATE(NOW()) AND uid=".$_UID;
		$req = mysql_query($sql);
		$errorSql = $req !== false;
		$results = mysql_fetch_assoc($req);
		$votesDone = $results["total"];
	}
	
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
			if(strpos($params[$i], "=") > -1) {
				list($var, $value) = explode("=", $params[$i]);
			}else {
				$var = $params[$i];
				$value = 0;
			}
			$_GET[$var] = $value;
		}
	}
	
	if (isset($_GET["act"]) && $_GET["act"] == "admin" && $_LEVEL > 1) {
		$light = isset($_GET["light"])? "&light" : "";
		header("Location: admin.php?uid=".$_GET['uid']."&name=".$_GET['name']."&pubkey=".$_GET['pubkey'].$light);
	}
	
	$swf = isset($_GET["act"]) && $_GET["act"] == "editor"? "kubeBuilder.swf" : "kubeRank.swf";
	
	//Put in english if the asked localistion doesn't exists
	if(isset($_GET["lang"])) $_LANG = $_GET["lang"];
	if(!file_exists("i18n/xml/labels_".$_LANG.".xml")) $_LANG = "en";
	//$_LANG = "en";
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
	<head>
		<title>KubeBuilder</title>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<link rel="shortcut icon" href="favicon.ico" />
		<style type="text/css">
            html, body {
                height: 100%;
                <?php if(!isset($_GET["act"]) || $_GET["act"] != "infos") echo "overflow: hidden;"; ?>
                margin:0;
                padding:0;
            }
            body {
                background: #4CA5CD;
                font: 86% Arial, "Helvetica Neue", sans-serif;
                margin: 0;
				color: #0B376E;
            }
			a {
				color: #FFFFFF;
			}
			.guide h2 {
				font-size: 17pt;
				font-variant: small-caps;
				margin-top: 15px;
			}
			.guide h3 {
				font-size: 14pt;
				margin: 20px 0;
			}
			.guide h2 {
				font-size: 17pt;
				font-variant: small-caps;
				margin-top: 15px;
			}
			.guide h3 {
				font-size: 14pt;
				margin: 20px 0;
			}
			.guide .helpimg {
				float: left;
				position: relative;
			}
			.guide span.more {
				font-size: 17pt;
			}
			.guide img {
				vertical-align: -17%;
			}
			.guide ul {
				margin-left: 15px;
				margin-right: 15px;
				list-style: none outside none;
			}
			.guide ul li {
				background-color: #9693BF;
				border: 1px solid #454A6B;
				margin: 0;
				padding: 10px;
			}
			.guide em {
				font-variant: small-caps;
				font-weight: bold;
			}
		</style>
		
		<script type="text/javascript" src="js/swfobject.js"></script>
    </head>
    <body>
<?php
	if (isset($_GET["act"]) && $_GET["act"] == "infos") {
		if ($_INFO_READ == false) {
			$sqlRead = "UPDATE kubebuilder_users SET infoRead=1 WHERE id=".$_UID;
			mysql_query($sqlRead);
		}
		include("i18n/infos_".$_LANG.".html");
	}else {


	if ($errorCheckCode == 0) {

?>
		<div id="content">
			<p>In order to view this page you must get Flash Player 10.1+ ! <br /><a href="http://get.adobe.com/flashplayer">Install the last version</a></p>
		</div>
		
		<script type="text/javascript">
			// <![CDATA[
			var so = new SWFObject('swf/<?php echo $swf ?>?v=3.3', 'content', '860', '502', '10.1', '#4CA5CD');
			so.useExpressInstall('swf/expressinstall.swf');
			so.addParam('menu', 'false');
			so.addParam('allowFullScreen', 'true');
			so.addVariable("configXml", "xml/config.xml?v=2.7");
<?php
	if (isset($_GET["uid"], $_GET["pubkey"])) {
		echo "\t\t\tso.addVariable('lang', '".$_LANG."');\r\n";
		echo "\t\t\tso.addVariable('uid', '".intval($_GET['uid'])."');\r\n";
		echo "\t\t\tso.addVariable('uname', '".htmlspecialchars($_GET['name'])."');\r\n";
		echo "\t\t\tso.addVariable('pubkey', '".htmlspecialchars($_GET['pubkey'])."');\r\n";
		echo "\t\t\tso.addVariable('key', '".$userKey."');\r\n";
		echo "\t\t\tso.addVariable('votesTotal', '".MAX_VOTES_PER_DAY."');\r\n";
		echo "\t\t\tso.addVariable('votesDone', '".$votesDone."');\r\n";
		echo "\t\t\tso.addVariable('infosRead', '".$_INFO_READ."');\r\n";
		if (isset($_GET["user"])) {
			echo "\t\t\tso.addVariable('userToShow', '".intval($_GET["user"])."');\r\n";
		}
		if (isset($_GET["list"])) {
			echo "\t\t\tso.addVariable('listToShow', '".intval($_GET["list"])."');\r\n";
		}
		if(isset($_GET["kid"])) {
			$sql = "SELECT * FROM kubebuilder_kubes WHERE locked=0 AND id=".intval($_GET["kid"]);
			$req = mysql_query($sql);
			if($req !== false) {
				$kube = mysql_fetch_assoc($req);
				if ($kube !== false) {
					$req = "SELECT name FROM kubebuilder_users WHERE id=".$kube['uid'];
					$user = mysql_fetch_assoc(mysql_query($req));
					
					if(isset($_UID)) {
						$req = "SELECT COUNT(kid) as `total` FROM kubebuilder_evaluation WHERE kid=".$kube['id']." AND uid=".$_UID;
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
					echo "\t\t\tso.addVariable('banned', '".($user['name'] == 0)."');\r\n";
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
?>
		<center>
			<div class="guide">
				<ul>
					<li>
						Une erreur est survenue.<br />
						Essayez de recharger la page, si le problème persiste, contactez Durss.<br /><br />
						An error occurred...<br />
						Try to reload the page, if the problem continues, please contact Durss.
					</li>
				</ul>
			</div>
		</center>

<?php
	} else {
?>
		<center>
			<div class="guide">
				<ul>
					<li>
						Redirection vers l'application en cours.<br />
						Si vous n'êtes pas automatiquement redirigez, <a href="http://muxxu.com/a/kube-builder" target="_self">cliquez ici</a>.<br /><br />
						Redirecting...<br />
						If you're not automatically redirected, <a href="http://muxxu.com/a/kube-builder" target="_self">click here</a>.
					</li>
				</ul>
			</div>
		</center>
		<script type="text/javascript">
			function redirect() {
				document.location.href = "http://muxxu.com/a/kube-builder";
			}
			setTimeout(redirect, 5000);
        </script>
		
<?php
	}
	}
?>
    </body>
</html>