<?


class gallery extends HotCat{
	var $ImgSizes;
	var $DB;

	function gallery(){
		$this->inc();
		$this->DB = $this->CFG->HDB;
		$this->ImgSizes = array(
			'big' 	=> array('width' => 1200, 'height' => 1200, 'quality' => 100),
			'thumb'	=> array('width' => 160, 'height' => 160, 'quality' => 100),
			'mini'	=> array('width' => 80,  'height' => 80,  'quality' => 100)
			//'' => array('width' => , 'height' =>, 'quality' => 100),
		);
		$this->pages = new Pages();
		$this->pages->setDB($this->DB);	// now MySQL link oriented on "hotelbase" DB (HDB)
		//print "[".$this->pages->DB->dbName."]";
	}


	function Exec($name, $params=NULL){
		parse_str($params, $p_arr);
		switch($name){
			case "show": 
				$xml = $this->Show($p_arr['album'], $p_arr['table'], $p_arr['id'], $p_arr['cursor'], $p_arr['limit'], $p_arr['template'], $p_arr['mode']);
				//print "<textarea>$xml</textarea>";
				return $xml; 
			break;
			case "list":
				return $this->ListGal($p_arr);
			break;
			//default : print "[$params]"; return "<g></g>"; break;
		}
	}
	
	function ListGal($cond){

		$cond_arr = array();
		if(is_array($cond)){
			if(($owner = $cond['owner']) && ($ownerid = $cond['ownerid'])){
				if(is_numeric($ownerid)) $uid = $ownerid;
				else
				switch($ownerid){
					case 'current': $uid = $this->CFG->UserData->Id; break;
					case 'fromuri': $uid = $this->CFG->User->getIdByField("name", $this->uriVars['username']); break;
				}
				$cond_arr['user'] = "and OwnerTable = '$owner' and OwnerId = $uid";
				$where_cond = join(' ', $cond_arr);
			}
			//return "[error: $owner, $ownerid]";
		}else $where_cond = 'and '.$cond;
		
		if(!$owner || !$uid){
			print "Owner undefined!";
			return false;
		}
		$qq = $this->CFG->HDB->q("select * from Modules where ModuleHandler = 'album' ".$where_cond);
		while($g = mysql_fetch_object($qq)){
			$xml.='
				<album id="'.$g->Id.'">
					<name>'.$g->Name.'</name>
					<url-params>
						<album id="'.$g->Id.'">'.$g->Name.'</album>
						<owner id="'.$g->OwnerId.'">'.$g->OwnerTable.'</owner>
					</url-params>
					<session id="'.session_id().'">'.session_name().'</session>
					'.$this->pages->getPage($g->PageId, $this->CFG->lang, '', 3).'
				</album>
			';

		}
		

		$xml = '
			<albumlist>
				<owner id="'.$uid.'">'.$owner.'</owner>
				'.$xml.'
			</albumlist>
		';

		return $xml;
	}

	
	function setDB($db){
		$this->DB = $db;
	}
	

