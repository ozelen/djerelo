<?
header("Content-type: text/html; charset=utf-8");
include("config.php");
$cfg = $caCFG;
$objid = $_POST['objid'] ? $_POST['objid'] : $_GET['objid'];
$obj = new Objects();
$objdata = $obj->miniInfo($objid, 'array');
$map = new Map();
$coords = $objid ? $map->Coords('Objects', $objid, 'array') : NULL;
if($_POST['lat']){
	print "post";
	$pv = $cfg->PostVars;
	$pv['owner'] = 'Objects';
	$pv['id'] = $objid;
	$map->setCoords($pv);
}

$obj_found = $objdata[0]['id'] ? true : false;
$coords_found = $coords['lat'] ? true : false;

$obj_str = $obj_found ? "[".$objid."] ".$objdata[0]['name'].", ".$objdata[0]['city']['name'] : "Object not found";

$coord_str = $coords_found ? $coords['str'] : "Position undefined";
$button_name = $coords_found ? "Change Position" : "Set Position";
?>
<html>
	<head>
		<script src="http://localhost:12175/javascript/GpsGate.js"></script>
		<script src="/js/jquery/jquery-1.4.4.min.js"></script>
		<script src="/js/mob/gps.js"></script>
	</head>
	<body>
		
		<form action="/gps.php" method="POST">
		<table>
			<tr>
				<td>Object</td>
				<td><?=$obj_str?> </td>
			</tr>
			<tr>
				<td>Position</td>
				<td><?=$coord_str?> </td>
			</tr>
			<tr>
				<td><label for="lat">Latitude</label></td>
				<td><input id="lat" name="lat" /></td>
			</tr>
			<tr>
				<td><label for="lng">Longtitude</label></td>
				<td><input id="lng" name="lng" /></td>
			</tr>
			<tr>
				<td><label for="alt">Altitude</label></td>
				<td><input id="alt" name="alt" /></td>
			</tr>
			<tr>
				<td><label for="tim">Time</label></td>
				<td><input id="tim" name="time" /></td>
			</tr>
			<tr>
				<td><button type="button" onclick="GpsGate.Client.getGpsInfo(CallbackMessage)">Refresh</button></td>
				<td> <?=$obj_found ? "<button>".($coords_found ? "Change Position" : "Set Position")."</button>" : '' ?> </td>
			</td>
		</table>
		</form>
		<a href="http://localhost:12175/javascript/GpsGate.js" target="_blank">Javascript</a>
	</body>
</html>