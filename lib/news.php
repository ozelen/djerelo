<?
class News extends Modules{
	var $Doc;
	function News(){
		$this->inc();
	}
	
	function Exec($name, $params=NULL){
		parse_str($params, $p_arr);
		switch($name){
			case "showcat": 
				$catid = $this->uriVars['news_catid'] ? $this->uriVars['news_catid'] : NULL;
				$catid = $p_arr['news_catid'] ? $p_arr['news_catid'] : NULL;
				//foreach($p_arr as $k=>$v)print "<p>$k=>$v</p>";
				if(!$catid)return false;

				$limit = $p_arr['news_limit'];
				$xml = $this->showByCategory($catid, $limit, $this->uriVars['skip']);
				return  $xml;
			break;
			case "open": 
				$xml =$this->Open($this->uriVars['docid']);
				//print "<textarea>$xml</textarea>";
				return $xml; 
			break;
		}
	}
	

	function getListQuery($q, $wide_info=false){
		$db = $this->CFG->DB;
		$qr = $db->q($q);
		while($doc = mysql_fetch_object($qr)){
			//if($wide_info)
			$source = '<content><![CDATA['.autoLinks($doc->Source).']]></content>';
			 
			//list($y,$m,$d) = explode('-', $doc->tDate,4);
			list($date, $time) = explode(" ",$doc->tDate);
			list($y,$m,$d) = explode("-", $date);
			//list($h, $m) = explode()
			$pretty = "$d.$m.$y";
			
			$xml.= '
				<item id="'.$doc->Id.'" paper="'.$doc->PaperId.'">
				  <title><![CDATA['.$doc->Name.']]></title>
				  <link>http://skiworld.org.ua/ua/news/show/'.$doc->PaperId.'</link>
				  <description><![CDATA['.autoLinks($doc->Descr).']]></description>
				  '.$source.'
				  <pubDate pretty="'.$pretty.'">'.$doc->tDate.'</pubDate>
				  <from>'.$doc->tFrom.'</from>
				  <author>'.$doc->tFrom.'</author>
				  <guid>'.$doc->Link.'</guid>
				</item>
			';
		}
		return $xml;
	}

	function Open($id){
		if(is_numeric($id))$where = " where News.Id = $id ";
		else if(is_string($id))$where = " where News.PaperId = '$id' ";
		else if(!$id)return false;
		
		$q = "
			select News.Id, tDate, tFrom, Name, PaperId, Source, Descr, Link from News 
			left join NewsLinks on DocId = News.Id
			$where
			group by News.Id
		";
		return '
			<items type="news" category="'.$catid.'">
				'.$this->getListQuery($q, true).'
			</items>
		';
	}
	
	function showByCategory($catid, $limit=NULL, $skip = NULL){
		//print "<h1>[showcat]</h1>";
		if(!$skip)$skip = '0';
		if(!$limit)$limit = $skip.', 20';
		if($limit)$limit_cond = " limit $limit ";
		$q = "
			select Name, tDate, tFrom, PaperId, Descr, Link, Source from News 
			left join NewsLinks on  News.Id = DocId and CaseId = $catid
			group by DocId
			order by tDate desc
			$limit_cond
		";
		//print "$q";
		return '<items type="news" category="'.$catid.'" skip="'.$skip.'">'.$this->getListQuery($q, false).'</items>';
	}
	
}

/*
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
*/


?>