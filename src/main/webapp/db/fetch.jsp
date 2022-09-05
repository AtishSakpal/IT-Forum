<%@include file="db_details.jsp" %>
<%@page import="java.sql.*" %>
<%
	Connection con=null;
	String content="";
	String para="%"+request.getParameter("search")+"%";
	try{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:1204/userdb","Atish","Aasavari@120416");
		PreparedStatement pst = con.prepareStatement("select * from tags_tbl where tags_name like ?");
		pst.setString(1,para);
		ResultSet rs = pst.executeQuery();
		content="[ ";
		while(rs.next()){
			content+="{\"id\":\""+rs.getString(1)+"\",\"name\":\""+rs.getString("tags_name")+"\"},";
		}
		content=content.length()==1 ? content : content.substring(0,content.length()-1);
		content+="]";
		out.print(content);
	}
	catch(Exception e){
		System.out.println(request.getRequestURI()+"-->"+ e.toString());
	}
	finally{
		if(con!=null) con.close();
	}
%>