<?
include "caching.php";
class Pages extends MNG{
	var $CacheSitemapsOn;
	function Pages($root=0){
		$this->inc();
		$this->CacheSitemapsOn = true;
	}
	
	function setDB($db){
		$this->DB = $db;
	}
	
	/*
	function checkAccess($id){
		if(($level = $this->CFG->UserData->Level) == 1)return true;
		else{
			return $this->CFG->DB->getField();
		}
	}
	*/
	
	function ShowHTML($id, $debug=""){

		if(!$id)return false;
		global $dbg;
		//if($dbg)print "dbg"; return false;
		//if(!$this->checkAccess($id))print "Access denied";
		// *** * caching html by object
		
		$p = $this->getParams($id);
		$cacheble = ($p['cache']=='yes') ? true : false; // total freezing of the page
		//$cacheble = false;

		if(($cfor = $p['cachefor']) && ($var = $p['cachevar'])){
			$cache = new HtmlCache($cfor, $var);
			if($html = $cache->go())
				return $html; 
			else{ 
				if($fpath)
				$printtofile = true;
			}
		}
		//dbg("$id, ");
		$pcache = new PageCache($id); // main caching
		if($cacheble && $chtml = $pcache->getcache() )return $chtml;
		// *** / caching html

		$xml = $this->CFG->xmlHeader.$this->getOnePage($id, $this->CFG->lang);
		//dbg($xml);
		$template = 
			($t = $this->DB->getField("Pages", "Template", $id)) 
				? $t.".xslt" 
				: $this->CFG->TEMPLATE
			;
		$res = $this->xmlOut->qShow($xml, $template, $debug);
		if($printtofile && $cacheble){
			$cache->writeCache($res);
		}
		if($cacheble)$pcache->saveit($res);
		return $res;
		//return $this->getOnePage($id, $this->CFG->lang, $template, $debug);
	}
	
	function getParamsStr($id){
		$db = $this->DB;
		$p = mysql_fetch_object($db->q("select Params from Pages where Id = $id"));
		return $p->Params;
	}
	
	function getParams($id){
		if(!$id)return false;
		$db = $this->DB;
		$p = mysql_fetch_object($db->q("select Params from Pages where Id = $id"));
		parse_str($p->Params, $par);
		return $par;
	}
	
	function getId($str, $host=0, $debug=false, $lev=0){
		if(!$str)return $host;
		$lev++;
		if($lev>=100){print "<b>Error cycling</b>"; return $str;}
		//$this->URI = $str; moved to index.html
		global $UriVars;
		$rsi = new rsi();
		$rsi->start();
		$db = $this->DB;
		$skIndex=1;
		$uri=split("/",$str);	// make array from uri string
		$rest_arr = $uri;
		//foreach($uri as $t){
			//dbg($t);	
			$srch = array("|'|", '|"|', '|\\\|', '|\+|');	// against SQL Injection
			if(!$rest_arr[0])array_shift($rest_arr);
			$t = preg_replace($srch, "", array_shift($rest_arr));
			// admin area protection
			if($t=="admin" && $this->CFG->UserData->Level!=1){
				$path = $path = "http://".$_SERVER['HTTP_HOST']."/login/auth";
				print 'You need to <a href="'.$path.'">login</a>';
				return 0;
			}
			
			$restway = join('/', $rest_arr);
			$flag=false;
			if($t!=""){
				$url[]=$t;
				$q="select * from Pages where Rozdil = '$host'";
				$res=$db->q($q);
				$mac=$db->q($q);
				while($r=mysql_fetch_array($res)){
					if($r['Name']==$t){
						$flag=true;				// switch on flag if document with this name is exists
						$host=$r['Id'];
						$alias = $r['AliasOf'];
						break;
					}
				}
				//print "[$q][$t][$host][$alias]<br/>";
				$level = $this->CFG->UserData->Level;
				if($r['AccessLevels'] && $level!=1 && $level>$r['AccessLevels']){
					print "Access Denied!";
					return false;
				}
				if($alias){
					return $this->getId($restway, $alias, false, $lev);
				}
				// Search on macros in name [...]
				if(!$flag){
					
					while($m=mysql_fetch_array($mac)){
						if(preg_match("|\[(.*)\:(.*)\]|", $m['Name'], $regs)){
							$type = $regs[1];
							$var = $regs[2];
							
							if($type == 'int' && is_numeric($t)){
								$flag=true;
								$host=$m['Id'];
								$this->uriVars[$var] = $UriVars[$var] = $t;
								$flag=true;
								break;
							}else
							if($type == 'char' && is_string($t)){
								$flag=true;
								$host=$m['Id'];
								$this->uriVars[$var] = $UriVars[$var] = $t;
								$flag=true;
								break;
							}else
							
							if($type == 'pass' && is_string($t)){
								print "[restway]";
								$flag=true;
								//return $this->getId($restway, $host, false, $lev);
							}
							
							
							if($type == 'unsigned'){
								$flag=true;
								$host=$m['Id'];
								$this->uriVars[$var] = $UriVars[$var] = $t;
								$flag=true;
								break;
							}
							//print "[$type]";
							if(preg_match("|^if\((.*)\)|", $type, $regs)){
								$cond = $regs[1];
								list($database, $table, $field) = split("\.", $cond);
								$dbx = $this->CFG->Databases[$database];
								$q="select $field from $table where $field = '$t'";
								if(mysql_fetch_array($dbx->q($q))){
									$flag = true;
									$host = $m['Id'];
									$this->uriVars[$var] = $UriVars[$var] = $t;
									//print "[yes][$q][".$m['AliasOf']."]";
									if($alias = $m['AliasOf']){
										//return $alias;
										
										return $this->getId($restway, $alias, false, $lev);
									}
									break;
								}
								
								//print "[$database], [$table], [$field]";
							}
							
						}
					}
				}
			}
			//if(!$flag)return $host;
		//}
		//$rsi->msg("parse uri");
		//dbg("return $restway, $host");
		//return $host;
		return $flag ? $this->getId($restway, $host) : $host;
	}
	
