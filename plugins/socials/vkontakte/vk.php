<?
require_once 'vkapi.class.php';
class vkLikeList{
	var $userlist;
	function __construct($id){
		$this->api_id 		= 2420113;
		$this->secret_key 	= '3en3uWCyGuIIvnwCOdkv';
		$this->VK 			= new vkapi($this->api_id, $this->secret_key);
		$this->getById($id);
	}
	
	public function getTotal(){
		return $this->userlist['count'];
	}
	
	private function getById($id){
		$resp = $this->VK->api('likes.getList', array('owner_id' => $this->api_id, 'type'=>'sitepage', 'item_id' => $id));
		$this->userlist = $resp['response'];
		//print_r($resp);
	}
}

/*
header("Content-Type: text; charset=utf-8");
$likes = new vkLikeList(300);
$count = $likes->getTotal();
print "VK: $count users like this\n";
*/

?>