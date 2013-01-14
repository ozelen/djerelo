<?
require 'vkapi.class.php';
header("Content-Type: text; charset=utf-8");

$api_id = 2420113; // Insert here id of your application
$secret_key = '3en3uWCyGuIIvnwCOdkv'; // Insert here secret key of your application

$VK = new vkapi($api_id, $secret_key);

//$resp = $VK->api('getProfiles', array('uids'=>'1,6492'));

//print_r($resp);

$userlist = $VK->api('likes.getList', array('owner_id' => 2420113, 'type'=>'sitepage', 'item_id' => 340));
//$profiles = $VK->api('likes.getProfiles', array('uids' => join(',', $userlist['response']['users'])));

$user = $VK->api('getUserInfo', array());

$count = $userlist['response']['count'];
print "VK: $count users like this\n";



// https://graph.facebook.com/me/likes?access_token=2227470867|2.AQCr8lg3ucM8ZoN7.3600.1318165200.0-100001573869359|NIFTTWQbFMCQYhI4swjeDQ3d48A
// https://api.facebook.com/method/fql.query?query=SELECT like_count, total_count, share_count, click_count from link_stat where url="http://skiworld.org.ua/taras/"
// https://api.facebook.com/method/fql.query?query=select%20%20like_count,%20total_count,%20share_count,%20click_count%20from%20link_stat%20where%20url=%22http://www.saschakimmel.com/2010/05/how-to-capture-clicks-on-the-facebook-like-button/%22
?>