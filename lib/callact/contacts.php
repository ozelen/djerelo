<?
class Contacts extends CallAct{
	var $CFG;
	var $xmlOut;
	var $addColsArray;
	var $addXml;
	function Contacts(){
		global $caCFG;
		$this->CFG = $caCFG;
		$this->xmlOut = new xmlOut;
		$this->addColsArray = array();
		$this->addXml = incXml("person_details.xml");
	}
	
	function detailsForm($cont_id, $field_id, $templ, $debug=NULL){
		$editfield = $field_id ? ' edit="'.$field_id.'"' : '';
		print "[$editfield]";
		$xml='
			<form '.$editfield.'>
				'.$this->addXml.'
				'.$this->contactList("select * from Contacts where Id = $cont_id", $owner_id, $debug).'
			</form>
		';
		//$debug = true;
		return $this->xmlOut->qShow($xml, $templ, $debug);
	}
	
	function quickNewContactForm($namefield, $phonenumber, $objid, $templ, $debug){
		$cont_xml = file_get_contents($this->CFG->RootDir."/sources/xml/person_details.xml");
		$name = split(" ", $namefield);
		$xmlcont = '<?xml version="1.0" encoding="Windows-1251"?>';
		$xmlcont	.= '<form id="'.$objid.'">';
		$xmlcont	.= $this->addXml;
		//$xmlcont 	.= $cont_xml;
		$xmlcont 	.= $this->getXmlFromArray(
			array(
				'person-lastname' 	=> $name[0],
				'person-firstname' 	=> $name[1], 
				'person-patronymic' => $name[2],
				'person-language'	=> '',
				'person-phonenumber'=> $phonenumber,
				'person-companyid'	=> $objid,
				'person-sex' 		=> 0
			)
		);
		$xmlcont .= '</form>';
		return $this->xmlOut->qShow($xmlcont, $templ, $debug);
	}	
	
	function contactList($q="select * from Contacts", $ownerid=NULL, $debug=NULL){
		$db=$this->CFG->CDB;
		//print "[$q]";
		$contacts=$db->q($q);
		$xml='<contacts ownerid="'.$ownerid.'">';
		$xml.=$this->addXml;
		$msg=mysql_affected_rows($db->CDB);
		while($c=mysql_fetch_array($contacts)){
			$xml.='<contact id="'.$c['Id'].'">';
			$fields=$db->q("select * from ContactFields where LinkTo = 1 and ContactId = ".$c['Id']." order by Id desc");
			while($f=mysql_fetch_array($fields)){
				foreach($f as $field_type => $field_data){
					if($field_data && preg_match("|data_(.*)|", $field_type, $regs)){
						$type = $regs[1];
						$data = $field_data;
						if(is_string($data))$data="<![CDATA[$data]]>";
					}
				}
				//print "<p>[id: ".$f['FieldTypeId']." type: $type; data: $data]</p>";
				$xml.='
					<field id="'.$f['FieldTypeId'].'" date="'.$f['DateLastEdit'].'">
						<data type="'.$type.'">'.$data.'</data> <!-- new format -->
						
						<!-- old format -->
						<int>'.$f['data_int'].'</int>
						<varchar><![CDATA['.$f['data_varchar'].']]></varchar>
						<datetime><![CDATA['.$f['data_datetime'].']]></datetime>
						<text><![CDATA['.$f['data_text'].']]></text>
						
					</field>
				';
			}
			$xml.='</contact>';
		}
		//$xml.="<count></count>";
		$xml.="</contacts>";
		//$debug = true;
		//if($debug)print "<textarea style='width:300px; height:200px'>$xml</textarea>";
		return $xml;
	}
	
	function showContact($id, $ownerid, $templ, $debug=NULL){
		//$debug = true;
		$xmlcont = 
		'<?xml version="1.0" encoding="Windows-1251"?>'
		.$this->contactList("select * from Contacts where Id = $id", $ownerid, $debug);
		return $this->xmlOut->qShow($xmlcont, $templ, $debug);
	}
	
	function FIO($id){
		$db = $this->CFG->CDB;
		$arr = array();
		$q="
			select 
				f.data_varchar data,
				f.FieldTypeId type
			from Contacts c
			join ContactFields f on f.ContactId = c.Id
			where c.Id = $id
			and f.FieldTypeId in ('person-lastname', 'person-firstname', 'person-patronymic')
		";
		$fields = $db->q($q);
		while($f = mysql_fetch_object($fields)){
			$arr[$f->type]=$f->data;
		}
		return $arr['person-lastname']." ".$arr['person-firstname']." ".$arr['person-patronymic'];
	}
	
	function showContactList($ownerid, $searchtext, $templ, $debug=false){
		//print "[$searchtext]";
		//if($searchtext)$searchtask = "where ";
		switch($searchtext){
			case 'none'			: $cont = '<contacts ownerid="'.$ownerid.'"> </contacts>'; break;
			case 'all'			: $cont = $this->contactList("select * from Contacts", $ownerid); break;
			case 'sameowner'	: 
				$searchparams = "ContactFields.data_varchar like '%".$searchtext."%'";
				$q = "
					select ContactFields.ContactId as Id
					from Contacts 
						join ContactFields on ContactFields.ContactId = Contacts.Id 
						where 
						ContactFields.FieldTypeId = 'person-companyid'
						and ContactFields.data_int = $ownerid
						and ContactFields.LinkTo = 1
						group by Id
						
				";
				$cont = $this->contactList($q, $ownerid);
			break;
			default : 
				$searchparams = "ContactFields.data_varchar like '%".$searchtext."%'";
				$q = "
					select ContactFields.ContactId as Id
					from Contacts 
						join ContactFields on ContactFields.ContactId = Contacts.Id 
						where 
						$searchparams
						and ContactFields.LinkTo = 1
						group by Id
						
				";
				$cont = $this->contactList($q, $ownerid);
			break;
		}

		
		
		$xmlcont = 
		'<?xml version="1.0" encoding="Windows-1251"?>'
		.$cont;
		
		$err=mysql_error($this->CFG->CDB->DB);
		if($err)print "[$err]";
		return $this->xmlOut->qShow($xmlcont, $templ, $debug);
	}
	
	function quickAddContact($postvars, $name='0', $decode=true){
		$db=$this->CFG->CDB;
		//print "Add contact!";
		$db->q("insert into Contacts (Name) values ('$name')");
		$f_id=$db->insId();
		$this->addDetails(1, $f_id, $postvars, $decode);
		return $f_id;
	}
	
}
?>