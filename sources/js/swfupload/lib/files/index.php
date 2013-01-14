<?php
	session_start();

	if (count($_FILES)) {
        // Handle degraded form uploads here.  Degraded form uploads are POSTed to index.php.  SWFUpload uploads
		// are POSTed to upload.php
	}

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<title>SWFUpload Demos - Multi-Instance Demo</title>
<link href="http://hotcat.zelenyuk.com/swfupload/lib/css/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="http://hotcat.zelenyuk.com/swfupload/lib/swfupload/swfupload.js"></script>
<script type="text/javascript" src="http://hotcat.zelenyuk.com/swfupload/lib/swfupload/swfupload.queue.js"></script>
<script type="text/javascript" src="http://hotcat.zelenyuk.com/swfupload/lib/files/js/fileprogress.js"></script>
<script type="text/javascript" src="http://hotcat.zelenyuk.com/swfupload/lib/files/js/handlers.js"></script>
<script type="text/javascript" src="http://hotcat.zelenyuk.com/swfupload/lib/files/js/definitions.js"></script>
</head>
<body>
<div id="header">
	<h1 id="logo"><a href="/swfupload/lib/">SWFUpload</a></h1>
	<div id="version">v2.2.0</div>
</div>
<div id="content">
	<h2>Multi-Instance Demo</h2>
	<form id="form1" action="index.php" method="post" enctype="multipart/form-data">
		<p>This page demonstrates how multiple instances of SWFUpload can be loaded on the same page.
			It also demonstrates the use of the graceful degradation plugin and the queue plugin.</p>
		<table>
			<tr valign="top">
				<td>
					<div>
						<div class="fieldset flash" id="fsUploadProgress1">
							<span class="legend">Large File Upload Site</span>
						</div>
						<div style="padding-left: 5px;">
							<span id="spanButtonPlaceholder1"></span>
							<input id="btnCancel1" type="button" value="Cancel Uploads" onclick="cancelQueue(upload1);" disabled="disabled" style="margin-left: 2px; height: 22px; font-size: 8pt;" />
							<br />
						</div>
					</div>
				</td>
				<td>
					<div>
						<div class="fieldset flash" id="fsUploadProgress2">
							<span class="legend">Small File Upload Site</span>
						</div>
						<div style="padding-left: 5px;">
							<span id="spanButtonPlaceholder2"></span>
							<input id="btnCancel2" type="button" value="Cancel Uploads" onclick="cancelQueue(upload2);" disabled="disabled" style="margin-left: 2px; height: 22px; font-size: 8pt;" />
							<br />
						</div>
					</div>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>
