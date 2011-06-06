<?php
header("Content-type: text/xml; charset=UTF-8");
header("Cache-Control: no-store, no-cache, must-revalidate"); // HTTP/1.1
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache"); // HTTP/1.0 

include '../connection.php';
include '../secure.php';
include '../getUserInfos.php';
?>
<!-- 
Retourne les informations sur l'utilisateur actuellement connécté ( name,uid,level)
-->