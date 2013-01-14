<?

class Docs extends Modules{
	function Exec($name, $params, $templ=NULL){
		//print "[$name, $params]";
		switch($name){
			case "list": return $this->AgrList(array('limit' => 100)); break;
			case "byobjid": return $this->AgrList(array('objid' => $this->uriVars['objid'])); break;
			case "open": return $this->AgrList(array('docid' => $this->uriVars['docid'])); break;
			case "addform": return $this->addForm(array('objid' => $this->uriVars['objid'], 'docid' => $this->uriVars['docid'])); break;
			case "save": return $this->Save(); break;
			case "delete": $this->Del($this->uriVars['docid']); break;
		}
	}
	function Docs(){
		$this->inc();
	}
	
	function Del($id){
		if(!$id) return false;
		$db = $this->CFG->HDB;
		$objid = $db->getField("Agreements", "ObjId", $id);
		$obj = new Objects();
		if(!$obj->objAccess('Objects', $objid, 'admin')){print "[access denied] You can't delete this Document!"; return false;}
		$db->q("delete from Agreements where Id = $id");
		print "Document $id has been deleted!";
	}
	
	function Save(){
		$pv = $this->CFG->PostVars;
		$db = $this->CFG->HDB;
		
		$qcond = ($DocId = $pv['Id']) == 'new' ? array('pref' => ' insert into ') : array('pref' => ' update ', 'where' => " where Id = ".$pv['Id']) ;

		$pv['BeginDate'] = date("Y-m-d", strtotime($pv['BeginDate']));
		$pv['Expire'] = date("Y-m-d", strtotime($pv['Expire']));
		
		$qr = array();
		foreach(array_keys($pv) as $key){
			$qr[$i++]=" `$key` = '$pv[$key]'";
		}
		$q = $qcond['pref']." Agreements set ".join(', ', $qr)." ".$qcond['where'];
		$db->q($q);
		
		//print "<textarea>$q</textarea> [".$qcond['where']."]";
		
		//$q = join(', ', array_keys($this->CFG->PostVars));

		foreach($pv as $k => $v){
			//print "$k=>$v<br/>";
			if($k == 'BeginDate' || $k == 'Expire')$attr = ' pretty="'.$this->prettyDate($v).'" ';
			$fields.='<field id="'.$k.'" '.$attr.'><![CDATA['.$v.']]></field>';
		}
		
		if(!$db->Error()){
			$id = $pv['Id'] == 'new' ? $db->insId() : $pv['Id'];
			$msg = $ObjId == 'new' ? array('id' => 'docs.added', 'msg' => 'Added Succesfylly!') : array('id' => 'docs.updated', 'msg' => 'Updated Succesfully!');
			if($id){
				$this->CFG->SysMsg->Add($msg['msg'], 'ok', $msg['id']);
				return $this->AgrList(array('docid' => $id));
			}
			else $this->CFG->SysMsg->Add('Something wrong!', 'error', 'docs.input.error');
		}
		else {
			$this->CFG->SysMsg->Add('', 'error', 'docs.input.error');
			return '
				<docs mode="savedoc-error">
					<doc id="'.$d['Id'].'">
						'.$fields.'
					</doc>
				</docs>
			';
		}
	}
	
	function addForm($p){
		$objid = $p['objid'];
		$docid = $p['docid'];
		//print "objid = $objid; docid = $docid";
		if($docid)return $this->AgrList(array('newontemplate'=>$docid));
		else{ 
			$y			= date("Y")+1;
			$exp 		= $y.'-'.date('m').'-'.date('d');
			$exp_pretty = date("d").'.'.date('m').'.'.$y;
			return '
				<docs mode="agreements-total">
					<doc id="new">
						<field id="Id">new</field>
						<field id="ObjId">'.$objid.'</field>
						<field id="BeginDate" pretty="'.date("d.m.Y").'">'.date("Y-m-d").'</field>
						<field id="Expire" pretty="'.$exp_pretty.'">'.$exp.'</field>
					</doc>
				</docs>
			';
		}
	}
	
