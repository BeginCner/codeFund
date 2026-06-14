<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeFund - 로그인</title>
   <link rel="stylesheet" href="../resources/css/bootstrap.min.css">
   <link rel="stylesheet" href="../resources/css/funding.css">
    <style>
        body { background-color: #f8f9fa; }
        .btn-funding { background-color: #212529; color: white; font-weight: bold; }
        .btn-funding:hover { background-color: #495057; color: white; }
        .text-funding { color: #212529; }
    </style>
    
        
    <%//processLogin에서 실패하면 error=1 로 파라미터 받아옴
        String error = request.getParameter("error");
        if(error != null && error.equals("1")) {
    %>
        <script>alert("아이디 또는 비밀번호가 일치하지 않습니다.");</script>
    <%
        }
    %>
</head>
<body class="d-flex align-items-center min-vh-100">
<div class="page">
     <div class="px-5" style="position: absolute; top: 0; left: 0; width: 100%; z-index: 100;">
        <%@ include file="../menu.jsp" %>
    </div>

    <div class="content-wrapper" style="padding-top: 70px;"> 
        </div>


<div class="container">
    <div class="row justify-content-center">
        <div class="col-12 col-md-6 col-lg-4">
            <div class="card shadow border-0 p-4 rounded-3 bg-white">
                <div class="card-body">
                    
                    <form action="processLogin.jsp" method="post">
                        <div class="mb-3">
                            <label for="u_login_id" class="form-label fw-semibold small text-secondary">아이디</label>
                            <input type="text" class="form-control p-2.5" id="u_login_id" name="u_login_id" placeholder="아이디를 입력해주세요" required>
                        </div>
                        
                        <div class="mb-4">
                            <label for="u_password" class="form-label fw-semibold small text-secondary">비밀번호</label>
                            <input type="password" class="form-control p-2.5" id="u_password" name="u_password" placeholder="비밀번호를 입력해주세요" required>
                        </div>
                        
                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-funding btn-lg fs-6 py-2.5">로그인</button>
                        </div>
                    </form>
                    
                    <div class="text-center small mt-4 text-muted">
                        아직 계정이 없으신가요? <a href="signup.jsp" class="text-funding text-decoration-none fw-bold">회원가입</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
    
      <%@ include file="../footer.jsp" %>
</div>


</body>
</html>