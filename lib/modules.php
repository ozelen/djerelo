<?

//include_once("../program/bookit.php");

class SiteMap extends Modules{
	private $Pages;
	function SiteMap(){
		$this->Pages = new Pages();
		$this->inc();
	}
	function Exec($name, $params, $templ=NULL){
		switch($name){
			case "menu" : return $this->menu($params); break;
		}
	}
	function menu($params){
		parse_str($params, $p_arr);
		$xml='<menu page="'.$p_arr['page'].'">'.$p_arr['name'].'</menu>';
		return $xml;
	}
}


class Modules extends MNG{
	function Modules(){
		$this->inc();
		$this->categories = new Categories();
		$this->ModuleClassArray = 
		array(
			'hotcat' 	=> new Hotcat(),
			'forum' 	=> new Forum(),
			'news'	 	=> new News(),
			'papers'	=> new Papers(),
			'pages'		=> new SiteMap(),
			'users'		=> new Users(),
			'docs'		=> new Docs(),
			'booking'	=> new Booking()
		);
	}
	function Exec($name, $params, $templ=NULL){

		switch($name){
			case "conception"	: /*$xml = $this->mdConception($params);*/ break;
			case "city"			: $xml = $this->mdCity($params); break;
//			case "citymenu"		: $xml = $this->mdCityMenu($params); break;
			case "objlist"		: /*$xml = $this->mdObjList($params);*/ break;
			case "objmenu"		: /*$xml = $this->categories->showByObject($params);*/ break;
			default:
				$cl = split('[/.]', $name);
				$xml = $this->classExec($cl);
			break;
			//case "": break;
			
		}
		
		
		if(preg_match("|(.*)\((.*)\)|", $name, $regs))
			$name=$regs[1];
			
		$single_xml = $this->CFG->xmlHeader.'
			<block lang="'.$this->CFG->lang.'">
				'.$this->addPresets().'
				<name><![CDATA['.$name.']]></name>
				<content>'.$xml.'</content>
			</block>';
		
		return (
			$templ 
				? $this->xmlOut->qShow($single_xml, $templ, false) 
				: $xml
			);

	}
	
	function iface($arr_call){
		$current = array_shift($arr_call);
		if(preg_match("|(.*)\((.*)\)|", $current, $regs)){
			$function_name = $regs[1];
			$function_params = $regs[2];
			//print "[$all][$current] is function";
			return $this->Exec($function_name, $function_params);
		}
		if(is_object(($obj = $this->ModuleClassArray[$current])))
		return $obj->iface($arr_call);
		//else print "<p>[$current] id not an object</p>";
	}
	
	
	function classExec($arr_call){
		if(is_object(($obj = $this->ModuleClassArray[array_shift($arr_call)])))
		return $obj->iface($arr_call);
	}
	
	function mdCity($params){

		parse_str($params, $p_arr);
		$id = $params;
		$db = $this->HDB;
		$pref = $this->pref;
		
		$q = "
			select 
				Id, Topic, RegionId, Name$pref as Name
			from 
				Cities where Ident = '$id'
		";
		
		$c = mysql_fetch_array($db->q($q));
		//$city_num_id = $db->getFieldWhere("Cities", "Id", "CityId = ".$id);
		$obj = $db->q("select Id, Name$pref as Name, Info$pref as Info, TypeId, CityId, Topic from Objects where CityId = ".$c['Id']);
		while($o = mysql_fetch_array($obj)){
			$objects .= '
				<object type="'.$o['TypeId'].'" city="'.$o['CityId'].'" topic="'.$o['Topic'].'">
					<name><![CDATA['.$o['Name'].']]></name>
				</object>
			';
		}

		$xml = '
			<city id="'.$c['Id'].'" topic="'.$o['Topic'].'" region="'.$o['RegionId'].'">
				<caption><![CDATA['.$c['Name'].']]></caption>
				<objects>
					'.$objects.'
				</objects>
			</city>
		
		';
		
		return $xml;
	}
	
