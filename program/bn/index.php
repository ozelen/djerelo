<?
include('../../config.php');
$cfg = $caCFG;

$id = $_GET['id'];
if(!$id){
	print "Banner not found";
	exit(-1);
}
if(preg_match("/\.\./", $id)){print "was ist das?!"; exit;}
$dir = $cfg->guiImgDir."bn/$id/";
$temp = $dir."{*.jpg,*.gif,*.jpg}";
$path = glob($temp,GLOB_BRACE);
if(!$path){print "Sources not found"; exit(-1);}

$url_path = $dir."url";

if(file_exists($url_path))$url = file_get_contents($url_path);
else{print "url not found"; exit;}

?>
<!DOCTYPE html>
<html>
	<head>
		<title><?=$id?></title>

		<script src="/js/jquery/jquery.js" ></script>
		<script src="/js/cycle-slides.js" ></script>

		<script>

		$(document).ready(function() {
			$('.slideshow').cycle({
				fx: 'fade'
			});
		});


		</script>
	</head>
	<body style="margin:0">
		<a href="<?=$url?>" target="_blank">
			<div class="slideshow" style="position:inline; float:left">
<?
				foreach($path as $key=>$val){
					//print "$key=>$val<br />";
					$img_prop = getimagesize($val);
					$inf = pathinfo($val);
					$fname = $inf['basename'];
					print '<img src="/img/bn/'.$id.'/'.$fname.'"/ '.$img_prop[3].' />';
				}
?>
			</div>
		</a>
	</body>
</html>