<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ include file = "../DBconn.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeFund - 회원가입</title>
    <link rel="stylesheet" href="../resources/css/bootstrap.min.css">
     <link rel="stylesheet" href="../resources/css/funding.css">
    <style>
        body { background-color: #f8f9fa; }
        .btn-funding { background-color: #212529; color: white; font-weight: bold; }
        .btn-funding:hover { background-color: #495057; color: white; }
        .btn-outline-funding { border-color: #212529; color: #212529; font-weight: bold; }
        .btn-outline-funding:hover { background-color: #212529; color: white; }
        .text-funding { color: #212529; }
    </style>
    <script>
        function validateForm() {
            var pwd = document.getElementById("u_password").value;
            var pwdCheck = document.getElementById("userPwdCheck").value;
            
            if (pwd !== pwdCheck) {
                alert("비밀번호가 일치하지 않습니다.");
                return false;
            }
            return true;
        }
    </script>
    <%
        String error = request.getParameter("error");
        if(error != null && error.equals("1")) {
    %>
        <script>alert("회원가입중 오류가 발생했습니다. 다시 시도해주세요.");</script>
    <%
        }
    %>
</head>
<body class="d-flex align-items-center min-vh-100 py-5">

<div class="page">
     <div class="px-5" style="position: absolute; top: 0; left: 0; width: 100%; z-index: 100;">
        <%@ include file="../menu.jsp" %>
    </div>
    <br>


<div class="container">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-5">
            <div class="card shadow border-0 p-4 rounded-3 bg-white">
                <div class="card-body">
                 
                    <form action="processAddUser.jsp" method="post" onsubmit="return validateForm()">
                        <div class="mb-3">
                            <label for="u_login_id" class="form-label fw-semibold small text-secondary">아이디</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="u_login_id" name="u_login_id" placeholder="아이디를 입력해주세요" required>
								<button class="btn btn-outline-funding" type="button" onclick="var id=document.getElementById('u_login_id').value.trim(); if(!id){alert('아이디를 입력해주세요.');}else{window.open('processCheckId.jsp?u_login_id='+id, 'idcheck', 'width=450,height=300');}">중복확인</button>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="u_nickname" class="form-label fw-semibold small text-secondary">이름(닉네임)</label>
                            <input type="text" class="form-control" id="u_nickname" name="u_nickname" placeholder="이름을 입력해주세요" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="u_password" class="form-label fw-semibold small text-secondary">비밀번호</label>
                            <input type="password" class="form-control" id="u_password" name="u_password" placeholder="비밀번호를 입력해주세요" required>
                        </div>
                        
                        <div class="mb-4">
                            <label for="userPwdCheck" class="form-label fw-semibold small text-secondary">비밀번호 확인</label>
                            <input type="password" class="form-control" id="userPwdCheck" placeholder="비밀번호를 한번 더 입력해주세요" required>
                        </div>
                        
                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-funding btn-lg fs-6 py-2.5">회원가입 완료</button>
                        </div>
                    </form>
                    
                    <div class="text-center small mt-4 text-muted">
                        이미 계정이 있으신가요? <a href="login.jsp" class="text-funding text-decoration-none fw-bold">로그인</a>
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