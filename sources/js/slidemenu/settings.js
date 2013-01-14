
$('document').ready(function(){
		// simple accordion
	//alert();
    $("#list1b").accordion({
			autoHeight: false,
			navigation: true,
			header: 'div.btn',
			active: '.selected'
	});
	$(".categories").accordion({
			autoHeight: false,
			navigation: true,
			header: 'div.btn',
			active: '.selected'
	});

	$(".mainMenu").accordion({
			autoHeight: false,
			navigation: true,
			header: '.mainMenuHeader',
			active: '.selected'
	});
	
	
				$('ul.icons li').hover(
					function() { $(this).addClass('ui-state-hover'); }, 
					function() { $(this).removeClass('ui-state-hover'); }
				);

	
	
	/*
	jQuerySlide('#list1b').accordion({
			autoheight: false,
			navigation: true,
			header: 'div.btn',
			active: '.selected'
		});
		
		jQuerySlide('.categories').accordion({
			header: 'div.btn',
			active: false, 
			alwaysOpen: false, 
			animated: false, 
			autoheight: false 
		});
		/*
		jQuerySlide('.hotel_list').accordion({
			autoheight: false,
			navigation: true,
			header: 'div.header',
			active: '.selected',
		    animated: false, 
		    alwaysOpen: true 
			
		});
		*/

	});
