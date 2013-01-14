<?

//interface child(){}

class c1{
	function __construct(){
		print "Hello from Parent<br>";
	}
	function ax(){

	}
}
class c2 extends c1{
	function c2(human $man){
		print "Hello $man->name $man->sname from Child!<br>";
	}
	function f(){
		print "c2::f()";
	}
}

class human{
	public $name;
	public $sname;
	function __construct($name, $sname){
		$this->name = $name;
		$this->sname = $sname;
	}
}

//$oleksa = new human("Oleksa","Zelenyuk");
//$c = new c2($oleksa);

?>