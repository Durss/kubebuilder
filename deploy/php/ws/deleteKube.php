<?php
header("Content-type: text/xml");
include '../connection.php';
include '../secure.php';
include '../getUserInfos.php';
?>
<!-- 
Permet de supprimer un kube ( si l'utilisateur courant est la personne ayant posté le kube ou si il a les droits suffisants )
-->