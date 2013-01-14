

<HTML>
<HEAD>
</HEAD>
<BODY>

<b>GpsGate "GPS in browser" demo</b><br>
Make sure GpsGate is installed and started. Then click "GPS info".<br>
<br>

<div id="position"></div><br>
<br>

<div id="time"></div><br>
<br>

<form name="f1">
  <input value="GPS info" type="button" onclick='JavaScript:GpsGate.Client.getGpsInfo(CallbackMessage)' id=button1 name=button1>
</form>

<script type="text/javascript" src="http://localhost:12175/javascript/GpsGate.js"></script>

<script type="text/javascript">
  //<![CDATA[

	if (typeof(GpsGate) == 'undefined' || typeof(GpsGate.Client) == 'undefined')
	{
		alert('GpsGate not installed or not started!');
	}

  //That is the callback function that is specified in the request url and gets executed after the data is returned

	function CallbackMessage(gps)
	{
    if(gps.status.permitted == false)
    {
      alert('Request not permitted by user');
    }
    else
    {
      var resultTag = document.getElementById('position');
      resultTag.innerHTML = 'longitude:' + gps.trackPoint.position.longitude + ' latitude:' + gps.trackPoint.position.latitude;

      var d = new Date(gps.trackPoint.utc);

      resultTag = document.getElementById('time');
      resultTag.innerHTML = d.toLocaleString();
    }
	}

  //]]>
</script>

</BODY>
</HTML>

