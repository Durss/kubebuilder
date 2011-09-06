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
                background-image: url(img/backHOF.jpg);
				background-repeat: no-repeat;
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
		<script type="text/javascript">
			function populate(id) {
				if(document.getElementById("fl_kube"+id) == null) return;
				document.getElementById("fl_kube"+id).populate();
			}
			
			window.onload = function() { setTimeout('populate(1)', 500); };//Don't know why, but I need to wait... As if the DOM weren't ready even after onload event.
		</script>
	</head>
	<body>
<?php
	$sql = "SELECT * FROM `kubebuilder_hof`";
	$query = mysql_query($sql);
	if (mysql_num_rows($query) == 0) {
		//IF no HOF yet
		echo "Come back later";
	}else{
		$offset = isset($_GET["offset"])? intval($_GET["offset"]) : 0;
		do{
			$sql = "SELECT id, p1, p2, p3, DATE_FORMAT( `date`, '%m-%Y' ) as `formatedDate` FROM `kubebuilder_hof` ORDER BY date DESC LIMIT ".$offset.", 1";
			$request = mysql_query($sql);
			$hof = mysql_fetch_assoc($request);
			$offset = 0;
		}while ($hof === false);
		
		echo "		<div class=\"date\">".$hof['formatedDate']."</div>";
		
		for($i = 1; $i < 4; $i++) {
			$sqlKube = "SELECT * FROM kubebuilder_kubes WHERE id=".$hof['p'.$i];
			$kube = mysql_fetch_assoc(mysql_query($sqlKube));
		
			$sqlUser = "SELECT name FROM kubebuilder_users WHERE id=".$kube['uid'];
			$user = mysql_fetch_assoc(mysql_query($sqlUser));
						
			echo "		<div id='kube".$i."_holder'>\r\n";
			echo "		<div id='kube".$i."'><a href='http://get.adobe.com/flashplayer'>Install flash</a></div>\r\n";
			echo "		<script type='text/javascript'>\r\n";
			echo "			// <![CDATA[\r\n";
			echo "			var so".$i." = new SWFObject('swf/KubeViewer.swf?v=1.1', 'fl_kube".$i."', '150', '160', '10.1', '#9693BF');\r\n";
			echo "			so".$i.".addParam('wmode', 'transparent');\r\n";
			echo "			so".$i.".addParam('menu', 'false');\r\n";
			$fileName = "kubes/".$kube["file"].".kub";
			$handle = fopen($fileName, "r");
			$fileContent = base64_encode(fread($handle, filesize($fileName)));
			fclose($handle);
			$xml = "<kube id=\"".$kube["id"]."\" uid=\"".$kube["uid"]."\" name=\"".htmlspecialchars(utf8_encode($kube["name"]))."\" pseudo=\"".htmlspecialchars(utf8_encode($user["name"]))."\" date=\"".strtotime ($kube["date"])."\" votes=\"".$kube["score"]."\"><![CDATA[".$fileContent."]]></kube>";
			echo "			so".$i.".addVariable('kube', '".urlencode($xml)."');\r\n";
			echo "			so".$i.".addVariable('dragSensitivity', '4');\r\n";
			if($i < 3) {
				echo "			so".$i.".addVariable('nextKube', '".($i+1)."');\r\n";
			}
			echo "			so".$i.".write('kube".$i."');\r\n";
			echo "			/*]]>*/\r\n";
			echo "		</script>\r\n";
			echo "		<span class='pseudo'>".utf8_encode($kube["name"])."</span><br /><span class='user'>(<a href='http://muxxu.com/u/".$user["name"]."' target='_parent'>".utf8_encode($user["name"])."</a>)</span>\r\n";
			echo "	</div>\r\n";
		}
	}
?>
    </body>
</html>