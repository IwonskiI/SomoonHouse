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
    String company_name = "";
    String company_img = "";
//    String company_address = "";
    String company_introduction = "";
    String stock = "";

    //파라미터 가져오기
    String tab = request.getParameter("tab") + "";
    String s_id = session.getAttribute("s_id")+"";
//    out.println(s_id);

    //DB 관련 객체 선언
    Connection conn = DBUtil.getMySQLConnection();
    ResultSet rs = null;
    PreparedStatement pstmt = null;
    String query = "";

    //DB 가져오기
    if(s_id != null) {
        query = "SELECT Name, Profile_img, Address, Introduction FROM COMPANY WHERE Id = " + s_id;
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            company_name = rs.getString("Name");
            company_img = rs.getString("Profile_img");
//            company_address = rs.getString("Address");
            company_introduction = rs.getString("Introduction");
            if(company_introduction == null || company_introduction.equals("null"))
                company_introduction = "소개글을 작성해주세요.";
        }
        //전체 잔여ㅎ
        query = "SELECT SUM(Stock) FROM ISSUED_COUPON where Company_id = " + s_id
                + " and Expiration_date >= CURDATE()"
                + " group by Company_id";
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();
        stock = "0";
        while(rs.next()){
            stock = rs.getString("SUM(Stock)");
        }

        pstmt.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="SHORTCUT ICON" href="https://somoonhouse.com/img/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/newTestHeader.css"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <title>소문난집</title>
</head>
<body>
<%=mylog%>
<%

%>
<div class="block"></div>
<div class="body_container_header">
    <div class="body_header">
        <div class="upper_header">
            <div class="left_header">
                <a href="homepage.jsp">
                    <span>소문난집</span>
                </a>
            </div>
            <div class="right_header">
                <a href="newTestReview.jsp" target="_self"> <!--style 해제 해주어야함-->
                    <div class="img_container">
                        <img class="review"
                             src="https://somoonhouse.com/otherimg/assets/review.png?raw=true" />
                    </div>
                </a>
                <% if(s_id.equals("47")) {%>
                <a href="newTestPartnerNewTemp.jsp" target="_self"> <!--style 해제 해주어야함-->
                    <div class="img_container">
                        <img class="cart"
                             src="https://somoonhouse.com/otherimg/assets/cart3.png?raw=true" />
                    </div>
                </a>
                <%} else{%>
                <a href="newTestPartnerNew.jsp" target="_self"> <!--style 해제 해주어야함-->
                    <div class="img_container">
                        <img class="cart"
                             src="https://somoonhouse.com/otherimg/assets/cart3.png?raw=true" />
                    </div>
                </a>
                <%}%>
                <a href="newTestPartnerOld.jsp" target="_self">
                    <div class="img_container">
                        <img class="graph" src="https://somoonhouse.com/otherimg/assets/ticket.png?raw=true" />
                    </div>
                </a>
                <div class="img_container" id="menu_slide" onclick="slide()">
                    <img class="menu" src="https://somoonhouse.com/otherimg/assets/menu3.png?raw=true" />
                </div>
            </div>
        </div>
        <div class="lower_header">
            <a href="_refresh_request_company.jsp?state=0" target="_self">
                <div class="menu" id="new_customer">
                    <div class="menu_text"><span>신규</span></div>
                    <div class="menu_underbar" id="New"></div>
                </div>
            </a>
            <a href="_refresh_request_company.jsp" target="_self">
                <div class="menu" id="ing_customer">
                    <div class="menu_text"><span>진행 중</span></div>
                    <div class="menu_underbar" id="InProgress"></div>
                </div>
            </a>
            <a href="_refresh_request_company.jsp?state=1" target="_self">
                <div class="menu" id="fin_customer">
                    <div class="menu_text"><span>완료</span></div>
                    <div class="menu_underbar" id="Done"></div>
                </div>
            </a>
            <a href="_refresh_request_company.jsp?state=2" target="_self">
                <div class="menu" id="stop_customer">
                    <div class="menu_text"><span>중단</span></div>
                    <div class="menu_underbar" id="Stopped"></div>
                </div>
            </a>
        </div>
    </div>
    <div id="navigation_container" onclick="closeMenu()">
        <div id="navigation" onclick="nonCloseMenu()">
            <div class="user_container">
                <div id="profile_img" class="user_img_container">