	function Show($album_id, $owner_table=NULL, $owner_id=NULL, $cursor=NULL, $step=50, $templ='', $mode=''){
		
		$db = $this->DB;
		$cursor 		= $cursor ? $cursor : 0;
		$step			= $step ? $step : 50;
		$r_cursor		= $cursor+$step;
		$mode			= $mode ? $mode : 'view';
		$vmode	=	$_POST['viewmode'];
		//print "[$vmode]";
		
		if($step!='all')$limit_cond = (($cursor>=0) ? "limit $cursor, $step" : "");
		

		if(!($album_id)){
			if(!$owner_id)return NULL;
			if(!($album_id = $db->getFieldWhere('Modules', 'Id', "where OwnerTable = '$owner_table' and OwnerId = $owner_id and ModuleHandler='album'"))){
				//print "<p>There is no album for this object [$owner_table:$owner_id]</p>";
				return NULL; 
			}
			//else print "New album [$album_id]";
		}
		//else print "Album fouded! [$album_id]";
		
		$q="select * from Images where AlbumId = $album_id order by `Range`, Added desc $limit_cond";
		//print "<!-- ggg: $q -->";
		$images = $db->q($q);
		//dbg($q);
		while($i = mysql_fetch_array($images)){
			//$db->getLine("Title", "PageData", "PageId =".$i['PageId']." and Lang = '".$this->lang."'");
			
			$img_xml.='
				<img id="'.$i['Id'].'" extension="'.$i['Extension'].'" album="'.$i['AlbumId'].'">
					<localpath>'.$i['LocalPath'].'</localpath>
					<page id="'.$i['PageId'].'">'.$i['Title'].'</page>
				</img>
			';
			
		}
		
		$g = mysql_fetch_object($db->q("select * from Modules where Id = $album_id"));
		
		$album_pageid 	= $g->PageId; //= $db->getField("Modules", "PageId", $album_id);
		$title_image	= $g->TitleImage; //= $db->getField("Modules", "TitleImage", $album_id);
		$owner_id		= $g->OwnerId;
		$owner_table	= $g->OwnerTable;
		
		$timg 			= $db->getLine("*", "Images", "Id = '$title_image'");
		$count_images 	= $db->getFieldWhere("Images", "count(Id) as CountImages", "where AlbumId = $album_id");
		
		if($album_pageid)
		$alb = $db->getLine("Title, Source", "PageData", "PageId = $album_pageid and Lang = '".$this->lang."'");
		$xml='
			<album id="'.$album_id.'" count="'.$count_images.'" cursor="'.$cursor.'" step="'.$step.'" mode="'.$mode.'" viewmode="'.$vmode.'">
				
				<name>'.$g->Name.'</name>
				<session id="'.session_id().'">'.session_name().'</session>
				<url-params>
					<album id="'.$album_id.'">'.$album_name.'</album>
					<owner id="'.$owner_id.'">'.$owner_table.'</owner>
				</url-params>
				<title-image>
					<img id="'.$title_image.'" extension="'.$timg['Extension'].'">
						<localpath>'.$timg['LocalPath'].'</localpath>
					</img>
				</title-image>
				<title>'.$alb['Title'].'</title>
				<text>'.$alb['Source'].'</text>
				'.$this->pages->getPage($g->PageId, $this->CFG->lang, '', 3).'
				<images>
					'.$img_xml.'
				</images>
			</album>
		';
		
		return (
			$templ 
				? $this->xmlOut->qShow($this->CFG->xmlHeader.$xml, $templ, false) 
				: $xml
		);
	}

	function readDir($dir, $id, $templ=NULL){
		if(!($handle = opendir($dir))){
			print "<p>Can't open dir [$dir]</p>";
			return false;
		}
		while(false!==($file = readdir($handle))){
			$db = $this->DB;
			//print "<p>$dir/$file</p>";
			if ($file != "." && $file != ".."){
				$file=trim($file);
				if(is_dir($dir."/".$file)){
					$xml.='
						<dir name="'.$file.'">
							'.$this->readDir($dir."/".$file, $id).'
						</dir>
					';
				}
				else{
					//$path = preg_replace("|".$this->CFG->TempDir."|", "", $dir);
					//$path=$url;
					//$xml.='<file local="'.$path.'" ext="xml">'.$file.'</file>';
					
					$xml.='
						<image name="'.$name.'">
							<title></title>
							<comments topic="">
								
							</comments>
						</image>
					';
					
				}
			}
			
			
			if(is_numeric($edit)){
				$pageid = $db->getField("Categories", "PageId", $edit);
				$titles = $db->q("select Lang, Title from PageData where PageId = $pageid");
				while($t = mysql_fetch_array($titles)){
					$multiname.='
						<lang id="'.$t['Lang'].'">'.$t['Title'].'</lang>
					';
				}
				$fields = $db->getLine("FullPlaces, AddPlaces, CountOf, Measure", "Categories", "Id = $edit");
			}
			
			$xml='
				<images>
					'.$xml.'
				</images>
				<edit>
					<name>
						'.$multiname.'
					</name>
				</edit>
			';
		}

		//if(!$xml)$xml="<empty>empty</empty>";
		return (
			$templ 
				? $this->xmlOut->qShow($this->CFG->xmlHeader.$xml, $templ, true) 
				: $xml);
	}
	
	function newDir($basepath, $localpath){
		$arr = split("/", $localpath);
		if(!is_dir($basepath)) print "<p>Error! Incorrect file address [$basepath]</p>";
		else{
			$current_dir = $basepath.'/'.array_shift($arr);
			if(!is_dir($current_dir))mkdir($current_dir);
			if(($lp = join('/', $arr))!=='')$this->newDir($current_dir, $lp);
		}
	}

	function fw($txt){
		$fp = fopen ("../program/logs/add_album.txt", "a");
		$now = date("d.m.Y H:i");
		fwrite($fp, 
"[$now] $txt\n
"
		);
		fclose($fp);
	}
	
