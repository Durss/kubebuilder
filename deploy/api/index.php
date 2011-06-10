<?php
require_once '../php/constants.php';
require_once '../php/connection.php';
require_once '../php/secure.php';

if($flux == user)
{
	if (!isset($_GET['id']))
		$error = 'missing id';
	elseif (!isset($_GET['key']))
		$error = 'missing key';
	elseif (!isset($_GET['appname']))
		$error = 'missing appname'
	else
		include 'user.php';
}

elseif ($flux = 'list')
{
	if (!isset($_GET['id']))
		$error = 'missing id';
	elseif (!isset($_GET['key']))
		$error = 'missing key';
	elseif (!isset($_GET['appname']))
		$error = 'missing appname'
	else
		include 'list.php';
}

elseif ($flux = 'kube')
{
	if (!isset($_GET['id']))
		$error = 'missing id';
	elseif (!isset($_GET['key']))
		$error = 'missing key';
	elseif (!isset($_GET['appname']))
		$error = 'missing appname'
	else
		include 'kube.php';
}
?>