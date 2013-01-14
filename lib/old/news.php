<?

function tnews(){
	global $sub;
	$news = new News;
	$uri=split("/",$sub);
	if(isset($uri[1])){
		if(is_numeric($uri[1])){
			return $news->showByCategory($uri[1]);
		}else if($uri[1]=="show"){
			return $news->Open();
		}
	}
}

function tnewsarchive($cat=1){
	global $sub;
	$WNews = new News;
	$WNews->Category = $cat;
	$WNews->TempFile = "news_block1.xslt";
	return $WNews->Show();
}

class News extends Modules{
	var $Doc;
	function News(){
		$this->inc();
	}
	
	function Exec($name, $params=NULL){
		switch($name){
			case "showcat": 
				if($params)$catid = $params;
				else if(!($catid = $this->uriVars['newscat'])){
					return false;
				}
				return $this->showByCategory($catid); 
			break;
			case "show": return $this->Open($this->uriVars['docid']); break;
		}
	}
	

	function getListQuery($q, $wide_info=false){
		$db = $this->CFG->DB;
		$qr = $db->q($q);
		while($doc = mysql_fetch_object($qr)){
			if($wide_info)$source = '<content>'.$this->Doc->Source.'</content>';
			$xml = '
				<item>
				  <title><![CDATA['.$this->Doc->Name.']]></title>
				  <link>http://skiworld.org.ua/news/show/'.$this->Doc->PaperId.'</link>
				  <description><![CDATA['.$this->Doc->Descr.']]></description>
				  '.$source.'
				  <pubDate>'.$this->Doc->tDate.'</pubDate>
				  <guid>'.$this->Doc->Link.'</guid>
				</item>
			';
		}
		return $xml;
	}

	function Open($id){
		if(is_numeric($id))$where = " where News.Id = $id "
		else if(is_string($id))$where = " where News.PaperId = $id "
		else if(!$id)return false;
		
		$q = "
			select Name, PaperId, Descr, Link from News 
			left join NewsLinks on DocId = News.Id
			$where
		";
		$this->getListWhere($q, false)
	}
	
	function showByCategory($catid){
		$q = "
			select Name, PaperId, Descr, Link from News 
			left join NewsLinks on DocId = News.Id and CaseId = $catid
			group by DocId
		";
		$this->getListWhere($q, false)
	}
	
}

?>