	function getObjPageId($owner_table, $owner_id){
		$db = $this->CFG->HDB;

		
		$root = $db->getFieldWhere("Pages", "Id", " where Rozdil = 0 and Name = '$owner_table'");
		if($res = $db->getFieldWhere("Pages", "Id", " where Rozdil = $root and Name = $owner_id"))
			return $res;
		else
			return $this->pages->addPage($owner_id, $root);
	}
	
	function addAlbum($name, $owner_table, $owner_id, $AlbumsPageId=NULL, $pagedata=NULL, $title_image=NULL){
		//print "[$name]";return false;
		$today = date("Y-m-d H:i");
		$db = $this->DB;
		if($a = mysql_fetch_array($db->q("select Id from Modules where Name = '$name' and OwnerTable = '$owner_table' and OwnerId = '$owner_id' and ModuleHandler='album'"))){
			print "[exists]";
			return $a['Id'];
		}
		else{
			//print "[add]";

			
			switch($owner_table){
				case "Users": $ObjPageId = $this->getObjPageId($owner_table, $owner_id); break;
				default: 
					if(  !($ObjPageId = $db->getField($owner_table, "PageId", $owner_id)) ){
						$ObjPageId = $this->getObjPageId($owner_table, $owner_id);
						$this->CFG->DB->q("update $owner_table set PageId = $ObjPageId where Id = $owner_id");
					}
				break;
			}
			
			//print "[".$this->pages->DB->dbName."]";
			//return false;
			
			$AlbPageId = $this->pages->addPage($name, $ObjPageId);
			$this->pages->setPageParam("PageHandler", "album", $AlbPageId);
			
			
			$q = "
				insert into Modules (
					ModuleHandler,
					Name, 
					OwnerTable, 
					OwnerId,
					PageId,
					Added,
					Updated,
					TitleImage
				) 
				values (
					'album',
					'$name',
					'$owner_table',
					$owner_id,
					$AlbPageId,
					'$today',
					'$today',
					'$title_image'
				)
			";
			$db->q($q);
			$AlbumId = $db->insId();
			if($pagedata){
				foreach($pagedata as $lang => $data){
					$this->pages->addData($AlbPageId, $pd['title'], $pd['source'], $lang);
				}
			}
			return $AlbumId;
		}
	}
	
