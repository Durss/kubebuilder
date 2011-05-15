<?php
header("Content-type: text/xml");
include '../connection.php';
include '../secure.php';
include '../getUserInfos.php';
?>
<!-- 
Retourne les informations sur l'utilisateur actuellement connécté ( name,uid,level)
-->