<%@page import="java.sql.*" %>	
<%@include file="../db/db_details.jsp" %>
<%
	String redirect = request.getRequestURI();
	(response).setHeader("Cache-Control", "max-age=0, private,no-cache,no-store,must-revalidate");
	(response).setHeader("Expires","-1");
	Connection con=null;
	int id = Integer.parseInt(session.getAttribute("uid")+"");
	try{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection(connection_string,username,password);
		String[] arr;
		String text="",code="",img="";
		String query3="select * from (select reply_id r,concat(id,'.',img_url) c,'1' ty,timestamp t from image_tbl where reply_id in(SELECT id from replies_tbl WHERE user_id=?)"
							+" UNION ALL"
							+" select reply_id r,code c,'2' ty,timestamp t from code_tbl where reply_id in(SELECT id from replies_tbl WHERE user_id=?)"
							+" UNION ALL"
							+" select reply_id r,text c,'3' ty,timestamp t from text_tbl WHERE reply_id in(SELECT id from replies_tbl WHERE user_id=?)) temp "
							+" ,replies_tbl r,user u,questions q "
							+" where temp.r = r.id" 
							+" and u.id=r.user_id"
							+" AND q.id=r.question_id"
							+" ORDER by temp.r,temp.t,r.id";
		PreparedStatement ps2=con.prepareStatement(query3);
		ps2.setInt(1,id);
		ps2.setInt(2,id);
		ps2.setInt(3,id);
		System.out.println(ps2);
		ResultSet rs_ans=ps2.executeQuery();
		//if(rs_ans.next()){
		%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@include file="libs.jsp" %>
		<title>My Replies</title>
		<script>
			function addToDatalist(value, elem, data) {
				$(elem).append("<option data-id=" + value.id + " value=" + value.name + "></option>");
				var index = data.selected.indexOf(value);
				data.selected.splice(index, 1);
				data.datalist.push(value);
			}
			var intelli_data = {
				tags: {
					selected: [],
					datalist: [],
					regex: false,	
					onadd: function (value, elem, data) {
						$("#tag_alert").append("<div class='tag_holder' style='margin-left:10px'><div id='curr' class='alert alert-info'><strong id='abc'>"
										+ value.name +
										"</strong><button type='button' class='close' data-dismiss='alert' >&times;</button></div></div>");
						var curr = $("#tag_alert").children().last();
						curr.find(".close").on("click", _ => {
							$(this).parentsUntil(".tag_holder").remove();
							addToDatalist(value, elem, data);
							getGridData();
						});
						getGridData();
					}
				},
				user: {
					selected: [],
					datalist: [],
					regex: false,
					onadd: function (value, elem, data) {
						$("#user_alert").append("<div class='tag_holder' style='margin-left:10px'><div class='alert alert-info'><strong>"
										+ value.name +
										"</strong><button type='button' class='close' data-dismiss='alert' >&times;</button></div></div>");
						var curr = $("#user_alert").children().last();
						curr.find(".close").on("click", _ => {
							$(this).parentsUntil(".tag_holder").remove();
							addToDatalist(value, elem, data);
							getGridData();
						});
						getGridData();
					}
				}
			};
		</script>
	</head>
	<body id="main-area">
	<%@include file="nav.jsp" %>
	<section id="topq" class="py-5 bg-light">
      <div class="container">
        <div class="row">
             <div class="col-md-8">
                  <div id="accordion">
				<%!String getHeading(ResultSet rs_ans,String quesid,HttpSession s,Connection c) throws Exception{
					String temp=""; 
					int like_type=-1;
					String like="",dislike="",like_class=" tutd";
					temp=rs_ans.getString("r.id");
					if(s.getAttribute("uid")!=null){
						String query_ans="select * from likes_tbl where question_id="+quesid+" and user_id="+s.getAttribute("uid");
						ResultSet rs =c.prepareStatement(query_ans).executeQuery();
						if(rs.next()){
							like_type=rs.getInt("type");
							like_class="";
							if(like_type==1) like="style='color:var(--tgreen);'";
							if(like_type==0) dislike="style='color:var(--tgreen);'";
						}
					}
					int clike=0,cdislike=0;
					String username="";
					String query_like_ans="select u.*,l.question_id,sum(l.type) likes,count(l.question_id)-sum(l.type) dislikes from likes_tbl l,questions q,user u " 
								+" where q.user_id=u.id and l.question_id = q.id and l.question_id='"+quesid+"' group by l.question_id";
					ResultSet rs_like_ans=c.prepareStatement(query_like_ans).executeQuery();
					if(rs_like_ans.next()){
						clike=rs_like_ans.getInt("likes");
						cdislike=rs_like_ans.getInt("dislikes");
					}
					String a_template="<div class='card-header'><div class='row no-gutters question' id='2' data-id='"+quesid+"'>"
					+"<div class='d-flex flex-column align-items-start justify-content-around col-1 '>"
					+"<span class='t-vote' "+like+"><i class='fas fa-thumbs-up"+like_class+"' id='1'></i><span id='likes'>"+clike+"</span></span>"
					+"<span class='t-vote' "+dislike+"><i class='fas fa-thumbs-down"+like_class+"' id='0'></i><span id='dislikes'>"+cdislike+"</span></span>"
					+" </div><h5 class='mb-0 col-11 pl-mb-2'><a data-toggle='collapse' data-target='#rep"+quesid+"'"
					+ "><h4>"+rs_ans.getString("q.question_heading")+"</h4></a></h5></div></div>";
					return a_template;
				}%>			
				<%
				String question_id="";
				boolean forward=true;
				if(rs_ans.next())
				while(forward){
					question_id=rs_ans.getString("q.id");
					String temp = question_id;
					question_id = question_id.trim();
					String ans_head=getHeading(rs_ans,question_id,session,con);
				%>
				<div class="card mb-3"><%=ans_head%>
					<div data-na="<%=question_id%>" id="rep<%=question_id%>" class="collapse"  data-parent="#accordion">
						<div class="card-body">
						<div class="row no-gutters"><section id="q-content">
								<div class="py-3"><h3><%=rs_ans.getString("r.answer_heading")%></h3></div>
						<%
							String content="";
							while(temp.equals(question_id)){
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
										+ "<img width='100%' height='350px' src='../answer_images/"+content+"'></a></div>";
									out.print(template);
									}
								forward = rs_ans.next();
								if(forward) question_id=rs_ans.getString("q.id");
								else question_id="-1";
								}
						%>						
						</section>
						</div>
						</div>
						</div>
					</div>
				<%}%>
                  </div>
              </div>
          <div class="col-md-4">
			<div id="accordion">
          	  <div class="card">
          	    <div class="card-header" id="status">
          	      <h5 class="mb-0">
          	        <button class=" w-100 btn btn-link c-btn-link " data-toggle="collapse" data-target="#status-body">
          	         Status <i class="far fa-lightbulb"></i>
          	        </button>
          	      </h5>
          	    </div>
          	    <div id="status-body" class="collapse show" data-parent="#accordion">
          	      <div class="card-body p-0">
					<ul class="list-group">
          	      	  <li class="list-group-item">
                        <input type="radio" id="solved" class="c-check-sidebar" name="status-opt">
                        <label for="solved"><i  class="far"></i><span class="filter_status" id="1">Solved</span> 
                        </label>
                      </li>
                      <li class="list-group-item"> 
					<input type="radio" id="unsolved" class="c-check-sidebar" name="status-opt">
                        <label for="unsolved"><i  class="far"></i><span class="filter_status" id="0">Unsolved</span> 
                        </label>
                      </li>
          	      	</ul>
          	      </div>
          	    </div>
          	  </div>
			</div>
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
	//}
	}
	catch(Exception e){
		System.out.println(redirect+"-->"+ e.toString());
	}
	finally{
		if(con!=null) con.close();
	}
%>