	function upload($getvars, $postvars, $files){
	print "\n\n\n === UPLOADING === \n\n\n";
		if($tmp=$files['Filedata']['tmp_name']){
			
			$db 		= $this->DB;
			$today 		= $this->nowDate();
			$fname 		= uniqid();					// Set unique ID
			$owner		= $postvars["owner"];
			$owner_id	= $postvars["id"];
			$album 		= $postvars["album"];
			//$ftp		= $this->CFG->FTP;

	
			print "<p><strong>[$today]</strong></p>";
			$dir = $this->CFG->ImgDir;
	
			// *** Set individual parameters for album owners
			if(!$album)$album_name = "album";		// Set default album name
			else{ 
				$album_name = $this->DB->getField("Modules", "Name", $album, 1);
				//print "[".$db->getField("Modules","Id",5)."]";
			}
			print "<p>[Owner: $owner]<br/> [Album #$album name: $album_name]</p>";
			switch($owner){
				case "Objects" : 
					$owner_table="Objects";
					$img_dir="objects/$owner_id/albums/$album_name"; 
				break;
				case "Categories" :
					$owner_table="Categories";
					$objid = $db->getField("Categories", "ObjId", $owner_id);
					$img_dir="objects/$objid/categories/$owner_id/$album_name"; 
				break;
				case "Cities": 
					$owner_table="Cities";
					$img_dir="cities/$owner_id/albums/$album_name"; 
				break;
				case "Users": 
					$owner_table="Users";
					$img_dir="users/$owner_id/albums/$album_name"; 
				break;
				case "News": 
					$owner_table="News";
					$img_dir="news/$owner_id"; 
				break;
				default: print "Owner Undefined!"; return NULL; break;
			}
		
			// *** Create album if there is no one
			if(!$album){
				$data = array(
					"ua" => array("title" => "gallery"),
					"ru" => array("title" => "gallery"),
					"en" => array("title" => "gallery")
				);
				$album = $this->addAlbum($album_name, $owner_table, $owner_id, $AlbumsPageId, $data, $fname);
				$this->setTitleImage($album, $fname);
				$is_new_album = true;
			}
			else{
				$album_name = $db->getField("Modules", "Name", $album);
				$is_new_album = false;
			}

			$image_params = getimagesize($tmp);			// Detect file format and set extension
			switch($image_params[2]){
				case 1 : $ext="gif"; break;
				case 2 : $ext="jpg"; break;
				case 3 : $ext="png"; break;
				default: 
					print "Incorrect format";
					return false;
				break;
			}
			
			if(!$album_name){
				print "Album not found!";
				return false;
			}
			$img_path	= $img_dir."/$fname";
			print "<p>Image dir:[$img_dir]<br> Image path: [$img_path]</p>";
			// ************* If the site based on same server ************** //
			$this->newDir($dir, $img_path);
			$full_dir = $dir."/".$img_path;		
			
			//$full_dir = $dir."/".$fname;			// If we working only with FTP, we'll save files in temp dir, and then delete
			//$ftp_dir = $this->CFG->DataFtp;			// ftp
			//$ftp->newDir($ftp_dir, $img_path);		// ftp
			
			
			foreach($this->ImgSizes as $size_name => $size_params){
				if(!is_dir($full_dir)){
					mkdir ($full_dir, 0777);
				}
				$dest 	= $full_dir."/".$size_name.'.'.$ext;
				$ftp_dest = $ftp_dir."/".$img_path."/".$size_name.'.'.$ext;
				$this->img_resize($tmp, $dest, $size_params['width'], $size_params['height'], $size_params['quality'], $dest);
				print "<p>full path [$dest]</p>";
				$fp = fopen("log_upload.txt", "a");
				fwrite($fp, "uploaded [$dest] [".$size_params['width']."x".$size_params['height']."px]\n");
				//$ftp->putFile($dest, $ftp_dest);
			}
			
			//$this->delDir($full_dir);				// Delete uploaded images if we work only with FTP
			
			// Save original *[if wide hosting]/
			//$big 	= $dir."/orig/".$fname.'.'.$ext;
			//move_uploaded_file($tmp, $big);				
			
			
			// *** Register image to database
			$ObjPageId = $db->getField($owner_table, "PageId", $owner_id);
			$album_page = $db->getField("Modules", "PageId", $album);
			$img_page = $this->pages->addPage($fname, $album_page);
			$this->pages->setPageParam("PageHandler", "image", $img_page);
			print "<p>insert [$fname]</p>";
			$db->q("insert into Images (Id, AlbumId, PageId, Added, LocalPath, Extension) values ('$fname', $album, $img_page, '$today', '$img_dir', '$ext')");
			$db->q("update Modules set Updated = '$today' where Id = $album");
			
			
		}
		else print "Problem in upload [$fname.$ext] to [$dir]!\n";

	}
	
	function setTitleImage($album_id, $img_id){
		print "[$album_id, $img_id]";
		$this->DB->q("update Modules set TitleImage = '$img_id' where Id = $album_id");
	}

	function img_resize($filename, $smallimage, $w, $h, $qual, $ftp_dest=NULL) { 
		// Имя файла с масштабируемым изображением 
		$filename = $filename; 
		// Имя файла с уменьшенной копией. 
		$smallimage = $smallimage;     
		// определим коэффициент сжатия изображения, которое будем генерить 
		$ratio = $w/$h; 
		// получим размеры исходного изображения 
		$size_img = getimagesize($filename); 
		// Если размеры меньше, то масштабирования не нужно 
		if (($size_img[0]<$w) && ($size_img[1]<$h)){
			copy($filename, $smallimage);
			return true; 
		}
		// получим коэффициент сжатия исходного изображения 
		$src_ratio=$size_img[0]/$size_img[1]; 
		
		// Здесь вычисляем размеры уменьшенной копии, чтобы при масштабировании сохранились  
		// пропорции исходного изображения 
		if ($ratio<$src_ratio) 
		{ 
		$h = $w/$src_ratio; 
		} 
		else 
		{ 
		$w = $h*$src_ratio; 
		} 
		// создадим пустое изображение по заданным размерам  
		$dest_img = imagecreatetruecolor($w, $h);   
		$white = imagecolorallocate($dest_img, 255, 255, 255);        
		if ($size_img[2]==2)  $src_img = imagecreatefromjpeg($filename);                       
		else if ($size_img[2]==1) $src_img = imagecreatefromgif($filename);                       
		else if ($size_img[2]==3) $src_img = imagecreatefrompng($filename);  
		
		// масштабируем изображение     функцией imagecopyresampled() 
		// $dest_img - уменьшенная копия 
		// $src_img - исходной изображение 
		// $w - ширина уменьшенной копии 
		// $h - высота уменьшенной копии         
		// $size_img[0] - ширина исходного изображения 
		// $size_img[1] - высота исходного изображения 
		imagecopyresampled($dest_img, $src_img, 0, 0, 0, 0, $w, $h, $size_img[0], $size_img[1]);                 
		
		// сохраняем уменьшенную копию в файл  
		if ($size_img[2]==2)  imagejpeg($dest_img, $smallimage,$qual);                       
		else if ($size_img[2]==1) imagegif($dest_img, $smallimage);                       
		else if ($size_img[2]==3) imagepng($dest_img, $smallimage);  
		// чистим память от созданных изображений 
		imagedestroy($dest_img); 
		imagedestroy($src_img); 
		//$this->CFG->FTP->putFile($smallimage, $ftp_dest);
		return true;          
	}