	function mdCityMenu($params){
		//$c = new Cities();
		
		//return $c->Show($params, false);
		$id = $params;
		$db = $this->HDB;
		$pref = $this->pref;
		
		$q = "
			select 
				Id, Topic, RegionId, Name$pref as Name, Ident
			from 
				Cities where Ident = '$id'
		";
		$c = mysql_fetch_array($db->q($q));
		if(!$c['Id']){
			//print "[$q]";
			return false;
		}
		$q = "
		
			SELECT 
			  ObjTypes.Id as TypeId,
			  TN.data_varchar AS Name,
			  count(Objects.Id) as ObjNum,
			  ObjTypes.Ident
			FROM
			  Objects
			  LEFT OUTER JOIN ObjTypes ON (ObjTypes.Id = Objects.TypeId)
			  left join DataFields as TN on (TN.ResId = ObjTypes.ResId and TN.Lang = '".$this->CFG->lang."')
			WHERE
			  CityId = ".$c['Id']."
			GROUP BY
			  ObjTypes.Id
			
		";
		//print "[[".$o['TypeId'];
		$obj = $db->q($q);
		while($o = mysql_fetch_array($obj)){
			if($o['Name'])$objects .= '
				<type id="'.$o['TypeId'].'" city="'.$o['CityId'].'" topic="'.$o['Topic'].'">
					<name><![CDATA['.$o['Name'].']]></name>
					<ident><![CDATA['.$o['Ident'].']]></ident>
					<objs>'.$o['ObjNum'].'</objs>
				</type>
			';
		}

		$xml = '
			<city id="'.$c['Id'].'" topic="'.$o['Topic'].'" region="'.$o['RegionId'].'" >
				<caption><![CDATA['.$c['Name'].']]></caption>
				<city-id>'.$c['Ident'].'</city-id>
				<objects>
					'.$objects.'
				</objects>
			</city>
		
		';
		
		return $xml;
		
		
	}
	
	function mdConception($params){
		if(is_numeric($params)){
			$cp_id = $params;
			$level = 1;
		}
		else{
			parse_str($params, $p_arr);
			$cp_id = $p_arr["id"];
			$level = $p_arr["level"];
		}

		$hdb = $this->HDB;
		$db = $this->CFG->DB;
		if($cp_id){
			$q = "
				select 
					Id, 
					Name,
					Title,
					Source
				from Pages 
				left join PageData on Pages.Id = PageData.PageId and Lang = '".$this->CFG->lang."'
				where Rozdil = $cp_id
			";
			$pages = $db->q($q);
			while($p = mysql_fetch_array($pages)){
				if(!$p['Title'])continue;
				$xml.='<conception id="'.$p['Id'].'">';
				$xml.='<name><![CDATA['.$p['Title'].']]></name>';
				$blocks = $db->q("select * from Blocks where DocId = ".$p['Id']);
				while($b = mysql_fetch_array($blocks)){
					if($b['Name']!='conception'){
						$xml.=$this->Exec($b['Name'], $b['Parameters']);
					}
				}
				$xml.='</conception>';
			}
			
			$c = mysql_fetch_array($db->q("select Title from Pages left join PageData on PageId = Id and Lang = '".$this->CFG->lang."' where Id = $cp_id"));
			
			return "
				<conceptions>
					<name>".$c['Title']."</name>
					$xml
				</conceptions>
			";

		}
		return "no conceptions";
	}
	
	
	function mdObjList($params){
		/*
		parse_str($params, $p_arr);
		$type 	= $p_arr['type'];
		$lim 	= $p_arr['lim'];
		$order	= $p_arr['order'];
		$city	= $p_arr['city'];
		
		$obj = new Objects();
		
		$xml = $obj->objList($type, $lim, $order, $city);
		//print "<textarea>$xml</textarea>";
		return $xml;
		*/
		$obj = new Objects();
		$xml = $obj->mdObjList($params);
		//print "<textarea>$xml</textarea>";
		return $xml;
	}
}
?>