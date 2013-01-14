<?

class Companies extends CallAct{
	function Companies(){
		$this->inc();
		$this->DB = $this->CFG->CDB;
	}

	
	function Add($postvars){
		if(!postvars){
			print "<p>Data fields is empty</p>";
			return false;
		}
		//foreach($postvars as $key => $value)print "[$key] = $value<br>";
		
		if(!($acode=$postvars['AccountCode']))$acode="null";
		else $acode = "'$acode'";
		
		$db=$this->CFG->DB;
		$db->q("insert into Companies (AccountCode) values ($acode)");
		$ins_id = $db->insId();
		$this->addDetails(2, $ins_id, $postvars, false, $user_id=$this->CFG->UserId);
		return $ins_id;
	}
	
	function Show($id){
		$qq = $this->CFG->CDB->q("select * from Companies where Id = $id");
		$c = mysql_fetch_object($qq);
		
		$xml = '
			<company id="'.$c->Id.'">
				<ident><![CDATA['.$c->AccountCode.']]></ident>
				'.$this->dataFields($id, 2).'
			</company>
		';
		
		return $xml;
	}
	
	function CompanyList($postvars, $getvars, $templ, $debug=NULL){
		//print "Companies";
		
		foreach($getvars as $key => $value){
			if(preg_match("|city_(.*)|", $key, $regs)){
				$cities[$i++] = $value; 
			}
			if(preg_match("|type_(.*)|", $key, $regs)){
				$types[$i++] = $value; 
			}
		}

		$cond_num=0;
		if($citylist = $this->CFG->DB->InsRepVals($cities)){
			//print "<h3>Citi</h3>";
			$conditions.="
					+
					max(case
						when ContactFields.FieldTypeId = 'company-cityid' and ContactFields.data_int in (".$citylist['InsVals'].") then 1
						else 0
					end)
			";
			$cond_num++;
		}
		if($typelist = $this->CFG->DB->InsRepVals($types)){
			$conditions.="
					+
					max(case
						when ContactFields.FieldTypeId = 'company-typeid' and ContactFields.data_int in (".$typelist['InsVals'].") then 1
						else 0
					end)
			";
			$cond_num++;
		}
		if($kw=$getvars['keyword']){
			//print "<h1>$kw</h1>";
			$conditions.="
				+
				max(case
					when ContactFields.FieldTypeId = 'company-name' and ContactFields.data_varchar like '%$kw%' then 1
					else 0
				end)
			";
			$cond_num++;
		}

		//print "[$usl]";
		//
		if(!$conditions)$limit = "limit 50";
		$query="
			select SQL_CALC_FOUND_ROWS
				Companies.Id as Id, 
				Companies.AccountCode as AccountCode,
				(select ResultId from Calls where OwnerId = Companies.Id order by CallDate desc limit 1) as LastCallResult
			from Companies
			
			
			right join 
				ContactFields 
					on ContactFields.ContactId = Companies.Id 
					and ContactFields.LinkTo = 2
			where Companies.Id is not null
			group by 
				Companies.Id, AccountCode
                having
                (
				 	 0
					 $conditions
					+0
				)=$cond_num
			
			order by Companies.Id
			$limit
		";
		
		//print "<textarea>$query</textarea>";
		
		//$query = "select * from Companies";
		
		$this->addXml.= $this->countByField("company-cityid", "cities-count");
		$this->addXml.= $this->countByField("company-typeid", "types-count");
		
		return $this->showTable($query, $templ, $debug);
		//print "[".$data->CFG->DB->AffectedRows()."]";
	}
}

?>