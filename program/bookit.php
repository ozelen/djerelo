<?
include_once("../config.php");
class BookIt extends Modules{
	var $data, $ids, $url;
	function BookIt(){
		$this->url = 'http://www.nezabarom.ua/scripts/export/index.php?u=djerelo&p=djerelo&url=';
		$this->ids = array(
			'cities' => '061144266b5595d1afdf614b8f6f7d00',
			'hotels' => '7a5a69edbdd188cd5c330009adab4d1b',
			'rooms'  => 'ea0a5ccc3e9fb0790690e94a32fdf28e'
		);
	}
	function xmlCompile(){
		foreach($this->ids as $key=>$id){
			//print $this->data.=file_get_contents($this->url.$id);
			$this->data.=$this->url.$id."<br>";
		}
		return $this->data;
	}
}

$book = new BookIt();
//print $book->xmlCompile();
?>
