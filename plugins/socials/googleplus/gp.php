<?
class gpLikeList{
	var $userlist;
	function __construct($url){
		$this->total = $this->getByUrl($url);
	}
	
	function getByUrl($url){
		$requests[] = array(
		    'apiVersion' => 'v1',
		    'id'      => 'p',
		    'jsonrpc' => '2.0',
		    'key' => 'p',
		    'method'  => 'pos.plusones.get',
		    'params'  => array("nolog" => "true", "id" => $url, "source" => "widget", "container" => $url, "userId" => "@viewer", "groupId" => "@self"),
		);
		$json_request = json_encode($requests);
		$ctx = stream_context_create(array(
		    'http' => array(
		        'method'  => 'POST',
		        'header'  => 'Content-Type: application/json\r\n',
		        'content' => $json_request
		    )
		));
		$json_response = file_get_contents('https://clients6.google.com/rpc?key=AIzaSyCKSbrvQasunBoV16zDH9R33D88CeLr9gQ', false, $ctx); 
		$arr = json_decode($json_response, true);
		//print_r($arr);
		$count = $arr[0]['result']['metadata']['globalCounts']['count'];
		//print "[$count]\n";
		return $count;
	}
	
	/*
	function getByUrl($url){
		$ch = curl_init();  
		$query = '[{"method":"pos.plusones.get","id":"p","params":{"nolog":true,"id":"' . $url . '","source":"widget","userId":"@viewer","groupId":"@self"},"jsonrpc":"2.0","key":"p","apiVersion":"v1"}]';
		curl_setopt($ch, CURLOPT_URL, "https://clients6.google.com/rpc?key=AIzaSyBDAcB4VLI32tc59MGauclqUsLM4bVToCM");
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $query);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
		  
		$curl_results = curl_exec ($ch);
		echo curl_error($ch);
		curl_close ($ch);
		
		print "$query\n$curl_results";
		
		$parsed_results = json_decode($curl_results, true);
				
		return $parsed_results[0]['result']['metadata']['globalCounts']['count'];	
	}
	*/
	
	function g(){

		//print_r(json_decode($json_response, true));
	}
	
	function getTotal(){
		return $this->total;
	}
}	

/*
header("Content-Type: text; charset=utf-8");
$likes = new gpLikeList("http://djerelo.info/torba/");
$count = $likes->getTotal();
print "GP: $count users like this\n";
*/

?>