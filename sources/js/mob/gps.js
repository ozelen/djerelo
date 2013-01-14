//alert('gps');


	$(document).ready(
		function(){
			if (typeof(GpsGate) == 'undefined' || typeof(GpsGate.Client) == 'undefined'){
				alert('GpsGate not found!');
			} else 
			GpsGate.Client.getGpsInfo(CallbackMessage);
		}
	);
	function CallbackMessage(gps){
	    if(gps.status.permitted == false){
	      alert('Request not permitted by user');
	    }
	    else{
	    	var lng = gps.trackPoint.position.latitude;
	    	var lat = gps.trackPoint.position.longitude;
	    	var alt = gps.trackPoint.position.altitude;
	    	var tim = Date(gps.trackPoint.utc);
	    	$('input#lng').val(lng);
	    	$('input#lat').val(lat);
	    	$('input#alt').val(alt);
	    	$('input#tim').val(tim);
	    	$('div#geodata').html('geo: ('+lat+':'+lng+', '+alt+'m) '+tim);
	    }
	}

