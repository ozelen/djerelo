<?


abstract class TCache extends MNG{
	var $dir;
	var $fname;
	var $ttl;
	var $ForAllUsers = false;
	public function __construct($params){
		$this->inc();
		$this->dir = $this->CFG->CacheDir.$params['dir'];
		$this->fname = $params['fname'];
		$this->fpath = $this->dir.$params['fname'];
		$this->ForAllUsers = $params['ForAllUsers'];
		$this->ttl = $params['ttl'] ? $params['ttl'] : 86400;

		//print "<h1>Define: [".$this->CFG->CacheDir."] $this->fpath</h1>";
	}

	function getcache(){
		$now = date(strtotime('now'));
		if($this->CFG->UserData->Id && !$this->ForAllUsers)return NULL;
		//print "<h1>read [".$this->CFG->UserData->Id." & $this->ForAllUsers]</h1>";
		if(file_exists($this->fpath)){
			$dbg.="File exists!\n";
			$stat = stat($this->fpath);
			//dbg("$now < $deadline | $this->ttl");
			if($stat[9] > $now-$this->ttl){
				//dbg("Read from file [$this->fpath], updated ".date("d.m.Y G:i:s", $stat[9]));
				return file_get_contents($this->fpath);
			}
		}
		else {
			//dbg("Not found [$this->fpath]");
			return NULL;
		}
		//dbg($dbg);
	}

	function saveit($txt){
		if($this->CFG->UserData->Id && !$this->ForAllUsers)return NULL;
		$gal = new gallery();
		$gal->newDir($this->CFG->CacheDir, $this->dir);
		$fp = fopen($this->fpath, "w");
		fwrite($fp, $txt);
		//dbg("Write to file [$this->fpath] \n");
		return file_get_contents($this->fpath);
	}
}

class Cache extends TCache{
	function get(){
		return $this->getcache();
	}
	function put($content){
		return $this->saveit($content);
	}
}

class PageCache extends TCache{
	var $ttl;	// time to live of cache file
	function PageCache($id, $ttl=7200){// standard 3 hours to rewrite
		$this->inc();
		$domain = $this->CFG->MainDomain;
		$subdom = $this->CFG->Domain;
		
		$dir = ($domain == $subdom) 
			? $domain.'/'.$this->CFG->lang.'/'
			: $domain.'/sub/'.$subdom.'/'.$this->CFG->lang.'/'
		;
		
		$this->ttl = $ttl;
		$this->dir = 'hardver5/'.$dir.$this->CFG->URI;
		$this->fpath = $this->CFG->CacheDir.$this->dir."/index.html";
		
		
	}
}

class HtmlCache extends MNG{ 
	var $fpath;
	var $cfor;
	var $var;
	public function HtmlCache($cfor, $var){
		$this->inc();
		$this->cfor = $cfor;
		$this->var = $var;
	}
	
	public function go(){
		switch($this->cfor){
			case 'objects': 
				return $this->cacheObject();
			break;
			case 'pages':
				return $this->cachePage();
			break;
		}
	}
	
	private function cachePage($pageid)
	{
		$updated = $this->CFG->DB->getField("Pages", "Updated", $objid);
		$this->CFG->DB->q("update ");
	}
	
	private function cacheObject($objid=NULL){
		global $UriVars;
		$obj = new Objects();
		$objid = $objid ? $objid : $UriVars[$this->var];
		if(!is_numeric($objid))$objid = $this->CFG->HDB->getFieldWhere("Objects", "Id", "where AccountCode = '$objid'");
		//dbg($objid);
		$role = $obj->getObjRole($objid);
		if($role=='guest' && $obj->leftTime($objid)>=0){
			$this->dir = $this->CFG->CacheDir.$this->cfor."/".$objid."/";
			$is_dir = is_dir($dir) ? 'ok': 'error';
			$this->fpath = $this->dir.$this->CFG->MainDomain."-".$this->CFG->lang."-full.html";
			$updated = $this->CFG->HDB->getField("Objects", "Updated", $objid);
			// print "[$updated, $objid]";
			if ($html = $this->readCache($this->dir, $this->fpath, $updated)) {
				return $html;
			}else {
				return false;
			}
			//print "<p style='color:yellow'>Caching: [$cfor:$objid] Path:[$this->fpath] Directory: [$is_dir]</p>";
		}
		
	}
	public function readCache($dir, $fpath, $updated)
	{
		if(is_dir($dir)){
			if(file_exists($fpath)){
				$stat = stat($fpath);
				if($updated<$stat[9]) {
					//print "read from file";
					return file_get_contents($fpath);
				}
				return NULL;
			}
		}else{
			$gal = new gallery();
			$gal->newDir($this->CFG->CacheDir, $this->cfor."/".$objid);
			return NULL;
		}
	}
	function writeCache($res){
		dbg($this->fpath);
		$fp = fopen($this->fpath, "w");
		fwrite($fp, $res);
	}
}
?>