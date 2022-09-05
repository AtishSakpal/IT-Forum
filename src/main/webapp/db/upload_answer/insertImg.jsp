<%@page import="java.io.File"%>
<%@page import="java.sql.*"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%!int copyImg(FileItem item,String img_id){
	try{
		String ext="";
		int i=1;
		String fileName=item.getName();
		System.out.println("filename : "+fileName);
		File path;
		String root=getServletContext().getRealPath(File.separator);
		System.out.println("root : " +root);
		path=new File(root+File.separator+"answer_images");
		if(!path.exists()){
			path.mkdirs();
		}
		String exts[]=fileName.split("\\.");
		//a.b.c.d.png
		ext=exts[exts.length-1];
		String img=img_id+ "."+ext;
		File uploadedFile=new File(path+File.separator+img);
		System.out.println("file : "+uploadedFile);
		item.write(uploadedFile);
		return 1;
	}
	catch(Exception e){
		System.out.println("Exception in---------inertImg.jsp --> "+e.toString());
		return 0;
	}
}%>
