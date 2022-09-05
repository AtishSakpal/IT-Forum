function addToDatalist(value, elem, data) {
	$(elem).append("<option data-id=" + value.id + " value=" + value.name + "></option>");
	var index = data.selected.indexOf(value);
	data.selected.splice(index, 1);
	data.datalist.push(value);
}
var intelli_data = {
	tags: {
		selected: [],
		datalist: [],
		regex: false,
		onadd: function (value, elem, data) {
			$("#tag_alert").append("<div class='tag_holder' style='margin-left:10px'><div id='curr' class='alert alert-info'><strong id='abc'>"
							+ value.name +
							"</strong><button type='button' class='close' data-dismiss='alert' >&times;</button></div></div>");
			var curr = $("#tag_alert").children().last();
			curr.find(".close").on("click", _ => {
				$(this).parentsUntil(".tag_holder").remove();
				addToDatalist(value, elem, data);
			});
		}
	}
};	
$(document).ready(function(){ 
	var regx1=/[a-zA-Z0-9]+$/;
	$("#sname").keypress(function(e){
		if(!regx1.test(e.key)){
			e.preventDefault();
		}
	});
	var regx2=/[a-zA-Z0-9]+$/;
	$("#spass").keypress(function(e){
		if(!regx2.test(e.key)){
			e.preventDefault();
		}
	});
	var regx3=/^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	function email_validate(semail){
		if(regx3.test(semail)) return true;
		return false;
	}
	var img;
	$("#file").on("change",function (){
		var canvas_ob = document.createElement("canvas");
		canvas_ob.height = 150;
		canvas_ob.width = 150;
		var context = canvas_ob.getContext("2d");
		var elem = document.querySelector("#file");
		var fr = new FileReader();
		fr.onload = function (e) {
			var img_ob = document.createElement("IMG");
			img_ob.onload = function () {
				context.drawImage(img_ob, 0, 0, 200, 200);
				$(".image-container").html(canvas_ob);
				img=elem.files[0];
				$("#file").val("");
			}
			img_ob.src = e.target.result;
		}
		fr.readAsDataURL(elem.files[0]);
	});
	function checkpass(){
		if($("#spass").val()==$("#scpass").val()){
			$("#scpass").removeClass("is-invalid");
			$("#rcpass").html("");
		}
	}
	function check_tags(){
		if(intelli_data.tags.selected.length>0){
			$("#tag_input").removeClass("is-invalid");
			$("#rtags").html("");
		}
	}
	$(".check").blur(function (){
		var temp = $(this)[0].dataset.regx;
		var cb = $(this)[0].dataset.cb;
		var elem=$(this).val();
		console.log(elem,temp)
		if(temp){
			var regExp=new RegExp(temp);
			console.log(regExp.test(elem));
			if(regExp.test(elem)){
				$(this).removeClass("is-invalid");
				$(this).removeClass("invalid-feedback");
			}
		}else if(cb){
			eval(cb);
		}
	});
	$("#newacbtn").click(function(e){
		var displayname=$("#sname").val();
		var password=$("#spass").val();
		var confirm_password=$("#scpass").val();
		var email=$("#semail").val();
		var lentags=intelli_data.tags.selected.length;
		var tags = intelli_data.tags.selected.map(_ => _.id).join(",");
				
		if(displayname===""){
			$("#rname").html("Please enter your name");
			$("#sname").addClass("is-invalid").focus();
			$("#rname").addClass("invalid-feedback");
			return false;
		}
					
		if(email==="" || !email_validate(email)){
			$("#remail").html("Please enter valid email address");
			$("#semail").addClass("is-invalid").focus();
			$("#remail").addClass("invalid-feedback");
			return false;
		}
		if(password===""  || password.length<8){
			$("#rpass").html("Password must contain atleast 8 characters");
			$("#spass").addClass("is-invalid").focus();
			$("#rpass").addClass("invalid-feedback");
			return false;
		}
		if(confirm_password==="" || password !== confirm_password){
			$("#rcpass").html("Password do not match");
			$("#scpass").addClass("is-invalid").focus();
			$("#rcpass").addClass("invalid-feedback");;
			return false;
		}
		if(lentags===0){
			$("#rtags").html("Atleast one tag is required");
			$("#tag_input").addClass("is-invalid").focus();
			$("#rtags").addClass("invalid-feedback");
			return false;
		}
		if($("#file").val() !==""){
			var name=img.name;
			name=name.split(".");
			var ext=name[name.length - 1];
		}
		var data ={
			displayname : displayname ,
			email : email,
			pass : password,	
			notify : ($("#snoti").is(":checked")+0)+"",
			tags : tags,
			ext : ext
		};
		var myform=new FormData();
		myform.append("data",JSON.stringify(data));
		myform.append("userimg",img);
					
		$.ajax({
			method:"post",
			url : "../db/upload_user/main_server.jsp",
			data : myform,
			processData: false,
			contentType: false,
			success : function(msg){
				location.href=redirect;
			}
		});
	});
});


