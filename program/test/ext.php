<?

class C extends B{
	function C(){
		print "class C<br>";
		$this->B();
	}
}

class B extends A{
	function B(){
		print "class B<br>";
		$this->A();
	}
}

class A{
	function A(){
		print "class A<br>";
	}
}

$b = new C();


?>