<?
require_once("/var/www/djerelo/data/www/ski.djerelo.info/config.php");
header ("Content-type: text/plain; charset=utf-8");

$cfg = $caCFG;
$db = $cfg->HDB;

$chan = array(
	'cities'    => '061144266b5595d1afdf614b8f6f7d00',
	'objects'   => '7a5a69edbdd188cd5c330009adab4d1b'
);
$element = array();
//print $xml;

$el = new xml2Array();
foreach($chan as $key => $id){
	//print "$id \n";
	$xml = file_get_contents('http://www.nezabarom.ua/scripts/export/index.php?u=skiworld&p=skiworld&url='.$id);
	$element[$key] = new SimpleXMLElement($xml);
	$arr = $el->simpleXMLToArray($element[$key]);
	switch($key){
		case "cities":
			foreach($arr['CitiesSearchForm'] as $item ){
				$item = $caCFG->slashes($item);
				$q = "insert ignore into bookit_CitiesSearchForm set Name = '".$item['Name']."', Id = '".$item['ID']."', url = '".$item['Url']."', InsertDate = now();";
				$db->q($q);
				//print "$q\n";
			}
		break;
		case "objects":
			foreach($arr['hotelsBookit'] as $i => $item ){
				$item = $caCFG->slashes($item);
				$q = "insert ignore into bookit_hotelsBookit set name = '".$item['name']."', id = '".$item['id']."', cityId = '".$item['cityId']."', InsertDate = now(); ";
				$db->q($q,1);
				//print "$q\n";
				if(is_array($images = $arr['hotelsBookit'][$i]['Images']))
				foreach($images as $img){
					$q= "insert ignore into bookit_Images set image_id = '".$img['image_id']."', image_objectId = '".$img['image_objectId']."', image_src = '".$img['image_src']."', image_descr = '".$img['image_descr']."'";
					$db->q($q);
					//print "\t\t$q\n";
				}
			}
			//print_r($arr['hotelsBookit']);
		break;
	}
	//print_r($arr);
}






?>