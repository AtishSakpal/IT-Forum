<%@include file="db_details.jsp" %>
<%@page import="java.sql.*" %>
<%
	Connection con=null;
	try{
		String reply=request.getParameter("reply");
		int uid=Integer.parseInt(session.getAttribute("uid")+"");
		String comment=request.getParameter("comment");
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection(connection_string,username,password);
		PreparedStatement ps=con.prepareStatement("insert into comments_tbl(reply_id,user_id,comment) values(?,?,?)");
		ps.setString(1,reply);
		ps.setInt(2,uid);
		ps.setString(3,comment);
		ps.executeUpdate();
	}
	catch(Exception e){
		System.out.print(request.getRequestURI()+"-->"+ e.toString());
	}
	finally{
		if(con!=null) con.close();
	}
%>