	function getURI($page_id, $lim=0){
		$db = $this->DB;
		$arr = $db->getLine("Name, Rozdil", "Pages", "Id = $page_id");
		if($page_id && $page_id!=$this->CFG->SiteHomePage){
			$uri = $this->getURI($arr['Rozdil'], $lim+1).'/'.$arr['Name'];
			return $uri;
		}else return NULL;
	}
	
	
	function getByQuery($query, $onepage=false, $xuri='', $open_level=0){
		$db = $this->DB;
		$lang = $this->CFG->lang;
		//print "<!-- [\n\n $query \n\n] -->";
		$pages=$db->q($query);
		//dbg($query);
		$count_matches = $db->AffectedRows();
		while($p=mysql_fetch_array($pages)){


			if($onepage){
				$blocks_xml = $this->scanBlocks($p['Id']);	// Search blocks only for current page
				/*
				$banners='
					<banners>
						<banner type="300x250" id="0"></banner>
						<banner type="300x70" w="300" h="70" id="1"></banner>
						<banner type="300x70" w="300" h="70" id="2"><url>/img/bn/300x70_xdr.php</url></banner>
						<banner type="300x70" w="300" h="70" id="3"><url>/img/bn/aratta/ar3.php</url></banner>
					</banners>
				';
				*/
			}
			else $blocks_xml = NULL;


			// *** How deep we need to get page content ***//
			if($open_level>0){
				$open_source=", PageData.Source as Source";
				$open_level--;
				$show_children = true;
			}
			// *** * ***/
			
			// Go inside
			$q = "
				select 
					Id,
					Params, 
					Rozdil, 
					Name,
					Params,
					AliasOf,
					PageData.Title as Title
					$open_source
				from 
					Pages 
					left join PageData on PageId = Pages.Id and Lang = '$lang'
			";
			
			// *** Here we are selecting route to next level *** //
			// * If we have AliasOf match in this page, then we 
			// * passing into that way.
			if($p['AliasOf']){
				$current_id = $p['AliasOf'];
				$p=mysql_fetch_array($db->q($q." where Id = ".$p['AliasOf']));
			}else{
				$current_id = $p['Id'];
			}
			$conditions_nextlevel = " where Rozdil = ".$current_id." group by Pages.Id";		// Little dirty nuke ;)
			
			// 
			$uri = $xuri.'/'.$p['Name'];
			if(!$onepage || !$this->CacheSitemapsOn || $show_children){
				//dbg($q.$conditions_nextlevel);
				$submap = $this->getByQuery($q.$conditions_nextlevel, false, $uri, $open_level);
			}
			// ---
			$inside = $db->AffectedRows();
			//$uri = $this->getURI($p['Id']);
			$params_xml = $p['Params'] ? $this->getXmlParams($p['Params']) : '';

			$xml.='
				<page id="'.$p['Id'].'" parent="'.$p['Rozdil'].'" range="'.$p['Range'].'">
					'.$this->presets.'
					<uri>'.$uri.'</uri>
					<paramstring><![CDATA['.$p['Params'].']]></paramstring>
					'.$params_xml.'
					<name>'.$p['Name'].'</name>
					<title><![CDATA['.$p['Title'].']]></title>
					<seo-title><![CDATA['.$p['SeoTitle'].']]></seo-title>
					<source><![CDATA['.autoLinks($p['Source']).']]></source>
					'.$blocks_xml.'
					<inside>
						'.$inside.'
					</inside>
					<pages>
						'.$submap.'
					</pages>
					'.$banners.'
					<inmap>'.$p['InMap'].'</inmap>
				</page>
			';
		}
		return $xml;
	}
	
