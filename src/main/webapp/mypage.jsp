<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="dto.User" %>
<%@ include file="DBconn.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <link rel="stylesheet" href="./resources/css/funding.css">
</head>

<body>
<div class="page">

    <%@ include file="./menu.jsp" %>

    <%
        if (loginUser == null) {
            response.sendRedirect("./auth/login.jsp");
            return;
        }

        DecimalFormat df = new DecimalFormat("#,###");
    %>

    <section class="mypage-title">
        <p class="small-title">My Page</p>
        <h1>마이페이지</h1>
        <p><%= loginUser.getU_nickname() %>님이 후원한 프로젝트와 직접 등록한 프로젝트를 확인할 수 있습니다.</p>
    </section>

    <!-- 내가 후원한 프로젝트 -->
    <section class="mypage-section">
        <div class="section-title-row">
            <div>
                <h2>내가 후원한 프로젝트</h2>
                <p>후원한 적 있는 프로젝트를 한눈에 확인할 수 있습니다.</p>
            </div>

            <a href="./fundingHistory.jsp" class="black-small-link">후원 내역 자세히 보기</a>
        </div>

        <table class="mypage-table">
            <tr>
                <th>번호</th>
                <th>프로젝트명</th>
                <th>내가 후원한 총 금액</th>
                <th>후원 횟수</th>
                <th>마감일</th>
                <th>상세보기</th>
            </tr>

            <%
                PreparedStatement fundingPstmt = null;
                ResultSet fundingRs = null;
                boolean hasFundingProject = false;

                try {
                    String fundingSql =
                        "SELECT p.p_id, p.p_title, p.p_end, "
                      + "       SUM(f.f_amount) AS total_amount, "
                      + "       COUNT(f.f_id) AS funding_count "
                      + "FROM Funding f "
                      + "JOIN Projects p ON f.p_id = p.p_id "
                      + "WHERE f.u_id = ? "
                      + "GROUP BY p.p_id, p.p_title, p.p_end "
                      + "ORDER BY MAX(f.f_id) DESC";

                    fundingPstmt = conn.prepareStatement(fundingSql);
                    fundingPstmt.setInt(1, loginUser.getU_id());
                    fundingRs = fundingPstmt.executeQuery();

                    int fundingNo = 1;

                    while (fundingRs.next()) {
                        hasFundingProject = true;
            %>

            <tr>
                <td><%= fundingNo++ %></td>
                <td class="table-title"><%= fundingRs.getString("p_title") %></td>
                <td><strong><%= df.format(fundingRs.getInt("total_amount")) %>원</strong></td>
                <td><%= fundingRs.getInt("funding_count") %>회</td>
                <td><%= fundingRs.getDate("p_end") %></td>
                <td>
                    <a href="./Projects/projectInfo.jsp?p_id=<%= fundingRs.getInt("p_id") %>" class="table-link">
                        보기
                    </a>
                </td>
            </tr>

            <%
                    }

                    if (!hasFundingProject) {
            %>

            <tr>
                <td colspan="6" class="empty-table-text">아직 후원한 프로젝트가 없습니다.</td>
            </tr>

            <%
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='6'>후원한 프로젝트를 불러오는 중 오류가 발생했습니다.</td></tr>");
                    e.printStackTrace();
                } finally {
                    if (fundingRs != null) fundingRs.close();
                    if (fundingPstmt != null) fundingPstmt.close();
                }
            %>
        </table>
    </section>

    <!-- 내가 올린 프로젝트 -->
<section class="mypage-section">
    <h2>내가 올린 프로젝트</h2>

    <table class="mypage-table">
        <tr>
            <th>프로젝트명</th>
            <th>목표 금액</th>
            <th>현재 금액</th>
            <th>달성률</th>
            <th>상태</th>
            <th>관리</th>
        </tr>

        <%
            PreparedStatement projectPstmt = null;
            ResultSet projectRs = null;
            boolean hasMyProject = false;

            try {
                String projectSql = "SELECT * FROM Projects WHERE u_id = ? ORDER BY p_id DESC";

                projectPstmt = conn.prepareStatement(projectSql);
                projectPstmt.setInt(1, loginUser.getU_id());
                projectRs = projectPstmt.executeQuery();

                while (projectRs.next()) {
                    hasMyProject = true;

                    int p_id = projectRs.getInt("p_id");
                    int goal = projectRs.getInt("p_goal");
                    int current = projectRs.getInt("p_current");

                    int rate = 0;
                    if (goal != 0) {
                        rate = (int)((current / (double) goal) * 100);
                    }

                    String status = projectRs.getString("p_status");
        %>

        <tr>
            <td><%= projectRs.getString("p_title") %></td>
            <td><%= df.format(goal) %>원</td>
            <td><%= df.format(current) %>원</td>
            <td><%= rate %>%</td>
            <td><span class="status-badge"><%= status %></span></td>
            <td>
    <a href="<%= request.getContextPath() %>/Projects/updateProject.jsp?p_id=<%= p_id %>"
       class="manage-btn edit-btn">
        수정
    </a>

    <%
        if (!"마감".equals(status)) {
    %>
        <a href="<%= request.getContextPath() %>/Projects/processCloseProject.jsp?p_id=<%= p_id %>"
           class="manage-btn close-btn"
           onclick="return confirm('이 프로젝트를 마감 처리하시겠습니까?');">
            마감
        </a>
    <%
        } else {
    %>
        <span class="closed-text">마감됨</span>
    <%
        }
    %>
</td>
        </tr>

        <%
                }

                if (!hasMyProject) {
        %>

        <tr>
            <td colspan="6">아직 등록한 프로젝트가 없습니다.</td>
        </tr>

        <%
                }
            } catch (SQLException e) {
                out.println("<tr><td colspan='6'>프로젝트 목록을 불러오는 중 오류가 발생했습니다.</td></tr>");
                e.printStackTrace();
            } finally {
                if (projectRs != null) projectRs.close();
                if (projectPstmt != null) projectPstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
</section>

    <%@ include file="footer.jsp" %>

</div>
</body>
</html>