// JavaScript Document
var map;
var layers = new Array();
var markers = new Array();

var visiMarker = function(point, name, header, info, icon){	
	var marker = new VMarker( point , icon);
	marker.hint(name);
	marker.info(header, info, {alwaysOpen:true});
	marker.info().scrollOnOpen(true);
	//marker.info().size(180, 200);
	return marker;
}

function visiLayer(name, icon_fname, width, height){
	this.name = name;
	this.fname = icon_fname;
	this.icon_path = this.fname;
	this.icon = new VMarkerIcon(width, height, this.icon_path);
	this.layer = new VLayer();

}

function createVisicomMap(div_id) {
	VMap.AUTH_KEY = "95086ad2defb8e860aeb7ed48d19cf4b";
	map = new VMap(document.getElementById(div_id), { zoomControl: {smooth:true, ruler:false}});
	var el = $('#'+div_id);
	var zm = 10;
	//var point = {lng: 24.54570453, lat: 48.44275167};
	var point = {lng: el.find('#lng').val(), lat: el.find('#lat').val()};
	if(el.find('#marker').val()!='false'){
		var marker = new VMarker(point);
		map.add(marker);
	}
	map.center(point);
	if(el.find('#zoom').val()){
		zm = el.find('#zoom').val();
	}
	
	map.zoom(parseInt(zm));
	//var searchWid = new VSearchWidget(map, document.getElementById('searchWidget'));
	//searchWid.show();

	//alert($('#'+div_id).find('#lng').val());
	
}

function chZoom(){
	var is = layers['infrastructure'].layer;
	var ct = layers['cities'].layer;
	var zoom = map.zoom();
	//alert(map.zoom());
	if(zoom<14){
		is.visible(false);
	}
	else{
		is.visible(true);
	}
	
	if(zoom<=14 && zoom>5){
		ct.visible(true);
	}else ct.visible(false);
}

$(function(){
	createVisicomMap('viewport');
});

layers['infrastructure'] = new visiLayer('is', 'hotel.png');
layers['cities'] = new visiLayer('ct', 'hotel.png');


function getContents(){
	var cr = map.clientRect();
	var pv = { 
			lb_lat: cr.leftBottom()['lat'], 
			lb_lng: cr.leftBottom()['lng'], 
			rt_lat: cr.rightTop()['lat'], 
			rt_lng: cr.rightTop()['lng']
		};
		//alert(pv['lb_lng']+"\n"+pv['rt_lng']);
	$.post(
		"/program/mapdef.php?lang="+CurrentLang+"&zoom="+map.zoom(), 
		pv, 
		function(xml){

			//$('#dbg').html('<textarea style="width:300px; height:400px;">'+xml+'</textarea>')
			
			$(xml).find('points').each(
				function(){
					var i=0;
					$(this).find('point').each(
						function(i, _item){
							//alert($(_item).attr('lat'))
							var objtype = $(_item).find('obj').find('type');
							var objtype = $(_item).find('obj').find('type');
							var icon	= $(_item).find('icon');
							var ident = objtype.attr('ident');
							if(!layers[ident]){
								layers[ident] = new visiLayer(objtype.text(), icon.attr('src'), icon.attr('w'), icon.attr('h'));
								layers[$(_item).attr('group')].layer.add(layers[ident].layer);
							}
							var objid = $(_item).find('obj').attr('id');
							if(!markers[objid]){
								i++;
								markers[objid] = new visiMarker(
									{lng: $(_item).attr('lng'), lat: $(_item).attr('lat')}, 
									$(_item).find('obj').find('name').text(), 
									$(_item).find('obj').find('header').text(),
									$(_item).find('obj').find('info').text(), 
									layers[ident].icon
								);
								layers[ident].layer.add(markers[objid]);
								//alert('add');
							}
						}
					)
					//$(this).ready(alert(i));
				}
			)
			map.repaint();
			
		}
		
		, 'xml'
	);
}

$(document).ready(function(){
		map.add(layers['infrastructure'].layer);
		map.add(layers['cities'].layer);
		map.repaint();
		map.onzoomchange(chZoom);
		map.enddrag(getContents);
		getContents();
	}
)


