<?php
	include 'php/ws/checkUser.php';
	$swf = isset($_GET["act"]) && $_GET["act"] == "rank"? "kubeRank.swf" : "kubeBuilder.swf";
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
		<center>
		<div id="content">
			<p>In order to view this page you need JavaScript and Flash Player 10+ support!</p>
		</div>
		</center>
		
		<script type="text/javascript">
			// <![CDATA[
			var so = new SWFObject('swf/<?php echo $swf ?>?v=1.2', 'content', '800', '500', '10', '#4CA5CD');
			so.useExpressInstall('swf/expressinstall.swf');
			so.addParam('menu', 'false');
			so.addParam('allowFullScreen', 'true');
			so.addVariable("configXml", "xml/config.xml?v=1.2");
			so.write('content');
			/*]]>*/
        </script>
    </body>
</html>