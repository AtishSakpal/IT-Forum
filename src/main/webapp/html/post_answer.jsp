<%@page import="java.util.Enumeration"%>
<%
	int qid = Integer.parseInt(request.getParameter("qid")); 
	if(session.getAttribute("uid")==null){
		String redirect = request.getRequestURI();
		Enumeration paramNames = request.getParameterNames();
		redirect += paramNames.hasMoreElements() ? "?":"";
		while (paramNames.hasMoreElements()) {
				String paramName = paramNames.nextElement()+"";
				redirect+=paramName+"="+request.getParameter(paramName)+"&";
			}
		redirect = redirect.substring(0,redirect.length()-1);
		response.sendRedirect("login_signup.jsp?redirect="+redirect);
	}
	(response).setHeader("Cache-Control", "max-age=0, private,no-cache,no-store,must-revalidate");
	(response).setHeader("Expires","-1");	
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@include file="libs.jsp" %>
		<title>Post Answer</title>
		<style type="text/css">
			.div1{
				height: 150px;
				width: 100%;
				border:1px solid;
				border-color:black;
				overflow-y: scroll;
			}
			.border-class{
				border:thin black solid;
				margin:10px;
				padding:10px;
			}
		</style>
		<script type="text/javascript">
	    $(document).ready(function(){
			$("#code").show();
			$("#code_btn").addClass('active');
			$("#code_content").show().focus();
			var addType=1;

			$("#code_btn").click(function(){
					addType=1;
					$(".collapse").hide();
					$("#code").show(); 
					$("#code_content").show().focus();
					$(".nav-link").removeClass('active');
					$(this).addClass('active');
			});

			$("#text_btn").click(function(){
					addType=2;
					$(".collapse").hide();
					$("#text").show();
					$("#text_content").show().focus();
					$(".nav-link").removeClass('active');
					$(this).addClass('active');
			});

			$("#img_btn").click(function(){
					addType=3;
					$(".collapse").hide();
					$("#image").show();
					$("#image_content").show().focus();
					$(".nav-link").removeClass('active');
					$(this).addClass('active');
			});
			
			var que_content=[];
			function createCodeDiv(data){
					var elem =  document.createElement("div");
					elem.textContent = data;
					que_content.push({type:"1",data:data});
					return elem;
			}
			
			function createTextDiv(data){
					var elem =  document.createElement("div");
					elem.innerHTML = data;
					que_content.push({type:"2",data:data});
					return elem;
			}
			
			function addImgDiv(ht,wd){
				var canvas_ob=document.createElement("canvas");
				canvas_ob.height = ht || 200;
				canvas_ob.width = wd || 200;
				var context=canvas_ob.getContext("2d");
				var elem=document.querySelector("#file_content");
				var fr=new FileReader();
				fr.onload =function(e){
					var img_ob=document.createElement("IMG");
					img_ob.onload=function(){
						context.drawImage(img_ob,0,0,200,200);
						$("#add_here").append(canvas_ob);
						var x = elem.files[0];
						que_content.push({type:"3",data:x});
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
			$("#add_btn").click(function(e){
				if(addType==1){
					remove_class();
					let a=$("#code_content").val();
					$("#add_here").append(createCodeDiv(a));
					$("#code_content").val("");
				} 
				else if(addType==2){
					remove_class();
					let a=$("#text_content").val();
					$("#add_here").append(createTextDiv(a));
					$("#text_content").val("");
				}
				else if(addType==3){
					remove_class();
					addImgDiv();
				}
			});
			
			$("#submit_btn").click(function(){
				
				var ah=$("#answer_heading").val();
				
				function check_text(){
					if(que_content.length>0){
						addType=2;
						$("#add_btn").trigger('click');
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
			
				if(ah==""){
					$("#answer_heading").addClass("is-invalid").focus();
					$("#rah").html("Answer heading is required");
					$("#rah").addClass("invalid-feedback");
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
				var content="{";
				var img = [];
				que_content.forEach(function(x,i) {
					if(x.type == '3'){
						var name = x.data.name;
						name = name.split('.');
						//a.b.c.png
						img.push(x.data); //img[] array 
						x.data = name[name.length-1];
					} 
				});
				que_content.forEach( (data,index) => content+=`"`+(++index)+`" : `+JSON.stringify(data)+`,`);
				content = content.substring(0,content.length-1);
				content += `}`;
				var data={
					ah:ah,
					content :content 
				};
				console.log("string ===="+JSON.stringify(data));
				console.log(img);
				
				var form = new FormData();
				form.append("data",JSON.stringify(data)); 
				img.forEach( x=> {
					form.append("img",x); //image data
				});
				
				$.ajax({
					url: "../db/upload_answer/main_server.jsp?qid=<%=qid%>&redirect=<%=request.getRequestURI()%>",
					method:"post",
					data: form,
					processData :false,
					contentType:false,
					success :function(msg){
						location.href = "/MainData/html/question_answer.jsp?id=<%=request.getParameter("qid")%>";
					}	
				});
			});
		});
	</script>
	</head>
	<body id="main-area">
    <%@include file="nav.jsp" %>
			<div class="container">
			<form class="myform border-class">
				<div class="mt-5">
					<h2 style="text-align: center">Your answer :</h2>
					<div class="form-group">
						<label for="sname">Answer Heading : </label>
						<input class="form-control check"  type="text" id="answer_heading" 
							data-regex="^[^\s].{1,}" placeholder="Answer Heading">
						<small class="text-muted form-text error" id="rah"></small>
					</div>
					<div class="div1" id="add_here">
						<!--content goes here--> 
					</div>
				</div>
				<br>
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
							<form>
								<div class="form-group tab_inner ">
									<label for="code_content" class="text">Type your code here : </label>
									<textarea class="form-control no-resize" id="code_content" rows="3" placeholder></textarea>
								</div>
							</form>
						</div>
						<div class="collapse" id="text" data-parent="#tablinks">
							<form>
								<div class="form-group tab_inner">
									<label for="text_content" class="text">Type your text here : </label>
									<textarea class="form-control no-resize check" id="text_content" 
										data-cb="check_text()" rows="3" placeholder></textarea>
									<small class="text-muted form-text error" id="rtext"></small>
								</div>
							</form>
						</div>
						<div class="collapse" id="image" data parent="#tablinks">
							<form>
								<div class="form-group tab_inner">
									<label for="file_content">Select File to upload : </label>
									<input type="file" id="file_content" class=" form-control-file" multiple="multiple">
								</div>
							</form>
						</div>
						<input type="button" class="btn btn-primary mt-4" id="add_btn" value="Add">
					</div>
				</div>
					<input type="button" class="btn btn-success mt-4" id="submit_btn" value="Submit">
			</form>
		</div>
		 <footer class="bg-dark text-white py-3">
			<div class="container">
				<p class="lead text-right">2022 &copy; IT-FORUM</p>
			</div>
		</footer>
  </body>
</html>
