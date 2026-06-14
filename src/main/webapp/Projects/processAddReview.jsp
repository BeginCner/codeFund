<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="dto.User" %>
<%@ include file="../DBconn.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("../auth/login.jsp");
        return;
    }

    String p_id = request.getParameter("p_id");
    String r_content = request.getParameter("r_content");
    String r_ratingStr = request.getParameter("r_rating");

    if (p_id == null || r_content == null || r_content.trim().isEmpty() || r_ratingStr == null) {
        response.sendRedirect("projectInfo.jsp?p_id=" + p_id + "&error=empty_review");
        return;
    }

    PreparedStatement pstmt = null;
    // r_rating 컬럼을 추가해 3개의 파라미터를 인서트합니다.
    String sql = "INSERT INTO Reviews (p_id, u_id, r_content, r_rating) VALUES (?, ?, ?, ?)";

    try {
        int r_rating = Integer.parseInt(r_ratingStr.trim());

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, p_id);
        pstmt.setInt(2, loginUser.getU_id()); 
        pstmt.setString(3, r_content);
        pstmt.setInt(4, r_rating);
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            response.sendRedirect("projectInfo.jsp?p_id=" + p_id);
        } else {
            response.sendRedirect("projectInfo.jsp?p_id=" + p_id + "&error=fail");
        }
    } catch (java.sql.SQLIntegrityConstraintViolationException e) {
        // UNIQUE KEY 제약조건 위반 시 처리 (중복 등록 검증)
        System.out.println("[알림] 중복 리뷰 등록 시도 차단: u_id=" + loginUser.getU_id() + ", p_id=" + p_id);
        response.sendRedirect("projectInfo.jsp?p_id=" + p_id + "&error=duplicate");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("projectInfo.jsp?p_id=" + p_id + "&error=db_error");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
        if (conn != null) try { conn.close(); } catch(SQLException e) {}
    }
%>