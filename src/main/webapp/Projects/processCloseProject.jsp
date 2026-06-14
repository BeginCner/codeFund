<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="dto.User" %>
<%@ include file="../DBconn.jsp" %>

<%
    User currentUser = (User) session.getAttribute("loginUser");

    if (currentUser == null) {
        response.sendRedirect("../loginRequired.jsp");
        return;
    }

    PreparedStatement pstmt = null;

    try {
        int p_id = Integer.parseInt(request.getParameter("p_id"));

        String sql = "UPDATE Projects "
                   + "SET p_status = '마감' "
                   + "WHERE p_id = ? AND u_id = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, p_id);
        pstmt.setInt(2, currentUser.getU_id());

        pstmt.executeUpdate();

        response.sendRedirect("../mypage.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../mypage.jsp");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>