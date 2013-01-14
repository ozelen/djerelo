<?

include("lib/mysql.php");
include("lib/mng.php");
include("lib/pages.php");
include("lib/xml.php");
include("lib/modules.php");
include("lib/rsi.php");
include("lib/hotcat.php");
include("lib/forum.php");
include("lib/news.php");
include("lib/papers.php");
include("lib/users.php");
include("lib/sendmail.php");
include("lib/documents.php");
include("lib/booking.php");
include("lib/callact/callact.php");
include("lib/callact/documents.php");
include("lib/callact/companies.php");
include("lib/callact/contacts.php");

class Settings{
	var $BeginUrl;
	var $RootDir;
	var $TempDir;
	var $ImgDir;
	var $Admin;
	var $DB;
	var $host;
	var $DB_log;
	var $DB_pas;
	var $DB_name;
	var $UserData;
	var $xmlHeader;
	var $SiteHomePage;
	var $rsi;
	var $Domain;
	var $MainDomain;
	var $SubDomain;
	var $Databases;
	var $TEMPLATE;
	var $PostVars;
	var $GetVars;
	var $SysMsg;
	var $User;
	var $CacheDir;
	var $Mail;
	public static $ModuleClassArray;
	function Settings(){
		$this->PAPA = "djerelo.info";
		global $RSI;
		$this->rsi = new rsi();
		
		// database settings
		$this->DB_host = "localhost";
		$this->DB_log = "djerelo";
		$this->DB_pas = "LPKT4Xlw";
		$this->DB_name = "skiworld";
		
		// database connections
		
		$this->DB  = new Database("skiworld",  $this->DB_log, $this->DB_pas, $this->DB_host);
		$this->HDB = new Database("hotelbase", $this->DB_log, $this->DB_pas, $this->DB_host);
		//$this->CDB = new Database("callact",   $this->DB_log, $this->DB_pas, $this->DB_host);
		
		$this->Databases = array(
			'skiworld' 	=> &$this->DB,
			'hotelbase'	=> &$this->HDB,
			'callact'	=> &$this->CDB
		);
		
		$this->BeginUrl="/";
		
		// detecting what domain was user requested, ignoring "www" set
		$this->Domain = preg_replace("|^www.|", "", $_SERVER['HTTP_HOST']);
		if($this->Domain == "ski.djerelo.info" || $this->Domain == "djerelo.info")$this->Domain = "skiworld.org.ua";
		
		//$this->Domain = $_SERVER['HTTP_HOST'];
		$this->RootDir=$_SERVER['DOCUMENT_ROOT'];
		$this->TempDir = $this->RootDir."/sources/temp/";

		//$this->CacheDir = $this->RootDir."/sources/cache/";
		$this->CacheDir = "/var/www/djerelo/data/cache/";

		$this->guiImgDir = $this->RootDir."/sources/img/";
		
		$this->ImgDir = "/var/www/djerelo/data/www/pic.djerelo.info/sources/img/hotcat";
		
		$this->IncDir = $this->RootDir."/lib/";
		$this->DataDir = $this->RootDir."/data";
		$this->Admin = false;
		$this->xmlHeader='<?xml version="1.0" encoding="utf-8"?>';
		
		$this->setHomePageId();
		
		
		if($dom = $this->DB->getFieldWhere("Sites", "DefaultLang", "where Domain = '$this->MainDomain'"))
		if(!$this->lang)$this->lang = 'ua';
		$this->lang = $dom;
		if($lang = $_GET['lang']) $this->lang = $lang;
		
		//print "<h1>[".$this->lang."]</h1>";
		//print "XMLHEADER: [".$this->xmlHeader."]<br>";
		//$this->addXml = $this->incXml("settings.xml");
		

		
		$this->addXml = $this->getLocale($this->lang);
		
		
		$this->ModuleClassArray = array(
			'hotcat' 	=> new Hotcat(),
			'forum' 	=> new Forum(),
			'news'	 	=> new News(),
			'papers'	=> new Papers(),
			'pages'		=> new SiteMap()
		);
		
		
		
		$this->TEMPLATE = "standart/subpage.xslt";
		
		$this->GetVars = $this->slashes($_GET);
		$this->PostVars = $this->slashes($_POST);
		
		
		// Read session info
		$this->UserData = new UserData($this->DB);
		$this->User = new Users();
		//print "lev [".$this->UserData->Level."]";
		
		// System messages
		$this->SysMsg = new SysMsg();
		
		// Mailboxes
		
		$this->AuthMail	= array(
			'info' => array(
				'address' 	=> '127.0.0.1',
				'port' 		=> 25,
				'login' 	=> 'info@djerelo.info',
				'pwd' 		=> 'ski123',
			),
			'forum' => array(
				'address' 	=> '127.0.0.1',
				'port' 		=> 25,
				'login' 	=> 'forum@djerelo.info',
				'pwd' 		=> 'QRUPcmLD',
			)
		);
		
		$this->Mail = new SendMail();
		$this->valid = new valid();		// checking on valid data input
		
		
		$this->Visitor = new Visitor($this->DB);
	}
	
