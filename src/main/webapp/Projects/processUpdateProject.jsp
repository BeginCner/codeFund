<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="dto.User" %>
<%@ include file="../DBconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    User currentUser = (User) session.getAttribute("loginUser");

    if (currentUser == null) {
        response.sendRedirect("../loginRequired.jsp");
        return;
    }

    PreparedStatement pstmt = null;

    try {
        int p_id = Integer.parseInt(request.getParameter("p_id"));
        String title = request.getParameter("p_title");
        String description = request.getParameter("p_description");
        int goal = Integer.parseInt(request.getParameter("p_goal"));
        String endDate = request.getParameter("p_end");

        String sql = "UPDATE Projects "
                   + "SET p_title = ?, p_description = ?, p_goal = ?, p_end = ? "
                   + "WHERE p_id = ? AND u_id = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, description);
        pstmt.setInt(3, goal);
        pstmt.setString(4, endDate);
        pstmt.setInt(5, p_id);
        pstmt.setInt(6, currentUser.getU_id());

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