<?php
// Prémunie contre les injections SQL et XSL

function secure_string($string)
{
$secure_string = mysql_real_escape_string(nl2br(htmlspecialchars($string)));
return $secure_string;
}
?>