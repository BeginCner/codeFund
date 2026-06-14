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

    int p_id = 0;

    try {
        p_id = Integer.parseInt(request.getParameter("p_id"));
    } catch (Exception e) {
        response.sendRedirect("../mypage.jsp");
        return;
    }

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String title = "";
    String description = "";
    int goal = 0;
    Date endDate = null;
    String status = "";

    try {
        String sql = "SELECT * FROM Projects WHERE p_id = ? AND u_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, p_id);
        pstmt.setInt(2, currentUser.getU_id());
        rs = pstmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("p_title");
            description = rs.getString("p_description");
            goal = rs.getInt("p_goal");
            endDate = rs.getDate("p_end");
            status = rs.getString("p_status");
        } else {
            response.sendRedirect("../mypage.jsp");
            return;
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("../mypage.jsp");
        return;
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    if (description == null) {
        description = "";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>프로젝트 수정</title>
    <link rel="stylesheet" href="../resources/css/funding.css">
</head>

<body>
<div class="page">

    <%@ include file="../menu.jsp" %>

    <section class="mypage-title">
        <h1>프로젝트 수정</h1>
        <p>등록한 프로젝트의 제목, 설명, 목표 금액, 마감일을 수정할 수 있습니다.</p>
    </section>

    <section class="mypage-section">
        <h2>프로젝트 정보 수정</h2>

        <form action="./processUpdateProject.jsp" method="post" class="project-form">
            <input type="hidden" name="p_id" value="<%= p_id %>">

            <div class="form-row">
                <label>프로젝트 제목</label>
                <input type="text" name="p_title" value="<%= title %>" required>
            </div>

            <div class="form-row">
                <label>프로젝트 설명</label>
                <textarea name="p_description" rows="6" required><%= description %></textarea>
            </div>

            <div class="form-row">
                <label>목표 금액</label>
                <input type="number" name="p_goal" value="<%= goal %>" required>
            </div>

            <div class="form-row">
                <label>마감일</label>
                <input type="date" name="p_end" value="<%= endDate %>" required>
            </div>

            <div class="form-row">
                <label>현재 상태</label>
                <input type="text" value="<%= status %>" readonly>
            </div>

            <div class="form-buttons">
                <button type="submit" class="form-submit-btn">수정하기</button>
                <a href="../mypage.jsp" class="form-cancel-btn">취소</a>
            </div>
        </form>
    </section>

    <%@ include file="../footer.jsp" %>

</div>
</body>
</html>