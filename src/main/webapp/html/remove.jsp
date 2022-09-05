<%
    if(session.getAttribute("uid")!=null){
        session.removeAttribute("uid");
				
		if(request.getParameter("redirect")!=null){
			response.sendRedirect(request.getParameter("redirect"));
		}else{
			response.sendRedirect("index.jsp");
		}
	}
	
%>
