<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<%
    //캐시 설정 - 이미지 캐시 폐기 기간을 늘려서 반응속도를 올림
    response.setHeader("Cache-Control", "no-cache") ;
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
    String s_id = session.getAttribute("s_id")+"";// 현재 사용자 current user

    //파라미터 가져오기
    String param = request.getParameter("param");
    String location = request.getParameter("location");

    //필요한 변수 선언
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
    <link rel="SHORTCUT ICON" href="https://somoonhouse.com/img/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/interiors.css"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <title>소문난집 - 파트너스</title>
    <!-- 사용자 행동 정보 수집 코드 시작 - Meta, GA -->
    <!-- 모든 페이지에 하나씩만 포함되어 있어야 합니다. 위치는 </head> 바로 위로 통일 -->
    <!-- Meta Pixel Code -->
    <script>
        !function(f,b,e,v,n,t,s)
        {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
            n.callMethod.apply(n,arguments):n.queue.push(arguments)};
            if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
            n.queue=[];t=b.createElement(e);t.async=!0;
            t.src=v;s=b.getElementsByTagName(e)[0];
            s.parentNode.insertBefore(t,s)}(window, document,'script',
            'https://connect.facebook.net/en_US/fbevents.js');
        fbq('init', '483692416470707');
        fbq('track', 'PageView');
    </script>
    <noscript><img height="1" width="1" style="display:none"
                   src="https://www.facebook.com/tr?id=483692416470707&ev=PageView&noscript=1"
    /></noscript>
    <!-- End Meta Pixel Code -->
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-PC15JG6KGN"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'G-PC15JG6KGN');
    </script>
    <!-- END Global site tag (gtag.js) - Google Analytics -->
    <!-- Google Tag Manager -->
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
            new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
        j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
        'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer','GTM-TQFGN2T');</script>
    <!-- End Google Tag Manager -->
    <!-- 사용자 행동 정보 수집 코드 끝 - Meta, GA -->
</head>
<body>

<div class="body_container">
    <jsp:include page="/homepage_pc_header.jsp" flush="false" />
    <jsp:include page="/homepage_mob_header.jsp" flush="false" />
    <div class="interior_container">
        <!-- div class="upper" id="interior_upper">
            <div class="searchBoxContainer">
                <form id="form_done" name="form_done" method="POST" action="newTest1.jsp">
                    <div class="searchBox" id="searchBox">
                        <div class="img_container">
                            <img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/magnifying.png?raw=true" />
                        </div>
                        <div class="text_container">
                            <input class="text_input" id="searchTextInput" type="text" placeholder="" value=""/>
                            <input class="searchSubmit" type="submit" />
                        </div>
                    </div>
                </form>
            </div>
            <div class="filter" id="filter">
                <button onclick="openFilterSlider()">필터</button>
            </div>
            <div class="filterSlider" id="filterSlider">
            </div>
        </div>
        <div id="upperShadow"></div>
        <div>소문난집 파트너스에 신청하세요!
            소문난집 파트너스 목록
        </div-->
        <div class="interior_body" id="interior_body">
            <!-- a href="https://github.com" class="company_container">
                <div class="company_text">
                    <div class="left">
                        <span class="name">햇반먹자디자인</span>
                        <span class="addr">대구 수성구</span>
                    </div>
                    <span class="title_sub">계약 3건 · 상담 12건</span>
                </div>
                <div class="company_imgs">
                    <div class="company_img"><img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/dog1.jpg?raw=true" /></div>
                    <div class="company_img"><img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/dog1.jpg?raw=true" /></div>
                </div>
            </a -->
        </div>
    </div>
</div>
<jsp:include page="/newTestFooter.jsp" flush="false" />
<%
    if(pstmt != null) {
        pstmt.close();
        rs.close();
        query = "";
        conn.close();
    }
