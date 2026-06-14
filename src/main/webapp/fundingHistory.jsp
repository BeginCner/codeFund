<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="dto.User" %>
<%@ include file="DBconn.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>후원 내역</title>
    <link rel="stylesheet" href="./resources/css/funding.css">
</head>

<body>
<div class="page">

    <%@ include file="./menu.jsp" %>

    <%
    	if (loginUser == null) {
        	response.sendRedirect("./loginRequired.jsp");
        	return;
    	}

        DecimalFormat df = new DecimalFormat("#,###");
    %>

    <section class="mypage-title">
        <p class="small-title">Funding History</p>
        <h1>후원 내역</h1>
        <p><%= loginUser.getU_nickname() %>님이 후원한 프로젝트 내역을 카드 형태로 확인할 수 있습니다.</p>
    </section>

    <section class="mypage-section">
        <div class="section-title-row">
            <div>
                <h2>내가 후원한 내역</h2>
                <p>후원한 프로젝트, 후원 금액, 프로젝트 진행률을 한눈에 볼 수 있습니다.</p>
            </div>

            <a href="./mypage.jsp" class="black-small-link">마이페이지로 이동</a>
        </div>

        <div class="project-list funding-history-grid">

            <%
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                boolean hasFunding = false;

                try {
                    String sql =
                        "SELECT f.f_id, f.f_amount, " +
                        "       p.p_id, p.p_title, p.p_description, p.p_goal, p.p_current, p.p_end, p.p_status " +
                        "FROM Funding f " +
                        "JOIN Projects p ON f.p_id = p.p_id " +
                        "WHERE f.u_id = ? " +
                        "ORDER BY f.f_id DESC";

                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, loginUser.getU_id());
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        hasFunding = true;

                        int f_id = rs.getInt("f_id");
                        int amount = rs.getInt("f_amount");

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

                        if (description.length() > 65) {
                            description = description.substring(0, 65) + "...";
                        }

                        int rate = 0;
                        if (goal != 0) {
                            rate = (int)((current / (double) goal) * 100);
                        }

                        int barRate = rate;
                        if (barRate > 100) {
                            barRate = 100;
                        }
            %>

            <div class="project-card funding-history-card">
                <div class="card-top">
                    <span class="category"><%= status %></span>
                    <span class="date">후원번호 #<%= f_id %></span>
                </div>

                <h3><%= title %></h3>
                <p class="desc"><%= description %></p>

                <div class="funding-amount-box">
                    <span>내가 후원한 금액</span>
                    <strong><%= df.format(amount) %>원</strong>
                </div>

                <div class="progress-wrap">
                    <div class="progress-bar" style="width:<%= barRate %>%"></div>
                </div>

                <div class="info-row">
                    <span>전체 달성률</span>
                    <strong><%= rate %>%</strong>
                </div>

                <div class="info-row">
                    <span>현재 모금액</span>
                    <strong><%= df.format(current) %>원</strong>
                </div>

                <div class="info-row">
                    <span>목표 금액</span>
                    <strong><%= df.format(goal) %>원</strong>
                </div>

                <div class="info-row">
                    <span>마감일</span>
                    <strong><%= endDate %></strong>
                </div>

                <div class="card-buttons">
                    <a href="./Projects/projectInfo.jsp?p_id=<%= p_id %>" class="gray-btn">상세보기</a>
                    <a href="./pay/payment.jsp?p_id=<%= p_id %>" class="black-small-btn">추가 후원</a>
                </div>
            </div>

            <%
                    }

                    if (!hasFunding) {
            %>

            <div class="empty-box">
                아직 후원한 내역이 없습니다.
            </div>

            <%
                    }

                } catch (SQLException e) {
                    out.println("<div class='empty-box'>후원 내역을 불러오는 중 오류가 발생했습니다.</div>");
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