<%--                    <img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/person.png?raw=true" />--%>
                </div>
                <div class="user_name">
                    <span><%=company_name%></span>
                </div>
                <div class="user_introduction">
                    <span><%=company_introduction%></span>
                </div>
            </div>
            <hr/>
            <div class="item_container" id="after_login">
                <div class="item_text">
                    <span>현재 이용중인 상품</span>
                </div>
                <div class="item_box">
                    <div class="item_text"><span class="num"><%=stock%></span></div>
                    <div class="item_text"><span class="sub">건</span></div>
                    <a href="newTestPartnerOld.jsp" target="_self">
                        <div class="item_img">
                            <img src="https://somoonhouse.com/otherimg/assets/rightDirection2.png?raw=true" />
                        </div>
                    </a>
                </div>
            </div>
            <div class="item_container" id="before_login">
                <div class="item_text">
                    <span>로그인 하셔야 이용 가능합니다.</span>
                </div>
                <a href="newTestLogin.jsp" target="_self">
                    <div class="item_box">
                        <div class="item_text"><span class="sub">로그인</span></div>
                        <div class="item_img">
                            <img src="https://somoonhouse.com/otherimg/assets/rightDirection2.png?raw=true" />
                        </div>
                    </div>
                </a>
            </div>
           <!-- <div class="menu_container">
                <div class="menu_upper">
                    <div class="upper_img">
                        <img src="https://somoonhouse.com/otherimg/assets/call.png?raw=true" />
                    </div>
                    <span>소문난집 전화문의</span>
                </div>
                <div class="menu_lower">
                    <span>053-290-5959</span>
                </div>
            </div> -->
            <!--
            <a class="board_href" href="newTestBoard.jsp" target="_self">
                <div class="board_container">
                    <div class="menu_upper">
                        <div class="upper_img">
                            <img src="https://somoonhouse.com/otherimg/assets/write.png?raw=true" />
                        </div>
                            <span>익명 게시판</span>
                    </div>
                </div>
            </a>
            -->
            <div class="setting_container">
                <a class="setting" href="company_home.jsp?company_id=<%=s_id%>" target="_self">
                    <img
                            src="https://somoonhouse.com/otherimg/assets/setting2.png?raw=true">
                </a>
                <div class="cancel_container" onclick="slide()">
                    <img src="https://somoonhouse.com/otherimg/assets/cancel.png?raw=true" />
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
    var nav = document.getElementById("navigation_container");
    var innerNav = document.getElementById("navigation");
    var isClose = true;
    const closeMenu = () => {
        if(isClose){
            nav.style.visibility = "hidden";
            nav.style.background = "rgba(0, 0, 0, 0)";
            nav.style.zIndex = 0;
            innerNav.style.right = "-300px";
        }
        isClose = true;
    }
    const nonCloseMenu = () => {
        isClose = false;
    }
    const slide = () => {
        if(nav.style.zIndex == 5){
            nav.style.visibility = "hidden";
            nav.style.background = "rgba(0, 0, 0, 0)";
            nav.style.zIndex = 0;
            innerNav.style.right = "-300px";
            isClose = true;
        }
        else{
            nav.style.visibility = "visible";
            nav.style.background = "rgba(0, 0, 0, 0.7)";
            innerNav.style.right = 0;
            nav.style.zIndex = 5;
        }
    }
    if (window.navigator.userAgent.match(/MSIE|Internet Explorer|Trident/i)) {
        alert("Edge 또는 Chrome을 사용해주시기 바랍니다.");
        window.location = "microsoft-edge:" + window.location.href;
    }
    $('document').ready(function(){
        let s_id = <%=s_id%>
        if("<%=s_id%>" == "null") {
            $('#before_login').css('display', 'flex');
            $('#after_login').css('display','none');
        }
        else{
            $('#before_login').css('display', 'none');
            $('#after_login').css('display','flex');
        }
        $('#profile_img').css("background", "url(<%=company_img%>) 50% 50% / 198px");
    })
</script>
<script>
    //탭 별 표시기능
    $('#<%=tab%>').css('visibility', 'visible');
</script>
</body>
</html>