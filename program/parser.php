<?
//$fp = fopen('http://yaremcha.com.ua/polyanytsya.html', 'r');
$files = array();
$url = 'http://yaremcha.com.ua/';
$files['ua'] = 'index1.html';
$files['ru'] = 'index1ru.html';


/*
<tr bgcolor="#eeeeee">
<td valign="center"><a title="Поляниця/Буковель/.Котедж Гладіолус." href="gladiolus.html"><img height="60" alt="Поляниця/Буковель/.Котедж Гладіолус." hspace="0" src="imagep/p17-0.jpg" width="80" border="0"></a> </td>
<td valign="center" align="left">
<table id="submenu" cellspacing="0" cellpadding="0" width="100%" border="0"><tbody>
<tr bgcolor="#005100">
<td><b>«Гладіолус» Котедж </b>
</td>
<td valign="center" align="middle" width="80">&nbsp;&nbsp;</td>
<td valign="center" align="left" width="190"><strong> |8|&nbsp;місця
</strong></td><td valign="center" align="middle" width="60"><a title="далі.Поляниця/Буковель/.Котедж Гладіолус." href="gladiolus.html">далі....</a></td></tr></tbody></table>
<div class="style0">
78593, Івано-Франківська обл., Яремчанська міська рада, с.Поляниця, тел.моб. +38(096) 9365859 Мирослава, +38(097) 6275167 Іван. </div>
<div class="style0" align="right"><b>ціна |300-1200 грн|</b>за номер /котедж</div>
</td></tr>
*/





//preg_match_all("|<td><b>(.*)</b></td>|", "$txt", $name, PREG_PATTERN_ORDER);
//preg_match_all("|<div class=style0>([^<]*)</div>|", "$txt", $addr, PREG_PATTERN_ORDER);

//print "<textarea cols=100 rows=20>$txt</textarea>";

$arr=array();
foreach ($files as $lang => $file) {
	$txt = file_get_contents($url.$file);
	$txt = iconv("windows-1251", "UTF-8", $txt);
	$num = preg_match_all('|<td><b>([^<]*)</b>.*?href="([^"]*)".*?class=style0>([^</div]*)|s', "$txt", $out, PREG_SET_ORDER);
	print "[$lang]";
	foreach($out as $v){
		$i++;
		if(!is_array($arr[$i]))$arr[$i]=array();
		list($all, $name, $link, $addr) = $v;
		$arr[$i][$lang]=array('name'=>$name, 'link'=>$link, 'addr'=>$addr);
		//if($lang == 'ru')print '<div> <h3>'.$name.'</h3> <a href="'.$url.$link.'">'.$url.$link.'</a> <p>'.$addr.'</p> </div>';
	}	
	$i=0;
}

foreach($arr as $obj){
	$i++;
	$html.='
		<tr>
			<td>
				<h3>'.$obj['ua']['name'].'</h3>
				<a href="'.$url.$obj['ua']['link'].'">'.$url.$obj['ua']['link'].'</a>
				<div>'.$obj['ua']['addr'].'</div>
			</td>
			<td>
				<h3>'.$obj['ru']['name'].'</h3>
				<a href="'.$url.$obj['ru']['link'].'">'.$url.$obj['ru']['link'].'</a>
				<div>'.$obj['ru']['addr'].'</div>
			</td>
		</tr>
	';
	$csv.=$obj['ua']['name']."	".$obj['ua']['addr']."	".$obj['ua']['link']."	";
}
$csv="name	addr	link\n".$csv;
//print "<textarea cols=100 rows=20>$csv</textarea>";

?>
<html>
	<head>
		<style>
			input{width:100%}
		</style>
	</head>
	<table border=1>
		<tr>
			<th colspan="2">
				URL: <input value="<?=$url?>" name="url">
			</th>
		</tr>
		<tr>
			<td>ua: <input value="<?=$files['ua']?>" name="file_ua"></td>
			<td>ru: <input value="<?=$files['ru']?>" name="file_ru"></td>
		</tr>
		<textarea style="width:100%" rows=20><?=$query?></textarea>
		<?=$html?>
	</table>
</html>