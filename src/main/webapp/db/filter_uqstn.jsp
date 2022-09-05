<%@page import="java.sql.*" %>
<%@include file="db_details.jsp" %>
<%
	Connection con=null;
	int uid=Integer.parseInt(session.getAttribute("uid")+"");
	System.out.println(uid);
	try{
		int order_type=-1;
		if(request.getParameter("order_type")!=null && !request.getParameter("order_type").equals(""))
			order_type=Integer.parseInt(request.getParameter("order_type"));
		String status=request.getParameter("status");
		String tags=request.getParameter("tags");
		String users=request.getParameter("users");
		String orders[] = {"timestamp desc","timestamp","views desc"};
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection(connection_string,username,password);
		
		String query="select q.*,u.*,ifnull(v.vc,0) views,GROUP_CONCAT(DISTINCT t.tags_name) tags,ifnull(l.s,0) likes,ifnull(l.c-l.s,0) dislikes "+
			" from  user u ,question_tags qt,tags_tbl t, "+
			" questions q LEFT JOIN (select question_id,count(question_id) c,sum(type) s from likes_tbl group by question_id) l "+
			"on l.question_id=q.id  left join (select count(question_id) vc,question_id qid from views_tbl GROUP by question_id) v on v.qid = q.id"+
			" where q.user_id=? "+
			" and qt.question_id = q.id "+
			" and qt.tag_id = t.id ";
		if(status!=null && status.length()>0){
			String in = status.equals("0")?"not in" : "in";
			query += " and q.id "+in+" (select DISTINCT r.question_id from replies_tbl r, question_status qs where r.id=qs.reply_id and qs.status=1) ";
		}
		if(tags!=null && tags.length()>0){
			query += " and q.id in (select question_id from question_tags where tag_id in ("+tags+")) ";
		}
		query+= " group by qt.question_id";
		if(order_type>0 && order_type<4 ){
			query+=" order by "+orders[--order_type];
		}
		PreparedStatement ps2=con.prepareStatement(query);
		ps2.setInt(1,uid);
		ResultSet rs1=ps2.executeQuery();
		String qh="[ ";
		while(rs1.next()){
			qh+="{\"id\":\""+rs1.getString("q.id")+"\",\"question\":\""+rs1.getString("q.question_heading")+"\",";
			qh+="\"tags\":\""+rs1.getString("tags") +"\",\"timestamp\":\""+rs1.getString("q.timestamp")+"\",";
			qh+="\"likes\":\""+rs1.getString("likes") +"\",\"dislikes\":\""+rs1.getString("dislikes")+"\",";
			qh+="\"views\":\""+rs1.getString("views") +"\"},";
		}
		qh = qh.substring(0,qh.length()-1);
		qh+="]";
		out.print(qh);
	}
	catch(Exception e){
		System.out.println(request.getRequestURI()+"-->"+ e.toString());
	}
	finally{
		if(con!=null) con.close();
	}
%>


