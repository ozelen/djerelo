
<?php
	include_once("../config.php");
	
	print "conf";
	session_start();
	if($_SESSION['email']){
		$caCFG->UserData->getData($_SESSION['email'], $_SESSION['pass']);
	}
	
	//foreach($_POST as $k=>$v){print "<p>$k = $v</p>";}
	//print "[".$_GET['mode']."]";

class actCA extends MNG{
	var $mode;
	function actCA(){
		global $caCFG;
		$this->inc();
		$this->pages = new Pages();
		$this->forum = new Forum();
		
		$this->cfg 	= $this->CFG;
		$this->db 	= $this->CFG->DB;
		$this->hdb 	= $this->CFG->HDB;
		$this->get 	= $this->CFG->GetVars;
		$this->pv	= $this->CFG->PostVars;
		
		$this->mode	= $this->get['mode'];
		$this->DOC	= new Documents();
		
		if($this->get['temp']){
			$this->template	= $this->get['temp'];
		}
		
	}
	
	function Go(){
		switch($this->mode){
			case "docslist": 
				if($compid = $this->CFG->HDB->getField("Objects", "CompId", $this->get['objid'])){
					print "[$compid]";
					//$this->DOC->showByOwner($compid, $this->template);
				}else print "There is no linked company. Find it in CallAct base or create new.";
			break;
			case "postdata": break;
			default : break;
		}
		print "[mode: $this->mode]";
	} 
}
$ca = new actCA();
$ca->Go();

?>