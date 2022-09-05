<%@include file="db_details.jsp" %>
<%@page import="java.sql.*" %>
<%
	Connection con=null;
	try{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection(connection_string,username,password);
		String reply_id=request.getParameter("reply_id");
		PreparedStatement ps=con.prepareStatement("insert into question_status(reply_id,status) values(?,?)");
		ps.setString(1,reply_id);
		ps.setString(2,"1");
		ps.executeUpdate();
	}
	catch(Exception e){
		System.out.print(request.getRequestURI()+"-->"+ e.toString());
	}
	finally{
		if(con!=null) con.close();
	}
%>
