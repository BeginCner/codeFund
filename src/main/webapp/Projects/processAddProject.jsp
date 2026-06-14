<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ include file="../DBconn.jsp" %>
<%@ page import="dto.User" %>
<%
    // 세션에서 로그인 유저 확인
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        out.println("<script>alert('로그인이 필요한 서비스입니다.'); location.href='../auth/login.jsp';</script>");
        return;
    }

    Properties prop = new Properties();

    // 1. webapp 폴더 바로 밑에 있는 config.properties 파일의 실제 톰캣 경로를 가져옵니다.
    String configRealPath = application.getRealPath("/config.properties");
    
    // 2. 파일이 진짜 해당 위치에 존재하는지 안전하게 체크합니다.
    File configFile = new File(configRealPath);
    if (!configFile.exists()) {
        throw new ServletException("webapp 폴더 밑에 config.properties 파일이 존재하지 않습니다! 파일 위치를 확인해주세요.");
    }

    // 3. 파일 스트림을 열어 프로퍼티를 정상적으로 로드합니다.
    InputStream is = new FileInputStream(configFile);
    prop.load(is);

    String savePath  = prop.getProperty("file.upload.path");
    String uploadUrl = prop.getProperty("file.upload.url");
    // 2. 프로퍼티 파일에서 설정값 꺼내오기

    // 외부 이미지 저장 폴더가 컴퓨터에 없으면 자동 생성 
    File uploadDir = new File(savePath);
    if (!uploadDir.exists()) {
        uploadDir.mkdirs();
    }

    // MultipartRequest로 폼 데이터 + 파일 한 번에 파싱
    // 마지막 인자: 동일 파일명 있을 때 자동으로 이름 바꿔줌
    MultipartRequest multi = new MultipartRequest(
        request,
        savePath,
        10 * 1024 * 1024,   // 최대 10MB
        "utf-8",
        new DefaultFileRenamePolicy()
    );

    // 폼 데이터 받기
    String title       = multi.getParameter("title");
    String description = multi.getParameter("description");
    int    goal        = Integer.parseInt(multi.getParameter("goal"));
    String endDate     = multi.getParameter("endDate");

    // 업로드된 파일명 가져오기 (파일 없으면 null)
    String fileName = multi.getFilesystemName("imageFile");
    
 	// [추가] 이미지 파일이 업로드되지 않았다면 알림을 띄우고 뒤로 가기
    if (fileName == null) {
        out.println("<script>");
        out.println("alert('프로젝트 이미지를 반드시 포함해야 합니다.');");
        out.println("history.back();"); // 사용자가 입력하던 폼으로 되돌림
        out.println("</script>");
        return; // 아래 DB 저장 로직이 실행되지 않도록 중단
    }
    
    // DB에는 "/upload/파일명" 형태로 저장해서 나중에 <img src> 로 바로 쓸 수 있게
    String imagePath = (fileName != null) ? uploadUrl + fileName : null;

    // DB에 저장
    String sql = "INSERT INTO Projects(u_id, p_title, p_description, p_goal, p_current, p_end, p_status, p_image) "
               + "VALUES(?,?,?,?,0,?,'진행중',?)";

    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, loginUser.getU_id());
    pstmt.setString(2, title);
    pstmt.setString(3, description);
    pstmt.setInt(4, goal);
    pstmt.setString(5, endDate);
    pstmt.setString(6, imagePath);  // 이미지 없으면 null 저장
    pstmt.executeUpdate();

    if (pstmt != null) pstmt.close();
    if (conn  != null) conn.close();

    response.sendRedirect("../main.jsp");
%>
