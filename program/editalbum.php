<?



	include_once("../config.php");
	
	//session_name('djerelo_info');
	setcookie('PHPSESSID', $_POST['PHPSESSID']);
	session_start();
	
	print "[email:".$_SESSION['email']."]";
	
	print "[".$_COOKIE['PHPSESSID']."=".$_POST['PHPSESSID']."]";
	if($_SESSION['email']){
		$caCFG->UserData->getData($_SESSION['email'], $_SESSION['pass']);
		//print "[LEVEL: ".$caCFG->UserData->Level."]";
	}else print "\nNO SESSION\n";
	
	
	
	
class editAlbum extends MNG{
	var $cfg;
	var $db;
	var $owner_db;
	var $owner_tbl;
	var $owner_id;
	var $today;
	function editAlbum(){
		global $caCFG;
		$this->inc();
		
		$this->cfg 	= $this->CFG;
		$this->db 	= $this->CFG->DB;
		$this->hdb 	= $this->CFG->HDB;
		$this->get 	= $this->CFG->GetVars;
		$this->pv	= $this->CFG->PostVars;
		
		
		// ***	Incoming parameters
		// **	Owner parametes 
		$this->owner_db 	= $this->pv['db'];
		$this->owner_tbl 	= $this->pv['tbl'];
		$this->owner_id 	= $this->pv['id'];
		$this->UID			= $this->pv['uid'];
		$this->multiform	= $this->get['multiform'];
		$this->mode			= $this->get['mode'];
		$this->field		= $this->get['field'];

		// ** Parameters of requesting album
		$this->album_id	= $this->pv['AlbumId'];	// : Request page ID
		$this->template	= $this->pv['temp'];	// : 
		if($this->get['temp']){
			$this->template	= $this->get['temp'];
		}
		//$this->content	= array();				// : Array of multilanguage Page Content
		
		$this->today = date("Y-m-d H:i");

		
	}
	
	
	function Go(){
		print "go! [$this->mode]";
		$fp = fopen ("tst/file.txt", "a");
		$gallery = new gallery();
		//$access =  ? "allowed" : "denied";

		if(!$this->checkAccess())return false;
		switch($this->mode){
			case 'upload':
				print "uuu";
				if($_FILES['Filedata']['tmp_name']){
					
					fwrite($fp, "upload ".$_FILES['Filedata']['tmp_name']." Access [$access] Session ID: [".session_id()."] Album: [".$_POST['album']."] Owner: [".$_POST['owner'].":".$_POST['id']."] \n");
					//print "write file!";
					$gallery->upload($this->get, $this->pv, $_FILES);
				}
				else print "Have no file <br/> Access [$access]";
			break;
			case 'sort':
				$this->sortAlbum();
			break;
			
			case 'delalbum':
				$gallery->delAlbum($this->album_id);
			break;
			
			case 'delimg':
				if(preg_match("/img_(.*)/", $this->get['img'], $regs)){
					$id = $regs[1];
					$gallery->delImage($id);
				}
			break;
			
			case 'settitle':
				if(preg_match("/img_(.*)/", $this->get['img'], $regs)){
					$img = $regs[1];
					$gallery->setTitleImage($this->get['album'], $img);
				}
			break;
			
			case 'newalbum':
				
				$id = $gallery->addAlbum($this->pv['name'], $this->owner_tbl, $this->owner_id);
				
				//print "<textarea cols=40 rows=10>".$this->CFG->xmlHeader.$gallery->Show(5883)."</textarea>";
				
				if($id && $this->template)
				print $this->xmlOut->qShow($this->CFG->xmlHeader.$gallery->Show($id), $this->template);
				
				
			break;
			
		}
	}
	
	//function 
	
	function sortAlbum(){
		$db = $this->CFG->HDB;
		foreach($this->pv as $k=>$v){
			if(preg_match("/img_(.*)/", $k, $regs)){
				$key = $regs[1];
				$q="update Images set Range = $v where Id = '$key'";
				$db->q($q);
				print "\n $q \n";
			}
		}
	}
	
	function checkAccess(){
		$db = $this->CFG->DB;
		$this->cfg->UserData->getData();
		// ****************************************************************************//
		// *** Now we checking access for user
		// 1 step : We check on super-user
		//print " level: [".$this->cfg->UserData->Level."] userid: [".$this->cfg->UserData->Level."]";
		if($this->cfg->UserData->Level == 1) return true;
		
		else {
			//print "\n\n\n*** ".$this->cfg->UserData->getXML()."\n\n access level: [".$this->cfg->UserData->Level." ***\n\n\n"; 
			return false; // temporary
		}

		// 2 step : Checking on access to this objects
		$q = "
			select PageId from $this->owner_db.$this->owner_tbl 
			join $this->owner_db.AccessPoints 
				on AccessArea = '$this->owner_tbl' 
				and Params = $this->owner_id
				and UserId = ".$this->CFG->UserData->Id."
			where Objects.Id = $this->owner_id
		";
		if($obj = $db->inObj($db->q($q))){
			$owner_pageid = $obj->PageId;
		}
		else return false;
		
		// 3 step : Check on linkage Requesting Album with Access Page
		$albums = $db->q("select * from hotelbase.Modules where OwnerTable='$this->owner_tbl' and OwnerId = $this->owner_id and ModuleHandler='album'");
		
		if($this->pages->isParent($owner_pageid, $this->page_id)){
			return true;
		}else return false;
	}
	
	
}

//foreach($_POST as $x=>$y){print "$x = $y\n";}
$edit = new editAlbum();
$edit->Go();


?>