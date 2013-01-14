<?

class Forum extends Modules{
	
	var $MNG;
	
	function Forum(){
		$this->inc();
		//$this->CFG->User->getUserDataById($id);
	}
	
	function Exec($name, $params=NULL){
		//print "[$name]";
		switch($name){
			case "show": 
				return $this->showByUri($this->uriVars['forum_topicid'], $this->uriVars['forum_pageid']); 
			break;
			case "showdir":
				if($topic_id = $this->getDirTopic($this->uriVars['forum_topicid'], $this->uriVars['forum_dir'])){
					return $topic_id == -1
							? '<closed />'
							: $this->showByUri( $topic_id , $this->uriVars['forum_pageid']);
				}else return '<topic id="'.$this->uriVars['forum_topicid'].'" dir="'.$this->uriVars['forum_dir'].'" level="1"/>';
			break;
			case "post":
				$this->postData($this->uriVars['forum_topicid'], $_POST);
			break;
			case "showall":
				return $this->showAll();
			break;
			case "notapproved":
				return $this->showAll();
			break;
		}
	}
	
	function findEmails($id, $arr=NULL){
		if(!is_array($arr))$arr = array();
		$db = $this->CFG->DB;
		if($m = mysql_fetch_object($db->q("select Id, Header, HostNode, Email, UserId, Username, Lang, Content from Msg where Id = $id"))){
			if($m->HostNode){
				if($m->UserId){
					$ud = $this->CFG->UserData->getArrById($m->UserId);
					if($ud->Username)$m->Username = $ud->Username;
					if($ud->Email)$m->Email = $ud->Email;
				}
				if($m->Email){
					$resp 	= $arr[0] ? $arr[0]['id'] : $m->Id;		// if we handling a first (index 0) element, than the respondent is same user
					array_push($arr, array(
						'id'		=> $m->Id,
						'email' 	=> $m->Email,
						'username'	=> $m->Username,
						'userid'	=> $m->UserId,
						'lang'		=> $m->Lang,
						'content'	=> $m->Content
					));
				}
				//if($m->Email)array_push($arr, $m->Email);
				return $this->findEmails($m->HostNode, $arr);
			}
			else return $arr;
		}//else return NULL;
	}
	
	
	function sendEmails($id){
		$arr 	= $this->findEmails($id);
		if(!$arr)return false;
		$mlist 	= array();
		list($owner_tbl, $owner_id)	= $this->getOwnerKey($id);
		$owner_tbl = strtolower($owner_tbl);
		$fmail = new SendMail();
		$fmail->Connect('forum');
		foreach($arr as $i => $vals){
			if(array_search($vals['email'], $mlist))continue;
			
			array_push($mlist, $vals['email']);
			$out='';
			$vals['respondent']	= $arr[0]['username'];
			$vals['domain']		= $this->CFG->Domain;
			$vals['postid']		= $vals['id'];
			$vals['ownertbl']	= $owner_tbl;
			$vals['ownerid']	= $owner_id;
			if($i){
				$vals['response'] = $arr[0]['content'];
				$msg = $this->cout('forum.mail.answer', 	$vals, $vals['lang']);
			}
			else {	
				if(!$vals['userid'])
					$msg = $this->cout('forum.mail.approved', 	$vals, $vals['lang']);
				else $msg = '';
			}
			if($msg && $vals['userid']!=$arr[0]['userid']){
				$fmail->smtpSend($vals['email'], 'forum@djerelo.info', $vals['domain'].' Forum', $msg);
				//print "<fieldset><legend>$i [id: ".$vals['id']."][email: ".$vals['email']."][lang: ".$vals['lang']."]</legend>$msg</fieldset>";
			}
		}
		$fmail->Disconnect();
	}
	
	function getOwnerKey($id){
		$data = $this->getRootData($id);
		list($tbl, $id) = split("_", $data->Header);
		return array($tbl, $id);
	}
	
	function getRootData($id){
		if(!$id)return false;
		$parent	= $this->findRoot($id);
		return mysql_fetch_object($this->CFG->DB->q("select * from Msg where Id = $parent"));
	}
	
	function getDirTopic($topic_id, $dir){
		$db = $this->CFG->DB;
		$obj = mysql_fetch_object($db->q("select Id, Approved, Header from Msg where HostNode = $topic_id and Header = '$dir' "));
		$app = $db->getField("Msg", "Approved", $topic_id);
		return $app == -1 ? -1 : $db->getFieldWhere("Msg", "Id", " where HostNode = $topic_id and Header = '$dir' ");
	}
	
	function findRoot($id){
		$db = $this->CFG->DB;
		if($m = mysql_fetch_object($db->q("select Id, Header, HostNode from Msg where Id = $id"))){
			if($m->HostNode) return $this->findRoot($m->HostNode);
			else return $m->Id;
		}else return NULL;
	}
	
	function showByUri($topic_id, $page=0, $step=10){
		if(!$page || $page == 1)$from = 0;
		else $from = $page*$step;
		
		return $this->showTopic($topic_id, array($from, $step));
	}
	
