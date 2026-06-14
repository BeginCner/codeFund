<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="dto.User" %>
<%@ include file="../DBconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String p_id = request.getParameter("p_id");

    if (p_id == null || p_id.trim().isEmpty()) {
        response.sendRedirect("../main.jsp?error=missing_id");
        return;
    }

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String p_title = "";
    String p_description = "";
    int p_goal = 0;
    int p_current = 0;
    String p_end = "";
    String p_image = "";
    String p_status = "";

    try {
        String sql = "SELECT * FROM Projects WHERE p_id = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, p_id);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            p_title = rs.getString("p_title");
            p_description = rs.getString("p_description");
            p_goal = rs.getInt("p_goal");
            p_current = rs.getInt("p_current");
            p_end = rs.getString("p_end");
            p_image = rs.getString("p_image");
            p_status = rs.getString("p_status");
        } else {
            response.sendRedirect("../main.jsp?error=not_found");
            return;
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("../main.jsp?error=1");
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
    }

    if (p_description == null) {
        p_description = "";
    }

    if (p_image == null) {
        p_image = "";
    }

    if (p_status == null) {
        p_status = "진행중";
    }

    int percent = 0;

    if (p_goal > 0) {
        percent = (int)((double)p_current / p_goal * 100);
    }

    if (percent > 100) {
        percent = 100;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeFund - <%= p_title %></title>

    <link href="../resources/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../resources/css/funding.css">
</head>

<body class="d-flex flex-column min-vh-100 bg-light text-dark">
<div class="page">

    <%@ include file="../menu.jsp" %>

    <%
        boolean alreadyReviewed = false;

        if (loginUser != null) {
            PreparedStatement checkPstmt = null;
            ResultSet checkRs = null;

            try {
                String checkSql = "SELECT r_id FROM Reviews WHERE p_id = ? AND u_id = ?";

                checkPstmt = conn.prepareStatement(checkSql);
                checkPstmt.setString(1, p_id);
                checkPstmt.setInt(2, loginUser.getU_id());
                checkRs = checkPstmt.executeQuery();

                if (checkRs.next()) {
                    alreadyReviewed = true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (checkRs != null) try { checkRs.close(); } catch (SQLException e) {}
                if (checkPstmt != null) try { checkPstmt.close(); } catch (SQLException e) {}
            }
        }
    %>

    <div class="container py-5 flex-grow-1">

        <% if ("duplicate".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                이미 이 프로젝트에 리뷰를 남기셨습니다.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <div class="row g-5">

            <div class="col-12 col-lg-7">

                <div class="bg-white p-3 rounded-3 shadow-sm mb-4 text-center">
                    <%
                        if (!p_image.trim().isEmpty()) {
                    %>
                        <img src="<%= p_image %>"
                             alt="프로젝트 이미지"
                             class="img-fluid rounded-3"
                             style="max-height: 400px; width: 100%; object-fit: cover;">
                    <%
                        } else {
                    %>
                        <img src="${pageContext.request.contextPath}/resources/images/default.png"
                             alt="기본 이미지"
                             class="img-fluid rounded-3"
                             style="max-height: 400px; width: 100%; object-fit: cover;">
                    <%
                        }
                    %>
                </div>

                <div class="bg-white p-4 rounded-3 shadow-sm mb-4">
                    <h4 class="fw-bold border-bottom pb-3 mb-3">프로젝트 상세</h4>
                    <p class="fs-6 text-secondary" style="white-space: pre-wrap;"><%= p_description %></p>
                </div>

                <div class="bg-white p-4 rounded-3 shadow-sm">
                    <h4 class="fw-bold border-bottom pb-3 mb-4">커뮤니티 / 후기</h4>

                    <div class="card mb-4 bg-light border-0">
                        <div class="card-body">

                            <%
                                if (loginUser == null) {
                            %>
                                <div class="text-center py-3 text-muted">
                                    리뷰를 작성하려면
                                    <a href="../auth/login.jsp" class="text-danger fw-bold text-decoration-none">로그인</a>이 필요합니다.
                                </div>
                            <%
                                } else if (alreadyReviewed) {
                            %>
                                <div class="text-center py-3 text-secondary small fw-bold">
                                    이미 이 프로젝트에 후기를 작성하셨습니다. (프로젝트당 1회 참여 가능)
                                </div>
                            <%
                                } else {
                            %>
                                <form action="processAddReview.jsp" method="post">
                                    <input type="hidden" name="p_id" value="<%= p_id %>">

                                    <div class="row g-3 mb-3 align-items-center">
                                        <div class="col-auto">
                                            <label class="form-label fw-bold text-secondary small mb-0">
                                                <%= loginUser.getU_nickname() %> 님
                                            </label>
                                        </div>

                                        <div class="col-auto d-flex align-items-center gap-2">
                                            <label for="r_rating" class="small text-muted fw-semibold mb-0">
                                                평점 선택:
                                            </label>

                                            <select class="form-select form-select-sm fw-bold text-warning"
                                                    id="r_rating"
                                                    name="r_rating"
                                                    style="width: 120px;">
                                                <option value="5" selected>★★★★★ 5점</option>
                                                <option value="4">★★★★☆ 4점</option>
                                                <option value="3">★★★☆☆ 3점</option>
                                                <option value="2">★★☆☆☆ 2점</option>
                                                <option value="1">★☆☆☆☆ 1점</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <textarea class="form-control bg-white"
                                                  name="r_content"
                                                  rows="3"
                                                  placeholder="펀딩 응원 한마디나 후기를 남겨주세요!"
                                                  required></textarea>
                                    </div>

                                    <div class="text-end">
                                        <button type="submit" class="btn btn-dark btn-sm fw-bold px-3 py-2">
                                            댓글 등록
                                        </button>
                                    </div>
                                </form>
                            <%
                                }
                            %>

                        </div>
                    </div>

                    <div class="review-list">

                        <%
                            PreparedStatement reviewPstmt = null;
                            ResultSet reviewRs = null;

                            try {
                                String reviewSql = "SELECT r.*, u.u_nickname "
                                                 + "FROM Reviews r "
                                                 + "JOIN Users u ON r.u_id = u.u_id "
                                                 + "WHERE r.p_id = ? "
                                                 + "ORDER BY r.r_date DESC";

                                reviewPstmt = conn.prepareStatement(reviewSql);
                                reviewPstmt.setString(1, p_id);
                                reviewRs = reviewPstmt.executeQuery();

                                boolean hasReviews = false;

                                while (reviewRs.next()) {
                                    hasReviews = true;

                                    int r_id = reviewRs.getInt("r_id");
                                    int r_u_id = reviewRs.getInt("u_id");
                                    String r_content = reviewRs.getString("r_content");
                                    String u_nickname = reviewRs.getString("u_nickname");
                                    String r_date = reviewRs.getString("r_date");
                                    int r_rating = reviewRs.getInt("r_rating");

                                    String starStr = "";

                                    for (int i = 1; i <= 5; i++) {
                                        if (i <= r_rating) {
                                            starStr += "★";
                                        } else {
                                            starStr += "☆";
                                        }
                                    }

                                    String displayDate = r_date;

                                    if (r_date != null && r_date.length() >= 16) {
                                        displayDate = r_date.substring(0, 16);
                                    }
                        %>

                        <div class="border-bottom py-3" id="review-container-<%= r_id %>">

                            <div id="review-view-<%= r_id %>">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <div>
                                        <span class="fw-bold text-dark me-2"><%= u_nickname %></span>
                                        <span class="text-warning fw-bold small"><%= starStr %></span>
                                    </div>

                                    <div class="d-flex align-items-center gap-2">
                                        <span class="text-muted small"><%= displayDate %></span>

                                        <%
                                            if (loginUser != null && loginUser.getU_id() == r_u_id) {
                                        %>
                                            <button type="button"
                                                    class="btn btn-link text-secondary p-0 text-decoration-none small"
                                                    onclick="toggleEditMode(<%= r_id %>)">
                                                수정
                                            </button>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>

                                <p class="mb-0 text-secondary small" style="white-space: pre-wrap;"><%= r_content %></p>
                            </div>

                            <%
                                if (loginUser != null && loginUser.getU_id() == r_u_id) {
                            %>
                                <div id="review-edit-<%= r_id %>" style="display: none;">
                                    <form action="processUpdateReview.jsp" method="post">
                                        <input type="hidden" name="p_id" value="<%= p_id %>">
                                        <input type="hidden" name="r_id" value="<%= r_id %>">

                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <label class="small text-muted fw-bold mb-0">
                                                평점 수정:
                                            </label>

                                            <select class="form-select form-select-sm text-warning fw-bold"
                                                    name="r_rating"
                                                    style="width: 120px;">
                                                <option value="5" <%= r_rating == 5 ? "selected" : "" %>>★★★★★ 5점</option>
                                                <option value="4" <%= r_rating == 4 ? "selected" : "" %>>★★★★☆ 4점</option>
                                                <option value="3" <%= r_rating == 3 ? "selected" : "" %>>★★★☆☆ 3점</option>
                                                <option value="2" <%= r_rating == 2 ? "selected" : "" %>>★★☆☆☆ 2점</option>
                                                <option value="1" <%= r_rating == 1 ? "selected" : "" %>>★☆☆☆☆ 1점</option>
                                            </select>
                                        </div>

                                        <div class="mb-2">
                                            <textarea class="form-control form-control-sm bg-white"
                                                      name="r_content"
                                                      rows="2"
                                                      required><%= r_content %></textarea>
                                        </div>

                                        <div class="text-end">
                                            <button type="button"
                                                    class="btn btn-light btn-sm me-1"
                                                    onclick="toggleEditMode(<%= r_id %>)">
                                                취소
                                            </button>

                                            <button type="submit" class="btn btn-dark btn-sm">
                                                수정완료
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            <%
                                }
                            %>

                        </div>

                        <%
                                }

                                if (!hasReviews) {
                        %>
                            <div class="text-center py-5 text-muted small">
                                아직 작성된 후기가 없습니다. 첫 번째 이야기를 남겨보세요!
                            </div>
                        <%
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                            } finally {
                                if (reviewRs != null) try { reviewRs.close(); } catch (SQLException e) {}
                                if (reviewPstmt != null) try { reviewPstmt.close(); } catch (SQLException e) {}
                                if (conn != null) try { conn.close(); } catch (SQLException e) {}
                            }
                        %>

                    </div>

                    <script>
                        function toggleEditMode(r_id) {
                            var viewDiv = document.getElementById("review-view-" + r_id);
                            var editDiv = document.getElementById("review-edit-" + r_id);

                            if (viewDiv.style.display === "none") {
                                viewDiv.style.display = "block";
                                editDiv.style.display = "none";
                            } else {
                                viewDiv.style.display = "none";
                                editDiv.style.display = "block";
                            }
                        }
                    </script>

                </div>
            </div>

            <div class="col-12 col-lg-5">
                <div class="position-sticky" style="top: 24px;">
                    <div class="bg-white p-4 rounded-3 shadow-sm border-0">

                        <%
                            if ("마감".equals(p_status)) {
                        %>
                            <span class="badge bg-secondary mb-2 px-3 py-2">마감된 프로젝트</span>
                        <%
                            } else if ("성공".equals(p_status)) {
                        %>
                            <span class="badge bg-success mb-2 px-3 py-2">목표 달성 프로젝트</span>
                        <%
                            } else {
                        %>
                            <span class="badge bg-dark mb-2 px-3 py-2">펀딩 진행중</span>
                        <%
                            }
                        %>

                        <h2 class="fw-bold lh-base mb-4"><%= p_title %></h2>

                        <div class="mb-3">
                            <span class="fs-4 fw-bold text-danger"><%= percent %>%</span> 달성
                        </div>

                        <div class="mb-2">
                            <span class="fs-2 fw-bold">
                                <%= java.text.NumberFormat.getInstance().format(p_current) %>
                            </span>
                            원 펀딩
                        </div>

                        <div class="mb-4 text-muted small">
                            목표 금액: <%= java.text.NumberFormat.getInstance().format(p_goal) %>원
                            <br>
                            마감 일시: <%= p_end %>
                        </div>

                        <div class="progress mb-4" style="height: 8px;">
                            <div class="progress-bar bg-danger"
                                 role="progressbar"
                                 style="width: <%= percent %>%"
                                 aria-valuenow="<%= percent %>"
                                 aria-valuemin="0"
                                 aria-valuemax="100">
                            </div>
                        </div>

                        <%
                            if ("마감".equals(p_status)) {
                        %>
                            <div class="alert alert-secondary text-center fw-bold mb-0">
                                마감된 프로젝트는 더 이상 후원할 수 없습니다.
                            </div>
                        <%
                            } else {
                        %>
                            <form action="../pay/payment.jsp" method="get">
                                <input type="hidden" name="p_id" value="<%= p_id %>">

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-danger btn-lg fw-bold py-3 fs-5">
                                        이 프로젝트 후원하기
                                    </button>
                                </div>
                            </form>
                        <%
                            }
                        %>

                    </div>
                </div>
            </div>

        </div>
    </div>

    <%@ include file="../footer.jsp" %>

</div>
</body>
</html>