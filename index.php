<?
//if($_SERVER['REMOTE_ADDR']!='109.86.140.143')exit(1);
	//print "<a href=http://djerelo.info/>djerelo</a>";
	//exit();
	//foreach($_GET as $key=>$val){print "$key : $val<br>";}
	
	header("Content-type: text/html; charset=utf-8");
	include("config.php");
// *sape

	global $sape;
	if (!defined('_SAPE_USER')){
		define('_SAPE_USER', '29f2bdd8d10766cb7c43da5ff3098114');
	}
	require_once($_SERVER['DOCUMENT_ROOT'].'/'._SAPE_USER.'/sape.php');
	$o = array();
	$o['multi_site'] = true; //Указывает скрипту наличие нескольких сайтов
	$o['force_show_code'] = true;
	$sape = new SAPE_client($o);

// /sape
	//$rsi->msg("begin");

	//print $_SERVER['REQUEST_URI'];
	//$caCFG->getHomePageId();
	
	$current_url =  $_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
	if(substr($current_url, -1, 1)!="/"){
		header("HTTP/1.1 301 Moved Permanently");
		header("Location: http://$current_url/");
		// add slash at the end
	}

	session_start();
	
	if($_SESSION['email']){
		$caCFG->UserData->getData($_SESSION['email'], $_SESSION['pass']);
	}//print $_SESSION['email'];
	
	$Pages = new Pages();

//print "[".$caCFG->lang."]";

	$rsi = new rsi();
	$rsi->start();


	
	if(($caCFG->URI = $_GET['sub']) || ($caCFG->SubDomainURI)){
		// Detect URI 
		$caCFG->VirtualUri = $caCFG->SubDomainURI."/".$caCFG->URI;	// merge subdomain path with uri path
		//$RequestPageId = $Pages->getId($caCFG->VirtualUri, $caCFG->SiteHomePage);
		$uri = $caCFG->VirtualUri;
		//dbg("[$caCFG->SiteHomePage]:".$Pages->getId($uri, 1)." - ".$Pages->getId($uri, $caCFG->SiteHomePage));
		$RequestPageId = ($id = $Pages->getId($uri, 1)) != 1 
			? $id 
			: $Pages->getId($uri, $caCFG->SiteHomePage)
		;
		//dbg($RequestPageId);
		
	}
	else $RequestPageId = $caCFG->SiteHomePage;
	
	//print "[".$caCFG->URI."]";
	
	// Get Language 
	//$RequestLanguage = ($lang = $_GET['lang']) ? $lang : "ua";
	
	// Get subsite map 
	$SubMap = $Pages->siteMap($RequestPageId, $RequestLanguage);
	
		

	

	
	//dbg(memory_get_usage(true));

	//print "[$RequestPageId, $caCFG->VirtualUri, $caCFG->SiteHomePage]";
	//dbg("sessid: ".$_COOKIE['PHPSESSID']);
	$CONTENT =  $Pages->ShowHTML($RequestPageId, $debug);
	
	$rsi->msg("all");
	$rsi->stop();

//foreach($_SESSION as $k=>$v){print '<h1 style="color:#fff">['.$k.' = '.$v.']</h1>';}

	
	$caCFG->DB->Fin();
	$caCFG->HDB->Fin();
	
	$CONTENT = injector($CONTENT);
	print $CONTENT;
	//dbg($CONTENT);
	//$caCFG->rsi->showLog();
	//print "<br/>$ip";
$ip = $_SERVER['REMOTE_ADDR'];
	print "<!-- [ip: ".$IP."] -->";

?>

