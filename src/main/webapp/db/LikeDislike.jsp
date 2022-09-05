<%
	if(session.getAttribute("uid")==null){
		response.sendRedirect("../html/login_signup.jsp?redirect="+request.getRequestURI());
	}
%>
<%@include file="db_details.jsp" %>
<%@page import="java.sql.*" %>
<%
	Connection con=null;
	PreparedStatement ps=null;
	ResultSet rs_check=null;
	try{
		String type=request.getParameter("type");
		String like_dislike=request.getParameter("like_dislike");
		String id=request.getParameter("id");
		String user_id=session.getAttribute("uid")+"";
		String comment=request.getParameter("comment");
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection(connection_string,username,password);
		String insert_query="";
		String check="";
		if(session.getAttribute("uid")!=null){
			if(type.equals("1")){
				check="SELECT * FROM questions WHERE user_id=? AND id=?";
				ps=con.prepareStatement(check);
				ps.setString(1,user_id);
				ps.setString(2,id);
				rs_check=ps.executeQuery();
				if(!rs_check.next()){
					insert_query="INSERT INTO likes_tbl(question_id,type,user_id) VALUES(?,?,?)";
				}
			}
			else if(type.equals("2")){
				check="SELECT * FROM replies_tbl WHERE user_id=? AND id=?";
				ps=con.prepareStatement(check);
				ps.setString(1,user_id);
				ps.setString(2,id);
				rs_check=ps.executeQuery();
				if(!rs_check.next()){
					insert_query="INSERT INTO likes_tbl(reply_id,type,user_id) VALUES(?,?,?)";
				}
			}
		}
		else{
			response.sendRedirect("../html/login_signup.jsp");
		}
		ps=con.prepareStatement(insert_query);
		System.out.println(ps);
		ps.setString(1,id);
		ps.setString(2,like_dislike);
		ps.setString(3,user_id);
		ps.executeUpdate();
	}
	catch(Exception e){
		System.out.print(request.getRequestURI()+"-->"+ e.toString());
	}
	finally{
		if(con!=null) con.close();
	}
%>
