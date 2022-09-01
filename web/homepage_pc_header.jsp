<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<%
    //캐시 설정 - 이미지 캐시 폐기 기간을 늘려서 반응속도를 올림
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 31536000);

    /*
    //네이버 로그인 시 필요
    String clientId = "G8MVoxXfGciyZW5dF4p1";//애플리케이션 클라이언트 아이디값";
    String redirectURI = URLEncoder.encode("http://somoonhouse.com/callback.jsp", "UTF-8");
    SecureRandom random = new SecureRandom();
    String state = new BigInteger(130, random).toString();
    String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
    apiURL += "&client_id=" + clientId;
    apiURL += "&redirect_uri=" + redirectURI;
    apiURL += "&state=" + state;
    session.setAttribute("state", state);

    //네이버 로그인 시 CSRF 방지를 위한 상태 토큰 검증
    //세션 또는 별도의 저장 공간에 저장된 상태 토큰과 콜백으로 전달받은 state 파라미터 값이 일치해야 함
    //콜백 응답에서 state 파라미터의 값을 가져옴
    state = request.getParameter("state");
     */

    // 세션 가져오기 get session
    String s_id = session.getAttribute("s_id") + "";
    String home_id = session.getAttribute("home_id") + "";// 현재 사용자 current user
    String home_name = session.getAttribute("home_name") + "";

    //파라미터 가져오기
    String param = request.getParameter("param");

    //필요한 변수 선언
    int i, j;
    String mylog = "";

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
    <link rel="SHORTCUT ICON" href="https://somoonhouse.com/img/favicon.ico"/>
    <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/homepage_header.css"/>
    <meta charset="UTF-8">
    <meta name="viewport" con tent="width=device-width, initial-scale=1, user-scalable=no"/>
    <title>소문난집</title>
</head>
<body>
<div class="fixed_button" id="fixed_button">
    <span id="topBtn">top</span>
    <a href="remodeling_form.jsp?item_num=0" id="applyBtn">
        <div>상담<br>신청</div>
    </a>
</div>
<div class="upper_fixed_pc"></div>
<div class="body_container_header">
    <div class="header_pc">
        <div class="header_left">
            <a href="homepage.jsp" target="_self">
                <img src="https://somoonhouse.com/otherimg/index/somunlogo.jpg"/>
            </a>
        </div>
        <div class="header_right">
            <div id="area_header_pc">
                <span>지역별 인테리어</span>
                <div class="div_pc" id="area_div_pc">
                    <a href="https://somoonhouse.com/newindex.jsp?rootloc=3"><span>대구/경북</span></a>
                    <a href="https://somoonhouse.com/newindex.jsp?rootloc=1"><span>서울/경기/인천</span></a>
<%--                    <a href="newindex.jsp?Daegu=141"><span>중구</span></a>--%>
<%--                    <a href="newindex.jsp?Daegu=142"><span>동구</span></a>--%>
<%--                    <a href="newindex.jsp?Daegu=143"><span>서구</span></a>--%>
<%--                    <a href="newindex.jsp?Daegu=144"><span>남구</span></a>--%>
<%--                    <a href="newindex.jsp?Daegu=145"><span>북구</span></a>--%>
<%--                    <a href="newindex.jsp?Daegu=146"><span>수성구</span></a>--%>
<%--                    <a href="newindex.jsp?Daegu=147"><span>달서구</span></a>--%>
<%--                    <a href="newindex.jsp?Daegu=148"><span>달성군</span></a>--%>
<%--                    <a href="newindex.jsp?Daegu=15"><span>경북</span></a>--%>
                </div>
            </div>
            <div class="sidebar"></div>
            <div id="popular_header_pc">
                <span>인기 인테리어</span>
                <div class="div_pc" id="popular_div_pc">
                    <a href="https://somoonhouse.com/newindex.jsp?rootloc=3&theme_id=1"><span>대구/경북</span></a>
                    <a href="https://somoonhouse.com/newindex.jsp?rootloc=1&theme_id=1"><span>서울/경기/인천</span></a>
                </div>
            </div>
            <!--a>
                <span>시공 후기</span>
            </a-->
            <div class="sidebar"></div>
            <div id="partner_header_pc">
                <span>파트너스</span>
                <div class="div_pc" id="partner_div_pc">
                    <a href="https://somoonhouse.com/interiors.jsp?rootloc=3"><span>대구/경북</span></a>
                    <a href="https://somoonhouse.com/interiors.jsp?rootloc=1"><span>서울/경기/인천</span></a>
                </div>
            </div>
        </div>
        <div class="header_login" id="header_login">
            <%if (home_id == null || home_id.equals("") || home_id.equals("null")) {%>
            <a id="loginplz" href="login.jsp">로그인</a>해주세요.
            <%} else {%>
            <span><b><%=home_name%></b>님 환영합니다!</span>
            <span><button onclick="location.href = 'mypage.jsp'">마이페이지</button></span>
            <span><button onclick="location.href = '_logout.jsp'">로그아웃</button></span>
            <%} %>
        </div>
    </div>
    <div class="underline"></div>
</div>

<%
    if (pstmt != null) {
        pstmt.close();
        rs.close();
        query = "";
        conn.close();
    }
%>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
    const area_header = document.getElementById("area_header_pc"),
        area_div = document.getElementById("area_div_pc");
    area_header.onmouseenter = () => {
        area_div.style.display = "flex";
    }
    area_header.onmouseleave = () => {
        area_div.style.display = "none";
    }

    const popular_header = document.getElementById("popular_header_pc"),
        popular_div = document.getElementById("popular_div_pc");
    popular_header.onmouseenter = () => {
        popular_div.style.display = "flex";
    }
    popular_header.onmouseleave = () => {
        popular_div.style.display = "none";
    }

    const partner_header = document.getElementById("partner_header_pc"),
        partner_div = document.getElementById("partner_div_pc");
    partner_header.onmouseenter = () => {
        partner_div.style.display = "flex";
    }
    partner_header.onmouseleave = () => {
        partner_div.style.display = "none";
    }

    const goToTop = () => {
        window.scrollTo(0, 0);
    }
    const topBtn = document.getElementById("topBtn");
    topBtn.onclick = goToTop;

    //상담신청페이지 버튼삭제
    const isRemodelingForm = location.href.indexOf("remodeling_form.jsp") !== -1;
    const isCustomerRequest = location.href.indexOf("customer") !== -1;
    if (!isRemodelingForm && !isCustomerRequest) {
        document.getElementById("fixed_button").style.display = "flex";
        document.getElementById("header_login").style.display = "flex";
    }
</script>
</body>
</html>