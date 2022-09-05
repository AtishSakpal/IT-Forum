<%@page import="java.util.Enumeration"%>
<%
//	String redirect=request.getParameter("redirect");
	if(session.getAttribute("uid")!=null){
            response.sendRedirect("index.jsp");
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
		<title>Login/Signup</title>
		<script>

		var redirect='<%=request.getParameter("redirect")%>';
		console.log(redirect);
		$(document).ready(function(){
			$("#login-link").click(function(){
				$("#signup").removeClass("active");
				$("#login").addClass("active");
			});
			$("#signup-link").click(function(){
				$("#login").removeClass("active");
				$("#signup").addClass("active");
			});
		<%if(session.getAttribute("invalid")!=null){%>
				$("#login-tab").trigger("click");	
				$("#btnerror").html("Invalid credentials");
//				$("#btnerror").addClass("invalid-feedback");
		<%session.removeAttribute("invalid");}%>
		});
		</script>
		<style>
			.intel{
				display: none;
			}
			.image-container {
				position: relative;
				height: 150px;
				width: 150px;
				background:url("../asset/images/profile.jpg") no-repeat;
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
	      #login_alert{
	        height: 15%;
	        width: 100%;
	      }
	      .card {
	        margin: 0 auto; /* Added */
	        float: none; /* Added */
	        margin-bottom: 100px; /* Added */
	        
		}
		.test{
		    color:  #6c757d;

		}
		 .big-checkbox {width: 20px; height: 30px;}
		 

		 #main-area{
		    margin-top: 76px;
		}
		.c-menu li {
		    font-size: 1.4rem;
		    padding-right: 20px;
		}

		.c-menu >li > a:hover{
		    color:#32926a !important;
		}
		#main-area nav{
		    box-shadow: 0px 2px 5px 2px rgba(50,146,106,1);
		}
		.form-text
		{
			color : red;
		}
		</style>
	</head>
	<body id="main-area">
	<%@include file="nav.jsp" %>
		<section>
			<div class="container"><br>
				<!-- Nav tabs -->
				<ul class="nav nav-tabs nav justify-content-center" role="tablist">
					<li class="nav-item" >
						<a class="nav-link active alert-success" id="signup-tab" data-toggle="tab" style=" width: 34rem;" href="#signup"><center><h1>SIGNUP</h1></center></a>
					</li>
					<li class="nav-item">
						<a class="nav-link alert-success" id="login-tab" data-toggle="tab" style=" width: 34rem;" href="#login"><center><h1>LOGIN</h1></center></a>
					</li>
				</ul>
				<!-- Tab panes -->
				<div class="tab-content">
					<div id="signup" class="container tab-pane active"><br>
						<div class="container ">

							<div class="card " style="width: 40rem; " >
								<div class="card-header alert-success  " style="height: 18%">
									<h2>Sign up now <i class="fas fa-pencil-alt"></i></h2>
									<h6>enter your details to get instant access 
								</div>
								<ul class="list-group list-group-flush  ">
									<form onsubmit="event.preventDefault()"> 
										<div class="form-group" style="padding-top:0px;">
											<div> 
												<div class="mb-3">
													<div class=" image-container" style="display: block; margin-left: auto; margin-right: auto; ">
														<label for="file" class="py-5 text-center"> <i class="fas fa-plus"></i> Upload Image</label>
														<input type="file" id="file" style="display: none">    
													</div>
												</div>
											</div>
										</div>             
										<div class="form-group input-group-prepend " style="padding-right: 35px; padding-left: 35px;">
											<span class="input-group-text"><i class="fas fa-user"></i></span>
											<input class="form-control check" type="text" id="sname" data-regx="[a-zA-z0-9]{1,}"  placeholder="Enter Username">
											<small class="form-text error" id="rname"></small>
										</div>

										<div class="form-group input-group-prepend" style="padding-right: 35px; padding-left: 35px;">
											<span class="input-group-text"><i class="fas fa-envelope-square"></i></span>
											<input class="form-control check" type="text" id="semail" 
														 data-regx="^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$" placeholder="name@example.com">
											<small class="form-text error" id="remail"></small>
										</div>

										<div class="form-group input-group-prepend" style="padding-right: 35px; padding-left: 35px;">
											<span class="input-group-text"><i class="fas fa-key"></i></span>
											<input class="form-control check" type="Password" id="spass" data-regx="^.{8,}$" placeholder="Enter Password" >
											<small class="form-text error" id="rpass"></small>
										</div>

										<div class="form-group input-group-prepend" style="padding-right: 35px; padding-left: 35px;">
											<span class="input-group-text"><i class="fas fa-key"></i></span>
											<input class="form-control check" type="password" id="scpass" data-regx="" data-cb="checkpass()" placeholder="Re-Enter Password">
											<small class="form-text error" id="rcpass"></small>
										</div>

										<div class="form-group input-group-prepend" style="padding-right: 35px; padding-left: 35px;">
											<span class="input-group-text"><i class="fas fa-tags"></i></span>
											<input list="tags" id="tag_input" data-cb="check_tags()" data-url="../db/fetch.jsp" class="intelli_input form-control" placeholder="Interested Tags ">
											<datalist id="tags">
											</datalist>
											<small class="form-text error" id="rtags"></small>

										</div>
										<div class="mt-4 justify-content-start"  style="display: flex;flex-wrap: wrap;" id="tag_alert">
											<!--            alert of tag-->
										</div>

										<div class="form-check" style="padding-right: 60px; padding-left: 60px;">
											<label class="form-check-label">
												<input class="form-check-input big-checkbox " type="checkbox"> 
												<h5 class="test p-2"> Notify me</h5>
											</label>
										</div>

										<div class="">
											<center><button type="button" id="newacbtn" class="btn mb-4 text-white" style="background-color:#32926a;">Create new account <i class="fas fa-user"></i></button></center>
											<div class="mb-4">
												<center><small ><a href="" id="login-link" class="h6" style="color:#32926a;">Already Have An Account ? LogIn</a></small></center>
											</div>
										</div>
									</form>
								</ul>
							</div>
						</div>
					</div>
					<div id="login" class="container tab-pane fade"><br>
						<div class="container">
							<div class="card p-5" style="width: 50rem;" >
								<div class="card-header alert-success  " style="height: 18%">
									<h2>Login to your account <i class="fas fa-lock"></i></h2>
									<h6>Enter username and password to log in</h6>
								</div>
								<form method="post" action="../db/check.jsp"> 
									<div class="form-group input-group-prepend" style="padding-top: 40px;">
										<span class="input-group-text"><i class="fas fa-user"></i></span>
										<input class="form-control" type="text" name="name" id="uname" data-regx="[a-zA-z0-9]{1,}"  placeholder="Enter Username Or Email">
										<small class="form-text error" id="runame"></small>
									</div>
									<div class="form-group input-group-prepend">
										<span class="input-group-text"><i class="fas fa-key"></i></span>
										<input class="form-control" type="Password" name="password" id="pass" data-regx="" placeholder="Enter Password" >
										<input type="hidden" name="redirect" value="<%=request.getParameter("redirect")%>">
										<small class="form-text error" id="rupass"></small>
									</div>
									<center>
										<button type="submit" id="loginbtn" class="btn  mb-4 text-white" style="background-color:#32926a;">LogIn <i class="fas fa-sign-in-alt"></i>
										</button>
										<small class="form-text" id="btnerror"></small>
									</center>	
								<center>
										<small ><a href="" id="signup-link" class="h6" style="color:#32926a;">Don't Have An Account ? SignUp</a></small>
									</center>
								</form>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>	  
		</section>
		<footer class="bg-dark text-white py-3">
			<div class="container">
				<p class="lead text-right">2022 &copy; IT-FORUM</p>
			</div>
    </footer>
		<script src="javascript/script.js"></script>
		<script src="javascript/signup.js"></script>
	</body>
</html>

