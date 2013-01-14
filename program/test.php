<?

class Account{
	var $B; 	// total points
	var $P;		// Service tariff
	var $b0; 	// basic price per day
	var $r; 	// campaign rate factor
	var $A;		// competition rate factor
	var $A_avg;	// competition rate factor
	var $bonus;	// bonus 
	var $months;
	function Account($B, $P){
		$this->B = $B;
		$this->P = $P;
		$this->b0 = $P/365;
		$this->r = array();
		$this->A = array(200,150,120,80,90,90,100,100,70,50,50,100);
		//$this->A = array(20,10,10,50,120,170,300,250,170,80,10,10);
		$this->A_avg = $this->avg();
		$this->months = array(31,28,31,30,31,30,31,31,30,31,30,31);
	}
	
	function setCampaignRate($begin, $end, $val){
		list($y,$m,$d) = split($begin);
		list($yn,$mn,$dn) = split($begin);
	}
	
	function calcYear(){
		$B = $this->B;
		$j=0;
		foreach($this->months as $month){
			$td = '';
			for($i=0; $i<$month; $i++){
				$b = $this->b0 * $this->A[$j] / 100;// + $this->r;
				$B -= $b;
				//$td.="<td>$B - $b = ".round($B, 2)."</td>";
				$td.="<td>".round($B, 2)."</td>";
				$n++;
			}
			$tr.="<tr>$td</tr>";
			$j++;
		}
		print "<table border=1>$tr</table>";
		print "Average: ".$this->avg()." days: $n";
	}
	
	function avg(){
		$A=0;
		foreach($this->A as $a){
			$A+=$a;
			$i++;
		}
		return $A/$i;
	}
}

//$acc = new Account(2000, 1050);
//$acc->calcYear();
/*
$i=5;
$i = ++$i + ++$i;
print "[$i]";
*/

//print date("Y-m-d", strtotime("10.01.2010"));

//print $_SERVER['REQUEST_URI'];


// array of outside injections
function injector($text){
	foreach(glob("../injects/*") as $fpath){ $info = pathinfo($fpath); $injects [$info['basename']] = file_get_contents($fpath);}
	foreach($injects as $id=>$content){$src[$i] = "'<inject id=\"$id\"[^>]*?>.*?</inject>'si"; $rep[$i++] = $content;}
	return preg_replace($src, $rep, $text);
}

print "$p \n $r";

print $_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];

print strtotime("2011-11-11aasd");

?>