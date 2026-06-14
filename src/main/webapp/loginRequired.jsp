<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 필요</title>
    <link rel="stylesheet" href="./resources/css/funding.css">
</head>

<body>
<div class="page">

    <%@ include file="./menu.jsp" %>

    <section class="login-required-box">
        <h1>로그인이 필요한 서비스입니다</h1>
        <p>
            프로젝트 등록과 후원 내역 확인은 로그인 후 이용할 수 있습니다.<br>
            로그인을 진행한 뒤 다시 이용해주세요.
        </p>

        <div class="login-required-buttons">
            <a href="./auth/login.jsp" class="login-required-btn">로그인 하러 가기</a>
            <a href="./main.jsp" class="login-required-sub-btn">메인으로 돌아가기</a>
        </div>
    </section>

    <%@ include file="./footer.jsp" %>

</div>
</body>
</html>