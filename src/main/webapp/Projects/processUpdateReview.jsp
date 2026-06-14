<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="dto.User" %>
<%@ include file="../DBconn.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 1. 세션 로그인 상태 체크
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("../auth/login.jsp");
        return;
    }

    // 2. 파라미터 수집
    String p_id = request.getParameter("p_id");
    String r_idStr = request.getParameter("r_id");
    String r_content = request.getParameter("r_content");
    String r_ratingStr = request.getParameter("r_rating");

    // 3. 유효성 검증
    if (p_id == null || r_idStr == null || r_content == null || r_content.trim().isEmpty() || r_ratingStr == null) {
        response.sendRedirect("projectInfo.jsp?p_id=" + p_id + "&error=empty_update");
        return;
    }

    PreparedStatement pstmt = null;
    // 조건절에 u_id = ? 를 추가하여 다른 사람의 게시글을 변조하는 것을 방지(보안 무결성)
    String sql = "UPDATE Reviews SET r_content = ?, r_rating = ?, r_date = CURRENT_TIMESTAMP WHERE r_id = ? AND u_id = ?";

    try {
        int r_id = Integer.parseInt(r_idStr.trim());
        int r_rating = Integer.parseInt(r_ratingStr.trim());

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, r_content);
        pstmt.setInt(2, r_rating);
        pstmt.setInt(3, r_id);
        pstmt.setInt(4, loginUser.getU_id()); 
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            // 수정 성공 시 보던 상세 페이지로 복귀
            response.sendRedirect("projectInfo.jsp?p_id=" + p_id);
        } else {
            // 본인 글이 아니거나 수정 대상이 없을 때
            response.sendRedirect("projectInfo.jsp?p_id=" + p_id + "&error=unauthorized");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("projectInfo.jsp?p_id=" + p_id + "&error=db_error");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
        if (conn != null) try { conn.close(); } catch(SQLException e) {}
    }
%>