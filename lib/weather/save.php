<?
include_once("weather.php");
$weath = array();

$weath['volovec']   = weatherByCity(1168, 5); 	//Volovets
$weath['podobovets']= weatherByCity(1168, 5); 	//Podobovets
$weath['mizhgyrya'] = weatherByCity(3284, 5);
$weath['pylypets']  = weatherByCity(3284, 5); //Pylypets (Podobovets)
$weath['izki']      = weatherByCity(3284, 5);
$weath['yasynya']   = weatherByCity(54, 5); 	//Yasinya
$weath['dragobrat'] = weatherByCity(54, 5); 	//Dragobat (Yasinya)

$weath['truskavets']= weatherByCity(142, 5); 	//Truskavets
$weath['skole']     = weatherByCity(62, 5); 	//Skole
$weath['slavsko']   = weatherByCity(138, 5); 	//Slavsko
$weath['volosyanka']= weatherByCity(138, 5); 	//Volosyanka (Slavsko)
$weath['oryavchik'] = weatherByCity(62, 5); 	//Oryavchik (Skole)
$weath['oriv']      = weatherByCity(62, 5); 	//Oryavchik (Skole)

$weath['yaremche']  = weatherByCity(150, 5); 	//Yaremche
$weath['bukovel']   = weatherByCity(150, 5); 	//Bukovel (Yaremche)
$weath['mykulychyn']= weatherByCity(150, 5); 	//Mykulychin (Yaremche)
$weath['tatariv']   = weatherByCity(150, 5); 	//Tatariv (Yaremche)
$weath['kosov']     = weatherByCity(1184, 5); 	//Kosiv
$weath['vorohta']   = weatherByCity(121, 5); 	//Vorohta
$weath['verhovyna'] = weatherByCity(3315, 5); 	//Verhovyna (Vorohta)

foreach($weath as $key => $value){
	$file = fopen("/var/www/djerelo/data/www/skiworld.org.ua/data/weather/weather_$key.xml", "w");
	fputs($file, $value);
	$res.=$weath[$key];
}
?>
<textarea style="width:600px; height:300px;"><?=$res;?></textarea>