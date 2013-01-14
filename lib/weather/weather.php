<?

function weatherByCity($city_id, $days=1, $template=''){
	global $hotelDB;
	$url = 'http://xml.weather.co.ua/1.2/forecast/'.$city_id.'?dayf='.$days.'&userid=www.skiworld.org.ua';
	$xml = file_get_contents($url);
	//$xml = iconv("UTF-8", "windows-1251", $xml);
	if($template){
		$xmlOut=new xmlOut;
		$xmlOut->TempFile=$template;
		$xmlOut->Source=$xml;
		$xmlOut->setParams();
		return iconv("UTF-8", "windows-1251", $xmlOut->Show());
	}
	//else return iconv("UTF-8", "windows-1251", $xml);
	else return $xml;
}

?>