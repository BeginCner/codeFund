<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ include file="DBconn.jsp" %>

<%
    DecimalFormat df = new DecimalFormat("#,###");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마감 프로젝트</title>
    <link rel="stylesheet" href="./resources/css/funding.css">
</head>

<body>
<div class="page">

    <%@ include file="menu.jsp" %>

    <section class="mypage-title">
        <p class="small-title">Closed Projects</p>
        <h1>마감된 프로젝트</h1>
        <p>마감 처리된 프로젝트들을 확인할 수 있습니다. 마감된 프로젝트는 더 이상 후원할 수 없습니다.</p>
    </section>

    <section class="project-area">
        <div class="project-title-row">
            <div>
                <p class="small-title">Projects</p>
                <h2>마감 프로젝트 목록</h2>
            </div>
        </div>

        <div class="project-list">
            <%
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                boolean hasProject = false;

                try {
                    String sql = "SELECT * FROM Projects "
                               + "WHERE p_status = '마감' "
                               + "ORDER BY p_id DESC";

                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        hasProject = true;

                        int p_id = rs.getInt("p_id");
                        String title = rs.getString("p_title");
                        String description = rs.getString("p_description");
                        int goal = rs.getInt("p_goal");
                        int current = rs.getInt("p_current");
                        Date endDate = rs.getDate("p_end");
                        String status = rs.getString("p_status");

                        if (description == null) {
                            description = "";
                        }

                        int rate = 0;
                        if (goal != 0) {
                            rate = (int)((current / (double) goal) * 100);
                        }
            %>

            <div class="project-card closed-project-card">
                <div class="card-top">
                    <span class="category closed-category"><%= status %></span>
                    <span class="date">마감일 <%= endDate %></span>
                </div>

                <h3><%= title %></h3>

                <p class="desc"><%= description %></p>

                <div class="info-row">
                    <span>목표 금액</span>
                    <strong><%= df.format(goal) %>원</strong>
                </div>

                <div class="info-row">
                    <span>최종 후원 금액</span>
                    <strong><%= df.format(current) %>원</strong>
                </div>

                <div class="info-row">
                    <span>최종 달성률</span>
                    <strong><%= rate %>%</strong>
                </div>

                <div class="card-buttons">
                    <a href="./Projects/projectInfo.jsp?p_id=<%= p_id %>" class="gray-btn">상세보기</a>
                </div>
            </div>

            <%
                    }

                    if (!hasProject) {
            %>

            <div class="empty-box">
                아직 마감된 프로젝트가 없습니다.
            </div>

            <%
                    }
                } catch (SQLException e) {
                    out.println("<div class='empty-box'>마감 프로젝트 목록을 불러오는 중 오류가 발생했습니다.</div>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            %>
        </div>
    </section>

    <%@ include file="footer.jsp" %>

</div>
</body>
</html>