	function getPage($node, $lang, $uri, $open_level=0){
		if(!$node)return false;
		$q="
			select 
				Id, 
				Rozdil, 
				Name,
				Template,
				PageData.Title,  
				PageData.Source,
				SeoTitle,
				Params,
				PageData.InMap
			from 
				Pages 
				left join PageData on PageId = Pages.Id and Lang = '$lang'
			where Id = $node
			group by Id
		";
		return $this->getByQuery($q, true, $uri, $open_level);		
	}
	
	function getOnePage($node, $lang='ua', $templ=NULL, $debug=NULL){
		global $sape;
		
		//if($lang=='en')$pref = ''; else $pref = '_'.$lang;

		$current_page = $this->getPage($node, $lang, $this->getURI($node));
		$cities = new Cities();
		$sape_links = iconv("windows-1251", "UTF-8", "<sape>$sape1</sape>");
		$xml = '
			<out lang="'.$this->CFG->lang.'" domain="'.$this->CFG->MainDomain.'">
				<session id="'.session_id().'">'.session_name().'</session>
				'.$this->CFG->UserData->XML.'
				<home>http://'.$this->CFG->MainDomain.'</home>
				<fulldom>'.$this->CFG->Domain.'</fulldom>
				<subdom>'.$this->CFG->SubDomain.'</subdom>
				
				'.$this->addXml.'
				
				'.$this->addPresets().'
				<sitemap>
					'.$this->siteMap($this->CFG->SiteHomePage, $lang).'
				</sitemap>
				<current>
					'.$current_page.'
				</current>

				'.$cities->lcSettlementListByDomain(array('domain' => $this->CFG->Domain)).'

				'.$this->CFG->SysMsg->XML().'
				'.$sape_links.'
			</out>
		';
		//$this->rsi->msg($xml, "textarea");
		//return print "<p>[$templ]</p><textarea style='width:600px; height:400px'>$xml</textarea>";
		
		
		return (
			$templ 
				? $this->xmlOut->qShow($xml, $templ, $debug) 
				: $xml
			);
	}
	
	function delCache($node){
		$dir = "sitemaps/";
		$lang = $this->CFG->lang;
		$db = $this->DB->dbName;
		foreach(glob($this->CFG->CacheDir.$dir."sitemap_".$db."_*_*.xml") as $fpath){
			$info = pathinfo($fpath);
			preg_match("/sitemap_(.*)_(.*)_(.*).xml/", $info['basename'], $regs);
			if(($regs[2]==$node) || $this->isParent($regs[2], $node)){
				unlink($fpath);
				//print "<h3>del [".$regs[2]."]</h3>";
			}
			//else print "<h3> not [".$regs[2].", $node]</h3>";
		}
		/*
		$fname = "$node_".$this->.".xml";
		$this->delCache("sitemaps", $fname);
		*/
	}
	
