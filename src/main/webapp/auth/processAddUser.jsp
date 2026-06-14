<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="java.util.*" %>
<%@page import = "java.sql.*" %>
<%@include file ="../DBconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");



    String u_login_id = request.getParameter("u_login_id");
    String u_nickname = request.getParameter("u_nickname");
    String u_password = request.getParameter("u_password");
    

   	PreparedStatement pstmt=null;
	
   	String sql = "INSERT INTO Users(u_login_id,u_password,u_nickname) Values(?,?,?)";
    
   	try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, u_login_id);
        pstmt.setString(2, u_password);
        pstmt.setString(3, u_nickname);
        pstmt.executeUpdate();
        
        response.sendRedirect("login.jsp");
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=1");
    } finally {
        if(pstmt != null)pstmt.close();
        if(conn != null) conn.close();
    }
%>