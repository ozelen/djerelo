		var upload1, upload2;

		function makeUpload2(ftypes){
			upl = new SWFUpload({
				// Backend Settings
				upload_url: "/program/actdata.php?table=Gallery&mode=upload",
				post_params: {"PHPSESSID" : CURRENT_SESSION},

				// File Upload Settings
				file_size_limit : "2000",	// 200 kb
				file_types : ftypes,
				file_types_description : "Image Files",
				//file_upload_limit : "10",
				//file_queue_limit : "500",

				// Event Handler Settings (all my handlers are in the Handler.js file)
				file_dialog_start_handler : fileDialogStart,
				file_queued_handler : fileQueued,
				file_queue_error_handler : fileQueueError,
				file_dialog_complete_handler : fileDialogComplete,
				upload_start_handler : uploadStart,
				upload_progress_handler : uploadProgress,
				upload_error_handler : uploadError,
				upload_success_handler : uploadSuccess,
				upload_complete_handler : uploadComplete,

				// Button Settings
				button_image_url : "/swfupload/lib/files/XPButtonUploadText_61x22.png",
				button_placeholder_id : "spanButtonPlaceholder2",
				button_width: 61,
				button_height: 22,
				
				// Flash Settings
				flash_url : "/swfupload/lib/swfupload/swfupload.swf",

				swfupload_element_id : "flashUI2",		// Setting from graceful degradation plugin
				degraded_element_id : "degradedUI2",	// Setting from graceful degradation plugin

				custom_settings : {
					progressTarget : "fsUploadProgress2",
					cancelButtonId : "btnCancel2"
				},

				// Debug Settings
				debug: true
			});
			return upl;
		}

		window.onload = function() {
			upload2 = makeUpload2("*.jpg;*.gif;*.png");
			//upload2.onclick = function{alert('Click');}
	     }
		 
	function modifyUplParams(swfu){
			 swfu.setUploadURL("/tst.php?fname=its_alive");
			 swfu.addPostParam("bla","bla bla");
	}