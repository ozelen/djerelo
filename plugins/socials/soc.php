<?
require_once("vkontakte/vk.php");
require_once("facebook/fb.php");
require_once("googleplus/gp.php");
require_once("../../config.php");
class likesCount{
	function __construct(){
		global $caCFG;
		$this->CFG = $caCFG;
	}
	
	function total($likes){
		foreach ($likes as $name => $obj) {
			$x=$obj->getTotal();
			$count += $x;
			//print "[$name]$x\n";
		}
		return $count;
	}
	
	function reCount($objid){
		$get = $this->CFG->GetVars;
		$db = $this->CFG->HDB;
		if(!$objid)return null;
		$last_record = mysql_fetch_object(
			$db->q("select * from Rating where Owner = 'Objects' and ObjId = $objid and Name = 'SocialsTotal' order by Updated desc limit 1")
		);
		
		$now = time();
		if(($get['mode']=='update') || ($last_record->Updated < $now-86400)){
			
			//print "Counting...\n";
			$login = $db->getField("Objects", "AccountCode", $objid);
			$likes = array(
				'vk' => new vkLikeList($objid)
			,	'fb' => new fbLikeList("http://skiworld.org.ua/$login/")
			,	'gp' => new gpLikeList("http://djerelo.info/$login/")
			);
			$new_value = $this->total($likes);
			if($last_record->Updated!=$new_value){
				$db->q("delete from Rating where Owner = 'Objects' and ObjId = $objid and Name = 'SocialsTotal'");
				$db->q("insert into Rating set Name = 'SocialsTotal', Owner = 'Objects', ObjId = $objid, Updated = '$now', Val = '$new_value' ");
			}

			return $new_value;
		}
		else return $last_record->Val;
	}
	
	function reCountAll(){
		$q = "
			select AccountCode as Login, obj.Id, Val
			from Objects obj 
			left join Rating r on r.ObjId = obj.Id and r.Owner = 'Objects' and r.Name = 'SocialsTotal'
			where r.Id is null
		--	limit 50
		";
		$objs = $this->CFG->HDB->q($q);
		while($obj = mysql_fetch_object($objs)){
			$res = $this->reCount($obj->Id);
			print "[$res] $obj->Login ($obj->Id) \n";
		}
	}
	
}
	
header("Content-Type: text; charset=utf-8");

$lc = new LikesCount();
switch($caCFG->GetVars['mode']){
	case 'checkall':
		$lc->reCountAll();
	break;
	default: print $lc->reCount($caCFG->GetVars['objid']); break;
}


	
?>