	function getAlbumDir($owner_table, $owner_id, $album_name="album"){
		//print "<p>[$owner_table, $owner_id, $album_name]</p>";
		$db = $this->DB;
		switch($owner_table){
			case "Objects" : 
				$img_dir="objects/$owner_id/albums/$album_name"; 
			break;
			case "Categories" :
				$objid = $db->getField("Categories", "ObjId", $owner_id);
				$img_dir="objects/$objid/categories/$owner_id/$album_name"; 
			break;
			case "Cities": 
				$img_dir="cities/$owner_id/albums/$album_name"; 
			break;
			case "Users": 
				$img_dir="users/$owner_id/albums/$album_name"; 
			break;
			case "News": 
				$img_dir="news/$owner_id"; 
			break;
			default: return NULL;
		}
		$dir = $basepath.$img_dir;
		return $dir;
	}
	
	function delImage($id){
		if(!$id) return NULL;
		$db = $this->DB;
		$pages = $this->classHotelPages();
		$img_params = $db->getLine("Id, PageId, Topic, LocalPath, AlbumId", "Images", "Id = '$id'");
		$alb_params = $db->getLine("Name, OwnerTable, OwnerId", "Modules", "Id = ".$img_params['AlbumId']);
		
		$img_local_path = $this->getAlbumDir($alb_params['OwnerTable'], $alb_params['OwnerId'], $alb_params['Name'])."/".$id;
		
		$img_dir = $this->CFG->DataDir."/".$img_local_path;
		$ftp_dir = $this->CFG->DataFtp."/".$img_local_path;
		
		$this->delDir($img_dir);			// We no need this if working with FTP
		//$this->CFG->FTP->delDir($ftp_dir);

		$pages->delNode($img_params['PageId']);
		$db->q("delete from Images where Id = '$id'");
	}

	function delDir($path){
		//print "<p>delete Directory [$path]<br>";
		if(is_dir($path)){
			$dir = opendir($path);
			while($file = readdir($dir)){
				$fpath = $path."/".$file;
				if(is_file($fpath)){
					unlink($fpath);
					//print "Delete file [$fpath]<br>";
				}
				else if(is_dir($fpath) && $file!='.' && $file!='..'){
					$this->delDir($fpath);
				}
			}
			closedir($dir);
			rmdir($path);
		}
	}

	function delAlbum($id){
		$pages = $this->classHotelPages();
		$db = $this->DB;
		$line = $db->getLine("PageId, OwnerTable, OwnerId", "Modules", "Id = $id", $id);
		$PageId = $line['PageId'];

		$db->q("delete from Modules where Id = $id");
		$db->q("delete from Images where AlbumId = $id");
		//print "<p>delete page: [$PageId]<br>[$q]</p>";
		$pages->delNode($PageId);
		//$this->delDir($this->getAlbumDir($line['OwnerTable'], $line['OwnerId']));
		
		if($img_local_path = $this->getAlbumDir($line['OwnerTable'], $line['OwnerId'])){
			$img_dir = $this->CFG->DataDir."/".$img_local_path;
			$ftp_dir = $this->CFG->DataFtp."/".$img_local_path;
			$this->delDir($img_dir);			// We no need this if working with FTP
			//$this->CFG->FTP->delDir($ftp_dir);
		}
		else print "<p>Can't find album folder!</p>";
	}

	function delByOwner($owner_table, $owner_id){
		$db = $this->DB;
		$albums = $db->q("select * from Modules where OwnerTable='$owner_table' and OwnerId = $owner_id and ModuleHandler='album'");
		while($a = mysql_fetch_array($albums)){
			$this->delAlbum($a['Id']);
		}
	}

}

?>