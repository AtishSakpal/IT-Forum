<%@page import="java.util.*"%>
<%@page import="java.sql.*" %>
<%@include file="../db_details.jsp" %>
<%@page import="org.json.simple.*" %>
<%@page import="org.json.simple.parser.*" %>
<%!String insertData(String raw_data){
	int user_id=0;
	String temp_store_img_ids = "";
	Connection con=null;
	try{
		JSONObject temp_obj = decoder(raw_data);
		String displayname=(String)temp_obj.get("displayname");
		String email=(String)temp_obj.get("email");
		String pass=(String)temp_obj.get("pass");
		int notify=Integer.parseInt((String)temp_obj.get("notify"));
		String tags=(String)temp_obj.get("tags");
		String ext=(String)temp_obj.get("ext");
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:1204/userdb","Atish","Aasavari@120416");
		PreparedStatement ps = con.prepareStatement("insert into user(name,email,u_password,notify,img_url) values(?,?,?,?,?)");
		ps.setString(1,displayname);
		ps.setString(2,email);
		ps.setString(3,pass);
		ps.setInt(4,notify);
		ps.setString(5,ext);
		ps.executeUpdate();
		String maxid="select max(id) from user";
		ps=con.prepareStatement(maxid);
		System.out.println(ps);
		ResultSet rs=ps.executeQuery();
		if(rs.next()){
			user_id=rs.getInt(1);
		}
		String query=	" INSERT INTO user_tags(tags_id,user_id) "+
							" SELECT tags_tbl.id,("+maxid+") "+
							" FROM tags_tbl WHERE tags_tbl.id in("+tags+") ";
		ps=con.prepareStatement(query);
		ps.executeUpdate(); 
		temp_store_img_ids += user_id+",";
		//to remove last comma
		temp_store_img_ids = temp_store_img_ids.substring(0, temp_store_img_ids.length()-1);
	}
	catch(Exception e){
		System.out.print("-------insert_question.jsp-------"+e.getMessage());
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