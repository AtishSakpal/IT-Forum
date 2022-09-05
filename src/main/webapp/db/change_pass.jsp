<%@page import="java.sql.*" %>
<%@include file="db_details.jsp" %>
<%
	Connection con=null;
	String c="0";
	String uid=session.getAttribute("uid")+"";
	String curpass=request.getParameter("curpass");
	String newpass=request.getParameter("newpass");
	try{
		System.out.println(uid);
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection(connection_string,username,password);
		PreparedStatement ps = con.prepareStatement("select * from user where id=?");
		ps.setString(1,uid);
		ResultSet rs=ps.executeQuery();
		if(rs.next()){
			String u_pass=rs.getString("u_password");
			if(curpass.equals(u_pass)){
				c="1";
				PreparedStatement ps1=con.prepareStatement("UPDATE user SET u_password=? WHERE id=? ");
				ps1.setString(1,newpass);
				ps1.setString(2,uid);
				ps1.executeUpdate();
			}
			else{
				out.print(c);
			}
		}
	}
	catch(Exception e){
		System.out.print(request.getRequestURI()+"-->"+ e.toString());
	}
	finally{
		if(con!=null) con.close();
	}
%>

