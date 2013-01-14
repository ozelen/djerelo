<?
class Papers extends Modules{
	var $Doc;
	function Papers(){
		$this->inc();
	}
	
	function Exec($name, $params=NULL){
		parse_str($params, $p_arr);
		//print "execute [$name]";
		switch($name){
			case "showcat": 
				$catid = $this->uriVars['catid'];
				if(!$catid) return false;
				$xml = $this->showByCategory($catid);
				//print "<textarea>$xml</textarea>";
				return  $xml;
			break;
			
			case "sectionlist":
				$xml = $this->tList($params);
				//print "<textarea>$xml</textarea>";
				return  $xml;
			break;
			
			case "open": 
				$xml =$this->Open($this->uriVars['docid']);
				//print "<textarea>$xml</textarea>";
				return $xml; 
			break;
			
			case "showlast":
				return $this->showLastArticles($params);
			break;
		}
	}
	

	function getListQuery($q, $wide_info=false){
		$db = $this->CFG->DB;
		$qr = $db->q($q);
		while($doc = mysql_fetch_object($qr)){
			if($wide_info)
				$source = '<content><![CDATA['.$doc->Source.']]></content>';
			 
			//list($y,$m,$d) = explode('-', $doc->tDate,4);
			list($date, $time) = explode(" ",$doc->Published);
			list($y,$m,$d) = explode("-", $date);
			//list($h, $m) = explode()
			$pretty = "$d.$m.$y";
			
			$xml.= '
				<item id="'.$doc->Id.'" paper="'.$doc->PaperId.'">
				  <title><![CDATA['.$doc->Name.']]></title>
				  <link>http://skiworld.org.ua/ua/papers/show/'.$doc->Id.'</link>
				  <description><![CDATA['.$doc->Descr.']]></description>
				  '.$source.'
				  <pubDate pretty="'.$pretty.'">'.$doc->Published.'</pubDate>
				  <author><![CDATA['.$doc->Author.']]></author>
				  <guid>'.$doc->Link.'</guid>
				</item>
			';
		}
		return $xml;
	}

	function Open($id){
		if(is_numeric($id))$where = " where Papers.Id = $id ";
		else if(is_string($id))$where = " where Papers.PaperId = '$id' ";
		else if(!$id)return false;

		$catid = $this->CFG->DB->getField("Papers", "tCase", $id);
		$catname = $this->CFG->DB->getField("BookCases", "Name".$this->pref, $catid);
		
		$q = "
			select Papers.Id, Name, PaperId, Source, Author, Link, Descr, Link, Published
			from Papers 
			$where
			group by Papers.Id
		";
		return '
			<items type="papers" category="'.$catid.'">
				<section id="'.$catid.'"><![CDATA['.$catname.']]></section>
				'.$this->getListQuery($q, true).'
			</items>
		';
	}
	
	function showByCategory($catid){
		
		if($limit)$limit_cond = " limit $limit ";
		$q = "
			select Papers.Id, Name, PaperId, Author, Link, Descr, Link, Published
			from Papers 
			where tCase = $catid
			order by Published desc
			$limit_cond
		";
		$catname = $this->CFG->DB->getField("BookCases", "Name".$this->pref, $catid);

		return '
			<items type="papers" category="'.$catid.'">
				<section id="'.$catid.'"><![CDATA['.$catname.']]></section>
				'.$this->getListQuery($q, false).'
			</items>';
	}
	

	function tList($rootnode=0){
		$db = $this->CFG->DB;
		$pref = $this->pref;

		$sections = $db->q("select Id, Name$pref as Name from BookCases where HostId = '$rootnode' order by Id");
		while($s=mysql_fetch_array($sections)){
			$art = $db->q("select Id, Name from Papers where tCase = '".$s['Id']."' order by Id desc");
			$articles='';
			while($a=mysql_fetch_array($art)){
				$articles.='
					<article id="'.$a['Id'].'">
						<name><![CDATA['.$a['Name'].']]></name>
					</article>
				';
			}
			$xml.='
			<section id="'.$s['Id'].'">
				<name>
					'.$s['Name'].'
				</name>
				'.$articles.'
			</section>';
		}
		$xml="<sections>$xml</sections>";
		return $xml;
	}

	function showLastArticles($limit, $categoryIndex=NULL){
		if($categoryIndex){
			$where =  " where tCase = '".$categoryIndex."' ";
		}
		$q="select Papers.Id, Name, PaperId, Author, Link, Descr, Link, Published from Papers ".$where." order by Id desc limit ".$limit;
		return '<items type="papers" category="'.$catid.'">'.$this->getListQuery($q).'></items>';
	}


}




?>