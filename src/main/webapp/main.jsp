<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ include file="DBconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String keyword = request.getParameter("keyword");
    if (keyword == null) {
        keyword = "";
    }

    DecimalFormat df = new DecimalFormat("#,###");

    int projectCount = 0;
    int totalAmount = 0;
    int successCount = 0;

    PreparedStatement summaryPstmt = null;
    ResultSet summaryRs = null;

    try {
        String summarySql = "SELECT "
                          + "IFNULL(SUM(CASE WHEN p_status = '진행중' THEN 1 ELSE 0 END), 0) AS project_count, "
                          + "IFNULL(SUM(p_current), 0) AS total_amount, "
                          + "IFNULL(SUM(CASE WHEN p_goal > 0 AND p_current >= p_goal THEN 1 ELSE 0 END), 0) AS success_count "
                          + "FROM Projects";

        summaryPstmt = conn.prepareStatement(summarySql);
        summaryRs = summaryPstmt.executeQuery();

        if (summaryRs.next()) {
            projectCount = summaryRs.getInt("project_count");
            totalAmount = summaryRs.getInt("total_amount");
            successCount = summaryRs.getInt("success_count");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (summaryRs != null) summaryRs.close();
        if (summaryPstmt != null) summaryPstmt.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CodeFund</title>
    <link rel="stylesheet" href="./resources/css/funding.css">
</head>

<body>
<div class="page">

    <%@ include file="menu.jsp" %>

    <section class="main-banner">
        <h1>개발 프로젝트 크라우드 펀딩</h1>
        <p>
            개발 프로젝트를 등록하고, 후원자는 원하는 프로젝트를 선택하여 후원할 수 있는
            JSP 기반 크라우드 펀딩 플랫폼입니다.
        </p>

        <div class="banner-buttons">
            <%
                if (loginUser == null) {
            %>
                <a href="./loginRequired.jsp" class="black-btn">프로젝트 등록</a>
            <%
                } else {
            %>
                <a href="./Projects/addProject.jsp" class="black-btn">프로젝트 등록</a>
            <%
                }
            %>
        </div>
    </section>

    <section class="summary-area">
        <div class="summary-box">
            <h3><%= projectCount %></h3>
            <p>진행 프로젝트</p>
        </div>

        <div class="summary-box">
            <h3><%= df.format(totalAmount) %>원</h3>
            <p>전체 후원 금액</p>
        </div>

        <div class="summary-box">
            <h3><%= successCount %></h3>
            <p>목표 달성 프로젝트</p>
        </div>
    </section>

    <section class="project-area">
        <div class="project-title-row">
            <div>
                <p class="small-title">Projects</p>
                <h2>진행 중인 프로젝트</h2>
            </div>

            <form action="./main.jsp" method="get" class="search-form">
                <input type="text" name="keyword" value="<%= keyword %>" placeholder="프로젝트 검색">
                <button type="submit">검색</button>
            </form>
        </div>

        <div class="project-list">

            <%
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                boolean hasProject = false;

                try {
                    String sql = "SELECT * FROM Projects "
                               + "WHERE p_status = '진행중' ";

                    if (!keyword.trim().equals("")) {
                        sql += "AND (p_title LIKE ? OR p_description LIKE ?) ";
                    }

                    sql += "ORDER BY p_id DESC";

                    pstmt = conn.prepareStatement(sql);

                    if (!keyword.trim().equals("")) {
                        pstmt.setString(1, "%" + keyword + "%");
                        pstmt.setString(2, "%" + keyword + "%");
                    }

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

                        int rate = 0;
                        if (goal != 0) {
                            rate = (int)((current / (double) goal) * 100);
                        }
            %>

            <div class="project-card">
                <div class="card-top">
                    <span class="category"><%= status %></span>
                    <span class="date">마감일 <%= endDate %></span>
                </div>

                <h3><%= title %></h3>

                <p class="desc"><%= description %></p>

                <div class="info-row">
                    <span>목표 금액</span>
                    <strong><%= df.format(goal) %>원</strong>
                </div>

                <div class="info-row">
                    <span>현재 후원 금액</span>
                    <strong><%= df.format(current) %>원</strong>
                </div>

                <div class="info-row">
                    <span>달성률</span>
                    <strong><%= rate %>%</strong>
                </div>

                <div class="card-buttons">
                    <a href="./Projects/projectInfo.jsp?p_id=<%= p_id %>" class="gray-btn">상세보기</a>
                    <a href="./pay/payment.jsp?p_id=<%= p_id %>" class="black-small-btn">후원하기</a>
                </div>
            </div>

            <%
                    }

                    if (!hasProject) {
            %>

            <div class="empty-box">
                검색 결과가 없습니다.
            </div>

            <%
                    }

                } catch (SQLException e) {
                    out.println("<div class='empty-box'>프로젝트 목록을 불러오는 중 오류가 발생했습니다.</div>");
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