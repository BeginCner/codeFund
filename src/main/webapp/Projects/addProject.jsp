<%@ page contentType="text/html;charset=utf-8"%>
<html>
<head>
<title>프로젝트 등록</title>
<style>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  background-color: #f5f5f5;
  font-family: 'Malgun Gothic', sans-serif;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}

.form-wrap {
  background: #fff;
  padding: 48px 40px;
  border-radius: 12px;
  box-shadow: 0 2px 16px rgba(0,0,0,0.08);
  width: 100%;
  max-width: 480px;
}

.form-wrap h2 {
  font-size: 22px;
  font-weight: 700;
  color: #111;
  margin-bottom: 32px;
  padding-bottom: 16px;
  border-bottom: 2px solid #111;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: #555;
  margin-bottom: 6px;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 10px 14px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 14px;
  color: #111;
  outline: none;
  transition: border 0.2s;
  font-family: inherit;
}

.form-group input:focus,
.form-group textarea:focus {
  border-color: #111;
}

.form-group textarea {
  height: 120px;
  resize: vertical;
}

.submit-btn {
  width: 100%;
  padding: 12px;
  background-color: #111;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  margin-top: 8px;
  transition: background 0.2s;
}

.submit-btn:hover {
  background-color: #333;
}
</style>
</head>
<body>
<%@ include file="../DBconn.jsp" %>

<div class="form-wrap">
  <h2>프로젝트 등록</h2>

  <%-- 이미지 파일 전송을 위해 enctype 반드시 필요 --%>
  <form action="./processAddProject.jsp" method="post" enctype="multipart/form-data">

    <div class="form-group">
      <label>프로젝트 제목</label>
      <input type="text" name="title" placeholder="제목을 입력하세요" required>
    </div>

    <div class="form-group">
      <label>목표 금액</label>
      <input type="number" name="goal" placeholder="목표 금액 (원)"required min ="1">
    </div>

    <div class="form-group">
      <label>마감일</label>
      <input type="date" name="endDate"required>
    </div>

    <div class="form-group">
      <label>설명</label>
      <textarea name="description" placeholder="프로젝트 설명을 입력하세요" required></textarea>
    </div>

    <div class="form-group">
      <label>대표 이미지</label>
      <input type="file" name="imageFile" accept="image/*"required>
    </div>

    <input type="submit" class="submit-btn" value="등록">

  </form>
</div>

</body>
</html>

