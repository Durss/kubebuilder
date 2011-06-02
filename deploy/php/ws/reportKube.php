<?php
header("Content-type: text/xml");
include '../constants.php';
include '../connection.php';
include '../secure.php';
include '../getUserInfos.php';

$result = 0;

if (isset($_UID, $_UNAME))
{
	if($_RIGHTS > 0) {
		if (isset($_POST['kid']))
		{
			$kid = intval($_POST['kid']);
			//Check votes of the day
			$sql = "SELECT COUNT(uid) as total FROM `kubebuilder_reports` WHERE kid=".$kid." AND uid=".$_UID;
			$req = mysql_query($sql);
			if ($req === false) {
				$result	= "Sql";
			}else{
				$results = mysql_fetch_assoc($req);
				if ($results["total"] > 0) {
					//Already reported, just ignore
				}else {
					$sql = "INSERT INTO `kubebuilder_reports` ( `kid` , `uid` ) VALUES (".$kid.", ".$_UID.")";
					$req = mysql_query($sql);
					if ($req === false) {
						$result	= "Sql";
					}else {
						$sql = "SELECT COUNT(uid) as total FROM `kubebuilder_reports` WHERE kid=".$kid;
						$req = mysql_query($sql);
						if ($req === false) {
							$result	= "Sql";
						}else {
							if ($results["total"] >= REPORTS_TO_HIDE_A_KUBE || $_RIGHTS > 1) {
								$sql = "UPDATE `kubebuilder_kubes` SET `locked`=1 WHERE `id`=".$kid;
								$req = mysql_query($sql);
								$result = $req === false? "Sql" : 0;
							}
						}
					}
				}
			}
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
echo "	<t>".$results["total"]."</t>\r\n";
echo "	<s>".$sql."</s>\r\n";
echo "</root>";

mysql_close();

?>