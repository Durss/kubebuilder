<?php
header("Content-type: text/xml");
/* 	Renvoyer un XML de la forme présentée ici.
	Trier les résultats par nombre de votes décroissant, et en cas d'égalité mettre les plus récents en premier (pour laisser couler les dinosaures)
	Prendre les variables POST suivantes en entrée :
		start : premier paramètre du LIMIT (index de début)
		length : nombre d'items à récupérer (pense à le limite à quelque chose comme 100 en dur pour éviter que des malins nous fassent des select all en bidouillant les requêtes) */

		
// Vérification des variables envoyées en POST 
session_start();

if (isset($_POST['start']) && isset($_POST['length']))
{
	$start = floor(intval($_POST['start']));
	$length = floor(intval($_POST['length']));

	if ($length > 100 || $length <= 0)
	{
		$length = 50;
	}
}

else
{
	$start = 0;
	$length = 50;
}

// Connection Mysql et récupération de la liste des kubes

include '../connection.php';
$req = "SELECT * FROM kubes ORDER BY `kubes`.`score`  DESC, `kubes`.`date`  DESC LIMIT ".$start.",".$length;
$kubes = mysql_query($req);
$kubeNodes = "";

while ($kube = mysql_fetch_assoc($kubes))
{
	$req = "SELECT name FROM users WHERE id=".$kube['uid'];
	$user = mysql_fetch_assoc(mysql_query($req));
	$kubeNodes .= "\t\t<kube id=\"".$kube['id']."\" uid=\"".$kube['uid']."\" name=\"".htmlspecialchars(utf8_encode($kube['name']))."\" pseudo=\"".htmlspecialchars(utf8_encode($user['name']))."\" date=\"".strtotime ($kube['date'])."\" votes=\"".$kube['score']."\" />\r\n";
}



echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n";
echo "<root>\r\n";
echo "	<kubes>\r\n";
echo $kubeNodes;
echo "	</kubes>\r\n";
echo "</root>";

?>