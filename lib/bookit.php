<?
class Bookit extends HotCat{
	private $DjereloObjId;
	private $NezabaromObjId;
	private $OwnerTable;
	function Bookit(){
		$this->inc();
	}
	function Exec($name, $params=NULL){
		parse_str($params, $p_arr);
		if($p_arr['owner']){
			$this->Owner = $p_arr['owner'];
			switch($this->Owner){
				case "Objects": $key = 'bookit_objid';  $this->linkField = "djObjId";           $this->bookitTable = "bookit_hotelsBookit"; $this->linkedTable = "Objects"; break;
				case "Cities":  $key = 'bookit_cityid'; $this->linkField = "djSettlementId";    $this->bookitTable = "bookit_CitiesSearchForm"; $this->linkedTable = "Settlements"; break;
			}
			$this->bookitObjId = $this->uriVars[$key];
		}
		switch($name){
			case "objects":
				return $this->getObjects($this->uriVars);
			break;
			case "cities":
				return $this->getCities($this->uriVars);
			break;
			case "editlink":
				return $this->editLink($this->uriVars);
			break;
		}
	}

	function getObjects($p){
		$where = " where 1=1 ";
		$where.= ($id = $p['bookit_objid']) ? " and id = $id"      : "";
		$where.= ($cid= $p['bookit_cityid'])? " and b.cityId = $cid" : "";
		$q = "
			select
				b.id, b.cityId, b.name, b.InsertDate
			,	d.Id as ObjId, pd.Title as ObjName
			,   st.Name as SettlementName
			from bookit_hotelsBookit b
			left join Objects d on b.djObjId = d.Id
			left join Settlements st on d.Settlement = st.id
			left join PageData pd on d.PageId = pd.PageId and lang = '".$this->CFG->lang."'
			$where
			group by b.id
		";
		//dbg($q);
		$obj = $this->CFG->HDB->q($q);
		$xml='';
		$i=0;
		while($o = mysql_fetch_object($obj)){
			$link = $o->ObjName
					? '<link id="'.$o->ObjId.'"><![CDATA['.$o->ObjName.' ('.$o->SettlementName.')]]></link>'
					: null;
			$xml.='
				<item id="'.$o->id.'" type="o">
					<name><![CDATA['.$o->name.']]></name>
					'.$link.'
					<insDate>'.$o->InsertDate.'</insDate>
				</item>
			';
			$i++;
		}
		$xml = $i>1 ? '<items>'.$xml.'</items>' : $xml;
		return $xml;
	}
	function getCities($p=null){
		$where = ($id = $p['bookit_cityid']) ? "where id = $id" : "";
		$q = "
			select
				c.Id, c.Name, c.Url, c.InsertDate
			,   s.id as SettlementId, s.name as SettlementName
			,   r.name as RegionName
			,   count(h.Id) as ObjNum
			from bookit_CitiesSearchForm c
			left join Settlements s on c.djSettlementId = s.id
			left join Regions r on s.region_id = r.Id
			join bookit_hotelsBookit h on h.cityId = c.Id
			group by c.Id
			order by ObjNum desc
		";
		//dbg($q);
		$cit = $this->CFG->HDB->q($q);
		$xml='';
		$i=0;
		while($c = mysql_fetch_object($cit)){
			$link = $c->SettlementId
					? '<link id="'.$c->SettlementId.'"><![CDATA['.$c->SettlementName.' ('.$c->RegionName.')]]></link>'
					: null;
			$xml.='
				<item id="'.$c->Id.'" type="c" inside="'.$c->ObjNum.'">
					<name><![CDATA['.$c->Name.']]></name>
					'.$link.'
					<insDate>'.$c->InsertDate.'</insDate>
				</item>
			';
			$i++;
		}
		$xml = '<items>'.$xml.'</items>';
		return $xml;
	}
	function editLink($p){
		if(!($link = $this->CFG->PostVars['linkid']) || !$this->bookitTable || !$this->bookitObjId){
			print "Invalid parameters: [link:$link], [tbl:$this->bookitTable], [field:$this->linkField], [id:$this->bookitObjId]";
			return;
		}
		$q = "update $this->bookitTable set $this->linkField = $link where id = $this->bookitObjId";
		dbg($q);
		$this->CFG->HDB->q($q);
		$cityname = $this->CFG->HDB->getField($this->linkedTable, "AccountCode", $link);
		print "$cityname";
	}

}
?>