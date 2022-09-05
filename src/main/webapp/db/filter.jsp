<%@page import="java.sql.*" %>
<%@include file="db_details.jsp" %>
<%
	Connection con=null;
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
		String query="select q.*,u.*,ifnull(v.vc,0) views,GROUP_CONCAT(t.tags_name) tags,ifnull(l.s,0) likes,ifnull(l.c-l.s,0) dislikes "+
			" from  user u ,question_tags qt,tags_tbl t, "+
			" questions q LEFT JOIN (select question_id,count(question_id) c,sum(type) s from likes_tbl group by question_id) l "+
			"on l.question_id=q.id  left join (select count(question_id) vc,question_id qid from views_tbl GROUP by question_id) v on v.qid = q.id"+
			" where q.user_id=u.id "+
			" and qt.question_id = q.id "+
			" and qt.tag_id = t.id ";
		if(status!=null && status.length()>0){
			String in = status.equals("0")?"not in" : "in";
			query += " and q.id "+in+" (select DISTINCT r.question_id from replies_tbl r, question_status qs where r.id=qs.reply_id and qs.status=1) ";
		}
		if(tags!=null && tags.length()>0){
			query += " and q.id in (select question_id from question_tags where tag_id in ("+tags+")) ";
		}
		if(users!=null && users.length()>0){
			query+= " and q.user_id in ("+users+") ";
		}
		query+= " group by qt.question_id";
		if(order_type>0 && order_type<4 ){
			query+=" order by "+orders[--order_type];
		}
		PreparedStatement ps2=con.prepareStatement(query);
//		answer content
		ResultSet rs1=ps2.executeQuery();
		
		String qh="[ ";
		while(rs1.next()){
			String qid=rs1.getString("q.id");
			String query3="select * from (select reply_id r,concat(id,'.',img_url) c,'1' ty,timestamp t "
						+" from image_tbl where reply_id in(SELECT id from replies_tbl WHERE question_id=?) " 
						+" UNION ALL "
						+" select reply_id r,code c,'2' ty,timestamp t "
						+" from code_tbl where reply_id in(SELECT id from replies_tbl WHERE question_id=?) "
						+" UNION ALL " 
						+" select reply_id r,text c,'3' ty,timestamp t "
						+" from text_tbl WHERE reply_id in(SELECT id from replies_tbl WHERE question_id=?))"
						+" temp, replies_tbl r,user u where temp.r = r.id and u.id=r.user_id ORDER by temp.r,temp.t ";
			ps2=con.prepareStatement(query3);
			ps2.setString(1,qid);
			ps2.setString(2,qid);
			ps2.setString(3,qid);
			ResultSet rs_ans=ps2.executeQuery();
			qh+="{\"id\":\""+rs1.getString("q.id")+"\",\"question\":\""+rs1.getString("q.question_heading")+"\",";
			qh+="\"tags\":\""+rs1.getString("tags") +"\",\"timestamp\":\""+rs1.getString("q.timestamp")+"\",";
			qh+="\"likes\":\""+rs1.getString("likes") +"\",\"dislikes\":\""+rs1.getString("dislikes")+"\",";
			qh+="\"views\":\""+rs1.getString("views") +"\",\"userid\":\""+rs1.getString("u.id")+"\",";
			qh+="\"users\":\""+rs1.getString("u.name") +"\",\"\":\""+rs1.getString("u.id")+"\",";
			qh+="\"users\":\""+rs1.getString("u.name") +"\"},";
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

