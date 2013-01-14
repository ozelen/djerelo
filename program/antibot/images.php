<?
define("S_MOD", 1);

require_once("../inc/config.php");
require_once("../inc/session.php");
$img_x          = 100;   //������ �����������, �� ���������-100
$img_y          = 30;   //������ �����������, �� ���������-30
$font_min_size  = 13;   //����������� ������ ������, �� ���������-12
$font_max_size  = 17;   //������������ ������ ������, �� ���������-12
$lines_n_max    = 2;    //������������ ����� ������� �����, �� ���������-2
$nois_percent   = 10;    //������������� ������� ���� � ������, � ���������, �� ���������-3
$angle_max      = 5;   //������������ ���� ���������� �� ����������� �� ������� ������� � ������, �� ���������-20
// � ����� /php/fonts/*.ttf ����� ��������� ������� ttf
$font_arr=glob(dirname(__FILE__)."/fonts/*.ttf");
$im=imagecreate($img_x, $img_y);
//������� ����������� �����
$text_color = imagecolorallocate($im, 0, 0, 0);       //���� ������
$nois_color = imagecolorallocate($im, 0, 0, 0);       //���� ����������� ����� � �����
$img_color  = imagecolorallocate($im, 255, 255, 255); //���� ����
//�������� ����������� ������� ������
imagefill($im, 0, 0, $img_color);
//� ���������� $number ����� ��������� �����, ���������� �� �����������
$number='';
$number=(empty($_SESSION['registr_key']))?'01020304':$_SESSION['registr_key'];
$num_n=strlen($number);
#$nums=explode("",$number);
for ($n=0; $n<$num_n; $n++){
	$num=substr($number,$n,1);
    #$num=rand(0,9);
    #$number.=$num;
    $font_size=rand($font_min_size, $font_max_size);//$img_y/2
    $angle=rand(360-$angle_max,360+$angle_max);

    $font_cur=rand(0,count($font_arr)-1);
    $font_cur=$font_arr[$font_cur];
    //���������� ��������� ��� ������ �����, ������� ������������ ���������� �����������
    //��� ����� ��������� �������� ����� � �����������
    $y=rand(($img_y-$font_size)/4+$font_size, ($img_y-$font_size)/2+$font_size);

    $x=rand(($img_x/$num_n-$font_size)/2, $img_x/$num_n-$font_size)+$n*$img_x/$num_n;

	$text_color = imagecolorallocate($im, rand(0, 100), rand(0, 100), rand(0, 100));       //���� ������

    imagettftext($im, $font_size, $angle, $x, $y, $text_color, $font_cur, $num);
};
//��������� ����� "�����������" ��������
$nois_n_pix=round($img_x*$img_y*$nois_percent/100);
//��������� ����������� ��������� ����� ������
for ($n=0; $n<$nois_n_pix; $n++){
    $x=rand(0, $img_x);
    $y=rand(0, $img_y);
	$nois_color = imagecolorallocate($im, rand(20, 255), rand(20, 255), rand(20, 255));       //���� ����������� ����� � �����
    imagesetpixel($im, $x, $y, $nois_color);
};
//��������� ����������� ��������� �������� �����
for ($n=0; $n<$nois_n_pix/2; $n++){
    $x=rand(0, $img_x);
    $y=rand(0, $img_y);
    imagesetpixel($im, $x, $y, $img_color);
};

$lines_n=rand(0,$lines_n_max);
//�������� "�����������" ����� ����� ������
for ($n=0; $n<$lines_n; $n++){
    $x1=rand(0, $img_x);
    $y1=rand(0, $img_y);
    $x2=rand(0, $img_x);
    $y2=rand(0, $img_y);
    $nois_color = imagecolorallocate($im, rand(20, 255), rand(20, 255), rand(20, 255));       //���� ����������� ����� � �����

    imageline($im, $x1, $y1, $x2, $y2, $nois_color);
};

Header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
Header("Last-Modified: ".gmdate("D, d M Y H:i:s")."GMT");
Header("Cache-Control: no-cache, must-revalidate");
Header("Pragma: no-cache");

header("Content-type: image/png");
imagepng($im);
imagedestroy($im);

?>