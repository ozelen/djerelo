<?
	$format = $_GET['format'] ? $_GET['format'] : "xml";
	header('Content-type: text/html; charset="utf-8"',true);
	include("../config.php");
	$MD = new Modules();
	$p = $_POST;
	//foreach($p as $k=>$v){print "<p>$k=>$v</p>";}
	print $MD->Exec($p['mod_name'], $p['mod_param'], $p['mod_temp']);
	//print '['.$p['mod_name'].']['.$p['mod_param'].']['.$p['mod_temp'].']';
?>