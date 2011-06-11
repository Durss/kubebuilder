<?php
header("Content-type: text/xml; charset=UTF-8");
header("Cache-Control: no-store, no-cache, must-revalidate"); // HTTP/1.1
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache"); // HTTP/1.0 

require_once('../constants.php');
require_once('../connection.php');
require_once('../secure.php');
require_once('../getUserInfos.php');

if (isset($_UID, $_UNAME))
{
	if($_RIGHTS > 0) {
		if (isset($_POST['name'], $_POST['kube']))
		{
			$sql = "SELECT COUNT(id) as `total` FROM `kubebuilder_kubes` WHERE DATE(date) = DATE(NOW()) AND `uid`=".$_UID;
			$req = mysql_query($sql);
			if ($req === false) {
				$result	= "Sql";
			}else{
				$results = mysql_fetch_assoc($req);
				if ($results["total"] >= MAX_KUBES_CREATION_PER_DAY) {
					$result = "MaxCreationPerDayReached";
				}else {
					$name = secure_string($_POST['name']);
					if($kube = base64_decode($_POST['kube']))
					{
						$fileName = $_UID."_".time();
						$file = "../../kubes/".$fileName.".kub";
						$handle = fopen($file,"w");
						if($handle !== false)
						{
							if (fputs($handle, $kube) === false) {
								$result = "Write";
							}else{
								$req = "INSERT INTO `kubebuilder_kubes` ( `name` , `uid` , `file` ) VALUES ('".$name."', ".$_UID.", '".$fileName."')";
								$kubes = mysql_query($req);
								$result = $kubes === false? "Sql" : 0;
								mysql_close();
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
			}
		}
		elseif (isset($_POST['name']))
		{
			$result = "File";
		}
		elseif (isset($_POST['kube']))
		{
			$result = "Name";
		}
		else
		{
			$result = "Post";
		}
	}else {
		$result = "Banned";
	}
}

else
{
	$result = "Auth";
}

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n";
echo "<root>\r\n";
echo "	<result>".$result."</result>\r\n";
echo "</root>";

?>