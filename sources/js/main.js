// JavaScript Document

$(document).ready(
	function(){
		
	$('.dropmenu').live('mouseenter', function(){$(this).find('.menuset').show()});
	$('.dropmenu').live('mouseleave', function(){$(this).find('.menuset').hide()});
	//$('.buttonbar').addClass('ui-state-default widget-header ui-corner-all');
	/*
	$('.btn-widget').live('mouseenter', function(){$('this').addClass('ui-state-hover');});
	$('.btn-widget').live('mouseleave', function(){$('this').removeClass('ui-state-hover');});
	$('.btn-widget').live('mouseleave', function(){$('this').removeClass('ui-state-hover');});
	*/
	
	$("a.ajax").live('click', function(){
		var target = $('#'+$(this).attr('target'));
		$.post($(this).attr('href'), function(data){target.html(data); defAll();});
		return false;
	});
	
	$("a.aj").live('click', function(){
		var target = $($(this).attr('target'));
		$.post($(this).attr('href'), function(data){target.html(data)});
		return false;
	});
	
	$("a.forumpage_link").live('click', function(){putFormBack()});
	
	$("a.forumpage_link").live('click', function(){
		var target = $(this).closest('div.ui-tabs-panel');
		$.post($(this).attr('href'), function(data){target.html(data)});
		return false;
	});
	
	$('#nzSearchForm').submit(function(){if(!$('#nzSearchTarget').val()){
	//	alert('You should select one item to continue!'); 
		alert('Начните вводить название отеля или курорта, затем выберите элемент в выпадающем списке'); 
		return false;
	}});

	
	// social networks
	// likes
	// vkontakte
					$(".vk_like").each(function(){
						VK.Widgets.Like($(this).attr('id'), {type: "mini"}, $(this).attr('objid'));
						//alert($(this).attr('objid'));
					});
	
	
		
		function gogo(){
			$.post($(this).attr('href'), 
			   {rand: 1},
			   function(data){
					//alert('yes');
					$("#msgArea").html(data);
			});
			//$('div.pagesplit a').live('hover', gogo);
			return false;
		}
		
		//$('div.pagesplit a').live('click', gogo);
		
		
		$('div.add-comment').live('click', function(){
			var formdiv = $(this).find('.input-form');
			if(formdiv)formdiv.slideDown(150);
			//formdiv.submit(function(){formdiv.delay(800).slideUp(150);});
		});
		
		$('.ddMenuDiv').hover( 
			function(){
				$(this).find('.dropdown').slideDown(150);
			},
			function(){
				$(this).find('.dropdown').slideUp(150);
			}
		)
		
		
		$('.li_accord a.dropdown').bind('click', function(){
			$(this).parent().parent().find('div').slideToggle();
			return false;
		});
		$('.li_accord').bind('click', function(){
			$(this).find('div').slideToggle();
		});
		$('.li_accord').hover(
			function(){
				$(this).addClass("hover")
			},
			function(){
				$(this).removeClass("hover")
			}
		);
		
		$('.accordion').accordion();
		$('.accordion-closed').accordion({event: "click hoverintent", active: false, autoHeight: false, clearStyle: true});
	
		$("a.forum-append-form").live('click', function(){forumAnswer($(this)); return false;});
		$("a.once").live('click', function(){$(this).hide();});
		
		$('form.ajax').submit(function(){submitForm($(this)); return false});
		$('form.ajax').live('submit', function(){submitForm($(this)); return false});
		
		$('form.addperiod').submit(function(){submitForm($(this), addPeriod); return false});
		

		
		//$("a.winhref").live('click', function(){winHref($(this).attr('target'), $(this).attr('href'))});
		
		setDjereloMyCounter();
		
		$('.winButton').each(function(){
			$(this).before('<button class="button" onclick="win(\''+$(this).attr('id')+'\')">'+$(this).attr('title')+'</button>');
			$('button').button();
			$(this).hide();
		});
		
		// toolbar menu
		$('.toolbar li').live('click', function(){
			setTools($(this));
		});
		
		defAll();	
		
		$('.forum_tabs').tabs({selected: -1 ,load: function(){defAll()}});
		$('.forum_tabs.ui-tabs.ui-widget.ui-widget-content.ui-corner-all').css('padding-top', '2px');
		
		$('.categories.closed').live('mouseenter', function(){$(this).addClass("ui-state-hover")});
		$('.categories.closed').live('click', function(){openCategory($(this))});
		$('.categories.closed').live('mouseleave', function(){$(this).removeClass("ui-state-hover")});
		
		
		$('select.dropdownperiods').change(function(){
			var form = $('input[name=perid]');
			form.val($(this).selected().val());
			form.submit();
			$('button.open').show();
			$('button.save').hide();
		});
		
		priceEditMode();
		
		//locFindDefine();
		//.siblings()
		
		$( ".radio input[type=radio]" ).change(function(){$(this).closest('form').submit()});
		
		$('table.zebra tr').live('mouseenter', function(){$(this).addClass('ui-state-hover')})
		$('table.zebra tr').live('mouseleave', function(){$(this).removeClass('ui-state-hover')})

		$('table.zeb tr:odd').addClass('table_odd');

		$(".titext").css({"height": "200px", "overflow":"auto"});


// *******
// Bookit search form

		$( "#nzSearch" ).autocomplete({

			source: function( request, response ) {
				//alert('2, ['+request.term+']');
				$.get(
						'/plugins/bookit/ajax.php',
						{param : {input: request.term},	controller: 'search', method : 'GetRegionalSuggestList'},
						function(data){
							response( $.map( data.results , function( item ){
								return {
									label: item.value + " (" + item.info + ")",
									value: item.value,
									id: item.id
								}
							}));
						}, "json"
				);
			},
			minLength: 2,
			select: function( event, ui ) {
				//alert('selected'+ui.item.value);
				$("#nzSearchName").val(ui.item.value);
				$("#nzSearchTarget").val(ui.item.id);
			},
			open: function() {
				$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
			},
			close: function() {
				$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" ).removeClass( "ui-autocomplete-loading" );
			}
		});

		var dates = $( "#nzArrival, #nzDeparture" ).datepicker({
			defaultDate: "+1w",
			changeMonth: true,
		//	numberOfMonths: 2,
			minDate: 0,
			maxDate: +300,
			dateFormat: 'dd.mm.yy',
			onSelect: function( selectedDate ) {
				var option = this.id == "nzArrival" ? "minDate" : "maxDate",
					instance = $( this ).data( "datepicker" ),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		});

// ********

	}
);

// *** LOCATIONS
function locLog( message ) {
	$("#locLog").html(message);
	//$( "#locLog" ).attr( "scrollTop", 0 );
}
function locFindDefine(){
		//alert('1');
		$( "#city, .cityfinder" ).autocomplete({
			source: function( request, response ) {
				//alert('2, ['+request.term+']');
				var inp = $(this);

				$.ajax({
					url: "/program/geo.php?mode=search",
					dataType: "json",
					type: "POST",
					data: {str: request.term},
					success: function( data ) {
						//alert($(this).attr('url'));
						//alert('3');
						response( $.map( data.settlements, function( item ) {
							return {
								label: item.name + " (" + (item.district ? ", " + item.district + ", " : "") + item.region + ")",
								value: '',
								id: item.id,
								name : item.name
							}
						}));
					}
				});
			},
			minLength: 2,
			select: function( event, ui ) {
				//alert($(this).attr('idinp'));
				var inp = $(this);
				var idinp = $('#'+inp.attr('idinp'));
				var logs = $('#'+inp.attr('log'));
				locLog( ui.item ?
					ui.item.label :
					"Nothing selected, input was " + this.value);
					$("#cityid").val(ui.item.id);
					inp.val('');
					idinp.val(ui.item.id);
					logs.html(ui.item.label);
			},
			open: function() {$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );},
			close: function() {	$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" ).removeClass( "ui-autocomplete-loading" );}
		});


		$( ".objfinder" ).autocomplete({
			source: function( request, response ) {
				//alert('2, ['+request.term+']');
				var inp = $(this);

				$.ajax({
					url: '/program/search.php?mode=objects', //"/program/geo.php?mode=search",
					dataType: "json",
					type: "POST",
					data: {str: request.term},
					success: function( data ) {
						//alert($(this).attr('url'));
						//alert('3');
						response( $.map( data, function( item ) {
							return {
								label: item.name + " (" + item.city.name + ", " + item.type.name + ")",
								value: '',
								id: item.id,
								name : item.name
							}
						}));
					}
				});
			},
			minLength: 2,
			select: function( event, ui ) {
				//alert($(this).attr('idinp'));
				var inp = $(this);
				var idinp = $('#'+inp.attr('idinp'));
				var logs = $('#'+inp.attr('log'));
				locLog( ui.item ?
					ui.item.label :
					"Nothing selected, input was " + this.value);
					$("#cityid").val(ui.item.id);
					inp.val('');
					idinp.val(ui.item.id);
					logs.html(ui.item.label);
			},
			open: function() {$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );},
			close: function() {	$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" ).removeClass( "ui-autocomplete-loading" );}
		});

}
// *** LOCATIONS


function openCategory(elt){
	elt.find('.details').slideDown(); 
	elt.removeClass('closed ui-state-hover ui-state-default'); 
	elt.addClass('ui-widget-content');
}

function priceEditMode(){
	$('div.pricetable').each(function(){
		var parent 	= $(this);
		var header 	= parent.find('.headerpanel');
		var b_open 	= parent.find('button.open');
		var b_save 	= parent.find('button.save');
		var content	= parent.find('div.content');
		var form 	= parent.find('form.sendprice');
		var fields 	= parent.find('tr.edit');
		var refr	= parent.find('form.refreshpricetable');
		var loader = parent.find('.ajax_loader.refresh');
		
		b_save.hide(); 
		fields.hide();

		b_open.live('click', 
			function(){
				var fields 	= parent.find('tr.edit');
				b_open.hide();
				b_save.show(); 
				fields.show();
			}
		);
		
		form.live('submit', function(data){
			// fields.hide(); b_open.show();
			b_save.hide(); 
			$.ajax({
				type		: 'POST',
				url			: form.attr('action'),
				data		: form.serialize(),
				success		: function(){
								b_open.show();
								fields.hide();
								refr.submit();
								loader.fadeOut();
								if(parent.hasClass('total')){
									var total	= $('form.refreshpricetable.total');
									refr.submit();
									total.submit();
								}else{
									$('form.refreshpricetable').each(function(){$(this).submit()});
								}
							  },
				beforeSend	: function(){loader.fadeIn();}
			});
			return false;
		});
	});
	
	$('form.refreshpricetable').live('submit', function(){
		var form = $(this);
		var parent = form.closest('div.pricetable');
		var content	= parent.find('div.content');
		var loader = parent.find('.ajax_loader.refresh');
		$.ajax({
			type		: 'POST',
			url			: form.attr('action'),
			data		: form.serialize(),
			success		: function(data){
							loader.fadeOut();
							content.html(data);
						  },
			beforeSend	: function(){loader.show();}
		});
		return false;
	})
}



function closeCategory(elt){
	
}


//$('a.ajax').ajaxStart(function(){alert('ajax'); putFormBack()});
function forumAdd(anch){
	var form_temp = $('#forum-temp-form');
	form_temp.prependTo(form_div);
}


function forumAnswer(anch){
	var form_temp 	= $('#forum-temp-form');
	var form 		= form_temp.find('form');
	var msg 		= anch.closest('div.msg');
	var childs 		= msg.next('div.childs');
	var form_div 	= msg.find('div.frm');
	var inst 		= form_temp.find('.instructions');
	//alert(form.length);
	
	form_temp.prependTo(form_div);
	
	form_temp.find('.form_title').html(anch.html());
	form.attr('target', form_div.attr('id'));
	form.find('input[name=topic]').val(msg.attr('id'));
	form.find('input[name=level]').val(msg.attr('level'));
	form.find('input[name=dir]').val(msg.attr('folder'));
	form.find('input[name=mtype]').val(anch.attr('href'));
	inst.html($('#'+anch.attr('href')).html());
	
	if(title_html = msg.find('.title').html()){
		form.find('input[name=title]').val('RE: '+title_html);
	}else form.find('input[name=title]').val('');
	
	// highlight link
	lnkHighlight(anch);
	form.unbind();
	form.bind('submit', function(){
		var thisform = $(this);
		$.post(
			thisform.attr('action'),
			thisform.serialize(),
			function(data){
				inst.html(data);
				if(!inst.find('.sysmsg_error').length){
					putFormBack();
					form_div.html(data);
				}
			}
		);
		return false;
	});
	return false;
}

function lnkHighlight(anch){
	$('a.ui-state-highlight.ui-corner-top.highlight-link').removeClass('ui-state-highlight ui-corner-top highlight-link');
	anch.addClass('ui-state-highlight ui-corner-top highlight-link');
}

function putFormBack(){
	//alert('form go home');
	$('#forum-temp-form').prependTo('#forum-form-place');
	$('#forum-temp-form input[type!=hidden], textarea').val('');
	lnkHighlight($('a.neverfindlink'));
}

function submitForm(current, fn){
	var win = current.closest('.win');
	var form_data = $.param(current.serializeArray());
	var method = current.attr('method') || 'post';
	var target;
	var fn = fn || function(){}
	if(current.attr('target')!=''){
		target = $('#'+current.attr('target'));
	}else target = $('emptyDiv');
	$.ajax({
		type: 		'POST',
		url:		current.attr('action'),
		data:		form_data,
		//dataType:	current.attr('datatype') || 'html',
		success:	function(data){
			//alert(current.attr('action')+' \n['+data+']');
			target.html(data);
			defAll();
			
			if(current.hasClass('clearaftersubmit')){
				current.find('input[type!=hidden], textarea').val('');
			}
			fn(data);
			//win.dialog('close');
		}
	});
}

function setDjereloMyCounter(){
	my_id = 10892;
	my_width = 88;
	my_height = 41;
	my_alt = "MyCounter";
}

function defAll(){
	//var form_data = $(this).closest('form').serialize();
	$('.tabs').tabs({
		spinner: 'Retrieving data...',
		load: function(){defAll()}
	});
	$('.tabs_scroll').tabs({
		//panelTemplate: '<li></li>',
		load: function(){defAll()}
	});
	
	$('.icons li').hover(function(){$(this).addClass('ui-state-hover');}, function(){$(this).removeClass('ui-state-hover');});
	$('.icon').hover(function(){$(this).addClass('ui-state-hover');}, function(){$(this).removeClass('ui-state-hover');});
	
	myMenu();
	perMenu();
	Periods();
	
	$("a.zoom").fancybox();
	
	
	$('table.zebra tr:odd').addClass('odd');
	
	
	$('input.button').button();
	
	$('ul.catPriceList li:not(:first-child)').hide();
	
	$( ".radio" ).buttonset();
	
	$(".buttonset").buttonset();
	
		$( "button, input:submit, a.btn").each(function(){
			$(this).button({
				icons:{
					primary: $(this).attr('ico'),
					secondary: $(this).attr('ico2')
				}
			})
		});
	
	locFindDefine();
	datePickerPares();
	
	//$( ".tabs" ).tabs( "option", "ajaxOptions", { beforeSend: function(){alert('wtf?');} } );
}




function Periods(){
	// datepickers for add period dialog
	var dates = $( "#addPerFrom, #addPerTo" ).each(function(){
		var elt = $(this);
		var id = elt.attr('id');
		var altid = id+'_alt';
		//if(!$('#'+altid).length){
		//elt.after('<input name="'+id+'" id="'+altid+'>');
		//length}
		$(this).datepicker({
			defaultDate: "+1w",
			changeMonth: true,
			dateFormat: 'dd.mm.yy',
			altField: '#'+altid,
			altFormat: 'yy-mm-dd',
			numberOfMonths: 2,
			onSelect: function( selectedDate ) {
				var option = this.id == "addPerFrom" ? "minDate" : "maxDate",
					instance = $( this ).data( "datepicker" );
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		})
	});
}

function datePickerPares(){
	var dates = $('.datePare').each(function(){
		//alert('pare');
		//$(this).val('#'+$(this).attr('link'));
		var current = $(this);
		var lnk = $('#'+current.attr('link'));
		$(this).datepicker({
			defaultDate: "+3d",
			changeMonth: true,
			dateFormat: 'dd.mm.yy',
			numberOfMonths: 2,
			onSelect: function (selectedDate){
				var option = $(this).hasClass('begin') ? "minDate" : "maxDate", 
					instance = $( this ).data( "datepicker" ),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings );
					//lnk.val('chg');
					lnk.datepicker( "option", option, date );	
					//alert('changed [#'+lnk.val()+']: '+option+':'+date);
			}
		});
	});



}


// ***  TOOLBARS ***
function setTools(button){
	var setting = button.attr('setting');
	var ul = button.closest('ul.toolbar');
	var parent = button.closest('div.control-area');
	var submenu = parent.find('.submenu')
	var actmenu = submenu.find('ul.'+setting);
	var zone = parent.find('.actzone');
	
	if(!button.hasClass('not-glue')){
		button.addClass('ui-state-active');
	}
	submenu.find('ul').hide();
	actmenu.show();
	button.siblings().removeClass('ui-state-active');
	button.siblings().each(function(){switchTool(zone, $(this), 'off');});
	switchTool(zone, button, 'on');
}

function switchTool(zone, button, param){
	var setting = button.attr('setting');
	//alert(setting+' '+param);
	var ul = zone.find('ul.control-list');
	var li = zone.find('li.control-element');
	switch(setting){
		case 'selectable': 
			switch(param){
				case 'on'	: ul.selectable(); break;
				case 'off'	: li.removeClass('ui-selected'); ul.selectable('destroy'); break;
			}
		break;
		case 'sortable': 
			switch(param){
				case 'on'	: ul.sortable({connectWith: '.catgroup'}).disableSelection(); break;
				case 'off'	: ul.sortable('destroy'); break;
			}
		break;
	}
}

function disableTools(){
	$('ul.control-list').each(function(){$(this).removeClass('ui-selected')});
	$('li.control-element').each(function(){$(this).selectable('destroy'); $(this).sortable('destroy');});
}

function getSelectedTool(obj){
	setTools(obj.find('li.ui-state-active'));
}

// *** /TOOLBARS ***


// ***   WINDOWS   *** //


function winButton(div){
	//$()
}


function win(divid){
	var win = $('#'+divid);
	win.dialog({
		modal: true,
		width:800,
		//height:500,
		buttons: {
			Close: function() {
				$(this).dialog('close');
			}
		}
	});
}

function winHref(divid, href, postdata){
	var win = $('#'+divid);
	//alert(href);
	$.post(href, postdata, function(data){
		win.html(data); defAll();

		var form = win.find('form.ajax');
		var closewin = function(){/*win.dialog('close');*/}
		var savewin = function(){submitForm(form, closewin);}
		win.dialog({
			modal: true,
			width:800,
			height:500
		});
		
	});

	
}


// *** / WINDOWS   *** //

// *** EDIT ALBUMS

function saveSortImages(parent_id, uid){
	var parent = $('#'+parent_id);
	var zone = parent.find('.actzone');
	var sorted_arr = zone.find('ul.control-list').sortable('toArray');
	var sorted='';
	for(var i = 0; i<=sorted_arr.length; i++){
		sorted+='&'+sorted_arr[i]+'='+(i+1);
	}
	$.post(
		'/program/editalbum.php?mode=sort&album='+uid,
		parent.find('form.toolbar-form').serialize()+sorted,
		function(data){
			galRefresh(parent, uid);
		}
	);
}

function cancelSortImages(parent_id, uid){
	galRefresh($('#'+parent_id), uid);
}

function delSelectedImages(parent_id, uid){
	var parent = $('#'+parent_id);
	var zone = parent.find('.actzone');
	var sel = zone.find('li.control-element.ui-selected');
	
	//alert(zone.length);
	
	if(!sel.length){
		alert('Nothing selected');
		return false;
	}
	if(!window.confirm("Delete "+sel.length+" objects?")) return false;
	
	sel.each(function(){
		var img_id = $(this).attr('id');
		$.post(
			'/program/editalbum.php?mode=delimg&album='+uid+'&img='+img_id,
			parent.find('form.toolbar-form').serialize(),
			function(data){
				galRefresh(parent, uid);
			}
		);
	});
}

function setTitleImage(parent_id, uid){
	var parent = $('#'+parent_id);
	var zone = parent.find('.actzone');
	var sel = zone.find('li.control-element.ui-selected');
	//alert(parent.html());
	if(!sel.length){
		alert('Nothing selected');
		return false;
	}
	if(sel.length>1){
		alert('Selected more than one Image');
		return false;
	}
	var img_id = sel.attr('id');
	$.post(
		'/program/editalbum.php?mode=settitle&album='+uid+'&img='+img_id,
		parent.find('form.toolbar-form').serialize(),
		function(data){
			galRefresh(parent, uid);
			//alert(data);
		}
	);
}

function galRefresh(parent, uid){
	var outdiv = parent.find('.actzone');
	var postdata = parent.find('form.toolbar-form').serialize();
	//alert(parent.html());
	$.ajax({
		type: "POST",
		url: '/program/bexec.php?format=html',
		data: postdata,
		success: function(data){
			outdiv.html(data);
			getSelectedTool(parent);
		}
	});
}

function albumSource(button, parent_id, uid){
	
	var parent = $('#'+parent_id);
	var vmode = parent.find('form.toolbar-form input[name=viewmode]');
	
	if(vmode.val()=='html')vmode.val('default')
	else vmode.val('html');
	
	//alert(vmode.val());
	
	galRefresh(parent, uid);
}

function delAlbum(parent, uid){
	var outdiv = $('#'+parent);
	var postdata = parent.find('form.toolbar-form').serialize();
	//alert(parent.html());
	$.ajax({
		type: "POST",
		url: '/program/editalbum.php?fmode=delelbum',
		data: postdata,
		success: function(data){
			outdiv.html(data);
			getSelectedTool(parent);
		}
	});
}

// *** /EDIT ALBUMS



// ***  EDIT CATEGORIES ***

// Categories
function winCategories(objid){
	var win = $('#winCategories');
	var zone = win.find('.actzone');
	var form = win.find('form.toobar-form');
	//zone.html('123');
	catRefresh(objid);
	win.dialog({
		modal: true,
		width:800,
		height:500,
		beforeClose: function(){globalCatRefresh()},
		buttons: {
			Close: function() {
				$(this).dialog('close');
			}
		}

	});
}

function globalCatRefresh(){
	//alert('refresh');
	disableTools();
	$('form#refresh_categories').submit();
}

function catRefresh(){
	var win = $('#winCategories');
	var zone = win.find('.actzone');
	var form = win.find('form.toobar-form');
	$.post(
		form.attr('action')+'?mode=catlist',
		form.serialize(),
		function(data){
			zone.html(data);
			getSelectedTool(win);
			defAll();
		}
	);
}
					 

function saveSortCategories(parent_id){
	var parent = $('#'+parent_id);
	var zone = parent.find('.actzone');
	var catgroups = zone.find('ul.control-list');
	var form = parent.find('form.toobar-form');
	var postdata = '';
	
	catgroups.each(function(){
		var handler = $(this).attr('id');
		var sorted_arr = $(this).find('li.control-element');
		sorted_arr.each(function(index){ 
			var id = $(this).attr('id');
			postdata+='&range_'+id+'='+(index+1)+'&handler_'+id+'='+handler;
		});
	});
	
	$.post(
		form.attr('action')+'?mode=catsort',
		form.serialize()+postdata,
		function(){catRefresh();}
	);
	
}

function delSelectedCategories(parent_id){
	var parent = $('#'+parent_id);
	var zone = parent.find('.actzone');
	var catgroups = zone.find('ul.control-list');
	var form = parent.find('form.toobar-form');
	var postdata = '';
	
	var sel = zone.find('li.control-element.ui-selected');
	
	//alert(zone.length);
	
	if(!sel.length){
		alert('Nothing selected');
		return false;
	}
	if(!window.confirm("Delete "+sel.length+" objects?")) return false;
	
	sel.each(function(){
		var cat_id = $(this).attr('id');
		$.post(
			'/program/editobj.php?mode=delcat&catid='+cat_id,
			parent.find('form.toolbar-form').serialize(),
			function(data){
				catRefresh();
			}
		);
	});
	
}

function addCategoryWin(){
	$('#addCategoryWin').dialog({
		modal: true,
		width:700,
		height:400,
		buttons:{
			'Cancel': function(){$(this).dialog('close')},
			'Save': function(){alert('Save')}
		}
	});
}

function winClassify(owner_tbl, owner_id){
	//alert('owner:'+owner_tbl+', id:'+owner_id);
	$('#winClassify_'+owner_tbl+'_'+owner_id).dialog({
		modal: true,
		width:700,
		height:500,
		buttons:{
			'Cancel': function(){$(this).dialog('close')},
			'Save': function(){
				var form = $(this).find('form');
				//alert(form.attr('action')); 
				form.submit(); 
				$(this).dialog('close');
			}
		}
	});
}

function openSubClass(node, target_id, lang){
	var target = $('#'+target_id);
	$.post(
		'/program/editpage.php?mode=sitemap&node='+node+'&lang='+lang,
		{
			temp : 'standart/classify',
			PageId: node
		},
		function(data){
			target.html(data);
		}
	);
}

function perMenu(){
	$('.perMenu li').hover(function(){$(this).addClass('ui-state-hover');}, function(){$(this).removeClass('ui-state-hover');});
	$('.perMenu li').click(
		function(){
			$(this).addClass('ui-state-active'); 
			$(this).siblings().removeClass('ui-state-active');
			switchLang($(this).attr('href'), $(this).attr('target'), $(this).attr('lang'));
		}
	);
	$('.myMenu li a').click(function(){$(this).closest('li').addClass('ui-state-active'); $(this).closest('li').siblings().removeClass('ui-state-active');});
}


function delPer(){
	var form = $('form.refreshpricetable');
	var input = $('select.dropdownperiods');
	var sel = $('select.dropdownperiods option:selected');
	if(sel.length<=0){alert('Nothing to delete!'); return false;}
	if(!confirm('Delete ['+sel.text()+'] period with prices?'))return false;
	$.post('/program/editobj.php?mode=delper', {objid: $('input[name=objid]').val(), perid: sel.val()}, function(){sel.remove(); input.change()})
}

function addPeriod(answer){
	var ans = $.parseJSON(answer);
	var win = $('#addperiod.win');
	var form = $('form.refreshpricetable');
	//alert(ans.result);
	var input = $('select.dropdownperiods');
	if(ans.result == 'ok'){
		var opt = input.append('<option value="'+ans.id+'" selected="selected">[new] '+ans.name+'</option>');
		opt.attr('selected', 'selected');
		form.find('input[name=perid]').val(ans.id);
		form.submit();
		win.dialog('close');
	}
	else alert(ans.descr);
}

// *** /EDIT CATEGORIES ***

function myMenu(){
	$('.myMenu li').hover(function(){$(this).addClass('ui-state-hover');}, function(){$(this).removeClass('ui-state-hover');});
	$('.myMenu li').click(
		function(){
			$(this).addClass('ui-state-active'); 
			$(this).siblings().removeClass('ui-state-active');
			switchLang($(this).attr('hr'), $(this).attr('target'), $(this).attr('lang'));
		}
	);
	$('.myMenu li a').click(function(){$(this).closest('li').addClass('ui-state-active'); $(this).closest('li').siblings().removeClass('ui-state-active');});
}

function switchLang(href, targ_name, lang){
	//alert('lang: '+lang);
	var targ = $('#'+targ_name);
	var new_name = targ_name+'_'+lang;
	if(!targ.has('#'+new_name).length){
		targ.append('<div id="'+new_name+'"></div>');
		//alert(href);
		$.post(href, targ.closest('form').serialize(), function(data){$('#'+new_name).html(data); defAll()});
	}
	var new_obj = $('#'+new_name);
	new_obj.siblings().hide();
	new_obj.show();	
}


function addLang(target_id, dataarea_id, url){
	var targ = $('#'+target_id);
	var pwin = $('#'+target_id+'_prompt');
	pwin.dialog({
		modal: true,
		buttons:{
			'Cancel': function(){$(this).dialog('close')},
			'Save'	: function(){
				var lang = $(this).find('select').val();
				$.post(url+'?multiform=true&mode=addlang&lang='+lang, $('#'+target_id).closest('form').serialize(), function(data){$('#'+target_id).html(data); defAll(); switchLang(url+'?lang='+lang, dataarea_id, lang)});
				$(this).dialog('close');
			}
		}
	});
}


function wymEd(targ_name, lang_cond, caller){
	var targ = $('#'+targ_name);
	targ.wymeditor({
		height: '500px',
		html: targ.val(),
		updateSelector: $('form.ajax'),
		updateEvent: 'submit',
		stylesheet: 'styles.css',
		lang: lang_cond,
		postInit: function(wym) {
			if($(caller))$(caller).remove();
		}
	});
}

function postFormSubmit(){
	
}

function winPageEdit(uid, pageid){
	var targ_title = $('.page_'+pageid+'_title');
	var targ_source = $('.page_'+pageid+'_source');
	var params = {
		modal:true,
		width:800,
		height:550,
		buttons:{
			'Cancel': function(){$(this).dialog('close')},
			'Save'	: function(){
				var postform = $('#form_'+uid);
				var thiswin = $(this);
				
				
				$.ajax({
					type: "POST",
					url:	postform.attr('action'), 
					data:	postform.serialize(), 
					success: function(xml){
						$('#loading').hide();
						var content_link_href = postform.find('a.getfield').attr('href');
						$.post(content_link_href+'&field=title', postform.serialize(), function(html){targ_title.html(html)});
						$.post(content_link_href+'&field=source', postform.serialize(), function(html){targ_source.html(html)});
						
						//alert('post');
						//targ_source.html(data); 
						
						/*
						$(xml).find('page').each(
							function(){
								var cont_title = $(this).find('var').find('title');
								var cont_source = $(this).find('var').find('source');
								//alert(cont_source);
								targ_title.html(cont_title);
								targ_source.html(cont_source);
							}
						);
						*/
						
						defAll();
						//reCache('objects', id)
						thiswin.dialog("close");
					},
					beforeSend: function(){
						$('#loading').show();
						
					},
					dataType: 'xml'
				});
				
				$(this).dialog({ buttons: { "Close": function() { $(this).dialog("close"); } } });
			}
		}
		
	}
	
	var form 	= $('#form_'+uid);
	var win 	= $('#win_'+uid);
	var vlink 	= form.find('a').attr('href');	// link that have a viewmode href
	var targ	= $('#'+form.attr('target'));
	//$.get(form.attr('action'), form.serialize(), function(data){});
	
	$.post(vlink, form.serialize(), function(data){targ.html(data); defAll();})
	//form.submit();
	win.dialog(params);
}

function reCache(tbl, id){
	$.post('/program/delcache.php?tbl='+tbl+'&id='+id, function(data){alert(data);});
}


