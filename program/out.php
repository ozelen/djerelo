<?php
	include_once("../config.php");
	$today = date("Y-m-d H:i");
	$db = $caCFG->DB;
	//setcookie("skiworld_out[$today]"
	if(isset($_SERVER['REMOTE_ADDR']))$host = $_SERVER['REMOTE_ADDR'];
	if(isset($_SERVER['HTTP_REFERER']))$ref = $_SERVER['HTTP_REFERER'];
	$from = addslashes($_GET['from']);
	$url = addslashes($_GET['url']);
	//if(isset($_COOKIE[]))
	$db->q("insert into Clicks (ReqUrl, ClickDate, PageFrom, Host) values ('$url', '$today', '$ref', '$host')");
	header( 'Location: '.$url ) ;
?>