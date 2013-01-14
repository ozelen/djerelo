<?
	header("content-type:application/xml;charset=utf-8");

	include("../config.php");
	$MD = new Modules();
	$p = $_POST;
	$lang = ($lang = $_GET['lang']) ? $lang : 'ua';
	$pref = ($lang=='en' ? '' : '_'.$lang);
	$zoom = $_GET['zoom'];
	
	$db = $caCFG->HDB;
	//print "[$pref]";
	
	if($zoom>=14){
		$q = "
			select 
				lat, 
				lng, 
				obj.Id as ObjId,
				obj.AccountCode,
				objdata.Title as Name, 
				cdata.Source as Address,

				Modules.TitleImage as img,
				
				profile.ClassValue as ProfId,
				profname.Title as ProfName,
				ctype.ClassValue as TypeId,
				ctypename.Title as TypeName
			from Locations
				join Objects obj
					on OwnerId = obj.Id
				
				join PageData objdata on objdata.PageId = obj.PageId and objdata.Lang = '$lang'
				left join Pages cont on cont.Rozdil = obj.PageId and cont.Name = 'contacts'
                left join PageData cdata on cont.Id = cdata.PageId and cdata.Lang = '$lang'
					
				join Modules 
					on Modules.OwnerTable = 'Objects'
					and Modules.OwnerId = obj.Id
                
				left join skiworld.ClassLinks profile on profile.OwnerId = obj.Id and profile.OwnerTable = 'Objects' and profile.ProfileOf = 'Objects'
                left join skiworld.PageData profname on profname.PageId = profile.ClassValue and profname.Lang = '$lang'
                left join skiworld.ClassLinks ctype on ctype.OwnerId = obj.Id and profile.OwnerTable = 'Objects' and ctype.TypeOf = 'Objects'
                left join skiworld.PageData ctypename on ctypename.PageId = ctype.ClassValue and ctypename.Lang = '$lang'
				
			where
				Locations.OwnerTable = 'Objects'
				and lat > ".$p['lb_lat']." and lat < ".$p['rt_lat']." 
				and lng > ".$p['lb_lng']." and lng < ".$p['rt_lng']."
			group by obj.Id
		";
		
		$lcs = $db->q($q);
		while($loc = mysql_fetch_object($lcs)){
			$icon_file = $_SERVER['DOCUMENT_ROOT']."/sources/img/icons/classes/".$loc->ProfId.".png";
			if(is_file($icon_file)){
				list($w, $h) = getimagesize($icon_file); 
				$icon_url = "http://djerelo.info/img/icons/classes/".$loc->ProfId.".png";
				$big_url = "http://djerelo.info/img/icons/classes/".$loc->ProfId.".png";
			}else{
				$icon_url = "http://djerelo.info/img/icons/city.png";
				$w = $h = 25;
			}
			
			$img = mysql_fetch_object($db->q("select Id, LocalPath, Extension from Images where Id = '$loc->img'"));
			$title_image = "http://pic.djerelo.info/crop/img/hotcat/".$img->LocalPath."/".$img->Id."/thumb.".$img->Extension;
			
			$objinfo = '
				<table width="100%">
					<tr>
						<td>
							<div style="width:50px;height:50px;background:url('.$icon_url.') center no-repeat; border:#ccc 1px solid" class="ui-border-all">
								<div style="width:50px;height:50px;background:url('.$title_image.') center no-repeat"></div>
							</div>
							
						</td>
						<td colspan="2">
							'.$loc->Address.'
						</td>
					</tr>
				</table>
			';
			
			$xml.='
				<point lat="'.$loc->lat.'" lng="'.$loc->lng.'" group="infrastructure">
					<icon src="'.$icon_url.'" w="'.$w.'" h="'.$h.'"/>
					<obj id="'.$loc->ObjId.'" ident="'.$loc->AccountCode.'">
						<name><![CDATA['.$loc->Name.']]></name>
						<header><![CDATA[<a href="/'.$lang.'/goto/'.$loc->ObjId.'/">'.$loc->Name.'</a>]]></header>
						<info><![CDATA['.$objinfo.']]></info>
						<type id="'.$loc->TypeId.'" ident="'.$loc->TypeIdent.'"><![CDATA['.$loc->TypeName.']]></type>
						<img id="'.$loc->img.'"/>
					</obj>
				</point>
			';
		}
	}
	
	if($zoom<=12){
		$q = "
			select 
				lat, 
				lng, 
				OwnerTable,
				Cities.Id as CityId,
				Ident,
				Title as Name,
				Source as Info
			from Locations
				left join Cities on OwnerId = Cities.Id
				left join PageData on Cities.PageId = PageData.PageId and Lang = '$lang'
			where
				Locations.OwnerTable = 'Cities'
				and lat > ".$p['lb_lat']." and lat < ".$p['rt_lat']." 
				and lng > ".$p['lb_lng']." and lng < ".$p['rt_lng']."
		";
		
		$lcs = $db->q($q);
		while($loc = mysql_fetch_object($lcs)){
			$icon_url = "http://djerelo.info/img/icons/city.png";
			$w = $h = 20;
			$xml.='
				<point lat="'.$loc->lat.'" lng="'.$loc->lng.'" group="cities">
					<icon src="'.$icon_url.'" w="'.$w.'" h="'.$h.'"/>
					<obj id="'.$loc->CityId.'" ident="'.$loc->Ident.'">
						<header><![CDATA[<a href="/'.$lang.'/goto/'.$loc->Ident.'/">'.$loc->Name.'</a>]]></header>
						<name><![CDATA['.$loc->Name.']]></name>
						<info><![CDATA['.$loc->Info.']]></info>
					</obj>
				</point>
			';
		}
	}
	
	
	$xml='<?xml version="1.0" encoding="utf-8"?>'."<points>$xml</points>";
	print $xml;
?>
