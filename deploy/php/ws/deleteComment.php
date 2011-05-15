<?php
header("Content-type: text/xml");
include '../connection.php';
include '../secure.php';
include '../getUserInfos.php';
?>
<!-- 
Permet de supprimer un commentaire ( uniquement personne ayant posté le commentaire, le kube associé ou ayant les droits suffisants )
-->