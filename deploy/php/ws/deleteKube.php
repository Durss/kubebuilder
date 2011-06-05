<?php
header("Content-type: text/xml; charset=UTF-8");
include '../constants.php';
include '../connection.php';
include '../secure.php';
include '../getUserInfos.php';

$result = 0;


if (isset($_UID, $_UNAME))
{
	if (isset($_POST['kid']))
	{
		$kid = intval($_POST['kid']);
		$sql = "SELECT file FROM `kubebuilder_kubes` WHERE id=".$kid." AND uid=".$_UID;
		$req = mysql_query($sql);
		$result = $req === false? "Sql" : 0;
		if($result === 0) {
			$kube = mysql_fetch_assoc($req);
			if ($kube === false) {
				$result = "NotFound";
			}else{
				@unlink("../../kubes/".$kube["file"].".kub");
				
				//Delete the kube
				$sql = "DELETE FROM `kubebuilder_kubes` WHERE id=".$kid." AND uid=".$_UID;
				$req = mysql_query($sql);
				$result = $req === false? "Sql" : 0;
				if ($result === 0) {
					//Delte reports for thisckube
					$sql = "DELETE FROM `kubebuilder_reports` WHERE kid=".$kid;
					$req = mysql_query($sql);
					$result = $req === false? "Sql" : 0;
					if ($result === 0) {
						//Delete evaluations for thisckube
						$sql = "DELETE FROM `kubebuilder_evaluation` WHERE kid=".$kid;
						$req = mysql_query($sql);
						$result = $req === false? "Sql" : 0;
					}
				}
			}
		}
	}
	else
	{
		$result = "Post";
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

mysql_close();

?>