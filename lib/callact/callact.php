<?

class CallAct extends MNG{
	function CallAct(){
		$this->inc();
		
	}
	function addDetails($LinkTo, $ContactId, $arr, $decode=true, $user_id=0){
		// Parameter LinkTo defines, what table have this field (1: contacts, 2: owners, etc. see documentation)
		// ContactId is Id of field in parent table define in forst parameter
		// $arr is hash array of values in special format write: (data type)--(field type) => (data)
		$db=$this->CFG->DB;
		$today = date("Y-m-d H:i");
		foreach($arr as $key => $value){
			if($decode)$value = $value;
			if(preg_match("|(.*)--(.*)|", $key, $regs)){
				$q="
					insert into ContactFields (
						LinkTo,
						ContactId, 
						DateAdd,
						LastEditDate,
						LastEditUser,
						FieldTypeId, 
						data_$regs[1]
					) 
					values (
						$LinkTo,
						$ContactId,
						'$today',
						'$today',
						$user_id,
						'$regs[2]', 
						'".addslashes($value)."'
					)
				";
				if($value)$db->q($q, false);
				//print "<p>".$q."</p>Err: ".mysql_error($db->DB);
			}
			//print "<p>$key = [$value]</p>";
		}
	}
	
	function dataFields($ContactId, $LinkTo){
		$db = $this->CFG->CDB;
		$xml='<datafields>';
		$q3='select * from ContactFields where ContactId = "'.$ContactId.'" and LinkTo = '.$LinkTo;
		$df = $db->q($q3);
		//print "[$q3] :".mysql_error($db->DB)."<br>";
		while($f=mysql_fetch_array($df)){
			$xml.='
				<field 
					id="'.$f['FieldTypeId'].'" 
					db_id="'.$f['Id'].'" 
					dateadd="'.$f['DateAdd'].'" 
					lastedit="'.$f['LastEditDate'].'" 
					lastedituser="'.$f['LastEditUser'].'" 
					notactual="'.$f['NotActual'].'"
				>
					<data type="int">'.$f['data_int'].'</data>
					<data type="varchar"><![CDATA['.$f['data_varchar'].']]></data>
					<data type="datetime">'.$f['data_datetime'].'</data>
					<data type="text"><![CDATA['.$f['data_text'].']]></data>
				</field>
			';
		}
		$xml.='</datafields>';
		//print "<textarea>$xml</textarea>";
		return $xml;
	}
	
}

?>