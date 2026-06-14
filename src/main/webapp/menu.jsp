<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import ="dto.User" %>

<%
    User loginUser = (User) session.getAttribute("loginUser");
%>

<header class="header">
    <a href="<c:url value='/main.jsp'/>" class="logo">
        <span class="logo-icon">C</span>
        <span>CodeFund</span>
    </a>

    <nav class="nav">
        <a href="<c:url value='/main.jsp'/>">프로젝트</a>
        <a href="<c:url value='/closedProjects.jsp'/>">마감 프로젝트</a>

        <%
            if (loginUser == null) {
        %>
            <a href="<c:url value='/loginRequired.jsp'/>">프로젝트 등록</a>
            <a href="<c:url value='/loginRequired.jsp'/>">후원 내역</a>
            <a href="<c:url value='/auth/login.jsp'/>" class="login-btn">로그인</a>
        <%
            } else {
        %>
            <a href="<c:url value='/Projects/addProject.jsp'/>">프로젝트 등록</a>
            <a href="<c:url value='/fundingHistory.jsp'/>">후원 내역</a>
            <a href="<c:url value='/mypage.jsp'/>" class="mypage-link">마이페이지</a>
            <a href="<c:url value='/auth/processLogout.jsp'/>">로그아웃</a>
        <%
            }
        %>
    </nav>
</header>