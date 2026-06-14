<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file ="../DBconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 중복 확인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <script>
        function useId(id) {
            window.opener.document.getElementById("u_login_id").value = id;
            window.close(); 
        }
    </script>
</head>
<body class="bg-light p-4 text-center">
<%
    request.setCharacterEncoding("UTF-8");
    String u_login_id = request.getParameter("u_login_id"); 
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean isDuplicated = false;


    String sql = "SELECT * FROM Users WHERE u_login_id = ?";

    try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, u_login_id);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            isDuplicated = true; // DB에 이미 있으면 중복된 아이디
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
    	if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

    <h5 class="fw-bold mb-3 text-secondary">아이디 중복 확인</h5>
    
    <div class="card p-3 shadow-sm bg-white">
        <% if (isDuplicated) { %>
            <p class="text-danger mb-3">
                <strong><%= u_login_id %></strong>은(는) 이미 사용 중입니다.
            </p>
            <form action="idCheck.jsp" method="get">
                <div class="input-group">
                    <input type="text" class="form-control form-control-sm" name="u_login_id" placeholder="다른 아이디 입력" required>
                    <button class="btn btn-dark btn-sm" type="submit">검색</button>
                </div>
            </form>
        <% } else { %>
            <p class="text-success mb-3">
                <strong><%= u_login_id %></strong>은(는) 사용 가능합니다!
            </p>
            <button class="btn btn-success btn-sm w-100 fw-bold" onclick="useId('<%= u_login_id %>')">이 아이디 사용하기</button>
        <% } %>
    </div>

</body>
</html>