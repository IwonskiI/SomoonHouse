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
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/interior_info.css"/>
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
<div class="body_container">
    <div class="interior_info_box">
        <div class="background">
            <img id="info_img" />
        </div>
        <div class="info_title" id="info_title">
            <span class="title_name" id="title_name"><span class="title_sub" id="title_sub"></span></span>
            <span class="title_submit"><a href="https://somoonhouse.com/remodeling_form.jsp?item_num=0">상담 신청</a></span>
        </div>
        <div class="info_title_block" id="info_title_block"></div>
        <div class="detail" id="info_title_detail">
            <!--div class="info">
                <div class="title">대표자</div>
                <div class="sub">임재한</div>
            </div>
            <div class="info">
                <div class="title">경력</div>
                <div class="sub">200년</div>
            </div>
            <div class="info">
                <div class="title">주소</div>
                <div class="sub addr">대구 북구 대현로 19길 54 가나다라마바사가나다라마바사가나다라마바사가나다라마바사</div>
            </div-->
        </div>
    </div>
    <!-- 각 업체별 사례 -->
    <div class="interior_info_case">
        <div class="upper">
            <span>시공 사례</span>
        </div>
        <div class="lower">
            <div class="slider" id="interior_info_case_slider">
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
    <!-- 후기 : 후기 페이지에 있는 거 가져오기 -->
    <!--div class="interior_info_review">
        <div class="reviewUpperTextContainer"><span>고객 후기</span></div>
        <div class="reviewBoxContainer">
            <div class="reviewBox">
                <div class="upper">
                    <span class="num">4.9</span>
                    <div class="infoDiv">
                        <span class="info">김○○님</span>
                    </div>
                </div>
                <div class="imgs">
                    <div>
                        <img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/dog1.jpg?raw=true" />
                    </div>
                    <div>
                        <img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/dog2.jpg?raw=true" />
                    </div>
                    <div>
                        <img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/cat1.jpg?raw=true" />
                    </div>
                    <div class="lastImg"></div>
                </div>
                <div class="text">
                <span>
                    이번에 로또 1등 당첨 되면서 집을 보러 가게 됐는데
                    인테리어가 마음에 안들어서 OROKOS 인테리어에 맡겼는데
                    일 정말 잘하더라고요~~! 여기 강추합니다! 대박.
                </span>
                </div>
            </div>
            <div class="reviewBox">
                <div class="upper">
                    <span class="num">4.9</span>
                    <div class="infoDiv">
                        <span class="info">김○○님</span>
                    </div>
                </div>
                <div class="imgs">
                    <div>
                        <img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/dog1.jpg?raw=true" />
                    </div>
                    <div>
                        <img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/dog2.jpg?raw=true" />
                    </div>
                    <div>
                        <img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/cat1.jpg?raw=true" />
                    </div>
                    <div class="lastImg"></div>
                </div>
                <div class="text">
                <span>
                    이번에 로또 1등 당첨 되면서 집을 보러 가게 됐는데
                    인테리어가 마음에 안들어서 OROKOS 인테리어에 맡겼는데
                    일 정말 잘하더라고요~~! 여기 강추합니다! 대박.
                </span>
                </div>
            </div>
        </div>
    </div-->
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
<script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
<script>
    const createEle = (sortOfElement, className) => {
        let nameOfElement = document.createElement(sortOfElement);
        if (className !== undefined) nameOfElement.className = className;
        return nameOfElement;
    }
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

    const url = location.href,
        urlPos = url.indexOf("?"),
        urlSub = url.substr(urlPos);
        comID = urlPos >= 0 ? urlSub.substr(4) : null;

    const getTargetCompanyData = async () => {
        const targetCompanyDataUrl = "https://somunbackend.com/auth-non/company/represent/" + comID;
        await fetch(targetCompanyDataUrl, {
            method: "GET",
            headers: {}
        })
        .then((res) => {
            return res.json();
        })
        .then((res) => {
            makeTitle(res);
        })
        .catch((err) => {
            console.log(err);
        })
    }
    if(comID){
        getTargetCompanyData();
    }


    const makeTitle = (data) => {
        const titleName = document.getElementById("title_name"),
            titleSub = document.getElementById("title_sub"),
            infoImg = document.getElementById("info_img"),
            titleDetail = document.getElementById("info_title_detail");
        titleName.innerHTML = data[0].name;
        if(data[0].counseling != 0){
            titleSub.innerHTML = "상담 " + data[0].counseling + "건";
        }
        if(data[0].represent_img1 !== "https://somoonhouse.com/sources/noprofile1.jpg"){
            infoImg.src = data[0].represent_img1;
        }
        else{
            infoImg.src = "https://somoonhouse.com/sources/noprofile1.png";
            infoImg.setAttribute("style","object-fit: contain");
        }

        const makeDetail = (titleStr, subStr) => {
            let infoDiv, titleDiv, subDiv;
            infoDiv = createEle("div", "info");
            titleDiv = createEle("div", "title");
            subDiv = createEle("div", "sub");
            titleDiv.innerHTML = titleStr;
            subDiv.innerHTML = subStr;
            infoDiv.appendChild(titleDiv);
            infoDiv.appendChild(subDiv);
            titleDetail.appendChild(infoDiv);
        }
        if(data[0].owner_name != null){
            makeDetail("대표자", data[0].owner_name);
        }
        if(data[0].address != null){
            makeDetail("주소", data[0].address);
        }
    }

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
            makeCaseBoxes(res);
        })
        .catch((err) => {
            console.log(err);
        })
    }

    getTargetCompanyCaseData();

    const makeCaseBoxes = (data) => {
        let viewMax = data.length > 5 ? 5 : data.length;
        if (viewMax === 0){noCaseBox();}
        for(let i = 0; i < viewMax; i++){
            if(data[i] === undefined) continue;
            makeCaseBox(data[i], i);
        }
    }

    const makeCaseBox = (data, index) => {
        let  infoCaseSlider = document.getElementById("interior_info_case_slider"),
            caseContainer, caseBox, boxUpper, boxLower, upperImg,
            lowerTitle, lowerSub;

        caseContainer = createEle("a", "case_container");
        caseBox = createEle("div", "box");
        boxUpper = createEle("div", "box_upper");
        boxLower = createEle("div", "box_lower");
        upperImg = createEle("img");
        lowerTitle = createEle("span", "title");
        lowerSub = createEle("span", "sub");

        caseContainer.href = "https://somoonhouse.com/interior_detail.jsp" + urlSub + "&cid=" + index;
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

    const noCaseBox = () => {
        let  infoCaseSlider = document.getElementById("interior_info_case_slider"),
            noCaseContainer, imgContainer, img, txtContainer, txt ;

        noCaseContainer = createEle("div", "main_body_none");
        imgContainer = createEle("div", "img_containers");
        txtContainer = createEle("div", "text_container");
        img = createEle("img");
        txt = createEle("span");

        img.src = "https://somoonhouse.com/otherimg/assets/nocase.png?raw=true";
        txt.innerHTML = "등록된 시공 사례가 없습니다."

        imgContainer.appendChild(img);
        txtContainer.appendChild(txt);
        noCaseContainer.appendChild(imgContainer);
        noCaseContainer.appendChild(txtContainer);
        infoCaseSlider.appendChild(noCaseContainer);
    }
</script>
</body>
</html>