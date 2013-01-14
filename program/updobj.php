<?
//include_once("../config.php");

$db = mysql_connect("localhost", "djerelo", "LPKT4Xlw", true);
mysql_select_db("hotelbase", $db);
mysql_query("update Objects set Updated = unix_timestamp(now())", $db);

print ($n = mysql_errno($db)) ? "[Error #$n:".mysql_error($db)."]" : "ok!";

mysql_close($db);



?>