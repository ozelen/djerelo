<?

require_once('../config.php');

class Search{
	function __construct(){
		global $caCFG;
		$this->cfg = $caCFG;
		$this->pv = $this->cfg->PostVars;
		$this->gv = $this->cfg->GetVars;
		$this->mode = $this->gv['mode'];
		$this->keyword = $this->pv['str'] ? $this->pv['str'] : $this->gv['str'];
		if(!$this->keyword){print "Not found";}
	}

	function get(){
		switch($this->mode){
			case 'objects':     return $this->objects(); break;
			case 'settlements': return $this->settlements(); break;
			case 'all': break;
		}
	}

	function objects(){
		$objects = new Objects();
		$list = $objects->miniInfo(array('searchin'=>'objname', 'keyword'=>$this->keyword), 'array');
		//print_r($list);
		//$list = iconv_deep('windows-1251', 'utf-8', $list);
		$json = json_encode($list);
		return "$json";
	}

	function settlements(){

	}
}


header ("Content-type: text/plain; charset=utf-8");
$search = new Search();
print $search->get();

?>