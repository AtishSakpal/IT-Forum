<%@page import="java.sql.*" %>
<%@include file="db_details.jsp" %>
<%
	String redirect=request.getParameter("redirect");
	Connection con=null;
	String uname=request.getParameter("name");
	String upass=request.getParameter("password");
	try{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:1204/userdb","Atish","Aasavari@120416");
		PreparedStatement ps = con.prepareStatement("select * from user where (name=? or email=?) and u_password=?");
		ps.setString(1,uname);
		ps.setString(2,uname);
		ps.setString(3,upass);
		ResultSet rs=ps.executeQuery();
		if(rs.next()){
			//working?
			if(redirect.equals(null) || redirect.equals("null")){
				redirect="/MainData/html/index.jsp";
			}
			session.setAttribute("uid", rs.getString(1));
			session.setAttribute("uname", rs.getString("name"));
			response.sendRedirect(redirect);
		}
		else{
			session.setAttribute("invalid","Invalid credentials");
			response.sendRedirect("../html/login_signup.jsp");
		}
	}
	catch(Exception e){
		System.out.print(request.getRequestURI()+"-->"+ e.toString());
	}
	finally{
		if(con!=null) con.close();
	}
%>
