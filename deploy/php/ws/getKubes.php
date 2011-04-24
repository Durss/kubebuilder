<?php
/* 	Renvoyer un XML de la forme présentée ici.
	Trier les résultats par nombre de votes décroissant, et en cas d'égalité mettre les plus récents en premier (pour laisser couler les dinosaures)
	Prendre les variables POST suivantes en entrée :
		start : premier paramètre du LIMIT (index de début)
		length : nombre d'items à récupérer (pense à le limite à quelque chose comme 100 en dur pour éviter que des malins nous fassent des select all en bidouillant les requêtes) */

		
// Vérification des variables envoyées en POST 

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

include 'connection.php';
$req = "SELECT * FROM kubes ORDER BY `kubes`.`score`  DESC, `kubes`.`date`  DESC LIMIT ".$start.",".$length;
$kubes = mysql_query($req);
echo "<?"; ?>xml version="1.0" encoding="UTF-8"?>
<root>
	<kubes>	

<?php
while ($kube = mysql_fetch_assoc($kubes))
{
	$req = "SELECT name FROM users WHERE id=".$kube['uid'];
	$user = mysql_fetch_assoc(mysql_query($req));
?>
<kube id="<?php print $kube['id'] ?>" uid="<?php print $kube['uid'] ?>" name="<?php print $kube['name'] ?> pseudo="<?php print $user['name'] ?>" date="<?php print $kube['date'] ?>" votes="<?php print $kube['score'] ?>" />
<?php
}
?>	
	</kubes>
</root>