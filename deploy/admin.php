<?php
	include 'php/constants.php';
	include 'php/connection.php';
	include 'php/checkUser.php';
	
	if($_LEVEL <= 1) {
		header("Location: index.php?act=rank&uid=".$_GET['uid']."&name=".$_GET['name']."&pubkey=".$_GET['pubkey']);
	}
	
	
	$error = 0;
	if(isset($_GET["unreport"])) {
		$kid = intval($_GET['unreport']);
		
		//get all the reports for this kube
		$sql = "SELECT `uid` FROM `kubebuilder_reports` WHERE `kid`=".$kid;
		$query = mysql_query($sql);
		$error = $query === false? "SQL : get reports" : 0;
		if ($error === 0) {
			//Update users and lock the users that reported too much times a kube as spam but it wasn't
			while ($report = mysql_fetch_assoc($query)) {
				$sqlWarn = "UPDATE `kubebuilder_users` SET `warnings`=`warnings`+1, `level`=IF(`warnings`>=".WRONG_REPORTS_BEFORE_LOCK." AND `level`=1, 0, `level`) WHERE `id`=".$report['uid'];
				mysql_query($sqlWarn);
			}
			
			//Delete reports for this kube
			$sql = "DELETE FROM `kubebuilder_reports` WHERE `kid`=".$kid;
			$query = mysql_query($sql);
			$error = $query === false? "SQL : delete reports" : 0;
			if ($error === 0) {
				$sql = "UPDATE `kubebuilder_kubes` SET `locked`=0, `reportable`=0 WHERE `id`=".$kid;
				$query = mysql_query($sql);
				$error = $query === false? "SQL : unlock kube" : 0;
			}
		}
	}
	
	if(isset($_GET["delete"])) {
		$kid = intval($_GET['delete']);
		$sql = "SELECT file FROM `kubebuilder_kubes` WHERE id=".$kid;
		$query = mysql_query($sql);
		$error = $query === false? "SQL : select kube" : 0;
		if($error === 0) {
			$kube = mysql_fetch_assoc($query);
			if ($kube === false) {
				$error = "Kube not found";
			}else{
				@unlink("./kubes/".$kube["file"].".kub");
				
				//Delete the kube
				$sql = "DELETE FROM `kubebuilder_kubes` WHERE id=".$kid;
				$query = mysql_query($sql);
				$error = $query === false? "SQL : delete kube" : 0;
				if ($error === 0) {
					//Delete reports for this kube
					$sql = "DELETE FROM `kubebuilder_reports` WHERE kid=".$kid;
					$query = mysql_query($sql);
					$error = $query === false? "SQL : delete reports" : 0;
					if ($error === 0) {
						//Delete evaluations for this kube
						$sql = "DELETE FROM `kubebuilder_evaluation` WHERE kid=".$kid;
						$query = mysql_query($sql);
						$error = $query === false? "SQL : delete evaluations" : 0;
					}
				}
			}
		}
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
            }
            body {
                background: #4CA5CD;
                font: 86% Arial, "Helvetica Neue", sans-serif;
                margin: 0px;
                padding: 0px;
				color: #0B376E;
            }
			a {
				color: #FFFFFF;
			}
			
			.guide img {
				vertical-align: -17%;
			}
			.guide ul {
				margin: 0px;
				margin-left:-40px;
				list-style: none outside none;
			}
			.guide ul li {
				background-color: #9693BF;
				border: 1px solid #454A6B;
				margin: 0;
				padding: 5px;
			}
			.guide em {
				font-variant: small-caps;
				font-weight: bold;
			}
		</style>
		
		<script type="text/javascript" src="js/swfobject.js"></script>
		<script type="text/javascript">
			function populate(id) {
				if(document.getElementById("fl_kube"+id) == null) return;
				document.getElementById("fl_kube"+id).populate();
			}
			
			window.onload = function() { setTimeout('populate(0)', 500); };//Don't know why, but I need to wait... -_-
		</script>
    </head>
    <body>
		<div class="guide">
<?php
	if ($error !== 0) {
		echo "			ERROR !!! ".$error."<br />\r\n";
	}
?>
			<table border='0' width='100%'>
