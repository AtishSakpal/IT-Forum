<%@page import="java.util.Enumeration"%>
<%
	String redirect="/MainData/html/index.jsp";
	if (session.getAttribute("uid") == null) {
		if(request.getParameter("redirect")!=null){
			String redirect1 = request.getRequestURI();
			response.sendRedirect("login_signup.jsp?redirect="+redirect1);
		}
		else
			response.sendRedirect(redirect);
	}else{
		if(request.getParameter("redirect")!=null)
			redirect = request.getParameter("redirect");
	}
	(response).setHeader("Cache-Control", "max-age=0, private,no-cache,no-store,must-revalidate");
	(response).setHeader("Expires", "-1");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@include file="libs.jsp" %>
		<script src="javascript/script.js"></script>
		<title>Post Question</title>
		<style type="text/css">
			.div1{
				height: 150px;
				width: 100%;
				border:1px solid;
				border-color:black;
				background-color:#f8f9fa;
				overflow-y: scroll;
			}

			.border-class{
				border:thick; black solid;
				margin:10px;
				padding:10px;
			}
		</style>
         <script type="text/javascript">
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
			$(document).ready(function () {
				$("#question_heading").focus();
				$("#code").show();
				$("#code_btn").addClass('active');
				$("#code_content").show();
				var addType = 1;
				
				$("#tag_input").keydown(function(e){
					var val=$(this).val();
					var arr=intelli_data.tags.selected;
					var regEx=new RegExp(val,"i");
					if(e.keyCode=="13"){
						console.log(val,arr);
					}
				});
				
				$("#code_btn").click(function () {
					remove_class();
					addType = 1;
					$(".collapse").hide();
					$("#code").show();
					$("#code_content").show().focus();
					$(".nav-link").removeClass('active');
					$(this).addClass('active');
				});

				$("#text_btn").click(function () {
					addType = 2;
					$(".collapse").hide();
					$("#text").show();
					$("#text_content").show().focus();
					$(".nav-link").removeClass('active');
					$(this).addClass('active');
				});

				$("#img_btn").click(function () {
					remove_class();
					addType = 3;
					$(".collapse").hide();
					$("#image").show();
					$("#image_content").show().focus();
					$(".nav-link").removeClass('active');
					$(this).addClass('active');
				});
				
				var tag_content = [];
				var que_content = [];
				function createCodeDiv(data) {
					var elem = document.createElement("div");
					elem.textContent = data;
					que_content.push({type: "1", data: data});
					return elem;
				}

				function createTextDiv(data) {
					var elem = document.createElement("div");
					elem.innerHTML = data;
					que_content.push({type: "2", data: data});
					return elem;
				}

				function addImgDiv(ht, wd) {
					var canvas_ob = document.createElement("canvas");
					canvas_ob.height = ht || 200;
					canvas_ob.width = wd || 200;
					var context = canvas_ob.getContext("2d");
					var elem = document.querySelector("#file_content");
					var fr = new FileReader();
					fr.onload = function (e) {
						var img_ob = document.createElement("IMG");
						img_ob.onload = function () {
							context.drawImage(img_ob, 0, 0, 200, 200);
							$("#add_here").append(canvas_ob);
							var x = elem.files[0];
							que_content.push({type: "3", data: x});
							$("#file_content").val("");
						}
						img_ob.src = e.target.result;
					}
					fr.readAsDataURL(elem.files[0]);
				}
				function remove_class(){
					$("#rtext").removeClass("text-muted");
					$("#text_content").removeClass("is-invalid");
					$("#rtext").html("");
				}
				$("#add_btn").click(function (e) {
					if (addType == 1) {
						remove_class();
						let a = $("#code_content").val();
						$("#add_here").append(createCodeDiv(a));
						$("#code_content").val("");
					} else if (addType == 2) {
						remove_class();
						let a = $("#text_content").val();
						$("#add_here").append(createTextDiv(a));
						$("#text_content").val("");
					} else if (addType == 3) {
						remove_class();
						addImgDiv();
					}
				});
				
				$("#submit_btn").click(function () {
					
					var lentags=intelli_data.tags.selected.length;
					var qh = $("#question_heading").val();
					
					function check_text(){
						if(que_content.length>0){
							addType=2;
							$("#add_btn").trigger('click');
						}
					}
					function check_tags(){
						if(intelli_data.tags.selected.length>0){
							$("#tag_input").removeClass("is-invalid");
							$("#rtags").html("");
						}
					}
					$(".check").blur(function(){
						var temp=$(this)[0].dataset.regex;
						var cb=$(this)[0].dataset.cb;
						var elem=$(this).val();
						if(temp){
							var regExp=new RegExp(temp);
							if(regExp.test(elem)){
								$(this).removeClass("is-invalid");
								$(this).removeClass(".invalid-feedback");
							}	
						}else if(cb){
							eval(cb);
						}	
					});	
					if(qh==""){
						$("#question_heading").addClass("is-invalid").focus();
						$("#rqh").html("Question heading is required");
						$("#rqh").addClass("invalid-feedback");
						return false;
					}
					if(lentags==0){
						$("#tag_input").addClass("is-invalid").focus();
						$("#rtags").html("Atleast one tag is required");
						$("#rtags").addClass("invalid-feedback");
						return false;
					}
					if(que_content.length==0){
						$("#text_btn").trigger('click');
						$("#text_content").addClass("is-invalid");
						$("#rtext").removeClass("text-muted");
						$("#rtext").addClass("invalid-feedback");
						$("#rtext").html("Description of your question is required");
						return false;
					}
					var content = "{";
					var img = [];
					que_content.forEach((x, i) => {
						if (x.type == '3') {
							var name = x.data.name;
							name = name.split(".");
							//a.b.c.png
							img.push(x.data); //img[] array 
							x.data = name[name.length - 1];
						}
					});
					console.log("len ",que_content.length);
					que_content.forEach((data, index) => content += `"` + (++index) + `" : ` + JSON.stringify(data) + `,`);
					content = content.substring(0, content.length - 1);
					content += `}`;
					
					var c_tag = intelli_data.tags.selected.map(_ => _.id).join(",");
					var data = {
						qh: qh,
						c_tag: c_tag,
						content: content
					};
					console.log(JSON.stringify(data));
					console.log(img);
					var form = new FormData();
					form.append("data", JSON.stringify(data));
					img.forEach(x => {
						form.append("img", x); //image data
					});

					$.ajax({ 
						method: "post",
						url: "../db/upload_question/main_server.jsp",
						data: form,
						processData: false,
						contentType: false,
						success: function (msg) {
							location.href='<%=redirect%>';
						}
					});
				});
			});
		</script>
	</head>
	<body id="main-area">
    <%@include file="nav.jsp" %>
		<div class="container">
			<div class="text-center">
				<legend class="display-5 text-uppercase">Post Question</legend>
			</div>
				<div class="form-group">
					<label for="question_heading">Question Heading</label>
					<input type="text" class="form-control check" type="text" id="question_heading" 
						data-regex="^[^\s].{1,}" placeholder="Question" >
					<small class="text-muted form-text error" id="rqh"></small>
				</div>
				<div class="form-group">
					<label for="question_tag">Tags :</label>
					<input list="tags" class="intelli_input form-control check" id="tag_input" data-cb="check_tags()" data-url="../db/fetch.jsp"  placeholder="Interested Tags ">
					<datalist id="tags">
					</datalist>
					<small class="text-muted form-text error" id="rtags"></small>
					<div class="mt-4 justify-content-start"  style="display: flex;flex-wrap: wrap;" id="tag_alert">
						<!--alert of tag-->
					</div>
				</div>				
				<div class="container">
					<div class="div1" id="add_here">
						<!--code text image content goes here--> 
					</div>
					<!--<div class="container mt-4">-->
					<div class="card text-center" id="tablinks">
						<div class="card-header">
							<ul class="nav nav-pills card-header-pills">
								<li class="nav-item">
									<a class="nav-link" data-toggle="collapse"  href="#" id="code_btn">Code</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" data-toggle="collapse"  href="#" id="text_btn">Text</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" data-toggle="collapse" href="#" id="img_btn">Image</a>
								</li>
							</ul>
						</div>
						<div class="card-body">
							<div class="collapse" id="code" data-parent="#tablinks">
									<div class="form-group tab_inner ">
										<label for="code_content" class="text">Type your code here : </label>
										<textarea class="form-control no-resize " id="code_content" rows="3" placeholder></textarea>
									</div>
							</div>
							<div class="collapse" id="text" data-parent="#tablinks">
								<form>
									<div class="form-group tab_inner">
										<label for="text_content" class="text">Type your text here : </label>
										<textarea class="form-control no-resize check" id="text_content" 
											data-cb="check_text()" rows="3" placeholder="Type your text here"></textarea>
										<small class="text-muted form-text error" id="rtext"></small>
									</div>
								</form>
							</div>
							<div class="collapse" id="image" data parent="#tablinks">
								<form>
									<div class="form-group tab_inner">
										<label for="file_content">Select File to upload : </label>
										<input type="file" id="file_content" class=" form-control-file" multiple="multiple">
										<!--<small class="text-danger">Max file size should be 2MB</small>-->
									</div>
								</form>
							</div>
							<input type="button" class="btn btn-primary mt-4" id="add_btn" value="Add">
						</div>
					</div>
					<input type="button" class="btn btn-primary mt-4" id="submit_btn" value="Post Question">
					<!--<button class="btn btn-success mt-4" id="submit_btn">Post Question</button>-->
				</div>
		</div>
	<footer class="bg-dark text-white py-3">
      <div class="container">
        <p class="lead text-right">2022 &copy; IT-FORUM</p>
      </div>
    </footer>
    <script src="../asset/plugin/popper.min.js"></script>
    <script src="../asset/js/bootstrap.min.js"></script>
	</body>
</html>
