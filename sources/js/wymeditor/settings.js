// JavaScript Document

jQuery(function() {

	$('a').live('click', function(){
		//allDefine();
	});

	$('#dialog').dialog({
		autoOpen: false,
		width: 600,
		buttons: {
			"Cancel": function() { 
				$(this).dialog("close"); 
			}, 
			"Save": function() { 
				$(this).dialog("close"); 
			} 
		}
	});
	
	//$('a').click(function(){$('#dialog').dialog('open')});

	$('textarea.html').live('focus', function(){
		/*
		jQuery.each(WYMeditor.INSTANCES, function() {
			  this.update();
			  $(this._box).remove();
			  $(this._element).show();
			  delete this;
		});
		*/

		$(this).wymeditor({
			html: $(this).val(),
		    updateSelector: $('form.ajax'),
		    updateEvent: 'submit',
			stylesheet: 'styles.css'
		});

	});
	




	$('form.ajax').live('submit',
		function(){
			//alert('submit');
			//alert($(this).serialize());
			var current = $(this);
			var form_data = $(this).serialize();
			var method = current.attr('method') || 'POST';
			//alert(method);
			$.ajax({
				type: 		method,
				url:		current.attr('action'),
				data:		form_data,
				success:	function(text){
								//alert(current.attr('action'));
								$('#'+current.attr('target')).html(text);
								defAll();
							},
				dataType:	'html'
			});
			
			return false;
		}
	);


	
	$(".editwin").live('mouseenter', function(){
		   $(this).find(".controls").fadeIn(200);
	   }
	);
	$(".editwin").live('mouseleave', function(){
		   $(this).find(".controls").fadeOut(200);
	   }
	)
	
	
	$('a.win').live('click', function(){
		var el = $('#'+$(this).attr('out'));
		if(el.dialog('isOpen')==true){
			//alert("move to top");
			el.dialog('moveToTop');
		}
		else{
			//alert("new window");
			el.dialog({
				autoOpen: true,
				width: 600
			});
			el.dialog('open');
			doit($(this).attr('href'), $(this).attr('in'), $(this).attr('out'), $(this).attr('mth'));
		}
		
		return false;
	})
	
	
	$('a.ajax').live('click', function(){
		doit($(this).attr('href'), $(this).attr('in'), $(this).attr('out'), $(this).attr('mth'));
		return false;
	})
	
	
	$('div.btn').live('mouseenter', function(){$(this).addClass("hover")});
	$('div.btn').live('mouseleave', function(){$(this).removeClass("hover")});
	
	defAll();
});

function jDoIt(act, target){
	$.post(act,	function(data){
			//alert(data);
			$('#'+target).html(data);
			defAll();
		}
	);
}


function defAccord(){
	$('.accord').accordion({
		header: ".head",
		active: false,
		autoheight: false
	});
}

function defButtons(){
	$('.submenu').hide();
	$('button').button();
	$('ul.icons div.icon').hover(
		function() { $(this).addClass('ui-state-hover'); }, 
		function() { $(this).removeClass('ui-state-hover'); }
	);
}

function defTabs(){
	$('.tabs').tabs();
}

function defAll(){
	defAccord();
	defButtons();
	defTabs();
}
