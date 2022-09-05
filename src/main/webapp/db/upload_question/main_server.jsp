<%@page import = "java.util.*"%>
<%@include file="insert_question_data.jsp"%>
<%@include file="insertImg.jsp"%>
<%@page import="org.apache.commons.fileupload.FileItemFactory" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%
	int id=Integer.parseInt(session.getAttribute("uid")+"");
	boolean isMultipart=ServletFileUpload.isMultipartContent(request);
	if(isMultipart){
		FileItemFactory factory=new DiskFileItemFactory();
		ServletFileUpload upload=new ServletFileUpload(factory);
		try{
			String img_id[]=null;
			int img_counter=0;
			List items=upload.parseRequest(request);
			Iterator iterator=items.iterator();
			while(iterator.hasNext()){
				FileItem item=(FileItem)iterator.next();
				if(item.isFormField()){
					String q_img_id = insertData(item.getString(),id);
					img_id = q_img_id.split(",");
				}
				if(!item.isFormField()){
					copyImg(item,img_id[img_counter++]);
				}
			}
		}
		catch(Exception e){
			System.out.print("------error in main_server.jsp-------"+e.toString());
		}
	}
%>