	function getLocale($lang){
		//$capts = $this->DB->q("select concat('<c id=\"', pg.Name, '\">', Source,'</c>') as str from Pages pg left join PageData pd on pd.PageId = pg.Id and Lang = '$lang' where Rozdil = 705",1);
		$capts = $this->DB->q("select Source, Name  from Pages pg left join PageData pd on pd.PageId = pg.Id and Lang = '$lang' where Rozdil = 705");
		while($c = mysql_fetch_object($capts)){$cxml.='<c id="'.$c->Name.'">'.$c->Source.'</c>'."\n";}
		$xml = '<locale lang="'.$lang.'">'.$cxml.'</locale>';
		//print "<textarea>$xml</textarea>";
		return $xml;
		/*
		return	($lng = $this->incXml($lang.".xml", "sources/langs/")) 
			? $lng 
			: $this->incXml("en.xml", "sources/langs/")
		;
		*/
	}
	
	function slashes($arr){
		$out = array();
		$regex = array(
			"/begin_of_the_skype_highlighting/",
			"/end_of_the_skype_highlighting/",
			"/]]>/"
		);
		foreach($arr as $key=>$value){
			if(is_array($value)) 
				$key = $this->slashes($value);
			else{
				$value = preg_replace($regex, "", $value);
				$out[$key] = addslashes($value);
			}
		}
		return $out;
	}
	
	function setHomePageId(){
		
		$arr = split("\.", $this->Domain);
		$sub=array();
		//$dom = join("[", $arr);
		foreach($arr as $e){
			$dom = join(".", $arr);
			$q = "select * from Sites where Domain = '$dom'";
			$res = $this->DB->q($q);
			if( $r = mysql_fetch_object($res) ){
				$this->MainDomain		= $dom;
				$this->SiteHomePage 	= $r->PageId;
				$this->SubDomainArr 	= $resub = array_reverse($sub);
				$this->SubDomain 		= join(".", $sub);
				$this->SubDomainURI 	= join("/", $resub);
				//print "[$this->SubDomainURI]";
				return true;
			}
			else{
				$sub[] = array_shift($arr);
			}
		}
		
		
		//$this->rsi->msg($this->Domain,"domain");
	}
	
	function lngList(){
		$langs = $this->DB->q("select * from txt_Langs");
		$xml="";
		while($lng=mysql_fetch_array($langs)){
			$xml.='<lang id="'.$lng['Id'].'">'.$lng['Handle'].'</lang>';
		}
		$xml="<langs>$xml</langs>";
		return $xml;
	}
	
	function incXml($nm, $path="sources/xml/"){
		$fname = $this->RootDir."/".$path.$nm;
		if(file_exists($fname)) return file_get_contents($fname);
		else return NULL;
	}
	
}

class valid{
	function valid(){}
	function price($str){
		return preg_match("/^[0-9]{1,6}$/i", $str);
	}
	function ident($str){
		return preg_match("/^[\w\-]+$/i", $str);
	}
	function email($email) {
		return preg_match("/^([\w\.\-])+@([\w\.\-]+\\.)+[a-z]{2,4}$/i", $email);
	}
	function phone($str){
		//return preg_match("/^\+[0-9]{2}\([0-9]{3}\)[0-9\-\s]+$/i", $str);
		return preg_match("/^[\+]{0,1}[0-9]{10,12}$/i", $str);
	}
	function formatPhone($str){
		$srch = array("/\(/", "/\)/", "/\+/", "/\-/", "/\s/");
		return preg_replace($srch, '', $str);
		
	}
	function formatContent($document){
		$search = array ("'<script[^>]*?>.*?</script>'si",  // javascript off
						 "'<[\/\!]*?[^<>]*?>'si",           // html-tags off
						 "'([\r\n])[\s]+'",                 // empty space cutting
						 "'&(quot|#34);'i",                 // html-elements replacement
						 "'&(amp|#38);'i",
						 "'&(lt|#60);'i",
						 "'&(gt|#62);'i",
						 "'&(nbsp|#160);'i",
					//	 "'\n'",
						 "'&(iexcl|#161);'i",
						 "'&(cent|#162);'i",
						 "'&(pound|#163);'i",
						 "'&(copy|#169);'i",
						 "'&#(\d+);'e");                    // calculate like php
		
		$replace = array ("",
						  "",
						  "\\1",
						  "\"",
						  "&",
						  "<",
						  ">",
						  " ",
					//	  "<br/>",
						  chr(161),
						  chr(162),
						  chr(163),
						  chr(169),
						  "chr(\\1)");
		return preg_replace ($search, $replace, $document);
	}
}

