<%@page import="java.util.Enumeration"%>
<%@page import="org.json.simple.*" %>
<%@page import="org.json.simple.parser.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@include file="../db/db_details.jsp" %>
<%
	String redirect = request.getRequestURI();
	Enumeration paramNames = request.getParameterNames();
	redirect += paramNames.hasMoreElements() ? "?":"";
	while (paramNames.hasMoreElements()) {
			String paramName = paramNames.nextElement()+"";
			redirect+=paramName+"="+request.getParameter(paramName)+"&";
		}
	redirect = redirect.substring(0,redirect.length()-1);
	(response).setHeader("Cache-Control", "max-age=0, private,no-cache,no-store,must-revalidate");
	(response).setHeader("Expires","-1");
	Connection con=null;
	int id = Integer.parseInt(request.getParameter("id")+"");
	try{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection(connection_string,username,password);
		String query1="select q.*,u.*,ifnull(v.vc,0) views,GROUP_CONCAT(t.tags_name) tags,ifnull(l.s,0) likes,ifnull(l.c-l.s,0) dislikes "+
			" from  user u ,question_tags qt,tags_tbl t,questions q "+
			" LEFT JOIN (select question_id,count(question_id) c,sum(type) s "+
			" from likes_tbl group by question_id) l on l.question_id=? "+
			" LEFT JOIN (select count(question_id) vc,question_id qid from views_tbl GROUP by question_id) v on v.qid = ?"+
			" where q.user_id=u.id "+
			" and qt.question_id = ? "+
			" and qt.tag_id = t.id "+
			" and q.id=? ";
		PreparedStatement ps1=con.prepareStatement(query1);
		ps1.setInt(1,id);
		ps1.setInt(2,id);
		ps1.setInt(3,id);
		ps1.setInt(4,id);
		ResultSet rs=ps1.executeQuery();
		
		String[] arr;
		String text="",code="",img="";
		String query2="select * from (select concat(id,'.',img_url) c,'1' ty,timestamp t from image_tbl where question_id=? "+
							" UNION ALL "+
							" select code c,'2' ty,timestamp t from code_tbl where question_id=? "+
							" UNION ALL "+
							" select text c,'3' ty,timestamp t from text_tbl WHERE question_id=?) temp ORDER by temp.t ";
		ps1=con.prepareStatement(query2);
		ps1.setInt(1,id);
		ps1.setInt(2,id);
		ps1.setInt(3,id);
		ResultSet rs_ques=ps1.executeQuery();
		
		String query3="select * from (select reply_id r,concat(id,'.',img_url) c,'1' ty,timestamp t "
						+" from image_tbl where reply_id in(SELECT id from replies_tbl WHERE question_id=?) " 
						+" UNION ALL "
						+" select reply_id r,code c,'2' ty,timestamp t "
						+" from code_tbl where reply_id in(SELECT id from replies_tbl WHERE question_id=?) "
						+" UNION ALL " 
						+" select reply_id r,text c,'3' ty,timestamp t "
						+" from text_tbl WHERE reply_id in(SELECT id from replies_tbl WHERE question_id=?))"
						+" temp, replies_tbl r,user u where temp.r = r.id and u.id=r.user_id ORDER by temp.r,temp.t ";
		ps1=con.prepareStatement(query3);
		ps1.setInt(1,id);
		ps1.setInt(2,id);
		ps1.setInt(3,id);
		ResultSet rs_ans=ps1.executeQuery();
		
		if(rs.next()){
			
			int q_uid=Integer.parseInt(rs.getString("q.user_id")+"");
			System.out.println(q_uid);
			if(session.getAttribute("uid")!=null){
				int uid=Integer.parseInt(session.getAttribute("uid")+"");
				boolean view_status=false;
				String views_query="select * from views_tbl where user_id=? and question_id=? ";
				ps1=con.prepareStatement(views_query);
				ps1.setInt(1,uid);
				ps1.setInt(2,id);
				ResultSet rs_views	=ps1.executeQuery();
				
				if(rs_views.next()){
					view_status=false;
				}
				else{
					view_status=true;
					if(uid!=q_uid){
						String insert_view="insert into views_tbl(user_id,question_id) values(?,?)";
						ps1=con.prepareStatement(insert_view);
						ps1.setInt(1,uid);
						ps1.setInt(2,id);
						ps1.executeUpdate();
					}
				}
			}
		%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Question_Answer</title>
		
		<%@include file="libs.jsp" %>
		<script type="text/javascript">
			$(document).ready(function(){
				$("#nav_tags").click(function(){
					$("#tag_input").focus();
				});
				$("#nav_users").click(function(){
					$("#user_input").focus();
				});
				$(".comment_btn").click(function(){
					var reply=$(this)[0].dataset.id;
					var comment=$(this).parent().find(".comment_input").val();
					$.ajax({
						method : "post",
						url:"../db/post_comment.jsp",
						data: {
							comment :comment,
							reply : reply
						},
						success: function () {
								$(".comment_input").val("");
									}
					});
				});
				$(".tutd").click(function (){
//					question=1 and answer=2
					var type=$(this).parents(".question").attr("id");
					var like_dislike=$(this).attr("id");
					var id=$(this).parents(".question")[0].dataset.id;
					$.ajax({
						method : "post",
						url:"../db/LikeDislike.jsp",
						data : {
							type : type,
							like_dislike : like_dislike,
							id : id
						},
						success : function (){
							console.log("-----")
						}
					});
				});
				$(".reply_solved").click(function(){
					var reply_id=$(this)[0].dataset.id;
					var elem = this;
					$.ajax({
						method : "post",
						url:"../db/resolved.jsp",
						data : {
							reply_id : reply_id
						},
						success : function (){
							$(elem).hide();
						}
					});
				});
		});
		</script>
	</head>
	<body id="main-area">
	<%@include file="nav.jsp" %>	
	<section class="py-3">
      <div class="container">
		<div class="row py-3">
        <div class="col-md-8 border">
          <div class="mb-3 ">     
				<%boolean is_owner=false;
					int like_type=-1;
					String like="",dislike="",like_class=" tutd";
					if(session.getAttribute("uid")!=null){
						String query_ques="select * from likes_tbl where question_id="+id+" and user_id="+session.getAttribute("uid");
						ResultSet rs_q=con.prepareStatement(query_ques).executeQuery();
						if(rs_q.next()){ 
							like_type=rs_q.getInt("type");
							like_class="";
							if(like_type==1) like="style='color:var(--tgreen);'";
							if(like_type==0) dislike="style='color:var(--tgreen);'";
						}
						if(session.getAttribute("uid")==null) like_class="";
					}
				%>		
              <div class="row no-gutters border-bottom p-2 align-items-bottom pb-3 question" id="1" data-id="<%=request.getParameter("id")%>">
                <div class="d-flex flex-column align-items-center justify-content-around col-1 ">
				<%if(session.getAttribute("uid")==null){%>
						<a style="text-decoration: none;color: black;" href="login_signup.jsp?redirect=<%=redirect%>">
				<%}%>
                  <span class="t-vote" <%=like%>>
					<i class="fas fa-thumbs-up<%=like_class%>" id="1"></i> 
					<span id="likes"><%=rs.getString("likes")%></span>
				</span>
                  <span class="t-vote" <%=dislike%> >
					<i class="fas fa-thumbs-down<%=like_class%>" id="0"></i>
					<span id="dislikes"><%=rs.getString("dislikes")%></span>
				</span>
				<%if(session.getAttribute("uid")==null){%>
					</a>
				<%}%>
                </div>
                <div class="questions col-11">
                  <a class="card-title h5 pl-2 mb-0 d-block qh pb-0" href="#">
                    <h2 class=""><%=rs.getString("q.question_heading")%></h2>
                  </a>
                </div>
				<%if(session.getAttribute("uid")!=null){
					int quid=Integer.parseInt(rs.getString("q.user_id"));
					int uid=Integer.parseInt(session.getAttribute("uid")+"");
						if(quid==uid){
							is_owner=true;
						}
					}
					%>	
								
              </div>
              <div class="row no-gutters mt-2 justify-content-between align-items-center	">
                <p class="tags d-flex justify-content-start">
				<%arr=rs.getString("tags").split(",");
						for (int i = 0; i < arr.length; i++) {
							%><strong class="tag-content"><%=arr[i]%></strong>																																																
				<% }%>
                </p>
				<p><i class="fas fa-eye"></i> <a id="views"><%=rs.getString("views")%></a></p>
				<section id="q-content">
					<h1>Question Section</h1><!--question content-->
					<%
						String content="";
						while(rs_ques.next()){
							if(rs_ques.getString("temp.ty").equals("3")){
								content = rs_ques.getString("temp.c");
								String template = "<div class='py-3'><p id='q-text' class='text-justify h5'>"+content+"</p></div>";
								out.print(template);
							}else if(rs_ques.getString("temp.ty").equals("2")){
								content = rs_ques.getString("temp.c");
								content = content.replace("&","&amp;").replace("<", "&lt;").replace(">", "&gt;");
								String template = "<div class='py-3'><div class='bg-light mh-300'>"
												+ "<code id='q-code'>"+content+"</code></div></div>";
								out.print(template);
							}else if(rs_ques.getString("temp.ty").equals("1")){
								content = rs_ques.getString("temp.c");
								String template = "<div class='py-3'><a href='../question_images/"+content+" ' id='q-img' target='_blank'>"
								+ "<img width='100%' height='300px' src='../question_images/"+content+" '></a></div>";
								out.print(template);
							}
						}
					%>
				</section>
              </div>
              <h3 class="display-4 w-100">Answers</h3>
              <div id="q-answers" class="w-100">
                <div class="col-md-12">
                  <div id="accordion">
				<%!String getHeading(ResultSet rs_ans,String replyid,HttpSession s,Connection c,Boolean is_owner) throws Exception{
					String temp=""; 
					int like_type=-1;
					String like="",dislike="",like_class=" tutd";
					temp=rs_ans.getString("r.id");
					if(s.getAttribute("uid")!=null){
						String query_ans="select * from likes_tbl where reply_id="+replyid+" and user_id="+s.getAttribute("uid");
						ResultSet rs =c.prepareStatement(query_ans).executeQuery();
						if(rs.next()){
							like_type=rs.getInt("type");
							like_class="";
							if(like_type==1) like="style='color:var(--tgreen);'";
							if(like_type==0) dislike="style='color:var(--tgreen);'";
						}
					}
					int clike=0,cdislike=0;
					String query_like_ans="select l.reply_id,sum(l.type) likes,count(l.reply_id)-sum(l.type) dislikes from likes_tbl l,replies_tbl r " 
								+" where l.reply_id = r.id and l.reply_id='"+replyid+"' group by l.reply_id";
					ResultSet rs_like_ans=c.prepareStatement(query_like_ans).executeQuery();
					if(rs_like_ans.next()){
						clike=rs_like_ans.getInt("likes");
						cdislike=rs_like_ans.getInt("dislikes");
					}
					String solvedBtn = "<input type='button' class='btn btn-success mr-2 reply_solved' data-id="+replyid+" value='solve'>";
					String solved_green="";
					if(!is_owner) solvedBtn="";
					String query_ans="select * from question_status where reply_id ="+replyid;
						ResultSet rs_btn =c.prepareStatement(query_ans).executeQuery();
						if(rs_btn.next()){
							solved_green=" alert-success";
							solvedBtn="<input type='button' class='btn btn-success mr-2' disabled value='solved'>";
						}
					String a_template="<div class='card-header'><div class='row no-gutters question' id='2' data-id='"+replyid+"'>"
					+"<div class='d-flex flex-column align-items-start justify-content-around col-1 '>"
					+"<span class='t-vote' "+like+"><i class='fas fa-thumbs-up"+like_class+"' id='1'></i><span id='likes'>"+clike+"</span></span>"
					+"<span class='t-vote' "+dislike+"><i class='fas fa-thumbs-down"+like_class+"' id='0'></i><span id='dislikes'>"+cdislike+"</span></span>"
					+" </div><h5 class='mb-0 col-11 pl-mb-2'><a data-toggle='collapse' data-target='#rep"+replyid+"'"
					+ "><h4 class='"+solved_green+"'>"+rs_ans.getString("r.answer_heading")+"</h4></a></h5></div>"
					+ "<p class='blockquote-footer text-muted text-right text-uppercase'> answered by "
					+ "<a href='user_profile.jsp?uid="+rs_ans.getString("r.user_id")+"' class='userid'>"+rs_ans.getString("u.name")+"</a>"
									+ solvedBtn+"</p></div>";
					return a_template;
				}%>			
				<%
				String reply_id="";
				boolean forward=true;
				if(rs_ans.next())
				while(forward){
					reply_id=rs_ans.getString("temp.r");
					String temp = reply_id;
					reply_id = reply_id.trim();
					String ans_head=getHeading(rs_ans,reply_id,session,con,is_owner);
				%>
					<div class="card"><%=ans_head%>
						<div data-na="<%=reply_id%>" id="rep<%=reply_id%>" class="collapse"  data-parent="#accordion">
							<div class="card-body">
							<div class="row no-gutters"><section id="q-content">
							<%
								while(temp.equals(reply_id)){
									if(rs_ans.getString("temp.ty").equals("3")){
										content = rs_ans.getString("temp.c");
										String template = "<div class='py-3'><p id='q-text' class='text-justify h5'>"+content+"</p></div>";
										out.print(template);
									}else if(rs_ans.getString("temp.ty").equals("2")){
										content = rs_ans.getString("temp.c");
										content = content.replace("&","&amp;").replace("<", "&lt;").replace(">", "&gt;");
										String template = "<div class='py-3'><div class='bg-light mh-300'>"
															+ "<code id='q-code'>"+content+"</code></div></div>";
										out.print(template);
									}else if(rs_ans.getString("temp.ty").equals("1")){
										content = rs_ans.getString("temp.c");
										String template = "<div class='py-3'><a href='../answer_images/"+content+"' id='q-img' target='_blank'>"
											+ "<img width='100%' height='300px' src='../answer_images/"+content+"'></a></div>";
										out.print(template);
										}
									forward = rs_ans.next();
									if(forward) reply_id=rs_ans.getString("temp.r");
									else reply_id="-1";
									}
							%>						
                           </section></div></div>
						<div class="card mt-3">
							<div class="card-block">
						<%
						String comment_query="SELECT u.*,c.* FROM user u,comments_tbl c "
														  +" WHERE u.id=c.user_id AND c.reply_id=?";
						ps1=con.prepareStatement(comment_query);
						ps1.setString(1,temp);
						ResultSet rs_comment=ps1.executeQuery();
						while(rs_comment.next()){
							String comment=rs_comment.getString("c.comment");
							String uname=rs_comment.getString("u.name");
							String user_id=rs_comment.getString("u.id");
							String temp_comment="<div class='input-group-prepend'><span class='ml-3'>"
															+"<i class='fas fa-user mr-1'></i>"
															+"<span ><a class='user_profile' href='user_profile.jsp?uid="+user_id+"'>"+uname+"</a> commented : </span>"
															+"<span>"+comment+"</span></span></div>";
							out.println(temp_comment);
						}
					%>
                      </div>
                    </div>
                    <div id="accordions" role="tablist" aria-multiselectable="true">
                      <div class="card">
                        <div class="card-header" role="tab" id="headingOne">
                          <div class="row">
						<label class="h6">Add Comment</label>
                              <textarea class="form-control comment_input" style="resize: none;"></textarea>
							<%if(session.getAttribute("uid")!=null){%>								
							<input type="button" class="comment_btn" value="Publish" data-id="<%=temp%>">
							<%}else{%>
							<a href="login_signup.jsp?redirect=<%=redirect%>"><button type="button">Publish</button></a>
							<%}%>
                          </div>
                        </div>
                      </div>
                    </div> 		
					</div>
				</div>
			<%}%>
                  </div>
                </div>
              </div>
          </div> 
			<a href="post_answer.jsp?qid=<%=id%>" class="btn btn-success btn-lg active d-flex justify-content-center" 
			role="button" aria-pressed="true">Reply to this</a>
        </div>
        <div class="col-md-4">
			<div class="card">
				<div class="card-header alert-success">
					<h3 class="card-title display-5 text-center">All Question </h3>
				</div>
			</div>
				<%	
					String related="select * from questions";
					PreparedStatement ps_related=con.prepareStatement(related);
					ResultSet rs_related=ps_related.executeQuery();
					while(rs_related.next()){
						%>
						<div class="card">
							<div class="card-block">
								<p class="p-3"><%=rs_related.getString("question_heading")%></p>
							</div>
						</div>
					<%}%>	
			
		</div>
      </div>
	</div>
</section>
<footer class="bg-dark text-white py-3">
	<div class="container">
		<p class="lead text-right">2022 &copy; IT-FORUM</p>
	</div>
</footer>
</body>
</html>
<%
	}
	}
	catch(Exception e){
		System.out.println(redirect+"-->"+ e.toString());
	}
	finally{
		if(con!=null) con.close();
	}
%>