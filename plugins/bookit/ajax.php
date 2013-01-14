<?
header ("Content-type: text/plain; charset=utf-8");
$json = file_get_contents('http://bookit.com.ua/ajax/?'.$_SERVER['QUERY_STRING']);
$json = preg_replace('/(results|id|value|info)/si', '"$1"', $json);
print $json;

//print_r(json_decode($json, true));

//echo '{"results":[{"id":"123", "value":"Bukovel"}, {"id":"13", "value":"Buk"}]}';
?>