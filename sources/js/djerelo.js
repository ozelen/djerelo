jQuery.fn.center = function()
	{
	var w = $(window);
	this.css("position","absolute");
	this.css("top",(w.height()-this.height())/2+w.scrollTop() + "px");
	this.css("left",(w.width()-this.width())/2+w.scrollLeft() + "px");
	return this;
	}
	
	$('.mdiv').center();