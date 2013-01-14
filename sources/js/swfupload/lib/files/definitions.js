		var upload1, upload2;

		//alert('swfupload');

		function makeSwfUpload(ftypes, uid, sessid){
			var holder_btn_id	 	= 'uplbutton_'+uid;
			var progress_btn_id		= 'uplprogress_'+uid;
			var cancel_btn_id 		= 'cancel_'+uid;
			var gallery_div			= $('#gallery_input_'+uid);
			var gallery_win			= $('#gallery_win_'+uid);
			gallery_div.html('');
			
			
			gallery_div.append('<div class="fieldset flash" id="'+progress_btn_id+'"><span class="legend"></span></div>');
			gallery_div.append('<div><span id="'+holder_btn_id+'"></span><input id="'+cancel_btn_id+'" type="button" value="Cancel Uploads" onClick="cancelQueue(upload2);" disabled="disabled" style="margin-left: 2px; height: 22px; font-size: 8pt; display:none" /></div>');
			
			galRefresh(gallery_win, uid);
			uplWin(uid);
			
			var upl = new SWFUpload({
				// Backend Settings
				upload_url: "/program/editalbum.php?mode=upload&album="+uid,
				post_params: {
					"PHPSESSID" : sessid,
					owner: $('#gallery_win_'+uid).find("input[name='owner_tbl']").val(),
					id: $('#gallery_win_'+uid).find("input[name='owner_id']").val(),
					album: uid
				},

				// File Upload Settings
				file_size_limit : "2 MB",	// 2 mb
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
				upload_complete_handler : function(){galRefresh(gallery_win, uid)},

				// Button Settings
				button_image_url : "/js/swfupload/lib/files/XPButtonUploadText_61x22.png",
				button_placeholder_id : holder_btn_id,
				button_width: 61,
				button_height: 22,
				
				// Flash Settings
				flash_url : "/js/swfupload/lib/swfupload/swfupload.swf",

				swfupload_element_id : "flashUI2",		// Setting from graceful degradation plugin
				degraded_element_id : "degradedUI2",	// Setting from graceful degradation plugin

				custom_settings : {
					progressTarget : progress_btn_id,
					cancelButtonId : cancel_btn_id
				},

				// Debug Settings
				debug: true
			});
			/*
			upl.addPostParam('owner', owner);
			upl.addPostParam('id', id);
			upl.addPostParam('album', album);
			*/
			return upl;
		}
		
		
		function uplWin(uid){
			var win = $('#gallery_win_'+uid);
			var params = {
				modal:true,
				width:800,
				height:550,
				buttons:{
					'Close': function(){
						$(this).dialog('close');
					}
				}
			}
			win.dialog(params);
		}
		


/*
		window.onload = function() {
			upload2 = makeUpload2("*.jpg;*.gif;*.png");
			//upload2.onclick = function{alert('Click');}
	     }
		 */
	function modifyUplParams(swfu){
			 swfu.setUploadURL("/tst.php?fname=its_alive");
			 swfu.addPostParam("bla","bla bla");
	}