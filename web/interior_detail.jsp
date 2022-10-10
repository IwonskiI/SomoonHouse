<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
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
    String s_id = session.getAttribute("s_id")+"";// 현재 사용자 current user

    //파라미터 가져오기
    String param = request.getParameter("param");

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
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/interior_detail.css"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <title>소문난집</title>
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
<jsp:include page="/homepage_pc_header.jsp" flush="false" />
<jsp:include page="/homepage_mob_header.jsp" flush="false" />
<!-- 상단 사진 -->
<div class="interior_detail_main_img" id="interior_detail_main_img">

</div>
<div class="body_container">
    <!-- 내용 설명 -->
    <div class="interior_detail_info">
        <div class="info_title" id="info_title">
            <span class="title_name" id="title_name"><span class="title_sub" id="title_sub"></span></span>
            <span class="title_submit"><a href="remodeling_form.jsp?item_num=0">상담 신청</a></span>
        </div>
        <div class="main_title" id="main_title"></div>
        <div class="info_detail" id="info_detail_detail"></div>
    </div>

    <!-- 사진들 -->
    <div class="interior_detail_imgs" id="interior_detail_imgs"></div>

    <!-- 이 디자이너의 다른 것들 -->
    <div class="interior_detail_case">
        <div class="upper">
            <span id="case_upper_span">의 다른 시공 사례</span>
        </div>
        <div class="lower">
            <div class="slider" id="interior_detail_case_slider">
                <!-- a href="https://github.com" class="case_container">
                    <div class="box">
                        <div class="box_upper">
                            <img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/dog1.jpg?raw=true" />
                        </div>
                        <div class="box_lower">
                            <span class="title">대구 수성구 수성동 수성보성타운</span>
                            <span class="sub">아파트 | 49평형</span>
                        </div>
                    </div>
                </a -->
            </div>
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
    /*
    const info_title = document.getElementById("info_title");
    const info_title_block = document.getElementById("info_title_block");
    let isForMobile = window.innerWidth > 700 ? false : true;
    window.addEventListener('resize', (event) => {
        isForMobile = event.currentTarget.innerWidth > 700 ? false : true;
    })
    window.onscroll = () => {
        if(isForMobile){
            if(document.documentElement.scrollTop >= 250 && info_title.style.position !== "fixed"){
                info_title.style.position = "fixed";
                info_title_block.style.display = "flex";
            }
            if(document.documentElement.scrollTop < 250 && info_title.style.position === "fixed"){
                info_title.style.position = null;
                info_title_block.style.display = "none";
            }
        }
        else{
            if(info_title.style.position === "fixed"){
                info_title.style.position = "";
                info_title_block.style.display = "none";
            }
        }
    }
    */
    const createEle = (sortOfElement, className) => {
        let nameOfElement = document.createElement(sortOfElement);
        if (className !== undefined) nameOfElement.className = className;
        return nameOfElement;
    }

    const url = location.href,
        urlPos = url.indexOf("?"),
        urlAndPos = url.indexOf("&"),
        urlSub = url.substr(urlPos);
        comID = urlPos >= 0 ? url.substr(urlPos).substr(4, urlAndPos - urlPos - 4) : "0",
        caseID = urlPos >= 0 ? url.substr(urlAndPos).substr(5) : "0";

    const getCompanyData = async () => {
        await fetch("https://somunbackend.com/auth-non/company/represent/" + comID, {
            method: "GET",
            headers: {
            }
        })
        .then((res) => {
            return res.json();
        })
        .then((res) => {
            makeDetailPage(res);
        })
        .catch((err) => {
            console.log(err);
        })
    }
    getCompanyData();

    const getTargetCompanyCaseData = async () => {
        const targetCompanyCaseDataUrl = "https://somunbackend.com/auth-non/remodeling/company/" + comID;
        await fetch(targetCompanyCaseDataUrl, {
            method: "GET",
            headers: {}
        })
            .then((res) => {
                return res.json();
            })
            .then((res) => {
                makeCaseImages(res[caseID]);
                makeCaseBoxes(res);
                makeMoreDetailPage(res);
            })
            .catch((err) => {
                console.log(err);
            })
    }
    getTargetCompanyCaseData();

    const makeMoreDetailPage = (data) => {
        const mainTitle = document.getElementById("main_title"),
            infoDetail = document.getElementById("info_detail_detail");
        mainTitle.innerHTML = data[caseID].title;
        const mainImgUrl =
            data[caseID].remodeling_imgs[0].img_path.replaceAll('(', '%28').replaceAll(')', '%29').replaceAll(' ',
                '%20');
            document.styleSheets[1].addRule('.interior_detail_main_img:after',
                'background-image: url(' + mainImgUrl + ');');

        const makeDetail = (titleStr, subStr) => {
            let infoDiv, titleDiv, subDiv;
            infoDiv = createEle("div", "info");
            titleDiv = createEle("div", "title");
            subDiv = createEle("div", "sub");
            titleDiv.innerHTML = titleStr;
            subDiv.innerHTML = subStr;
            infoDiv.appendChild(titleDiv);
            infoDiv.appendChild(subDiv);
            infoDetail.appendChild(infoDiv);
        }

        makeDetail("아파트명", data[caseID].apartment_name);
        if(data[caseID].area != 0){
            makeDetail("평수", data[caseID].area + "평");

        }


    }

    const makeCaseImages = (data) => {
        let detailImages = document.getElementById("interior_detail_imgs");
        for(let i = 0; i < data.remodeling_imgs.length; i++){
            let caseImage = createEle("img");
            caseImage.src = data.remodeling_imgs[i].img_path;
            detailImages.appendChild(caseImage);
        }

    }

    const makeCaseBoxes = (data) => {
        for(let i = 0; i < 5; i++){
            if(i + "" === caseID) continue;
            if(data[i] === undefined) continue;
            makeCaseBox(data[i], i);
        }
    }

    const makeCaseBox = (data, index) => {
        let  infoCaseSlider = document.getElementById("interior_detail_case_slider"),
            caseContainer, caseBox, boxUpper, boxLower, upperImg,
            lowerTitle, lowerSub;

        caseContainer = createEle("a", "case_container");
        caseBox = createEle("div", "box");
        boxUpper = createEle("div", "box_upper");
        boxLower = createEle("div", "box_lower");
        upperImg = createEle("img");
        lowerTitle = createEle("span", "title");
        lowerSub = createEle("span", "sub");

        caseContainer.href = "interior_detail.jsp?id=" + comID +
            "&cid=" + index;
        upperImg.src = data.remodeling_imgs[0].img_path;
        lowerTitle.innerHTML = data.apartment_name;
        const caseArea = data.area;
        let lowerSubString = "아파트 ";
        if(caseArea != 0){
            lowerSubString += "| " + caseArea + "평";
        }
        lowerSub.innerHTML = lowerSubString;

        boxUpper.appendChild(upperImg);
        boxLower.appendChild(lowerTitle);
        boxLower.appendChild(lowerSub);
        caseBox.appendChild(boxUpper);
        caseBox.appendChild(boxLower);
        caseContainer.appendChild(caseBox);
        infoCaseSlider.appendChild(caseContainer);
    }

    const makeDetailPage = (data) => {
        const caseUpperSpan = document.getElementById("case_upper_span"),
            titleName = document.getElementById("title_name");
        caseUpperSpan.innerHTML = data[0].name + "의 다른 시공 사례";
        titleName.innerHTML = data[0].name;
        titleName.onclick = () => {
            location.href="interior_info.jsp?id=" + comID;
        }
    }

</script>
</body>
</html>