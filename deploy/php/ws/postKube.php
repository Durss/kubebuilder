<?php 
session_start();
$date = date("Y-m-d H:i:s");
include 'connection.php';
include 'secure.php';

/* 	Renvoyer un XML de la forme présentée ici.
	Prendre les variables POST suivantes en entrée :
		name : nom du kube
		kube : données binaires du kube
	
	Définir un ID arbitraire de retour pour chaque cas d'erreur possible et créer un
	noeud <label> comme suit dans le fichier config.xml :
		<label code="errorSubmitResultID"><![CDATA[Label de l'erreur.]]></label> */

echo "<?"; ?>xml version="1.0" encoding="UTF-8"?>
<root>
<?php
if (isset($_SESSION['statut']) && ($_SESSION['statut'] == 1))
{
?>
	<session statut="1" name="<?php print $_SESSION['name'] ?>" uid="<?php print $_SESSION['uid'] ?>" />
<?php

	if (isset($name) && isset ($kube))
	{
		$name = secure_string($_POST['name']);
		if($kube = base64_decode($_POST['kube']))
		{
			$file = "../kubes/".md5($SESSION['uid'].$SESSION['name'].$date).".kub";
			if($fp = fopen($file,"w"))
			{
				fputs($fp, $kube);
				$result = 0;
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
?>

	<session statut="0" error="<?php print $error ?>" />

<?php
}
?>
	<result><?php print $result ?></result>

</root>