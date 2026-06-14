<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="java.util.*" %>
<%@page import = "java.sql.*" %>
<%@include file ="../DBconn.jsp" %>
<%@ page import ="dto.User" %>

  <%
    request.setCharacterEncoding("UTF-8");
	User loginUser = (User) session.getAttribute("loginUser");
	String p_id = request.getParameter("p_id");
	String f_amountStr = request.getParameter("f_amount");
	
	PreparedStatement pstmt = null; //funding 용
	PreparedStatement updatePstmt = null; //projects 용

   
    
    String sql = "INSERT INTO Funding(u_id,p_id,f_amount) Values(?,?,?)";
    String updateSql = "UPDATE Projects SET p_current = p_current + ? WHERE p_id = ?";
    try {
    	int f_amount = Integer.parseInt(f_amountStr);
    	
    	//트렌젝션 시작
    	conn.setAutoCommit(false);
    	
    	//funding에 insert
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1,loginUser.getU_id());
        pstmt.setString(2,p_id);
        pstmt.setInt(3,f_amount);
        int rs = pstmt.executeUpdate();

        updatePstmt = conn.prepareStatement(updateSql);
        updatePstmt.setInt(1,f_amount);
        updatePstmt.setString(2,p_id);
        int updateRs = updatePstmt.executeUpdate();
        
        if (rs>0 && updateRs > 0) {
           	// 두 작업이 모두 성공하면 DB에 반영
        	conn.commit();
        	response.sendRedirect("../fundingHistory.jsp");      
        }
        else{
        	//하나라도 실패하면 롤백
        	conn.rollback();
        	 response.sendRedirect("../main.jsp?error=2");
        }
    } catch (SQLException e) {
    	if (conn != null) {
            try { conn.rollback();
            } catch(SQLException ex) { 
            	ex.printStackTrace(); 
            	}
        }
        e.printStackTrace(); // 톰캣 콘솔창에서 정확한 에러 메시지 확인용
        response.sendRedirect("../main.jsp?error=1");
        return;
    } finally {
    	
        if (updatePstmt != null) updatePstmt.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
   
%>