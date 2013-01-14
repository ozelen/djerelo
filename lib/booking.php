<?

class Booking extends HotCat{
	function Booking(){
		$this->inc();
	}
	function Exec($name, $params=NULL){
		parse_str($params, $p_arr);
		switch($name){
			case 'form': return $this->Form(); break;
			case 'send': return $this->Send(); break;
		}
	}
	
	function additionalInfo($area_name, $area_id){
		$area_id = $this->arId($area_name, $area_id);
		
		$obj = new Objects();
		$cty = new Cities();
		switch($area_name){
			case "Objects": 
				$add_xml = $obj->cutShow($area_id);
			break;
			case "Settlements": 
				$add_xml = 
					$cty->Show($area_id).
					$obj->fastList(array('cityid'=>$area_id))
				;
			break;
			case "All": 
				$add_xml = $cty->lcSettlementListByDomain(array('domain' => $this->CFG->Domain));
				$name = '<name>all</name>';
			break;
			default: return false; break;
		}
		
		return 
			'<area id="'.$area_id.'">'.
				'<table>'.$area_name.'</table>'.
				'<name><![CDATA['.$this->getName($area_name, $area_id).']]></name>'.
			'</area>'.
			$add_xml;
	}
	
	function arId($tname, $area_id){
		if(!is_numeric($area_id))$area_id = $this->CFG->HDB->getIDbyIdent($tname, $area_id);
		return $area_id;
	}
	
	function Form(){
		
		$area_name 	= $this->uriVars['area_name'];
		$area_id 	= $this->arId($area_name, $this->uriVars['area_id']);
		
		$xml = '
			<booking-form mode="clean">
				'.$this->additionalInfo($area_name, $area_id).'
			</booking-form>
		';
		//dbg("$xml");
		//print "<textarea>$xml</textarea>";
		return $xml;
	}
	
	function Send(){
		//print $_POST['keystring']." == ".$_SESSION['captcha_keystring']."<br/>";
		//foreach($_POST as $key=>$val){print "$key=>$val<br>";}
		$pv = $this->CFG->PostVars;
		$valid = $this->CFG->valid;
		$errors = array();
		$phone = $valid->formatPhone($pv['Phone']);
		$fmail = new SendMail();
		$fmail->Connect('info');
		$names = array();
		
		$pv	= $valid->formatContent($pv);
		
		// Validation form
		if($_POST['keystring'] != $_SESSION['captcha_keystring']) $errors[$i++] = 'forms.captcha.incorrect';
		if(!$pv['Name']) $errors[$i++] = 'booking.form.incorrect.name';
		if(!$valid->email($pv['Email'])) $errors[$i++] = 'booking.form.incorrect.email';
		if($phone && !$valid->phone($phone)) $errors[$i++] = 'booking.form.incorrect.phone';
		if(!strtotime($pv['Arrival']) || !strtotime($pv['Departure'])) $errors[$i++] = 'booking.form.incorrect.dates';
		
		//print "[".strtotime($pv['Arrival']).' - '.strtotime($pv['Departure'])."]<br>";
		
		foreach($errors as $id){
			$this->CFG->SysMsg->Add('', 'error', $id);
		}
		
		$mode = $i ? 'retry' : 'ok';
		//$mode = 'retry';
		
		
		foreach($pv as $k=>$v){
			switch($k){
				case 'settlement'	: $st_id 	= $v; $names[0] = ($v == 'all') ? $v : $this->getName('Settlements', $pv[$k]); break;
				case 'profile'		: $prof_id 	= $v; $names[1] = ($v == 'all') ? $v : $this->getClassName($pv['profile']); break;
				case 'type'			: $type_id 	= $v; $names[2] = ($v == 'all') ? $v : $this->getClassName($pv['type']); break;
				case 'object'		: $obj_id 	= $v; $names[3] = ($v == 'all') ? $v : $this->getName('Objects', $pv[$k]); break;
			}
		}
		$path = join(' / ', $names);
		$pv['path']	= $path;
		
		if(!$i){
			$lng = "<br />[".$this->CFG->lang."]";
			$this->CFG->SysMsg->Add('', 'ok', 'booking.added');
			$msg = $this->cout('booking.mail.request', $pv, 'ua');
			$sms = $this->cout('booking.mail.request.sms', $pv, 'ua');
			//print "<textarea>$msg</textarea>";
			$fmail->smtpSend('rsv@djerelo.info', 'rsv@djerelo.info', "Booking request from Djerelo.Info", $msg);
			$fmail->smtpSend('vivat@ukrpost.ua', 'rsv@djerelo.info', "Booking request from Djerelo.Info", $msg);
			$fmail->smtpSend('sms@djerelo.info', 'rsv@djerelo.info', "Booking", $sms);
			//$fmail->smtpSend('vivat@ukrpost.ua', 'rsv@djerelo.info', "Booking", $sms);
		}
		
		//else print "[$i]";
		$xml = '
			<booking-form mode="'.$mode.'">
				'.$this->additionalInfo($pv['area_name'], $pv['area_id']).'
				<time>'.date("d.m.Y H:i").'</time>
				<name><![CDATA['.$pv['Name'].']]></name>
				<email><![CDATA['.$pv['Email'].']]></email>
				<phone><![CDATA['.$phone.']]></phone>
				<arrival><![CDATA['.$pv['Arrival'].']]></arrival>
				<departure><![CDATA['.$pv['Departure'].']]></departure>
				<adults><![CDATA['.$pv['Adults'].']]></adults>
				<children><![CDATA['.$pv['Children'].']]></children>
				<comments><![CDATA['.$pv['Comments'].']]></comments>
				<settlement id="'.$pv['settlement'].'">'.$names[0].'</settlement>
				<profile id="'.$pv['profile'].'">'.$names[1].'</profile>
				<type id="'.$pv['type'].'">'.$names[2].'</type>
				<object id="'.$pv['object'].'">'.$names[3].'</object>
				<path>'.$path.'</path>
			</booking-form>
		';
		
		//print "<textarea>$xml</textarea>";
		
		return $xml;
	}

}

?>