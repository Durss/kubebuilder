<?php
header("Content-type: text/xml; charset=UTF-8");
header("Cache-Control: no-store, no-cache, must-revalidate"); // HTTP/1.1
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache"); // HTTP/1.0 

// Connection Mysql et récupération de la liste des kubes
include '../constants.php';
include '../connection.php';
include '../getUserInfos.php';
include '../secure.php';
		
$resultCode = 0;
$uidCache = array();//Prevents from unnecessary SQL calls to get user's informations.

	/**
	 * Gets the details about a kube
	 */
	function getKubeDetails($kube) {
		global $uidCache, $_UID;
		if(!isset($uidCache[$kube['uid']])) {
			$sqlUser = "SELECT `name` FROM `kubebuilder_users` WHERE id=".$kube['uid'];
			$user = mysql_fetch_assoc(mysql_query($sqlUser));
			$uidCache[$kube['uid']] = $user;
		}else {
			//If user's informations have already been loaded, just load them back from cache.
			$user = $uidCache[$kube['uid']];
		}
		
		if (isset($_UID)) {
			$sqlEval = "SELECT COUNT(kid) as `total` FROM `kubebuilder_evaluation` WHERE kid=".$kube['id']." AND uid=".$_UID;
			$uvote = mysql_fetch_assoc(mysql_query($sqlEval));
			$voted = intval($uvote['total']) > 0? "true" : "false";
		}else {
			$voted = "true";
		}
		
		return array("voted" => $voted, "user" => $user);
	}

	/**
	 * Creates the XML node of a kube
	 */
	function createKubeNode($id) {
		$sql = "SELECT * FROM kubebuilder_kubes WHERE `id`=".$id."";
		$query = mysql_query($sql);
		$kube = mysql_fetch_assoc($query);
		$details = getKubeDetails($kube);
		
		$fileName = "../../kubes/".$kube['file'].".kub";
		$handle = fopen($fileName, "r");
		$fileContent = base64_encode(fread($handle, filesize($fileName)));
		fclose($handle);
		return "\t\t\t<kube id=\"".$kube['id']."\" uid=\"".$kube['uid']."\" name=\"".htmlspecialchars(utf8_encode($kube['name']))."\" pseudo=\"".htmlspecialchars(utf8_encode($details['user']['name']))."\" date=\"".strtotime ($kube['date'])."\" voted=\"".$details['voted']."\" hof=\"".$kube['hof']."\"><![CDATA[".$fileContent."]]></kube>\r\n";

	}

	$sql = "SELECT * FROM `kubebuilder_hof`";
	$query = mysql_query($sql);
	$kubeNodes = "";
	$lastKubesNode = "";
	while ($hof = mysql_fetch_assoc($query)) {
		$kubeNodes .= "\t\t<hof date=\"".$hof['date']."\" id=\"".$hof['id']."\">\r\n";
		$kubeNodes .= createKubeNode($hof['p1']);
		$kubeNodes .= createKubeNode($hof['p2']);
		$kubeNodes .= createKubeNode($hof['p3']);
		$kubeNodes .= "\t\t</hof>\r\n";
	}


echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n";
echo "<root>\r\n";
echo "	<result>".$resultCode."</result>\r\n";
if($resultCode === 0) {
	echo "	<hofs>\r\n";
	echo $kubeNodes;
	echo $lastKubesNode;
	echo "	</hofs>\r\n";
}
echo "</root>";

mysql_close();

?>