%>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
    const createEle = (sortOfElement, className) => {
        let nameOfElement = document.createElement(sortOfElement);
        if (className !== undefined) nameOfElement.className = className;
        return nameOfElement;
    }
    /*
    const tagData = {
        area : ["중구", "동구", "서구", "남구", "북구", "수성구", "달서구", "달성군", "경북"],
        hashtag : ["모던", "화이트", "블랙", "미니멀"]
    }

    const upper = document.getElementById("interior_upper");
    upper.style.top = "102px";
    handler.set = (obj, prop, value) => {
        obj[prop] = value;
        value ?
            upper.style.top = "102px"
            :
            upper.style.top = "0";
    }

    const upperShadow = document.getElementById("upperShadow");
    upperShadow.style.height = upper.clientHeight + "px";

    const openFilterSlider = () => {
        if(filterSlider.style.display === "flex"){
            filterSlider.style.display = "none";
            upperShadow.style.height = upper.clientHeight + "px";
        }
        else{
            filterSlider.style.display = "flex";
            upperShadow.style.height = upper.clientHeight + "px";
        }
    }

    const searchTextInput = document.getElementById("searchTextInput"),
        searchBox = document.getElementById("searchBox");
    searchTextInput.addEventListener('focus', () => {
        searchBox.style.background = "#fff";
    })
    searchTextInput.addEventListener('blur', () => {
        searchBox.style.background = "#fafafa";
    })


    const filter = document.getElementById("filter"),
        filterSlider = document.getElementById("filterSlider");

    let i = 0;
    for(i; i < tagData.area.length; i++){
        filter.innerHTML +=
            "<div class='nowTagBox' onclick='clickToNone(this, " + i + ")'>" +
            "<div class='leftTag sideTag'></div>" +
            "<div class='nowTag tag" + i + "'>" + tagData.area[i] +
            "<div>X</div></div>" +
            "<div class='rightTag sideTag'></div></div>";
        filterSlider.innerHTML +=
            "<div class='allTagBox' onclick='test(this, " + i + ")'>" +
            "<div class='leftTag sideTag'></div>" +
            "<div class='allTag tag" + i + "'>" + tagData.area[i] +
            "<div class='onOff'>X</div>" +
            "</div><div class='rightTag sideTag'></div></div>";
    }
    for(let j = 0, i; j < tagData.hashtag.length; i++, j++){
        filter.innerHTML +=
            "<div class='nowTagBox' onclick='clickToNone(this, " + i + ")'>" +
            "<div class='leftTag sideTag'></div>" +
            "<div class='nowTag tag" + i + "'>" + tagData.hashtag[j] +
            "<div>X</div></div>" +
            "<div class='rightTag sideTag'></div></div>";
        filterSlider.innerHTML +=
            "<div class='allTagBox' onclick='test(this, " + i + ")'>" +
            "<div class='leftTag sideTag'></div>" +
            "<div class='allTag tag" + i + "'>" + tagData.hashtag[j] +
            "<div class='onOff'>X</div>" +
            "</div><div class='rightTag sideTag'></div></div>";
    }

    const nowTag = document.getElementsByClassName("nowTag");
        allTag = document.getElementsByClassName("allTag"),
        nowTagBox = document.getElementsByClassName("nowTagBox"),
        allTagBox = document.getElementsByClassName("allTagBox"),
        onOff = document.getElementsByClassName("onOff"),
        leftTag = document.getElementsByClassName("leftTag"),
        rightTag = document.getElementsByClassName("rightTag");
    const clickToNone = (prop, index) => {
        nowTagBox[index].style.display = "none";
        onOff[index].style.visibility = "hidden";
    }
    const test = (prop, index) => {
        if(onOff[index].style.visibility === "visible"){
            onOff[index].style.visibility = "hidden";
            nowTagBox[index].style.display = "none";
        }
        else{
            onOff[index].style.visibility = "visible";
            nowTagBox[index].style.display = "flex";
        }
    }

    */

    const makeInteriorsCompanyInfoBox = (prop) => {
        let interiorsContainer = document.getElementById("interior_body"),
            companyContainer, companyText, companyTextLeft,
            leftName, leftAddr, titleSub, companyImgs, loc;

        const comName = prop.name,
            counseling = prop.counseling,
            construction = prop.construction,
            location = prop.location,
            img = [prop.represent_img1, prop.represent_img2];

        if(141<=parseInt(location)&&parseInt(location)<=148){
            console.log(parseInt(location))
            loc = "1";
        }
        else {
            console.log(parseInt(location))
            loc = "2";
        }
        console.log(loc)
        if(loc === "<%=location%>"){
            companyContainer = createEle("a", "company_container");
            companyText = createEle("div", "company_text");
            companyTextLeft = createEle("div", "left");
            leftName = createEle("span", "name");
            leftAddr = createEle("span", "addr");
            titleSub = createEle("span", "title_sub");
            companyImgs = createEle("div", "company_imgs");

            companyContainer.href = "https://somoonhouse.com/interior_info.jsp?id=" + prop.id;
            leftName.innerHTML = comName;
            if(loc === "1") leftAddr.innerHTML = "대구";
            else leftAddr.innerHTML = "서울/경기/인천";
            titleSub.innerHTML = "상담 " + counseling + "건";
            interiorsContainer.appendChild(companyContainer);
            companyContainer.appendChild(companyText);
            companyContainer.appendChild(companyImgs);
            companyText.appendChild(companyTextLeft);
            companyTextLeft.appendChild(leftName);
            companyTextLeft.appendChild(leftAddr);
            companyText.appendChild(titleSub);
            for(let i = 0; i < 2; i++){
                let cImg = createEle("img"),
                    companyImg = createEle("div", "company_img");
                cImg.src = img[i];
                companyImg.appendChild(cImg);
                companyImgs.appendChild(companyImg);
            }
        }
    }

    const getCompanyData = async () => {
        await fetch("https://somunbackend.com/auth-non/company/represent", {
            method: "GET",
            headers: {
            }
        })
            .then((res) => {
                return res.json();
            })
            .then((res) => {
                makeInteriorsCompanyInfo(res);
            })
            .catch((err) => {
                console.log(err);
            })
    }

    const makeInteriorsCompanyInfo = (data) => {
        for(let i = 0; i < data.length; i++){
            makeInteriorsCompanyInfoBox(data[i]);
        }
    }
    getCompanyData();

</script>
</body>
</html>