<?
//print "docs1";

class Documents extends CallAct{
	var $CFG;
	var $xmlOut;
	var $addColsArray;
	var $addXml;
	function Documents(){
		//global $caCFG;
		//$this->CFG = $caCFG;
		//$this->xmlOut = new xmlOut;
		$this->addColsArray = array();
	}

	function showDir($dir, $id, $templ=NULL){
		if(!($handle = opendir($dir))){
			print "<p>Can't open dir [$dir]</p>";
			return false;
		}
		while(false!==($file = readdir($handle))){
			//print "<p>$dir/$file</p>";
			if ($file != "." && $file != ".."){
				$file=trim($file);
				if(is_dir($dir."/".$file)){
					$xml.='
						<dir name="'.$file.'">
							'.$this->showDir($dir."/".$file, $id).'
						</dir>
					';
				}
				else{
					$path = preg_replace("|".$this->CFG->TempDir."|", "", $dir);
					//$path=$url;
					$xml.='<file local="'.$path.'" ext="xml">'.$file.'</file>';
				}
			}
		}

		//if(!$xml)$xml="<empty>empty</empty>";
		return (
			$templ 
				? $this->xmlOut->qShow($this->CFG->xmlHeader.'<dir id="'.$id.'">'.$xml.'</dir>', $templ, false) 
				: $xml);
	}
	
	function showForm($filename, $serviceid, $ownerid, $templ=NULL, $debug=NULL){
		//print "[$filename]";
		$xml = '
			<document-form ownerid="'.$ownerid.'" xmlfile="'.$filename.'" serviceid="'.$serviceid.'">
				'.$this->dataFields($ownerid, 2).'
				'.incXml("docs/".$filename).'
				'.$additional.'
			</document-form>
		';
		return ($templ ? $this->xmlOut->qShow($this->CFG->xmlHeader.$xml, $templ, $debug) : $xml);
	}
	
	function showDoc($postvars, $debug=false){
		$xmlfile	= $postvars['XmlFile']; 
		$xsltfile	= $postvars['TempFile'];
		if(!$xsltfile)$xsltfile="docs/templates/agreements/agreement.xslt";
		
		//print "[$xmlfile, $xsltfile]";
		
		foreach($postvars as $key => $value){
			if(preg_match("|insert-field_(.*)--(.*)|", $key, $regs)){
				//print "<p>$regs[1] >> $regs[2]</p>";
				$value=stripslashes(preg_replace("|\n|", "<br/>", $value));
				$fieldvalues.='<field name="'.$regs[2].'"> <![CDATA[ '.$value.' ]]> </field>';
			}
		}
		$xml = '
			<document-form ownerid="'.$ownerid.'">
				<field-values>
					'.$fieldvalues.'
				</field-values>
				'.incXml("docs/".$xmlfile).'
			</document-form>
		';
		return $this->xmlOut->qShow($this->CFG->xmlHeader.$xml, $xsltfile, $debug);
	}
	
	function saveDoc($postvars, $debug=false){
		$db = $this->CFG->CDB;
		$xmlfile	= $postvars['XmlFile']; 
		$xsltfile	= $postvars['TempFile'];
		
		$arr = array();
		foreach($postvars as $key => $value){
			if(preg_match("|insert-field_(.*)|", $key, $regs)){
				$arr[$regs[1]]=$value;
			}
		}
		$today = date("Y-m-d H:i");
		$ins = $db->InsRepVals(
			array(
				'Registered'	 	=> $today,
				'UserRegister'		=> $this->CFG->UserId,
				'OwnerId'			=> $postvars['OwnerId'],
				'ProjectName' 		=> $postvars['ProjectName'],
				'ServiceId' 		=> $postvars['ServiceId']
			)
		);
		$q = "insert into Documents (".$ins['InsKeys'].") values (".$ins['InsVals'].")";
		$db->q($q);
		if(($id=$db->insId()) && !$db->Error()){
			$this->addDetails(3,$id,$arr,false);
			$content=$this->showDoc($postvars, $debug);
			$newdir=$this->CFG->DataDir."/docs/$id";
			//print "[$newdir]";
			mkdir($newdir, "0777");
			$fp = fopen($newdir."/$id.html", "w");
			if (fwrite($fp, $content))return true; print "<p>Document has been saved to file!</p>";
		}
		else print "Error!";
		//print "[$q]";
	}
	
	function docsList($q){
		$db = $this->CFG->CDB;
		$doc = $db->q($q);
		print $db->Error();
		$xml='<documents>';
		while($d=mysql_fetch_array($doc)){
			$xml.='
				<document id="'.$d['Id'].'">
					 <registered date="'.$d['Registered'].'" userid="'.$d['UserRegister'].'">'.$d['UserName'].'</registered>
					 <owner id="'.$d['OwnerId'].'">'.$d['OwnerName'].'</owner>
					 <project serviceid="'.$d['ServiceId'].'" type = "'.$d['ServiceType'].'">'.$d['ProjectName'].'</project>
				</document>
			';
		}
		$xml.='</documents>';
		return $xml;
	}
	
	function showByOwner($id, $templ=NULL){
		if(!$id)return false;
		$q="
			select
				Documents.Id as Id,
				Registered,
				UserRegister,
				UserSigned,
				Documents.OwnerId as OwnerId,
				OwnerHandle,
				Documents.ServiceId as ServiceId,
				Documents.ProjectName,
				ContactFields.data_varchar as OwnerName,
				Services.ProjectName as ProjectName,
				Services.ServiceId as ServiceType,
				Users.Username as UserName
			from Documents
				left join ContactFields on ContactId = $id and FieldTypeId = 'owner-name'
				left join Services on Services.Id = Documents.ServiceId
				left join Users on Users.Id = Documents.UserRegister
			where Documents.OwnerId = $id
			group by Documents.Id
			order by Registered desc
		";
		$xml=$this->docsList($q, true);
		$addxml="<owner-docs>".incXml("settings.xml").$xml."</owner-docs>";
		//print "<textarea style='width:400; height:200'>$addxml</textarea>";
		return (
			$templ 
				? $this->xmlOut->qShow($this->CFG->xmlHeader.$addxml, $templ, false) 
				: $xml
			);
		
	}
	

}

?>