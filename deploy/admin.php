<?php

	include 'php/constants.php';
	include 'php/connection.php';
	include 'php/checkUser.php';
	
	if($_LEVEL <=1) {
		header("location:index.php?act=rank&uid=".$_GET['uid']."&name=".$_GET['name']."&pubkey=".$_GET['pubkey']);
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
		<script type="text/javascript">
			function populate(id) {
				document.getElementById("fl_kube"+id).populate();
			}
			
			window.onload = function() { setTimeout('populate(0)', 500); };//Don't know why, but I need to wait... -_-
		</script>
    </head>
    <body>
		<div class="guide">
<?php
	$sql = "SELECT * FROM kubebuilder_kubes WHERE locked=1";
	$request = mysql_query($sql);
	$index = 0;
	$total = mysql_num_rows($request);
	while ($kube = mysql_fetch_assoc($request)) {
		$sqlUser = "SELECT name FROM kubebuilder_users WHERE id=".$kube['uid'];
		$user = mysql_fetch_assoc(mysql_query($sqlUser));
					
		if(isset($_UID)) {
			$req = "SELECT COUNT(kid) as `total` FROM kubebuilder_evaluation WHERE kid=".$kube['id']." AND uid=".$_UID;
			$uvote = mysql_fetch_assoc(mysql_query($req));
			$voted = intval($uvote['total']) > 0? true : false;
		}else {
			$voted = true;
		}
		
		echo "		<ul><li>\r\n";
		echo "		<table border='0'>\r\n";
		echo "			<tr>\r\n";
		echo "				<td>\r\n";
		echo "					<div id='kube".$index."'><a href='http://get.adobe.com/flashplayer'>Install flash</a></div>\r\n";
		echo "					<script type='text/javascript'>\r\n";
		echo "						// <![CDATA[\r\n";
		echo "						var so".$index." = new SWFObject('swf/KubeViewer.swf?v=1', 'fl_kube".$index."', '160', '160', '10.1', '#9693BF');\r\n";
		echo "						so".$index.".addParam('menu', 'false');\r\n";
		$fileName = "kubes/".$kube["file"].".kub";
		$handle = fopen($fileName, "r");
		$fileContent = base64_encode(fread($handle, filesize($fileName)));
		fclose($handle);
		$xml = "<kube id=\"".$kube["id"]."\" uid=\"".$kube["uid"]."\" name=\"".htmlspecialchars(utf8_encode($kube["name"]))."\" pseudo=\"".htmlspecialchars(utf8_encode($user["name"]))."\" date=\"".strtotime ($kube["date"])."\" votes=\"".$kube["score"]."\" voted=\"".$voted."\"><![CDATA[".$fileContent."]]></kube>";
		echo "						so".$index.".addVariable('kube', '".urlencode($xml)."');\r\n";
		if($index < $total-1) {
		echo "						so".$index.".addVariable('nextKube', '".($index+1)."');\r\n";
		}
		echo "						so".$index.".write('kube".$index."');\r\n";
		echo "						/*]]>*/\r\n";
		echo "					</script>\r\n";
		echo "				</td>\r\n";
		echo "				<td>\r\n";
		echo "					<b>".$kube["name"]."</b> par <a href='http://muxxu.com/u/".$user["name"]."' target='_parent'>".$user["name"]."</h1>\r\n";
		echo "				</td>\r\n";
		echo "			</tr>\r\n";
		echo "		</table>\r\n";
		echo "		</li></ul>\r\n";
		$index ++;
	}
?>
		</div>
    </body>
</html>