	function AgrList($conditions, $mode='agreements-total'){
		
		if(is_array($conditions)){
			
			//$conditions['newontemplate'] = $conditions['docid'];
			
			if($conditions['newontemplate']){
				$docid = $conditions['docid'] = $conditions['newontemplate'];
				$datefields = "BeginDate + interval 12 month as BeginDate, Expire + interval 12 month as Expire, ";
				//$cond_str .= " and agr.Id = ".$docid;
			}else{
				$datefields = "BeginDate, Expire,";
			}
			
			
			if($docid = $conditions['docid'])$cond_str = " and agr.Id = ".$docid;
			else
			foreach($conditions as $key => $value){
				switch($key){
					case 'objid'	 : $value ? $cond_str.=" and ObjId = ".$value : false; break;
					case 'from'		 : $value ? $cond_str.=" and BeginDate > '".$value."'" : false; break;
					case 'to'		 : $value ? $cond_str.=" and BeginDate < '".$value."'" : false; break;
					case 'keyword': 
						if($value)
						switch($conditions['searchin']){
							case "objname"	: $cond_str.=" and objdata.Title like '%$value%' "; break;
							case "owner"	: $cond_str.=" and concat_ws(' ', LastName, FirstName, Patronymic) like '%$value%' "; break;
							case "number"	: $cond_str.=" and concat_ws(' ', Ser, Number) like '%$value%' "; break;
						}
					break;
					case 'orderby'	 : $order_cond." order by ".$value; break;
					case 'ordertype' : $order_cond ? $order_cond.=" ".$value : false; break;
					case 'groupby'	 : if($value == 'ObjId')$group_cond = "group by obj.Id"; break;
					case 'limit'	 : $limit = " limit ".$value; break;
				}
			}
		}
		
		if(!$group_cond)$group_cond = "group by agr.Id";
		$q = "
			select 
				agr.Id,
				ObjId,
				objdata.Title as ObjName,
				FirstName, Patronymic, LastName,
				
				$datefields
				
				Contacts,
				Price,
				Ser,
				Number,
				count(agr.Id) as Howmany,
				count(Bills.Id) as BillsCount,
				
				stl.Ident as CityName,
				tp.Name as TypeIdent,
				obj.AccountCode as login
			from Agreements agr
				left join Objects obj on obj.Id = agr.ObjId
				left join PageData objdata on obj.PageId = objdata.PageId and Lang = '".$this->CFG->lang."'
				left join Bills on AgrId = agr.Id
				left join Settlements stl on obj.Settlement = stl.Id
				left join skiworld.ClassLinks `type` on `type`.OwnerTable = 'Objects' and `type`.OwnerId = obj.Id and `type`.TypeOf = 'Objects'
				left join skiworld.Pages tp on `type`.ClassValue = tp.Id
			where 1=1
				$cond_str
			$group_cond
			$order_cond
			$limit
		";
		//print "<textarea>$q</textarea>";
		
		
		$docs = $this->CFG->HDB->q($q);
		while($d = mysql_fetch_array($docs)){
			$fields='';
			
			if($conditions['newontemplate']){
				$vv = split("-", $d['Number']);
				if(count($vv)>1 && strlen($vv[count($vv)-1])==2)$vv[count($vv)-1] = date("y");
				else $vv[count($vv)] = date("y");
				$d['Number']=join('-',$vv);
				$d['Id'] = 'new';
			}
			
			foreach($d as $k=>$v){
				if(!is_numeric($k))
					if($k == 'BeginDate' || $k == 'Expire')$attr = ' pretty="'.$this->prettyDate($v).'" ';
					$fields.='<field id="'.$k.'" '.$attr.'><![CDATA['.$v.']]></field>';
			}
			
			
			$print_values = array(
				'num' => $d['Ser']." ".$d['Number'],
				'objname' => $d['ObjName'],
				'owner' => $d['LastName']." ".$d['FirstName']." ".$d['Patronymic'],
				'date' => date("d.m.Y", strtotime($d['BeginDate'])),
				'cityname' => $d['CityName'],
				'typeident' => $d['TypeIdent'],
				'price' => $d['Price'],
				'login' => $d['login']
			);
			foreach($print_values as $key => $value){
				$value = preg_replace("'[\t\n]'", " ", $value);
				$csv.="$value\t";
			}
			
			$csv = join("\t", array_keys($print_values))."\n$csv";
			$xml.='
				<doc id="'.$d['Id'].'">
					'.$fields.'
					<csv><![CDATA['.$csv.']]></csv>
				</doc>
			';
		}
		$xml = '<docs mode="'.$mode.'">'.$xml.'</docs>';
		//print "<textarea>$xml</textarea>";
		return $xml;
	}
	
	function edAgr($data){
		($id = $data['id']) ? $cond = array("update", "where Id = $id") : $cond1 = array("insert into", "");
		
		$q = "
			$cond[0] Agreements set 
				FirstName = '".$data['name1']."', 
				Patronymic = '".$data['namep']."', 
				LastName = '".$data['name2']."', 
				BeginDate = '".$data['price']."', 
				EndDate = '".$data['cont']."', 
				Contacts = '".$data['begdate']."', 
				Ser = '".$data['ser']."', 
				Num = '".$data['num']."'
			$cond[1]
		";
	}
}

?>