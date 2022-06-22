<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<%
    //필요한 변수 선언
    int i, j;
    String mylog = "";

    //파라미터 가져오기
    //String param = request.getParameter("param");

    //DB 관련 객체 선언
    Connection conn = DBUtil.getMySQLConnection();
    ResultSet rs = null;
    PreparedStatement pstmt = null;
    String query = "";
    String sql = "";

    //DB 가져오기 예시
    /*query = "select * from KEYWORD";
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();
    HashMap<String, String> keyword = new HashMap<String, String>();
    while(rs.next()) {
        keyword.put(rs.getString("Id"), rs.getString("Name"));
    }
    pstmt.close();
     */
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="SHORTCUT ICON" href="https://somoonhouse.com/img/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/newTestFooter.css"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <title>소문난집</title>
</head>
<body>
<%=mylog%>
<%

%>
<div class="body_container_footer">
    <div class="body_footer">
        <div class="text_container">
            <div class="text">
                <span class="value">패스트웨이</span>
            </div>
            <div class="text">
                <span class="key">대표</span><span class="value">길영민</span>
            </div>
            <div class="text">
                <span class="key">주소</span><span class="value">대구광역시 북구 대학로 11-1</span>
            </div>
            <div class="text">
                <span class="key">전화</span><span class="value">010-4399-7660 ( 대표전화 / 고객센터 )</span>
            </div>
        </div>
        <div class="bar"></div>
        <div class="text_container">
            <div class="text">
                <span class="key">문의</span><span class="value">somoonhouse@naver.com</span>
            </div>
            <div class="text">
                <span class="key">사업자등록번호</span><span class="value">476-30-00276</span>
            </div>
            <div class="text">
                <span class="key">통신판매업신고번호</span><span class="value">제2017-대구북구-0141호</span>
            </div>
            <div class="text">
                <span class="key">instagram</span>
                <div class="value_img">
                    <a href="https://www.instagram.com/somoonhouse/" target="_self"><img src="https://somoonhouse.com/otherimg/assets/instagram.png?raw=true" /></a>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
    //새 스크립트 작성
    //window.close();
</script>
</body>
</html>