class SysMsg{
	var $Arr;
	function SysMsg(){
		$this->Arr = array();
	}
	function Add($content, $type='', $id=''){
		array_push($this->Arr, array(
			'type'		=> $type,
			'content' 	=> $content,
			'id'		=> $id
		));
	}
	function XML(){
		foreach($this->Arr as $e){
			$xml.='
				<message type="'.$e['type'].'" id="'.$e['id'].'">
					<![CDATA['.$e['content'].']]>
				</message>
			';
		}
		return '<sysmsg>'.$xml.'</sysmsg>';
	}
}

// inject links into content by keywords
function autoLinks($txt, $fpath="injections/autolinks.csv"){
	// Parse template csv file
	$row = 1;
	if (file_exists($fpath)){
		$cont = file_get_contents($fpath);
		$cont_arr = split("\n", $cont);
		foreach($cont_arr as $str){
			list($url, $keywords, $title) = split("\t", $str);
			$srch[]="'($keywords)'i";
			$rep[]='<a href="'.$url.'" title="'.$title.'">$1</a>';
		}
		//dbg($sr."\n\n".$txt);
	}else return false;
	// hide headers, hyperlinks and img tags
	preg_match_all("'<a[^>]*?>.*?</a>'si", $txt, $a_array); 
	$txt = preg_replace("'<a[^>]*?>.*?</a>'si",'[a_array]', $txt); 
	preg_match_all("'<h[1-9][^>]*?>.*?</h[1-9]>'si",$txt, $h_array); 
	$txt = preg_replace("'<h[1-9][^>]*?>.*?</h[1-9]>'si",'[h_array]', $txt); 
	preg_match_all('/(<img[^>]*?>)/si',$txt, $img_array);
	$txt = preg_replace('/(<img[^>]*?>)/si','[img_array]',$txt);  
	
	$txt = preg_replace($srch, $rep, $txt,1);
	
	// take hidden tags back
	$i = 0; 
	$txt = preg_replace('~\[a_array\]~e', '$a_array[0][$i++];', $txt);
	$i = 0; 
	$txt = preg_replace('~\[h_array\]~e', '$h_array[0][$i++];', $txt);
	$i = 0; 
	$txt = preg_replace('~\[img_array\]~e', '$img_array[0][$i++];', $txt);  
	//dbg($txt);
	return $txt;
}

function injector($text, $dir="injections/"){
	
	$host = preg_replace("'www\.'", "", $_SERVER['HTTP_HOST']);
	//print "[$host]";
	if(is_dir($dir.$host."/"))$dir = $dir.$host."/";
	//print "[$dir]";
	foreach(glob("$dir*") as $fpath){if(is_file($fpath))$info = pathinfo($fpath); $injects [$info['basename']] = file_get_contents($fpath);}
	foreach($injects as $id=>$content){
		/* $temp = "'<inject id=\"$id\"[^>]*?>.*?</inject>'si"; */
		$temp = '|<inject id="'.$id.'"></inject>|';
		$src[$i] = $temp; $rep[$i++] = $content;
	}
	global $sape;
	$i++;
	$src[$i] 	= '|<inject id="sape"></inject>|';
	$rep[$i] 	= $sape->return_links(5);
	$i++;
	$src[$i] 	= '|<inject id=".*?"></inject>|';
	$rep[$i] 	= '';
	//$rep[$i] = preg_replace('|href="//|', 'href="http://', $rep[$i]);
	
	//print $rep[$i];
	//return $text;
	return preg_replace($src, $rep, $text);
}



	
	// Show data 
	$IP=$_SERVER ['HTTP_X_FORWARDED_FOR'];
	$office = '195.68.203.234'; // - office
	$vika = '109.86.140.143'; // - vika
	$taras = '178.94.225.237'; // - taras
	$lviv = '46.119.116.19';
	if($IP==$lviv)$dbg = true;
	
	function dbg($txt){
		global $dbg;
		$txt = print_r($txt, true);
		$ip=$_SERVER['REMOTE_ADDR'];
		if($dbg){
			print "<textarea cols=60 rows=10>$txt</textarea>";
			//$debug=true;
		}
	}
	
	function lg($txt, $channel="default", $type="w"){
		$fp = fopen("logs/$channel.log", $type);
		fwrite($txt, $fp);
		fclose($fp);
	}

$caCFG = new Settings();

$xmlOut = new xmlOut();
$caDB = $caCFG->DB;
$UriVars = array();
$DebugText=array();
$RSI = new rsi();

?>