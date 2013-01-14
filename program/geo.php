<?
include_once("../config.php");

session_start();
if($_SESSION['email']){
	$caCFG->UserData->getData($_SESSION['email'], $_SESSION['pass']);
}

class geo extends MNG{
	function geo(){
		$this->inc();
		$this->cfg 	= $this->CFG;
		$this->db 	= $this->CFG->DB;
		$this->hdb 	= $this->CFG->HDB;
		$this->get 	= $this->CFG->GetVars;
		$this->pv	= $this->CFG->PostVars;
		$this->mode = $this->get['mode'];
	}
	function Go(){
		switch($this->mode){
			case "search":
				//print "asd";
				header ("Content-type: text/plain; charset=utf-8"); 
				$cities = new Cities();
				print $cities->lcFind($this->pv['str']);
			break;
			
			case "cities":
				$this->tt();
			break;
		}
	}
	
	function tt(){
		$db = $this->hdb;
		$ct = $db->q("select * from Cities");
		while($c = mysql_fetch_object($ct)){
			$db->q("update Settlements set PageId = $c->PageId, Topic = '$c->Topic', Ident = '$c->Ident' where id = ".$c->Settlement);
		}
	}
	
	function integCitiesPost(){
		foreach($this->pv as $key=>$value){
			print "$key => $value <br>";
		}
	}
	
	function integCities(){
		$db = $this->hdb;
		$q = "
			select 
				Id,
				Name,
				Name_ru,
				Name_ua
			from Cities
			-- left join PageData ua on Cities.Name
			where Settlement is null or Geoname is null
			
			limit 1,10
		";
		$ct = $db->q($q);
		while($c = mysql_fetch_object($ct)){
			$q = "
				select
					s.id,
					s.name,
					d.Name as district,
					r.Name as region,
					t.id as type_link,
					lat, lng
				from Settlements s
				left join Regions d on d.Id = district_id
				left join Regions r on r.Id = region_id
				left join locations.types t on t.id = type_id
				where s.`name` like '$c->Name_ru%'
				group by s.`Id`
			";
			$st = $db->q($q);
			
			// settlements
			$setlist='';
			while($s = mysql_fetch_object($st)){
				$setlist.='
				<li>
					<input type="radio" name="city_'.$c->Id.'" value="'.$s->id.'" id="city_'.$c->Id.'_'.$s->id.'"> 
					<label for="city_'.$c->Id.'_'.$s->id.'">'.$s->name.' ('.$s->region.', '.$s->district.')</label>
				</li>
				';
			} 
			$setlist = '
				<ul>
					'.$setlist.'
					<li><input name="city_'.$c->Id.'_manual"></li>
				</ul>
			';
			
		
			
			$res.='
				<fieldset>
					<legend>'.$c->Name.'</legend>
					<input name="" value="'.$c->Name_ua.'">
					<input name="" value="'.$c->Name_ru.'">
					<table>
						<tr>
							<td>
								'.$setlist.'
							</td>
							<td>
								'.$geolist.'
							</td>
						<tr>
					</table>
				</fieldset>
			';
		}
		$res="<form method=post action='geo.php?mode=cities'>$res<p><button>Submit</button></p></form>";
		print $res;
	}
	
}

$geo = new geo();
$geo->Go();

?>