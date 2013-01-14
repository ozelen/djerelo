<?
class Map extends HotCat{
	function Map(){
		$this->inc();
	}
	
	function Exec($name, $params=NULL){
		switch($name){
			case "show": return $this->Show($this->uriVars['identcity']); break;
		}
	}
	
	function setCoords($pv){
		//foreach($pv as $k=>$v){print "$k = $v <br>";}
		$pv['coords']=$pv['lat'].'|'.$pv['lng'].'|'.$pv['alt'];
		$this->postData($pv);
	}
	
	function postData($pv){
		if(!$pv['owner'] || !$pv['id'])return false;
		list($lat, $lng, $alt) = split("\|", $pv['coords']);
		//print "$lat, $lng";
		$db = $this->CFG->HDB;
		if($lat && $lng){
			$alt = $alt ? $alt : 'NULL';
			if($db->getFieldWhere("Locations", "lat", " where OwnerTable = '".$pv['owner']."' and OwnerId = ".$pv['id'])){
				 $db->q("update Locations set lat = $lat, lng = $lng, alt=$alt where OwnerTable = '".$pv['owner']."' and OwnerId = ".$pv['id']);
				 $res="Update";
			}
			else{ 
				$db->q("insert into Locations (OwnerTable, OwnerId, lat, lng, alt) values('".$pv['owner']."', ".$pv['id'].", $lat, $lng, $alt)");
				$res = "Insert";
			}
			print $res." location ".$pv['owner'].":".$pv['id']." on ".$pv['coords'];
		}else print "Incorrect geo data";
	}
	
	
	
	function Coords($owner, $id, $format=NULL){
		$locs = $this->CFG->HDB->q("select * from Locations where OwnerTable = '$owner' and OwnerId = $id");
		if($loc = mysql_fetch_object($locs)){
			$xml = '
				<location lat="'.$loc->lat.'" lng="'.$loc->lng.'" alt="'.$loc->alt.'" />
			';
			$str = "$loc->lat|$loc->lng|$loc->alt";
			$arr = array('lat'=>$loc->lat, 'lng'=>$loc->lng, 'alt'=>$loc->alt, 'str'=>$str);
			switch($format){
				case 'array': return $arr; break;
				default: return $xml;
			}
			return $res;
		}
		return NULL;
	}
}
?>