	function showByLevel($topic_id, $level){
		if(!$level)$level=1;
		return $this->showTopic($topic_id, NULL, $level);
	}
	function showList($topic_id, $templ){
		//print "[forum]";
		$xml = '
			<forum>
				'.$this->addXml.'
				'.$this->showTopic($topic_id).'
			</forum>
		';
		//print "<textarea style='width:500px; height:300px'>$xml</textarea>";
		return $this->xmlOut->qShow($this->CFG->xmlHeader.$xml, $templ, false);
	}
	
	function Del($id){
		$db = $this->CFG->DB;
		$qr = $db->q("select Id from Msg where HostNode = $id");
		while($msg = mysql_fetch_object($qr)){
			$this->Del($msg->Id);
		}
		$q = "delete from Msg where Id = $id";
		//print "$q<br>";
		$db->q($q);
	}
	
	function Approve($id){
		$this->CFG->DB->q("update Msg set Approved = 1 where Id = ".$id);
		$this->sendEmails($id);
	}
	
	function addTopic($table, $id, $header=''){
		$db = $this->CFG->DB;
		$q="insert into Msg (Username) values ('$table_$id')";
		$db->q($q);
		return $db->insId();
	}
	
	
	function checkValid($pv){
		$valid = $this->CFG->valid;
		$res = true;
		$pv	= $valid->formatContent($pv);
		$pv['phone']	= $valid->formatPhone($pv['phone']);
		if($userid = $this->CFG->DB->getFieldWhere('Msg', 'UserId', "where Username = '".$pv['name']."'")){
			if($userid != $this->CFG->UserData->Id)
				$this->CFG->SysMsg->Add('', 'error', 'forum.answers.bad.username.exists');
		}
		if($pv['email'] && !$this->CFG->valid->email($pv['email'])){
			$this->CFG->SysMsg->Add('', 'error', 'forum.answers.bad.email');
			$res = false;
		}
		if($phone && !$this->CFG->valid->phone($phone)){
			$this->CFG->SysMsg->Add('', 'error', 'forum.answers.bad.phone');
			$res = false;
		}
		if(!$pv['content']){
			$this->CFG->SysMsg->Add('', 'error', 'forum.answers.emptymsg');
			$res = false;
		}
		if(!$res)return NULL;
		else return $pv;
	}
	
	function postData($node, $pv, $approved=0){
		if(!$pv = $this->checkValid($pv))return false;
		$db = $this->CFG->DB;
		$name	= ($n = $pv['name']) ? $n : "Anonymous";
		$header	= $pv['header'];
		$title	= $pv['title'];
		$content= $pv['content'];
		$today	= date("Y-m-d H:i");
		$email	= $pv['email'];
		$phone	= $pv['phone'];
		$lang	= $pv['lang'];
		$userid = $this->CFG->UserData->Id;
		if(!$userid)$userid = 'null';
		if(!$approved)$approved=0;
		
		$parent = mysql_fetch_object($db->q("select * from Msg where Id = $node"));
		
		if($parent->Type == 'dir' && $parent->Header == 'book')
			$approved = 2;
		
		if($pv['mtype'] == 'complain'){
			$this->CFG->SysMsg->Add('', 'ok', 'forum.answers.complain.ok');
			$approved=3;
		}

		
		$q = "
			insert into Msg 
				(Username, Header, Title, Content, Created, HostNode, Approved, Email, Phone, UserId, Lang)
			values
				('$name', '$header', '$title', '$content', '$today', $node, $approved, '$email', '$phone', $userid, '$lang')
		";
		
		$db->q($q);
		$id = $db->insId();
		
		if($approved == 1)$this->sendEmails($this->CFG->DB->insId());
		//$this->Mail->SendStack('forum', $this->CFG->LocaleArr['forum.mail.reply'][$this->CFG->lang]);
		return $id;
	}
	
	function moveTo($topic, $msg, $recepient){
		$db = $this->CFG->DB;
		if(
		   !$topic || 
		   !$msg || 
		   !$recepient || 
		   !$db->getField("Msg", "Type", $topic) == 'root'
		)return false;
		
		
		if(!($recep_id = $db->getFieldWhere("Msg", "Id", "where HostNode = $topic and Header = '$recepient'"))){
			$db->q("insert into Msg set HostNode = $topic, Header = '$recepient', Type = 'dir'");
			$recep_id = $db->insId();
			//print "[$recep_id]";
		}
		if($recep_id!=$msg)
			$db->q("update Msg set HostNode = $recep_id where Id = $msg");
		else print "What are you doing?! Object can not be parent for his self! Want to kill me?";
	}
	
