<?php
header("Content-type: text/xml; charset=UTF-8");
include '../connection.php';
include '../secure.php';
include '../getUserInfos.php';
?>
<!-- 
Permet de supprimer un commentaire ( uniquement personne ayant post� le commentaire, le kube associ� ou ayant les droits suffisants )
-->