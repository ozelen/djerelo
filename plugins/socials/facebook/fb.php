<?
class fbLikeList{
	var $userlist;
	function __construct($url){
		$this->getByUrl($url);
	}
	private function getByUrl($url, $format='json'){
		$q = "https://api.facebook.com/method/fql.query?query=SELECT%20like_count,%20total_count,%20share_count,%20click_count%20from%20link_stat%20where%20url=%22$url%22&format=$format";
		$resp = file_get_contents($q);
		$res = json_decode($resp, true);
		$this->userlist = $res[0];
	//	print_r($this->userlist);
	}
	
	public function getTotal(){
		return $this->userlist['total_count'];
	}
}

/*
header("Content-Type: text; charset=utf-8");
$likes = new fbLikeList("http://skiworld.org.ua/torba/");
$count = $likes->getTotal();
print "FB: $count users like this\n";
*/

?>