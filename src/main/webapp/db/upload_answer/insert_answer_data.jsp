<%@page import="java.util.*"%>
<%@page import="java.sql.*" %>
<%@include file="../db_details.jsp" %>
<%@page import="org.json.simple.*" %>
<%@page import="org.json.simple.parser.*" %>
<%!String insertData(String raw_data,int id,int qid){
	int replyid=0;
	JSONObject temp_obj = decoder(raw_data);
	String uanswer=(String)temp_obj.get("ah");
	JSONObject content=decoder((String)temp_obj.get("content"));
	String temp_store_img_ids = "";
	Connection con=null;
	try{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:1204/userdb","Atish","Aasavari@120416");
		PreparedStatement ps1=con.prepareStatement("insert into replies_tbl(question_id,user_id,answer_heading) values(?,?,?)");
		ps1.setInt(1,qid);
		ps1.setInt(2,id);
		ps1.setString(3,uanswer);
		ps1.executeUpdate();
		
		ps1=con.prepareStatement("select max(id) from replies_tbl");
		ResultSet rs=ps1.executeQuery();
		if(rs.next()){
			replyid=rs.getInt(1);
		}
		PreparedStatement ps2 = con.prepareStatement("insert into code_tbl(code,reply_id) values(?,?)");
		PreparedStatement ps3 = con.prepareStatement("insert into text_tbl(text,reply_id) values(?,?)");
		PreparedStatement ps4 = con.prepareStatement("insert into image_tbl(img_url,reply_id) values(?,?)");
			
		for(int i=1;i<=content.size();i++){
		JSONObject temp = (JSONObject)content.get(i+"");
		String data=(String)temp.get("data");
		String type=(String)temp.get("type");
		if(type.equals("1")){
			ps2.setString(1,data);
			ps2.setInt(2,replyid);
			ps2.executeUpdate();
		}
		else if(type.equals("2")){
			ps3.setString(1,data);
			ps3.setInt(2,replyid);
			ps3.executeUpdate();
		}
		else if(type.equals("3")){
			//storing extensions
			ps4.setString(1,data);
			ps4.setInt(2,replyid);
			ps4.executeUpdate();
			//to fetch img_id of every entry 
			PreparedStatement fetch_img_id = con.prepareStatement("select max(id) from image_tbl");
			ResultSet temp_rs = fetch_img_id.executeQuery();
			if(temp_rs.next()) temp_store_img_ids += temp_rs.getInt(1)+",";
		}
		}
		//to remove last comma
		temp_store_img_ids = temp_store_img_ids.substring(0, temp_store_img_ids.length()-1);
		
	}
	catch(Exception e){
		System.out.print("-------insert_answer_data.jsp-------"+e.toString());
	}
	//returning q_id and comma separated img_ids
	return temp_store_img_ids;
}
%>

<%!JSONObject decoder(String temp){
	JSONParser parser = new JSONParser();
	JSONObject obj=null;
	try{
	obj = (JSONObject)parser.parse(temp);
	}
	catch(Exception e){
		System.out.println("Error While parsing data to json "+e.toString());
	}
	return obj;
}%>