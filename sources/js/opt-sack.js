

function expandCollapse(ename){
	var e = document.getElementById(ename);
	e.style.display = (e.style.display == 'block') 
	? 'none' : 'block';
}

function putItThere(sender, recepient){
	document.getElementById(recepient).innerHTML = document.getElementById(sender).innerHTML;
}

function centralise(parent_obj, child_obj){
	var p = parent_obj.currentStyle || window.getComputedStyle(parent_obj, null);
	var c = child_obj.currentStyle || window.getComputedStyle(child_obj, null);

	child_obj.style.left = parseInt(parent_obj.offsetLeft)+parseInt(parent_obj.offsetWidth)/2+"px"
	child_obj.style.left = parseInt(child_obj.offsetLeft) - parseInt(child_obj.offsetWidth)/2+"px";
	
	child_obj.style.top = parseInt(parent_obj.offsetTop)+parseInt(parent_obj.offsetHeight)/2+"px"
	child_obj.style.top = parseInt(child_obj.offsetTop) - parseInt(child_obj.offsetHeight)/2+"px";
	//alert(p.marginLeft);

}

function ajaxEvents(reqout){
	
	var e = document.getElementById(reqout); 
	
	var ico = document.createElement('div');
	ico.className = 'loadProgress';
	e.appendChild(ico);
	centralise(e, ico);
	
	var showIco = function(){
		//ico.style.display='block';
	}
	
	this.whenLoading = function(){
		showIco();
		//e.innerHTML += "<div class='msgProcess'>Sending Data...</div>";
	}
	
	this.whenLoaded = function(){
		showIco();
		//e.innerHTML += "<div class='msgProcess'>Data Sent...</div>";
	}
	
	this.whenInteractive = function(){
		showIco();
		//e.innerHTML += "<div class='msgProcess'>getting data...</div>";
	}
	this.whenCompleted = function(){

	}
}

function do_or_close (reqfile, reqin, reqout, reqmethod, writeto, debug){
	divout = document.getElementById(reqout)
	
	divout.firstChild
		? expandCollapse(reqout)
		: doit(reqfile, reqin, reqout, reqmethod, writeto, debug);
}

function do_if_empty (reqfile, reqin, reqout, reqmethod, writeto, debug){
	divout = document.getElementById(reqout)
	if(!divout.firstChild)
		doit(reqfile, reqin, reqout, reqmethod, writeto, debug);
	//else alert(reqin);
}

function doit(reqfile, reqin, reqout, reqmethod, writeto, debug){
	
	//alert("File: "+reqfile+"\nIn: "+reqin+"\nOut: "+reqout+"\nMethod: "+reqmethod);
	//reqmethod='GET';
	var ajax = new sack();

	var events = new ajaxEvents(reqout);

	var divin = document.getElementById(reqin);
	var divout= document.getElementById(reqout);
	var inp=divin.getElementsByTagName("INPUT");
	var txt=divin.getElementsByTagName("TEXTAREA");
	var sel=divin.getElementsByTagName("SELECT");
	
	divout.style.display = 'block';
	
	var res='';
	
	if(writeto=='bot')ajax.outHeader=divout.innerHTML; else
	if(writeto=='top')ajax.outFooter=divout.innerHTML;
	
	for (var i=0; i<inp.length; i++) {
		//alert(inp[i].name+" type: "+inp[i].type+"="+inp[i].value);
		if(inp[i].type=='radio' || inp[i].type=='checkbox'){
			if(inp[i].checked){
				ajax.setVar(inp[i].name, inp[i].value);
				res+=inp[i].name+'='+inp[i].value+"\n";
			}
		}
		else{
			ajax.setVar(inp[i].name, inp[i].value);
			res+=inp[i].name+'='+inp[i].value+"\n";
		}
	}
	for (var i=0; i<txt.length; i++) {
		ajax.setVar(txt[i].name, txt[i].value);
	}
	for (var i=0; i<sel.length; i++) {
		ajax.setVar(sel[i].name, sel[i].value);
		res+=sel[i].name+'='+sel[i].value+"\n";
	}
	//alert("Result:\n"+res);
	
	ajax.requestFile = reqfile;
	ajax.method = reqmethod;
	ajax.element = reqout;
	ajax.onLoading = events.whenLoading;
	ajax.onLoaded = events.whenLoaded; 
	ajax.onInteractive = events.whenInteractive;
	ajax.onCompletion = events.whenCompleted;
	ajax.runAJAX();
	//delete ajax;
}