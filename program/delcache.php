<?
	include_once("../config.php");
	
	
class delCache extends MNG{
	var $cfg;
	var $db;
	var $tbl;
	var $today;
	function delCache(){
		global $caCFG;
		$this->inc();
		
		$this->cfg 	= $this->CFG;
		$this->db 	= $this->CFG->DB;
		$this->hdb 	= $this->CFG->HDB;
		$this->get 	= $this->CFG->GetVars;
		$this->pv	= $this->CFG->PostVars;
		$this->tbl	= $this->get['tbl'];
		$this->id	= $this->get['id'];	
	}
	
	
	function Go(){
		$gallery = new gallery();
		switch($this->tbl){
			case "sitemap": 
				$pg = new Pages();
				$pg->reCache($this->id);
			break;
			case "objects": 
				//print "[objs]";
				$obj = new Objects();
				$obj->delCache($this->id);
			break;
			default;
		}
	}
	
}

$edit = new delCache();
$edit->Go();


?>