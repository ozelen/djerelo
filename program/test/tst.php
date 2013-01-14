<?

	function prettyDate($str){
		list($date, $time) = split(" ", $str);
		list($y,$m,$d) = split("-",$date);
		$res = $d.'.'.$m.'.'.$y;
		if($time)$res.=' '.$time;
		return $res;
	}

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Test</title>
</head>

<p>Full: <?=prettyDate("2010-09-15 18:55:00")?></p>
<p>Half: <?=prettyDate("2010-09-15")?></p>

<body>
</body>
</html>