<?php
header("Content-type: text/xml");
session_start();
$date = date("Y-m-d H:i:s");
include '../connection.php';
include '../secure.php';

if (isset($_SESSION['statut']) && ($_SESSION['statut'] == 1))
{
	if (isset($_POST['name'], $_POST['kube']))
	{
		$name = secure_string($_POST['name']);
		if($kube = base64_decode($_POST['kube']))
		{
			$fileName = md5($_SESSION['uid'].$_SESSION['name'].$date);
			$file = "../../kubes/".$fileName.".kub";
			$handle = fopen($file,"w");
			if($handle !== false)
			{
				if (fputs($handle, $kube) === false) {
					$result = "Write";
				}else{
					$req = "INSERT INTO `kubes` ( `name` , `uid` , `file` ) VALUES ('".secure_string($_POST['name'])."', ".secure_string($_SESSION['uid']).", '".$fileName."')";
					$kubes = mysql_query($req);
					$result = $kubes === false? "Sql" : 0;
				}
				fclose($handle);
			}
			else
			{
				$result = "Create";
			}
		}
		else
		{
			$result = "Format";
		}
	}
	elseif (isset($name))
	{
	$result = "File";
	}
	elseif (isset($kube))
	{
	$result = "Name";
	}
	else
	{
	$result = "Post";
	}
}

else
{
	$result = "Session";
	if (isset($_SESSION['error']))
		$error = $_SESSION['error'];
	else
		$error = "unknown";
}

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n";
echo "<root>\r\n";
echo "	<result>".$result."</result>\r\n";
echo "</root>";

?>