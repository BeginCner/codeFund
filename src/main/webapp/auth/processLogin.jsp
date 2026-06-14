<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file ="../DBconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");
    String u_login_id = request.getParameter("u_login_id");
    String u_password = request.getParameter("u_password");

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    
    String sql = "SELECT * FROM Users WHERE u_login_id = ? AND u_password = ?";

    try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, u_login_id);
        pstmt.setString(2, u_password);
        rs = pstmt.executeQuery();

        if (rs.next()) {
           
        	//User 클래스로 세션 남기기
        	dto.User user = new dto.User();
        	user.setU_id(rs.getInt("u_id"));
        	user.setU_login_id(rs.getString("u_login_id"));
        	user.setU_nickname(rs.getString("u_nickname"));
        	
  
            session.setAttribute("loginUser",user);
            
          
            response.sendRedirect("../main.jsp"); 
        } else {
            response.sendRedirect("login.jsp?error=1");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=1");
    } finally {
        
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

%>