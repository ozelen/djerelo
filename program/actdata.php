<?
	include("../lib.php");
	include("../lib/incxml.php");
	$data = new dataExpress();

	$postvars = postDecode($_POST);
	$getvars = postDecode($_GET);
	
	if($t  = $getvars['template'])	{$templ = $t;}	else	{$templ = "table1.xslt";}
	if($tb = $getvars['table'])		{$tbl = $tb;}	else 	{$tbl = "Companies";}
	$ActMode = $getvars['mode'];
	
	$presets = 
		$set_xml.
		$person_details.
		$owner_details.
		$citieslist.
		$objtypelist.
		$servicelist.
		$data->userInfo()
	;

	$data->addXml = $presets;
	
	function msg($txt){
		/*
		$msg = '
			<div class="ui-widget" style="margin:10px 0">
				<div class="ui-state-default ui-corner-all" style="margin-top: 20px; padding: 0 .7em;"> 
					<p>
						<span class="ui-icon ui-icon-wrench" style="float: left; margin-right: .3em;"></span>
						'.$txt.' 
					</p>
				</div>
			</div>
		';
		*/
		$msg='
			<div style="width:5px; height:5px; position:absolute; z-index:10; background:#d00; margin:5px -10px" title="'.$txt.'" onclick="$(this).children().first().toggle()">
				<div style="width:400px; background:#ccc; position:absolute; display:none">'.$txt.'</div>
			</div>
		';
		print $msg;
	}
	
	msg("[template: $templ] [table: $tbl] [mode: $ActMode]<br/>");

	switch($tbl){
		
		/* ******************************************************** COMPANIES ******************************************************** */
		case "Companies" :
			if($CompId=$getvars['Id'])$tbl1=$data->showOwner($CompId, $templ, false);
			else $tbl1 = $data->CompanyList($postvars, $getvars, $templ, false);
		break;
		
		/* ******************************************************** SERVICES ******************************************************** */
		case "Services" :
			switch($ActMode){
				case 'add': 
					$data->Services->addService($postvars, $templ);
					$tbl1 = $data->Services->showOwnerServices($getvars['Id'], $servicelist, $templ, false); 
				break;
				case 'group': $tbl1 = $data->xmlOut->qShow($data->CFG->xmlHeader.'<list id="'.$postvars['ServiceId'].'">'.$servicelist.'</list>', $templ); break;
				case 'reserve':
					$data->Services->reserveVacancy($getvars['Id']);
					$tbl1 = "Reserved!";
				break;
				default: 
					$tbl1 = $data->Services->showOwnerServices($getvars['Id'], $servicelist, $templ, false); 
				break;
			}
		break;
		
		/* ******************************************************** PROJECTS ******************************************************** */
		case "Projects":
			$tbl1=$data->Services->showProjects($getvars, $postvars, $servicelist, $templ);
		break;
		
		/* ******************************************************** DOCUMENTS ******************************************************** */
		case "Documents":
			switch($getvars['mode']){
				case 'showschemes': $tbl1 = $data->Documents->showDir($data->CFG->RootDir."/sources/xml/docs", $getvars['OwnerId'], $templ); break;
				case 'showform': $tbl1 = $data->Documents->showForm($getvars['file'], $postvars['ServiceId'], $postvars['OwnerId'], $templ, false); break;
				case 'showtemplates': $tbl1 = $data->Documents->showDir($data->CFG->RootDir."/sources/temp/docs/templates".$postvars['dir'], $getvars['OwnerId'], $templ); break;
				case 'showdoc': $tbl1 = $data->Documents->showDoc($postvars, false); break;
				case 'savedoc': $tbl1 = $data->Documents->saveDoc($postvars, false); break;
				case 'show_by_ownerid': $tbl1=$data->Documents->showByOwner($getvars['Id'], $templ); break;
			}
		break;
		
		/* ******************************************************** DATA FIELDS ******************************************************** */
		case "DataFields":
			switch($ActMode){
				case 'addform'	: $tbl1=$data->dfAddForm($postvars['fieldtypeid'], $templ); break;
				case 'addfield'	: 
					$ownid=$getvars['OwnerId'];
					$data->addDetails(2,$getvars['OwnerId'], $postvars);
					$tbl1=$data->showTable("select * from Companies where Id = ".$getvars['OwnerId'], $templ, false);
				break;
				case 'form':
						$tbl1 = $data->fieldForm($postvars['linkto'], $postvars['fieldtypeid'], $postvars['contactid'], $getvars['fieldid'], $templ);
				break;
				case 'saveone':
					//foreach($postvars as $k=>$v)print "[$k = $v], ";
					$data->fieldSave($postvars);
					//print "Saved!";
				break;
			}
		break;
		
		/* ******************************************************** CONTACTS ******************************************************** */
		case "Contacts":
			switch($ActMode){
				case 'addcontactform':
					$data->Contacts->addXml = $presets;
					$tbl1=$data->Contacts->quickNewContactForm($postvars['ContactName'], $postvars['PhoneNumber'], $getvars['owner_id'], $templ, false);
				break;
				case 'addquick':
					$cont_id=$data->Contacts->quickAddContact($postvars);
					$tbl1=$data->Contacts->showContact($cont_id, $getvars['OwnerId'], $templ, false);
				break;
				case 'showselected':
					$tbl1=$data->Contacts->showContact($getvars['Id'], $getvars['OwnerId'], $templ, false);
				break;
				case 'searchlist':
					$tbl1=$data->Contacts->showContactList($getvars['OwnerId'], $postvars['searchquery'], $templ, false);
				break;
				case 'contactlist':
					$tbl1=$data->Contacts->showContactList($getvars['OwnerId'], $getvars['searchmode'], $templ, false);
				break;
				case 'contact_search':
					$tbl1=$data->Contacts->showContactList($getvars['OwnerId'], 'none', $templ, false);
				break;
				
				case 'addfieldform':
					$tbl1=$data->Contacts->detailsForm($getvars['ContactId'], $getvars['FieldId'], $templ);
					//$tbl1=$data->Contacts->showContact($getvars['ContactId'], $getvars['OwnerId'], $templ, true);
				break;
			}
		break;
		
		/* ******************************************************** CALLS ******************************************************** */
		case "Calls":
			switch($ActMode){
				case 'add': 
					$data->Calls->addCall($postvars); 
					//$data->Tasks->addTask($postvars);
				break;
			}
		break;
		
		/* ******************************************************** MODIFY ******************************************************** */
		case "Modify":
			switch($ActMode){
				case 'addowner': $tbl1=$data->showOwner($data->addOwner ($postvars), $templ, false); break;
				case 'delowner': $tbl1=$data->delOwner($getvars['OwnerId'], $postvars['Recipient']); break;
				case 'delfield': $data->delField($getvars['FieldId']); $tbl1=$data->showOwner($getvars['OwnerId'], $templ, false); break;
			}
		break;
		
		case "Users":
			print "users ";
			switch($ActMode){
				case "list":
					print "userlist";
				break;
				case "add": break;
				case "alter": break;
			}
		break;
	}
	
	$x = 10; $y = '';

	print "<h1>aaa</h1>";
	print "$tbl1";
?>