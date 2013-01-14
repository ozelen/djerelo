<?
header("Content-type: text/html; charset=utf-8");
include("../../config.php");
$cfg = $caCFG;
$objid = $_POST['objid'] ? $_POST['objid'] : $_GET['objid'];

$map = new Map();
$coords = $objid ? $map->Coords('Objects', $objid, 'array') : NULL;
//print "<p>ObjId: $objid </p>";
if($_POST['lat']){
	$pv = $cfg->PostVars;
	$pv['owner'] = 'Objects';
	$pv['id'] = $objid;
	$map->setCoords($pv);
	print "Done!";
	exit(1);
}


print "Something wrong";
exit(0);


?>