$(document).ready(function(){
	window.intelli_data = intelli_data ? intelli_data : {
	}
	document.querySelectorAll(".intelli_input").forEach(x => {
		x.addEventListener("input",function(e){
			var elem = this.getAttribute("list");
			var datastorage = intelli_data[elem] ? intelli_data[elem] : {datalist:[],selected:[],regex:false};
			testinput(e,datastorage,this,"#"+elem);
		});
	});
	
	function testinput(event,data,input,elem){
	if(!event.data){			//if the data is not from typed input (i.e. from list)
	var val = input.value;
		if(data.datalist.length > 0)
		var index = Array.prototype.findIndex.call(data.datalist, x => {
			return x.name==val;
		});
		if(index>=0){
			var temp = data.datalist[index];
			Array.prototype.splice.call(data.datalist,index,1);
			data.selected.push(temp);	//to remove item if is selected
			if(data.onadd) data.onadd(temp,elem,data);
			var opts = $(elem).children();
			opts.each(x => {
				if(opts[x].dataset.id==temp.id){
					$(opts[x]).remove();
				}
				input.value = "";
			});
		}
		}
	}
	$(".intelli_input").keyup(function(){
		var elem = $(this).attr("list");
		var datastorage = intelli_data[elem] ? intelli_data[elem] :intelli_data[elem]= {datalist:[],selected:[],regex:false};
		var url = $(this)[0].dataset.url;
		getDataList(url,datastorage,"#"+elem,this);
	});
	
	function getDataList(url,data,elem,input){
		var val = $(input).val();
		if(data.regex && data.regex.test(val)){
			return;
		}
		if(val=="") return;
		$.ajax({
			url : url+"?search="+val,
			success : function(res){
				data.datalist = JSON.parse(res);
				data.regex = new RegExp(val,"i");
				filterList(data);
				updateList(data,elem);//for new data
			}
		});
	}
	function filterList(data){
		Array.prototype.forEach.call(data.selected,x => {
			var index = Array.prototype.findIndex.call(data.datalist,y => x.id==y.id);
			if(index>-1)
			Array.prototype.splice.call(data.datalist,index,1); //1 to remove 1 value
		})
	}
	function updateList(data,elem){		
		$(elem).html("");
		Array.prototype.forEach.call(data.datalist,x => {
			$(elem).append("<option data-id="+x.id+" value="+x.name+"></option>");
		});
	}
});