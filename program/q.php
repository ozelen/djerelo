<?

$DB = mysql_connect('localhost', 'djerelo', 'LPKT4Xlw');
mysql_select_db("hotelbase", $DB);
function q($q, $dbg=NULL){
	global $DB;
	if($dbg)print "</p>$q<p>";
	return mysql_query($q, $DB);
}
function insid(){
	global $DB;
	return $ins = mysql_insert_id($DB) ? $ins : '[$ID]';
}

if($_SERVER['REMOTE_ADDR']!='109.86.140.143'){
	print "Access denied";
	exit();
}

$query = iconv("windows-1251", "UTF-8", $_POST['q']);
//print "<textarea>$q</textarea>";
$arr = split(";", $query);
foreach($arr as $q){
	if(!$q)continue;
	q($q.";");
	print ($err = mysql_errno()) ? "Error: ".mysql_error() : "OK: ";
	print "$q<hr>";
}
$r = mysql_fetch_object(q("select @objid as obj_id;"));
if($objid = $r->obj_id)
	header("Location: http://skiworld.org.ua/ru/goto/$objid/");
else {
	print "<h1>Error</h1> ".mysql_errno()." ".mysql_error();
}

?>