	function reCache($node){
		$dir = "sitemaps";
		$fname = "sitemap_".$db."_".$node."_".$lang.".xml";
		$xml = $this->cache__siteMap($node, $lang, $wide_info);
		$this->delCache($node);
		$this->newCache($dir, $fname, $xml);
	}
	
	function siteMap($node, $lang='ua', $wide_info=false){
		//return $this->cache__siteMap($node, $lang, $wide_info);
		$dir = "sitemaps";
		$lang = $this->CFG->lang;
		$db = $this->DB->dbName;
		$fname = "sitemap_".$db."_".$node."_".$lang.".xml";
		if(!($xml = $this->getCache($dir, $fname))){
			$xml = $this->cache__siteMap($node, $lang, $wide_info);
			$this->newCache($dir, $fname, $xml);
		}
		//print "<textarea>$xml</textarea>";
		return $xml;
	}
	
	function cache__siteMap($node, $lang='ua', $wide_info=false){
		if(!$node)return '';
		//print "[$node, $lang='ua', $wide_info]";
		$db = $this->DB;
		$pref = ($lang == 'en' ? '' : '_'.$lang);
		//$ap = $this->getAccessPoints('sitemap');
		
		if($node == 'all'){
			foreach($ap as $area => $param){
				$res.=$this->siteMap($param, $lang, $templ);
			}
			return $res;
		}
		
		if($node=='root'){
			print "root";
			$xml.='
				<page id="0">
					<name>root</name>
				</page>
			';
		}else{
			if($wide_info)$source = ", PageData.Source as Source";
			$q = "
				select 
					Id, 
					Rozdil, 
					Name,
					AliasOf,
					Params,
					PageData.Title as Title
					".$source."
				from 
					Pages 
					left join PageData on PageId = Pages.Id and Lang = '$lang'
				where Rozdil = $node
				group by Pages.Id
			";
			$xml.=$this->getByQuery($q);
		}
		if(!$node)$ParentName='root';
		else{
			$parent=mysql_fetch_array($db->q("select * from Pages where Id = $node"));
			$ParentName=$parent['Name'];
		}
		
		
		
		$db->q("select Id from Pages where Rozdil = ".$node);
		$inside = $db->AffectedRows();
		$xml = '
			<pages>
				'.$this->presets.'
				'.$this->addXml.'
				<page type="parent" id="'.$node.'">
					<name>'.$ParentName.'</name>
					<inside>'.$inside.'</inside>
				</page>
				'.$xml.'
			</pages>
		';
		return $xml;
	}
	
	function scanBlocks($PageId){
		$db = $this->DB;
		$q="select DocId, Name, Place, Prioritet, Parameters from Blocks where DocId = $PageId";
		$blocks=$db->q($q);
		$module = new Modules();
		while($b=mysql_fetch_array($blocks)){
			//print "<p>[".$b['Name']."]</p>";
			
			if(preg_match("|^out.|", $b['Name'])){
				$b['Name'] = preg_replace("|^out.|", "", $b['Name']);
				//print "[$name]";
			}
			
			$name = preg_match("|(.*)\((.*)\)|", $b['Name'], $regs)
				? $regs[1]
				: $b['Name']
			;
			
			if($block_content = $module->Exec($b['Name'], $b['Parameters'])){
				$xml.='
					<block id="'.$b['Id'].'" page="'.$b['DocId'].'" lang="'.$this->CFG->lang.'">
						<name><![CDATA['.$name.']]></name>
						<place><![CDATA['.$b['Place'].']]></place>
						<range><![CDATA['.$b['Prioritet'].']]></range>
						<params><![CDATA['.$b['Parameters'].']]></params>
						<content>
							'.$block_content.'
						</content>
					</block>
				';
			}
		}
		//print "<!-- $xml -->";
		return "
			<blocks>
				".$this->presets."
				$xml
			</blocks>
		";
	}
	
	function isParent($parent, $child){
		if($node = $this->DB->getField("Pages", "Rozdil", $child)){
			if($node == $parent)return true;
			else $this->isParent($parent, $node);
		}
		else return false;
	}

	function addPage($name, $rozdil){
		$this->DB->q("insert into Pages (Name, Rozdil) values ('$name', $rozdil)", false);
		return $this->DB->insId();
	}
	
