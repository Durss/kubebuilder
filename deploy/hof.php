<?php
	include 'php/constants.php';
	include 'php/connection.php';
	include 'php/checkUser.php';

	
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
	
	if ($_UID != -1) {
		$sql = "SELECT COUNT(uid) as total FROM `kubebuilder_evaluation` WHERE DATE(date) = DATE(NOW()) AND uid=".$_UID;
		$req = mysql_query($sql);
		$errorSql = $req !== false;
		$results = mysql_fetch_assoc($req);
		$votesDone = $results["total"];
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
	<head>
		<title>KubeBuilder</title>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<link rel="shortcut icon" href="favicon.ico" />
		<style type="text/css">
            html, body {
                margin:0px;
                padding:0px;
				overflow:hidden;
            }
            body {
                background-color: #4CA5CD;
                font: 86% Arial, "Helvetica Neue", sans-serif;
                margin: 0px;
                padding: 0px;
				color: #ffffff;
            }
			a {
				color: #4699EC;
				font-weight:bold;
			}
			
			.pseudo {
				font-size:20px;
				font-weight:bold;
			}
			
			.date {
				font-size:40px;
				font-weight:bold;
				text-align:center;
				width:870px;
			}
			
			#kube1_holder {
				position:absolute;
				left:355px;
				top:90px;
				text-align:center;
				width:200px;
				overflow:hidden;
			}
			
			#kube2_holder {
				position:absolute;
				left:200px;
				top:130px;
				width:150px;
				text-align:center;
				overflow:hidden;
			}
			
			#kube3_holder {
				position:absolute;
				left:540px;
				top:170px;
				width:150px;
				text-align:center;
				overflow:hidden;
			}
		</style>
		
		<script type="text/javascript" src="js/swfobject.js"></script>
		<script type="text/javascript" src="js/swfwheel.js"></script>
	</head>
	<body>
		<div id="content">
			<p>In order to view this page you must get Flash Player 10.2+ ! <br /><a href="http://get.adobe.com/flashplayer">Install the last version</a></p>
		</div>
		<script type="text/javascript">
			// <![CDATA[
			var so = new SWFObject('swf/kubeHOF.swf?v=2', 'content', '860', '502', '10.2', '#4CA5CD');
			so.useExpressInstall('swf/expressinstall.swf');
			so.addParam('menu', 'false');
			so.addParam('allowFullScreen', 'true');
			so.addParam('wmode', 'opaque');
			so.setAttribute("id", "externalDynamicContent");
			so.setAttribute("name", "externalDynamicContent");
			so.addVariable("configXml", "xml/config.xml?v=3.4");
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
	}
?>
			so.write('content');
			/*]]>*/
        </script>
    </body>
</html>