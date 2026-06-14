<%@ page contentType="text/html; charset=utf-8" %>
<%
    // 현재 유지되고 있는 세션을 가져옵니다.
 
    HttpSession userSession = request.getSession(false);

    if (userSession != null) {
        //세션 있으면 삭제 
        userSession.invalidate(); 
    }

    response.sendRedirect("../main.jsp");
%>