	function showTopic($topic_id, $limit=NULL, $level=1){
		if($topic_id===NULL)return false;
		$db = $this->CFG->DB;
		if(is_array($limit)){
			list($from, $step) = $limit;
			if(!$from)$from = 0; else $from-=$step;
			$lim_condition = "limit $from, $step";
			$topic_count = $db->getFieldWhere("Msg", "count(*)", "where Approved = 1 and HostNode = ".$topic_id);
			$num_pages = ceil($topic_count/$step); 
			if($num_pages > 1){
				for($i=1; $i<=$num_pages; $i++){
					$pos = $i*$step-$step;
					$to = $from+$step;
					if( ($pos >= $from) && ($pos < $to))$here = 'here="'.$i.'"';
					
					else $here = NULL;
					$pages.='<page '.$here.' >'.$i.'</page>';
				}
				$pages='<pages pos="'.$pos.'" count="'.$num_pages.'" step="'.$step.'">'.$pages.'</pages>';
			}
		}
		$conditions = "
			where HostNode = $topic_id
			$topic_cond
			order by Created desc, Id desc
			$lim_condition
		";
		
		$xml = '
			<topic id="'.$topic_id.'" level="'.$level.'" count="'.$topic_count.'">
				'.$this->showByCond($conditions, $level).'
				'.$pages.'
			</topic>
		';
		
		return $xml;
	}
	
	function showAll(){
		//return "<messages>".$this->msgTree(14756)."</messages>";
		$db = $this->CFG->DB;
		$msgs = $db->q("select Id, Header, Title, Content, Email from Msg where Approved != 1 and HostNode !=0 and Header not in ('all', 'book') order by Created desc");
		while($msg = mysql_fetch_object($msgs)){
			$xml.=$this->msgTree($msg->Id);
		}
		$xml="<messages>$xml</messages>";
		//print "<textarea>$xml</textarea>";
		return $xml;
	}
	
	function msgTree($id, $xml=''){
		$db = $this->CFG->DB;
		$lang = $this->CFG->lang;
		$msg = mysql_fetch_object($db->q("select * from Msg where Id = $id"));
		if($msg->HostNode){
			$msg = mysql_fetch_object($db->q("select * from Msg where Id = $id"));
			if($msg->UserId){
				$ud = $this->CFG->UserData->getArrById($msg->UserId);
				if($ud->Username)$username = $ud->Username;
				if($ud->Email)$msg->Email = $ud->Username;
			}
			$xml = '
				<msg id="'.$msg->Id.'" type="'.$msg->Type.'" approved="'.$msg->Approved.'">
					<user id="'.$msg->UserId.'">'.$msg->Username.'</user>
					<email>'.$msg->Email.'</email>
					<header><![CDATA['.$msg->Header.']]></header>
					<title><![CDATA['.$msg->Title.']]></title>
					<content><![CDATA['.$msg->Content.']]></content>
					'.$xml.'
				</msg>
			';
			$xml = $this->msgTree($msg->HostNode, $xml);
		}
		else{
			if(preg_match("/(.*)_(.*)/", $msg->Header, $regs)){
				$tbl 	= $regs[1];
				$objid 	= $regs[2];
				switch($tbl){
					case "Cities" : 
					case "Objects": 
						$obj = mysql_fetch_object($this->CFG->HDB->q("select Id, Title as Name, TypeId, Topic from $tbl left join PageData on $tbl.PageId = PageData.PageId and Lang = '$lang' where Id = $objid"));
					break;
					default : $dbname="skiworld"; break;
				}
				
				$xml='
					<obj tbl="'.$tbl.'" id="'.$objid.'" type="'.$obj->TypeId.'" topic="'.$obj->Topic.'">
						<name><![CDATA['.$obj->Name.']]></name>
						'.$xml.'
					</obj>
				';
			}
		}
		//print "<textarea>$xml</textarea>";
		return $xml;
	}
	
	function showByCond($conditions=NULL, $level){
		$db = $this->CFG->DB;
		$q = "
			select 
				Id, HostNode, Username, UserId, Header, Content, Created, Approved,
				Email, Phone, Title
			from Msg
			$conditions
		";
		$qr = $db->q($q);

		while($msg = mysql_fetch_object($qr)){
			if($level && $ans = $db->getFieldWhere("Msg", "count(*)", "where HostNode = ".$msg->Id)){
				$thread = 
					'<thread>
						'.$this->showTopic($msg->Id, NULL, $level+1).'
					</thread>';
			}else $thread = '';
			$msg->Content = preg_replace("/\\n/", "<br/>", $msg->Content);
			
			if($msg->UserId){
				$ud = $this->CFG->UserData->getArrById($msg->UserId);
				$msg->Username = $ud->Username;
			}
			
			$xml.='
				<msg id="'.$msg->Id.'" parent="'.$msg->HostNode.'" approved="'.$msg->Approved.'">
					<username><![CDATA['.$msg->Username.']]></username>
					<created><![CDATA['.$this->prettyDate($msg->Created).']]></created>
					<header><![CDATA['.$msg->Header.']]></header>
					<email><![CDATA['.$msg->Email.']]></email>
					<phone><![CDATA['.$msg->Phone.']]></phone>
					<title><![CDATA['.$msg->Title.']]></title>
					<content><![CDATA['.$msg->Content.']]></content>
					<answers>'.$ans.'</answers>
					'.$thread.'
				</msg>
			';
		}
		return $xml;
	}
}

?>