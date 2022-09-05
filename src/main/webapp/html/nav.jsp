<%@page import="java.util.Enumeration"%>
<%
	String nav_redirect = request.getRequestURI();
	Enumeration nav_paramNames = request.getParameterNames();
	nav_redirect += nav_paramNames.hasMoreElements() ? "?":	"";
	boolean paramAdded= false;
	while (nav_paramNames.hasMoreElements()) {
		paramAdded	= true;
			String paramName = nav_paramNames.nextElement()+"";
			nav_redirect+=paramName+"="+request.getParameter(paramName)+"&";
			System.out.println(nav_redirect);
		}
	if(paramAdded) nav_redirect = nav_redirect.substring(0,nav_redirect.length()-1);
	System.out.println(nav_redirect);
%>
<nav class="navbar navbar-expand-md bg-light navbar-light fixed-top py-2">
	<div class="container">
		<a href="index.jsp#main-area" class="navbar-brand">
			<img src="../asset/images/logo.png" height="50" width="50" alt="">
			<h3 class="d-inline align-middle">IT-FORUMS</h3>
			
		</a>
		<button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#mynav">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="mynav" class="collapse navbar-collapse">
			<ul class="navbar-nav ml-5 c-menu">
				<li class="nav-item"><a href="index.jsp#main-area" class="nav-link">Home</a></li>
				<li class="nav-item"><a href="index.jsp#subscribe" id="searchbtn" class="nav-link">Search</a></li>
				<li class="nav-item"><a href="index.jsp#tag_input" class="nav-link" id="nav_tags">Tags</a></li>
				<li class="nav-item"><a href="index.jsp#topq" class="nav-link">Top Questions</a></li>
				<li class="nav-item"><a href="index.jsp#user_input" class="nav-link" id="nav_users">Users</a></li>
				<%if(session.getAttribute("uid")!=null){ %>
				<li class="nav-item dropdown">
					<a href="#" class="nav-link dropdown-toggle text-uppercase" id="dropdownMenu1" data-toggle="dropdown" 
						aria-haspopup="true" aria-expanded="false"><i class="fas fa-user-circle mr-2"></i><%=session.getAttribute("uname")%></a>
					<div class="dropdown-menu" aria-labelledby="dropdownMenu1">
						<a class="dropdown-item" href="retrieve_user_questions.jsp"><i class="fas fa-question-circle mr-2"></i>Questions</a>
						<a class="dropdown-item" href="retrieve_user_replies.jsp"><i class="fas fa-comments mr-2"></i>Replies</a>
						<a class="dropdown-item" href="user_profile.jsp?uid=<%=session.getAttribute("uid")%>"><i class="fas fa-user mr-2"></i>Account</a>
						<a class="dropdown-item" id="logoutbtn" href="remove.jsp?redirect=<%=nav_redirect%>"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
					</div>
				</li>
<!--	<li class="nav-item dropdown notification ml-5">
		<a href="#" class="nav-link" id="dropdownMenu2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fas fa-bell"></i></a>
		<div class="dropdown-menu" aria-labelledby="dropdownMenu2">
			<ul class="list-group notify-menu">
				<li class="list-group-item">Cras justo odio</li>
				<li class="list-group-item">Dapibus ac facilisis in</li>
				<li class="list-group-item">Morbi leo risus</li>
				<li class="list-group-item">Porta ac consectetur ac</li>
				<li class="list-group-item">Vestibulum at eros</li>
			</ul>
		</div>
	</li>-->
	<% } else if(session.getAttribute("uid")==null){%>
	<li class="nav-item">
		<a  href="login_signup.jsp?redirect=<%=nav_redirect%>" class="nav-link">LogIn / SignUp</a>
	</li>
	<% } %>
			</ul>
		</div>
	</div>
</nav>