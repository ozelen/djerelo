
<?php
	include_once("../config.php");
	
	//print '['.$caCFG->lang.']';
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
		$this->CMP	= new Companies();
		$this->docs = new Docs();
		
		$this->temp = $this->pv['temp'];
	}
	
	function Go(){
		
		switch($this->mode){
			case "doclist": 
				print $this->xmlOut->qShow($this->docs->AgrList($this->pv), $this->temp);
			break;
			case "postdata": break;
			
			case "agrbyobj":
				print $this->xmlOut->qShow($this->docs->AgrList(array('objid' => $this->get['objid'])), $this->temp);
			break;
			
			default : break;
		}
		
	} 
}
$ca = new actCA();
$ca->Go();

?>