	function setPageParam($field, $value, $id){
		$db = $this->DB;
		$db->q("update Pages set $field = '$value' where Id = $id");
	}

	function delNode($id){
		if(!$id)return false;
		$db = $this->DB;
		$pages=$db->q("select Id from Pages where Rozdil = $id");
		while($p=mysql_fetch_array($pages)){
			$this->delNode($p['Id']);
		}
		$db->q("delete from Pages where Id = $id");
		$db->q("delete from PageData where PageId = $id");
		$db->q("delete from Blocks where DocId = $id");
		//print "<p>$q</p>";
	}	
	
	function addData($id, $title, $source, $lang){
		$lang=='en' ? $pref = '' : $pref = '_'.$lang;
		$today = $this->nowDate();
		
		$arr = array(
			'PageId'	=> $id,
			'Title' 	=> $title,
			'Source' 	=> $source,
			'lang'		=> $lang,
			'InMap'		=> 1
		);
		$dta = $this->DB->InsRepVals($arr);
		$this->DB->q("insert into PageData  (".$dta['InsKeys'].") values (".$dta['InsVals'].")");
	}

}


class EditPages extends MNG{
	
	function EditPages($dbname){
		$this->inc();
		$this->dbname = $dbname;
		$this->db = $this->CFG->Databases[$dbname];
	}
	
	function pushData($owner_tbl, $owner_id, $pv){
		if(!$owner_tbl || !$owner_id){print "Incorrect owner data [$owner_tbl, $owner_id]"; return false;}
		if($name = $pv['Ident']){
			if(!$this->CFG->valid->ident($name)){
				print "Invalid Ident format";
				return false;
			}
		}else{
			print "Settlement/Region must have Ident name";
			return false; 
		}
		switch($owner_tbl){
			case 'Regions': $rozdil = 3; break;
			case 'Settlements': $rozdil = 1; break;
			default: print "Unknown table [$owner_tbl]"; return false;
		}
		if($pageid = $this->db->getField($owner_tbl, 'PageId', $owner_id)){
			print "Page alredy exists";
			return false;
		}
		else {
			$pageid = $this->newPage($name, $rozdil);
			$this->setPage($owner_tbl, $owner_id, $pageid);
			$this->Edit($pv, $pageid);
			//print "Created page id:$pageid, node:$rozdil <br/>";
			return $pageid;
		}
	}
	
	function Edit($pv, $pageid){
		if(!$pageid){print "Can't edit page, id us null!<br/>"; return false;}
		$db 		= $this->db;
		$content 	= $this->parseData($pv);
		$today = date("Y-m-d h:m:s");
		foreach($content as $lang=>$data){
			if($db->getFieldWhere('PageData', 'PageId', " where PageId = $pageid and Lang = '$lang'"))
				$q = "update PageData set Title = '".$data['Title']."', Source = '".$data['Source']."', LastMod = '$today' where PageId = $pageid and Lang = '$lang' ";
			else
				$q = "insert into PageData set Title = '".$data['Title']."', Source = '".$data['Source']."', PageId = $pageid, Lang = '$lang', LastMod = '$today' ";
			$db->q($q);
		}
	}
	
	function parseData($pv){
		// ** Fill page content array from POST
		$content = array();
		foreach($pv as $key=>$value){
			if(preg_match("/content_(.*)_(.*)/", $key, $arr)){
				$field	= $arr[1];
				$lang 	= $arr[2];
				if(is_array($content[$lang])){
					$content[$lang][$field] = $value;
				}
				else $content[$lang] = array($field => $value);
			}
		}
		
		return $content;
	}	
	
	function newPage($name, $rozdil){
		if($o = mysql_fetch_object($this->db->q("select Id from Pages where Rozdil = $rozdil and Name = '$name'")))
			return $o->Id;
		else{
			//print "<h3>New Object Page [".$p['Id']."]</h3>";
			$q="insert into Pages (Name, Rozdil) values ('$name', $rozdil) ";
			//print "<p>$q</p>";
			$this->db->q($q);
			return $this->db->InsId();
		}
		return NULL;
	}
	
	function setPage($table, $id, $page){
		$this->db->q("update $table set PageId = $page where Id = $id");
	}
	
}

?>