<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dto.User" %>
<%@ page import="java.sql.*" %>
<%@ include file ="../DBconn.jsp" %>
   
<%
    request.setCharacterEncoding("UTF-8");
    User loginUser = (User) session.getAttribute("loginUser");
    String p_id = request.getParameter("p_id");
    
    if (loginUser == null) {
        response.sendRedirect("../auth/login.jsp");
        return;
    }
    
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String p_title = "";
    String p_image ="";
    int current;

    String sql = "SELECT * FROM Projects WHERE p_id = ?";

    try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1,p_id);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            p_title = rs.getString("p_title");
            p_image = rs.getString("p_image");
            current = rs.getInt("p_current");       
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("../main.jsp?error=1");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeFund - 주문/결제</title>
    
    <link href="../resources/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../resources/css/funding.css">
</head>
<body class="bg-light text-dark">

<div class="container py-5">
    <h2 class="fw-bold mb-4">주문/결제</h2>
    
    <form action="processPayment.jsp?p_id=<%=p_id %>" method="post">
        <div class="row g-4">
            
            <div class="col-12 col-lg-8">
                <div class="d-flex flex-column gap-4">
                    
                    <div class="card shadow-sm border-0 rounded-3 p-4 bg-white">
			    <div class="card-body p-0">
			        <h5 class="fw-bold pb-3 mb-3 border-bottom text-secondary">후원 프로젝트 정보</h5>
			        <div class="d-flex align-items-center gap-3">
			            <!-- 이미지 부모 컨테이너에 overflow-hidden 추가 -->
			            <div class="bg-secondary bg-opacity-25 rounded-3 overflow-hidden" style="width: 80px; height: 60px; min-width: 80px;">
			                <img src="<%= p_image %>"
			                     alt="프로젝트 이미지"
			                     class="w-100 h-100" 
			                     style="object-fit: cover;">
			            </div>
			            <div>
			                <h6 class="fw-bold mb-1 fs-5"><%= p_title%></h6>
			            </div>
			        </div>
			    </div>
			</div>
                    <div class="card shadow-sm border-0 rounded-3 p-4 bg-white">
                        <div class="card-body p-0">	 
                            <h5 class="fw-bold pb-3 mb-3 border-bottom text-secondary">후원 금액 선택</h5>
                            <div class="mb-1">
                                <label for="f_amount" class="form-label fw-semibold small text-muted">후원하실 금액을 선택해주세요</label>
                                <select class="form-select p-2.5 fw-semibold" id="f_amount" name="f_amount" onchange="updatePrice(this.value)">
                                    <option value="50000" selected>50,000 원</option>
                                    <option value="100000">100,000 원</option>
                                    <option value="150000">150,000 원</option>
                                    <option value="200000">200,000 원</option>
                                    <option value="250000">250,000 원</option>
                                    <option value="300000">300,000 원</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card shadow-sm border-0 rounded-3 p-4 bg-white">
                        <div class="card-body p-0">
                            <h5 class="fw-bold pb-3 mb-3 border-bottom text-secondary">후원자 정보</h5>
                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-muted">후원자 이름</label>
                                <div><%=loginUser.getU_nickname() %></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card shadow-sm border-0 rounded-3 p-4 bg-white">
                        <div class="card-body p-0">
                            <h5 class="fw-bold pb-3 mb-3 border-bottom text-secondary">결제 수단</h5>
                            <div class="d-flex flex-column gap-2">
                                <label class="border rounded-3 p-3 d-flex align-items-center" style="cursor: pointer;">
                                    <input type="radio" class="form-check-input me-3" name="pay_method" value="card" checked style="width: 20px; height: 20px; accent-color: #212529;">
                                    <span class="fw-semibold">신용/체크카드</span>
                                </label>
                                <label class="border rounded-3 p-3 d-flex align-items-center" style="cursor: pointer;">
                                    <input type="radio" class="form-check-input me-3" name="pay_method" value="trans" style="width: 20px; height: 20px; accent-color: #212529;">
                                    <span class="fw-semibold">실시간 계좌이체</span>
                                </label>
                                <label class="border rounded-3 p-3 d-flex align-items-center" style="cursor: pointer;">
                                    <input type="radio" class="form-check-input me-3" name="pay_method" value="vbank" style="width: 20px; height: 20px; accent-color: #212529;">
                                    <span class="fw-semibold">가상계좌</span>
                                </label>
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
            
            <div class="col-12 col-lg-4">
                <div class="position-sticky" style="top: 24px;">
                    <div class="card shadow-sm border-0 rounded-3 p-4 bg-white">
                        <div class="card-body p-0">
                            <h5 class="fw-bold pb-3 mb-4 border-bottom text-secondary">최종 결제 금액</h5>
                            
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="text-muted">펀딩 금액</span>
                                <span class="fw-bold" id="display_funding_amount">50,000원</span>
                            </div>
                            
                            <div class="border-top border-secondary border-dashed my-3" style="border-style: dashed !important;"></div>
                            
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <span class="fw-bold fs-5">최종 결제 금액</span>
                                <span class="fw-bold fs-4 text-danger" id="display_total_amount">50,000원</span>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-dark btn-lg fw-bold py-3 fs-6">결제하기</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </form>
    
    <%@ include file="../footer.jsp" %>
</div>

<script>
    function updatePrice(selectedValue) {
        var fundingAmount = parseInt(selectedValue);
        var formattedPrice = fundingAmount.toLocaleString() + "원";
        
        // 1. 펀딩 금액 영역 업데이트
        document.getElementById("display_funding_amount").innerText = formattedPrice;
        // 2. 최종 결제 금액 영역 업데이트
        document.getElementById("display_total_amount").innerText = formattedPrice;
    }
    
    // 페이지 로드 시 초기 선택된 금액 세팅
    window.addEventListener('DOMContentLoaded', (event) => {
        const initialValue = document.getElementById("f_amount").value;
        updatePrice(initialValue);
    });
</script>

</body>
</html>