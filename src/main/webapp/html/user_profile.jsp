<%@include file="../db/db_details.jsp" %>
<%@page import="java.sql.*" %>
<%
	Connection con=null;
	String uid=request.getParameter("uid");
	try{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection(connection_string,username,password);
		String query = "SELECT u.*,concat(u.id,'.',u.img_url) user_img,GROUP_CONCAT(t.tags_name) tags,q.qstn_asked,r.qstn_answered "
							+" FROM user u,user_tags ut,tags_tbl t,"
							+ " (SELECT COUNT(id) qstn_asked FROM questions WHERE user_id=?) q,"
							+ " (SELECT COUNT(id) qstn_answered FROM replies_tbl WHERE user_id=?) r"
							+" WHERE u.id=? AND u.id=ut.user_id AND t.id=ut.tags_id ";
		PreparedStatement ps=con.prepareStatement(query);
		ps.setString(1,uid);
		ps.setString(2,uid);
		ps.setString(3,uid);
		ResultSet rs_user=ps.executeQuery();
		if(rs_user.next()){				
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@include file="libs.jsp" %>
		<title>User Profile</title>
		<style>
			.intel{
				display: none;
			}
			.image-container {
				/*background : url("../asset/images/profile.jpg") no-repeat;*/
				position: relative;
				height: 150px;
				width: 150px;
				background-size: contain;
			}
			.image-container:hover label {
				position: absolute;
				color: #FFF;
				background: rgba(0, 0, 0, .6);	
			}
			label{
				top: 0;
				left: 0;
				width: 100%;
				height: 100%;
				color:transparent;
				transition: .3s all ease-in-out;
			}
		</style>
		<script>
			$(document).ready(function (){
				function checkpass(){
					if($("#newpass").val()==$("#cnewpass").val()){
						$("#cnewpass").removeClass("is-invalid");
						$("#rcnewpass").html("");
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
				$("#change_pass_btn").click(function (){
					
					var curpass=$("#curpass").val();
					var newpass=$("#newpass").val();
					var cnewpass=$("#cnewpass").val();
					
					if(curpass===""){
						$("#rcurpass").html("Please enter your current password");
						$("#curpass").addClass("is-invalid").focus();
						$("#rcurpass").addClass("invalid-feedback");
						return false;
					}
					if(newpass===""  || newpass.length<8){
						$("#rnewpass").html("Password must contain atleast 8 characters");
						$("#newpass").addClass("is-invalid").focus();
						$("#rnewpass").addClass("invalid-feedback");
						return false;
					}
					if(cnewpass==="" || newpass !== cnewpass){
						$("#rcnewpass").html("Password do not match");
						$("#cnewpass").addClass("is-invalid").focus();
						$("#rcnewpass").addClass("invalid-feedback");;
						return false;
					}
					$.ajax({
						method : "post",
						url:"../db/change_pass.jsp",
						data : {
							curpass : curpass,
							newpass : newpass,
							cnewpass : cnewpass
						},
						success : function (msg){
							var msg=msg.trim();
							if(msg==="0"){
								$("#rcurpass").html("Password do not match");
								$("#curpass").addClass("is-invalid").focus();
								$("#rcurpass").addClass("invalid-feedback");
							}else{
								$("#success").html("Your password has been changed successfully").css({"color":"green"});
								$("#success").prepend("<i class='fas fa-check success mr-1'></i>");
								$(".check").val("");
							}
						}
					});
				});
				$("#logoutbtn").click(function(){					
					$.ajax({
						url : "remove.jsp",
						success: function(){
										login = 0;
										location.href="index.jsp";
									}
					});	
				});
			});
		</script>
	</head>
	<body id="main-area">
		<%@include file="nav.jsp" %>
		<div class="container">
			<div class="row">
				<div class="mb-3">
<!--					style=" background : url('../asset/user_images/1.jpg') no-repeat;-->
					<div class="image-container" style=" background : url('../user_images/<%=rs_user.getString("user_img")%>') ;background-size: cover">
						<!--<label for="file" class="text-center py-5"> <i class="fas fa-plus"></i> Upload Image</label>-->
						<input type="file" id="file" style="display: none">    
					</div>
				</div>
<!--				<div class="img-upload">
					<label for="file" class="text-center py-5 img-label"> <i class="fas fa-plus"></i> Upload Image</label>
					<input type="file" id="file" style="display: none"> 
				</div>-->
				<div class="py-4 col-8 d-flex  flex-column justify-content-between">
					<h4>Name : 
						<span class="lead"><%=rs_user.getString("u.name")%></span>
					</h4>
					<h4>E-mail :
						<span class="lead"><%=rs_user.getString("u.email")%></span>
					</h4>
					<%if(session.getAttribute("uid")!=null){%>
					<%if(session.getAttribute("uid").equals(rs_user.getString("u.id"))){%>
					<button type="button" class="btn btn btn-c-btn text-capitalize" 
						data-toggle="modal" data-target="#pass_modal">Change password</button>
					<%}%>
					<%}%>
					
				</div>
			</div>
		</div>
		<section>
			<div class="container">
				<h3 class="font-weight-bold">Interested Tags</h3>
				<p class="tags d-flex justify-content-start">
				<%
					String[] arr=rs_user.getString("tags").split(",");
						for (int i = 0; i < arr.length; i++) {
						%><strong class="tag-content"><%=arr[i]%></strong>
				<% }%>
                </p>
			</div>
		</section>
		<section id="bgcount">
			<div class="container py-3">
				<div class="row">
					<div class="col-md-6 text-center">
						<h4 class="display-4">
							<span><%=rs_user.getString("q.qstn_asked")%></span>
						</h4>
						<h3 class="h4 mt-2">Question Asked</h3>
					</div>
					<div class="col-md-6 text-center">
						<h4 class="display-4">
							<span><%=rs_user.getString("r.qstn_answered")%></span>
						</h4>
						<h3 class="h4 mt-2">Question Answered</h3>
					</div>
				</div>
			</div>
		</section>
	<!-- FOOTER -->
	<footer class="bg-dark text-white py-3">
		<div class="container">
			<p class="lead text-right">2022 &copy; ITFORUM</p>
		</div>
	</footer>

	<!-- PASSWORD MODAL -->
	<div class="modal" id="pass_modal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header bg-color">
					<div class="modal-title text-uppercase font-weight-bold">sign in
					</div>
					<button type="button" class="close" data-dismiss="modal">&times;
					</button>
				</div>
				<div class="modal-body">
						<form>
							<div class="form-group font-weight-bold">
								<label for="cpass">CURRENT PASSWORD :-</label>
								<input type="password" id="curpass" class="form-control check" data-regx="^[^\s].{1,}" placeholder="Enter Current Password">
								<small class="form-text error" id="rcurpass"></small>
							</div>
							<div class="form-row">
								<div class="col">
									<div class="form-group font-weight-bold">
										<label for=pname">PASSWORD</label>
										<input type="password" class="form-control check" id="newpass" data-regx="^.{8,}$" placeholder="Enter Password">
										<small class="form-text error" id="rnewpass"></small>
									</div>
								</div>
								<div class="col">
									<div class="form-group font-weight-bold">
										<label for=cname"> CONFIRM PASSWORD</label>
										<input type="password" class="form-control check" id="cnewpass" data-regx="" data-cb="checkpass()" placeholder="Confirm Password">
										<small class="form-text error" id="rcnewpass"></small>
									</div>
								</div>
							</div>
							<button type="button" id="change_pass_btn" class="btn btn-c-btn form-control">Confirm</button>
							<small class="form-text text-center" id="success"></small>
<!--							<div class="form-group font-weight-bold">
								<label for="otp">Enter OTP :-</label>
								<input type="text" class="form-control" id="otp">
							</div>-->
						</form>
				</div>
<!--				<div class="modal-footer">
						<button type="button" class="btn btn-c-btn" data-dismiss="modal">SUBMIT</button>
						<button type="button" class="btn btn-outline-success" data-dismiss="modal">CLOSE</button>
				</div>-->
			</div>
		</div>
	</div>
	</body>
</html>
<!--		<script>
			$(document).ready(function() {
				var options = {  
					useEasing: true,
					useGrouping: true
				};
				$('.countupthis').each(function() {
					var num = $(this).attr('numx'); //end count
					var nuen = $(this).text();
					if (nuen === "") {
						nuen = 0;
					}
					var counts = new CountUp(this, nuen, num, 0, 60, options);
					counts.start();
				});
				//form label width calc
				var cname_lbl = ($("#cname + label").width())+10;
				$("#cname").css({"padding-left":""+cname_lbl+"px"});
				var cname_lbl = ($("#cemail + label").width())+10;
				$("#cemail").css({"padding-left":""+cname_lbl+"px"});
				var cname_lbl = ($("#cmsg + label").width())+10;
				$("#cmsg").css({"padding-left":""+cname_lbl+"px"});

				console.log(cname_lbl);

			});
		</script>-->
<%
		}
	}
	catch(Exception e){
		System.out.print(request.getRequestURI()+"-->"+ e.toString());
	}
	finally{
		if(con!=null) con.close();
	}
%>