<?php


	$sql = "SELECT * FROM kubebuilder_kubes WHERE locked=1";
	$request = mysql_query($sql);
	$index = 0;
	$total = mysql_num_rows($request);
	$light = isset($_GET["light"]);
	$cols = $light? 4 : 2;
	$lightParam = isset($_GET["light"])? "&light" : "";
	while ($kube = mysql_fetch_assoc($request)) {
		if ($index % $cols == 0) {
			if($index > 0) echo "			</tr>\r\n";
			echo "			<tr>\r\n";
		}
		$sqlUser = "SELECT name FROM kubebuilder_users WHERE id=".$kube['uid'];
		$user = mysql_fetch_assoc(mysql_query($sqlUser));
					
		if(isset($_UID)) {
			$query = "SELECT COUNT(kid) as `total` FROM kubebuilder_evaluation WHERE kid=".$kube['id']." AND uid=".$_UID;
			$uvote = mysql_fetch_assoc(mysql_query($query));
			$voted = intval($uvote['total']) > 0? true : false;
		}else {
			$voted = true;
		}
		
		echo "			<td>\r\n";
		echo "				<ul><li>\r\n";
		echo "					<table border='0' width='100%'>\r\n";
		echo "						<tr>\r\n";
		echo "							<td>\r\n";
		echo "								<div id='kube".$index."'><a href='http://get.adobe.com/flashplayer'>Install flash</a></div>\r\n";
		echo "								<script type='text/javascript'>\r\n";
		echo "									// <![CDATA[\r\n";
		echo "									var so".$index." = new SWFObject('swf/KubeViewer.swf?v=1.1', 'fl_kube".$index."', '".($light? '40' : '150')."', '".($light? '42' : '160')."', '10.1', '#9693BF');\r\n";
		echo "									so".$index.".addParam('menu', 'false');\r\n";
		$fileName = "kubes/".$kube["file"].".kub";
		$handle = fopen($fileName, "r");
		$fileContent = base64_encode(fread($handle, filesize($fileName)));
		fclose($handle);
		$xml = "<kube id=\"".$kube["id"]."\" uid=\"".$kube["uid"]."\" name=\"".htmlspecialchars(utf8_encode($kube["name"]))."\" pseudo=\"".htmlspecialchars(utf8_encode($user["name"]))."\" date=\"".strtotime ($kube["date"])."\" votes=\"".$kube["score"]."\" voted=\"".$voted."\"><![CDATA[".$fileContent."]]></kube>";
		echo "									so".$index.".addVariable('kube', '".urlencode($xml)."');\r\n";
		echo "									so".$index.".addVariable('dragSensitivity', '4');\r\n";
		
		if($light) {
			echo "									so".$index.".addVariable('light', 'true');\r\n";
		}
		if($index < $total-1) {
			echo "									so".$index.".addVariable('nextKube', '".($index+1)."');\r\n";
		}
		
		echo "									so".$index.".write('kube".$index."');\r\n";
		echo "									/*]]>*/\r\n";
		echo "								</script>\r\n";
		echo "							</td>\r\n";
		echo "							<td>\r\n";
		echo "								<b>".utf8_encode($kube["name"])."</b><br />Par <a href='http://muxxu.com/u/".$user["name"]."' target='_parent'>".utf8_encode($user["name"])."<br /><br />\r\n";
		echo "								<a href='?delete=".$kube["id"]."&uid=".$_GET['uid']."&name=".$_GET['name']."&pubkey=".$_GET['pubkey'].$lightParam."' target='_self'><img src='img/delete.png' /><b>Supprimer</b></a><br />\r\n";
		echo "								<a href='?unreport=".$kube["id"]."&uid=".$_GET['uid']."&name=".$_GET['name']."&pubkey=".$_GET['pubkey'].$lightParam."' target='_self'><img src='img/submit.png'/><b>Annuler report</b></a>\r\n";
		echo "							</td>\r\n";
		echo "						</tr>\r\n";
		echo "					</table>\r\n";
		echo "				</li></ul>\r\n";
		echo "			</td>\r\n";
		if($index == $total - 1) {
			echo "			</tr>\r\n";
		}
		$index ++;
	}
	
	if($total == 0) {
		echo "			<ul><li><b><center>Aucun kube à modérer actuellement =)</center></b></li></ul>";
	}
?>
			</table>
		</div>
    </body>
</html>