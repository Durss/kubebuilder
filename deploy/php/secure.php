<?php

//Reverses the magic_quotes effect if enabled. (.htaccess configuration to disable it seems not to work properly :( )
if (get_magic_quotes_gpc()) {
    $process = array(&$_GET, &$_POST, &$_COOKIE, &$_REQUEST);
    while (list($key, $val) = each($process)) {
        foreach ($val as $k => $v) {
            unset($process[$key][$k]);
            if (is_array($v)) {
                $process[$key][stripslashes($k)] = $v;
                $process[] = &$process[$key][stripslashes($k)];
            } else {
                $process[$key][stripslashes($k)] = stripslashes($v);
            }
        }
    }
    unset($process);
}


// Prevents from SQL nor XSL injections.
function secure_string($string)
{
	$secure_string = mysql_real_escape_string(nl2br(utf8_decode($string)));
	return $secure_string;
}
?>