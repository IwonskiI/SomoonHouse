<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="myPackage.*" %>
<%@ page import="javax.resource.cci.ResultSet" %>
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
    <link rel="SHORTCUT ICON" href="https://somoonhouse.com/img/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/homepage.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/homepage_header.css"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
    <meta property="og:type" content="website">
    <meta property="og:title" content="소문난집">
    <meta property="og:description" content="믿을 수 있는 대구 리모델링 업체, 견적 플랫폼 소문난집">
    <meta property="og:image" content="https://www.somoonhouse.com/otherimg/assets/thumnail.png">
    <meta property="og:url" content="https://www.somoonhouse.com/">
    <meta name="description" content="믿을 수 있는 대구 리모델링 업체, 견적 플랫폼 소문난집">
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
    <div class="body_container">
        <jsp:include page="/homepage_pc_header.jsp" flush="false" />
        <jsp:include page="/homepage_mob_header.jsp" flush="false" />
        <div class="container">
            <div class="banner">
                <div class="img_container" id="bannerParent">
                    <div class="turn before" onclick="bannerLeft()">
                        <img src="https://somoonhouse.com/otherimg/assets/arrow.png?raw=true" />
                    </div>
                    <!-- a class="bannerBox" >
                        <img />
                    </a -->
                    <div class="turn after" onclick="bannerRight()">
                        <img src="https://somoonhouse.com/otherimg/assets/arrow.png?raw=true" />
                    </div>
                </div>
            </div>
        </div>
        <div class="container">
            <!--div class="area_part">
                <div class="upper">
                    <span>인테리어 스타일이 궁금하다면?</span>
                </div>
                <div class="lower" id="slider_container">
                    <div class="slider" id="area_slider">
                        <a class="area" href="https://somoonhouse.com/newindex.jsp?theme_id=1">
                            <div>
                                <img src="https://somoonhouse.com/otherimg/assets/dog4.jpg?raw=true" />
                            </div>
                            <span>모던</span>
                        </a>
                    </div>
                </div>
            </div-->
            <div class="partner_info">
                <div class="upper">
                    <span>전국 인테리어 전문가를 만나보세요</span>
                    <div>
                        <a href="https://somoonhouse.com/newindex.jsp?theme_id=1">
                            <span>자세히보기</span>
                            <img src="https://somoonhouse.com/otherimg/assets/arrow.png?raw=true" />
                        </a>
                    </div>
                </div>
                <div class="lower" id="partner_info_lower">
                    <!--a href="https://github.com" class="partner_info_container">
                        <div class="box">
                            <div class="box_upper">
                                <div class="imgBox"><img src="https://somoonhouse.com/otherimg/assets/dog1.jpg?raw=true" /></div>
                                <div class="imgBox secondImg"><img src="https://somoonhouse.com/otherimg/assets/dog1.jpg?raw=true" /></div>
                            </div>
                            <div class="box_lower">
                                <div class="txt fir">
                                    <span class="fir_title">아이비디자인</span>
                                    <div class="fir_box">
                                        <span class="fir_sub">A/S 1년</span>
                                    </div>
                                </div>
                                <div class="txt thr">
                                    <span class="title_sub">계약 3건 · 상담 12건</span>
                                    <div class="thr_img">
                                        <img src="https://somoonhouse.com/otherimg/assets/star.png?raw=true" />
                                    </div>
                                    <span>4.8</span>
                                    <div class="thr_img">
                                        <img src="https://somoonhouse.com/otherimg/assets/heart2.png?raw=true" />
                                    </div>
                                    <span>177</span>
                                </div>
                            </div>
                        </div>
                    </a -->
                </div>
                <div class="moreInfo" id="moreInfo">더 보 기</div>
            </div>
            <div class="review">
                <div class="upper">
                    <span>소문난집 이용후기</span>
                </div>
                <div class="lower">
                    <div class="boxes" id="reviewBox">
                        <!--div class="reviewBox sub">
                            <div class="top">
                                <div class="star">
                                    <div class="block"></div>
                                    <img src="https://somoonhouse.com/otherimg/assets/star2.png?raw=true" />
                                    <img src="https://somoonhouse.com/otherimg/assets/star2.png?raw=true" />
                                    <img src="https://somoonhouse.com/otherimg/assets/star2.png?raw=true" />
                                    <img src="https://somoonhouse.com/otherimg/assets/star2.png?raw=true" />
                                    <img src="https://somoonhouse.com/otherimg/assets/star2.png?raw=true" />
                                </div>
                                <span class="grade">4.5</span>
                            </div>
                            <div class="text">
<pre>
좋은 업체 소개해주셔서 감사합니다~~
미팅했던 두 곳은 진정성 있게 봐주셨습니다
번창하세요~~
소문난집 화이팅~~
오늘 점심은 혜화문식당입니다
    오늘 점심은 혜화문식당입니다
</pre>
                            </div>
                            <div class="bot">
                                <span class="address">대구 북구 대현동 <span>&nbsp 김** 님</span></span>
                                <div class="under">
                                    <div class="comBox">견적업체</div>
                                    <span>굿하우스 / 바르다인테리어디자인 / 아이비디자인</span>
                                </div>
                            </div>
                        </div-->
                    </div>
                    <div class="btn_container">
                        <div class="left" id="reviewLeftBtn">
                            <img src="https://somoonhouse.com/otherimg/assets/arrow.png?raw=true" />
                        </div>
                        <div class="right" id="reviewRightBtn">
                            <img src="https://somoonhouse.com/otherimg/assets/arrow.png?raw=true" />
                        </div>
                    </div>
                </div>
            </div>
            <!--div class="style">
                <div class="upper">
                    <div class="left">
                        <span>공사 금액부터 시공까지 자세히 알아보세요</span>
                    </div>
                    <a class="right" href="https://somoonhouse.com/newindex.jsp?theme_id=1">
                        <span>더보기</span>
                        <img src="https://somoonhouse.com/otherimg/assets/arrow.png?raw=true" />
                    </a>
                </div>
                <div class="lower">
                    <div class="slider">
                        <a href="https://github.com" class="style_container">
                            <div class="box">
                                <img src="https://somoonhouse.com/otherimg/assets/dog5.jpg?raw=true" />
                            </div>
                            <div class="text">
                                <div class="txt fir">
                                    <span class="fir_title">아이비디자인</span>
                                    <div class="fir_box">
                                        <span class="fir_sub">A/S 1년</span>
                                    </div>
                                    <div class="fir_box">
                                        <span class="fir_sub">응답우수</span>
                                    </div>
                                </div>
                                <span class="txt sec">서변동 서변월드메르디앙</span>
                                <div class="txt thr">
                                    <div class="thr_img">
                                        <img src="https://somoonhouse.com/otherimg/assets/star.png?raw=true" />
                                    </div>
                                    <span>4.8</span>
                                    <div class="thr_img">
                                        <img src="https://somoonhouse.com/otherimg/assets/heart2.png?raw=true" />
                                    </div>
                                    <span>177</span>
                                </div>
                                <div class="txt fiv">
                                    <span>33평</span>
                                    <div class="sidebar"></div>
                                    <span>600만원</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
            </div-->
        </div>
        <div class="free">
            <a href="https://somoonhouse.com/remodeling_form.jsp?item_num=0">
                <div class="free_text">
                    <span>우리 집 리모델링 비용은 ?</span>
                    <div class="text_lower">
                        <span class="lower_text">무료 견적 받으러 가기</span>
                        <div class="lower_img">
                            <img src="https://somoonhouse.com/otherimg/assets/arrow2.png?raw=true" />
                        </div>
                    </div>
                </div>
                <div class="free_img">
                    <img src="https://somoonhouse.com/otherimg/assets/chat.png?raw=true" />
                </div>
            </a>
        </div>
        <div class="container">
            <div class="insta">
                <div class="title">
                    <div class="icon">
                        <img src="https://somoonhouse.com/otherimg/assets/insta.png?raw=true" />
                    </div>
                    <span>somoonhouse_official</span>
                </div>
                <span class="sub">소문난집 인스타그램에서 <br>다양한 이벤트와 소식을 확인하세요.</span>
                <div class="follow">
                    <div class="follow_img">
                        <img
                                src="https://somoonhouse.com/otherimg/assets/heart4.png?raw=true" />
                    </div>
                    <span>1.3K</span>
                </div>
                <div class="imgs">
                    <a href="https://www.instagram.com/somoonhouse/">
                        <div class="a"><img src="https://somoonhouse.com/otherimg/index/instagram/004.jpeg" /></div>
                        <div class="a"><img src="https://somoonhouse.com/otherimg/index/instagram/002.jpeg" /></div>
                        <div class="a"><img src="https://somoonhouse.com/otherimg/index/instagram/003.jpeg" /></div>
                        <div class="a"><img src="https://somoonhouse.com/otherimg/index/instagram/008.jpeg" /></div>
                        <div class="b"><img src="https://somoonhouse.com/otherimg/index/instagram/005.jpeg" /></div>
                        <div class="b"><img src="https://somoonhouse.com/otherimg/index/instagram/006.jpeg" /></div>
                        <div class="b"><img src="https://somoonhouse.com/otherimg/index/instagram/001.jpeg" /></div>
                        <div class="b"><img src="https://somoonhouse.com/otherimg/index/instagram/007.jpeg" /></div>
                    </a>
                </div>
            </div>
        </div>
        <a class="findA" href="https://somoonhouse.com/banner1.jsp?id=3">
            <div class="find">
                <img src="https://somoonhouse.com/otherimg/assets/with.png?raw=true" />
            </div>
        </a>
    </div>
    <jsp:include page="/newTestFooter.jsp" flush="false" />
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
    <script src="./homepage_banner.js"></script>
    <script src="./consultReviewData.js"></script>
<script>
    console.log("sid= <%=s_id%>")
    const createEle = (sortOfElement, className, idName) => {
        let nameOfElement = document.createElement(sortOfElement);
        if (className !== undefined) nameOfElement.className = className;
        if (idName !== undefined) nameOfElement.id = idName;
        return nameOfElement;
    }

    const abs = (a) => {
        return a >= 0 ? a : -1 * a;
    }

    const starSetting = () => {
        const block = document.getElementsByClassName("block"),
            grade = document.getElementsByClassName("grade");
        for(let i = 0; i < grade.length; i++){
            let gdiffNum = (5 - grade[i].textContent[0]) * 40;
            switch(10 - grade[i].textContent[2] * 1){
                case 10: break;
                case 1: gdiffNum -= 32;
                    break;
                case 2: gdiffNum -= 31;
                    break;
                case 3: gdiffNum -= 27;
                    break;
                case 4: gdiffNum -= 24;
                    break;
                case 5: gdiffNum -= 20;
                    break;
                case 6: gdiffNum -= 17;
                    break;
                case 7: gdiffNum -= 15;
                    break;
                case 8: gdiffNum -= 13;
                    break;
                case 9: gdiffNum -= 11;
                    break;
            }
            block[i].style.width = gdiffNum + "px";
        }
    }
    const reviewBoxSetting = () => {
        const reviewBoxContainer = document.getElementById("reviewBox"),
            boxes = document.getElementsByClassName("reviewBox");
        let mainBoxNum,
            PCPos = Math.round(-660 + (reviewBoxContainer.clientWidth - 660) / 2),
            MobPos = Math.round(-400 + (reviewBoxContainer.clientWidth - 400) / 2);
        if(matchMedia("(max-width: 700px)").matches){
            for(let i = 0; i < boxes.length; i++){
                if(boxes[i].className === "reviewBox main"){
                    mainBoxNum = i;
                }
                boxes[i].style.transform = "translateX(" + MobPos + "px)";
            }
        }
        else{
            for(let i = 0; i < boxes.length; i++){
                if(boxes[i].className === "reviewBox main"){
                    mainBoxNum = i;
                }
                boxes[i].style.transform = "translateX(" + PCPos + "px)";
            }
        }
        const goLeft = () => {
            if(mainBoxNum === 0){
                PCPos -= boxes.length * 660;
                MobPos -= boxes.length * 400;
            }
            PCPos += 660;
            MobPos += 400;
            if(matchMedia("(max-width: 700px)").matches){
                for(let i = 0; i < boxes.length; i++){
                    if(boxes[i].className === "reviewBox main"){
                        mainBoxNum = i;
                    }
                    boxes[i].style.transform = "translateX(" + MobPos + "px)";
                }
                boxes[mainBoxNum].className = "reviewBox sub";
                mainBoxNum === 0 ? mainBoxNum = boxes.length - 1 : mainBoxNum--;
                boxes[mainBoxNum].className = "reviewBox main";
            }
            else{
                for(let i = 0; i < boxes.length; i++){
                    if(boxes[i].className === "reviewBox main"){
                        mainBoxNum = i;
                    }
                    boxes[i].style.transform = "translateX(" + PCPos + "px)";
                }
                boxes[mainBoxNum].className = "reviewBox sub";
                mainBoxNum === 0 ? mainBoxNum = boxes.length - 1 : mainBoxNum--;
                boxes[mainBoxNum].className = "reviewBox main";
            }
        }
        const goRight = () => {
            if(mainBoxNum === boxes.length - 1){
                MobPos += boxes.length * 400;
                PCPos += boxes.length * 660;
            }
            MobPos -= 400;
            PCPos -= 660;
            if(matchMedia("(max-width: 700px)").matches){
                for(let i = 0; i < boxes.length; i++){
                    if(boxes[i].className === "reviewBox main"){
                        mainBoxNum = i;
                    }
                    boxes[i].style.transform = "translateX(" + MobPos + "px)";
                }
                boxes[mainBoxNum].className = "reviewBox sub";
                mainBoxNum === boxes.length - 1 ? mainBoxNum = 0 : mainBoxNum++;
                boxes[mainBoxNum].className = "reviewBox main";
            }
            else{
                for(let i = 0; i < boxes.length; i++){
                    if(boxes[i].className === "reviewBox main"){
                        mainBoxNum = i;
                    }
                    boxes[i].style.transform = "translateX(" + PCPos + "px)";
                }
                boxes[mainBoxNum].className = "reviewBox sub";
                mainBoxNum === boxes.length - 1 ? mainBoxNum = 0 : mainBoxNum++;
                boxes[mainBoxNum].className = "reviewBox main";
            }
        }
        const reviewLeftBtn  = document.getElementById("reviewLeftBtn"),
            reviewRightBtn  = document.getElementById("reviewRightBtn");
        reviewLeftBtn.onclick = goLeft;
        reviewRightBtn.onclick = goRight;

        let isSmall = reviewBoxContainer.clientWidth >= 684 ? false : true;
        const observer = new ResizeObserver((prop) => {
            if(prop[0].contentRect.width >= 684){
                if(isSmall){
                    isSmall = false;
                    for(let i = 0; i < boxes.length; i++){
                        boxes[i].style.transform = "translateX(" + PCPos + "px)";
                    }
                }
                else{
                    PCPos = Math.round(-660 + (reviewBoxContainer.clientWidth - 660) / 2 - 660 * (mainBoxNum - 1));
                    for(let i = 0; i < boxes.length; i++){
                        boxes[i].style.transform = "translateX(" + PCPos + "px)";
                    }
                }
            }
            else{
                if(!isSmall){
                    isSmall = true;
                    for(let i = 0; i < boxes.length; i++){
                        boxes[i].style.transform = "translateX(" + MobPos + "px)";
                    }
                }
                else{
                    MobPos = Math.round(-400 + (reviewBoxContainer.clientWidth - 400) / 2 - 400 * (mainBoxNum - 1));
                    for(let i = 0; i < boxes.length; i++){
                        boxes[i].style.transform = "translateX(" + MobPos + "px)";
                    }
                }
            }
        })
        observer.observe(reviewBoxContainer);
    }
    setTimeout(() => {
        starSetting();
        reviewBoxSetting();
    }, 1500);

    let reviewMainBoxCount = 0;
    const makeNoImgReviewBox = (prop) => {
        let reviewBox, reviewBoxTop, reviewBoxText, textPre, reviewBoxBot,
            starDiv, starBlock, grade, reviewAddr, reviewName,
            reviewUnder, comBox, coms,
            reviewBoxContainer = document.getElementById("reviewBox");

        reviewMainBoxCount++;
        reviewBox = reviewMainBoxCount == 2 ? createEle("div", "reviewBox main") : createEle("div", "reviewBox sub");
        reviewBoxTop = createEle("div", "top");
        reviewBoxText = createEle("div", "text");
        reviewBoxBot = createEle("div", "bot");
        starDiv = createEle("div", "star");
        starBlock = createEle("div", "block");
        grade = createEle("span", "grade");
        textPre = createEle("pre");
        reviewAddr = createEle("span", "address");
        reviewName = createEle("span");
        reviewUnder = createEle("div", "under");
        comBox = createEle("div", "comBox");
        coms = createEle("span");

        let compArr = prop.remodeling_apply.companies.map((value) => {
            return value.name;
        }), compStr = compArr.join(", "),
            customerAddrArr = prop.remodeling_apply.address.split(' '),
            customerAddrStr = customerAddrArr[0] + " " + (customerAddrArr[1] ?? "");

        grade.innerHTML = prop.point;
        const str = prop.content.replaceAll('\\n', '<br/>');
        textPre.innerHTML = str;
        reviewAddr.innerHTML = customerAddrStr;
        reviewName.innerHTML = "&nbsp " + prop.remodeling_apply.name[0] + "** 님";
        comBox.innerHTML = "견적업체";
        coms.innerHTML = compStr;

        reviewBoxContainer.appendChild(reviewBox);
        reviewBox.appendChild(reviewBoxTop);
        reviewBox.appendChild(reviewBoxText);
        reviewBox.appendChild(reviewBoxBot);
        reviewBoxTop.appendChild(starDiv);
        starDiv.appendChild(starBlock);
        for(let i = 0; i < 5; i++){
            let starImg = createEle("img");
            starImg.src = "https://somoonhouse.com/otherimg/assets/star2.png?raw=true";
            starDiv.appendChild(starImg);
        }
        reviewBoxTop.appendChild(grade);
        reviewBoxText.appendChild(textPre);
        reviewBoxBot.appendChild(reviewAddr);
        reviewBoxBot.appendChild(reviewUnder);
        reviewAddr.appendChild(reviewName);
        reviewUnder.appendChild(comBox);
        reviewUnder.appendChild(coms);
    }

    const makeHomepageCompanyInfoBox = (prop) => {
        let partnerContainer = document.getElementById("partner_info_lower"),
            partnerInfoContainer, partnerInfoBox,
            boxUpper, boxLower, upperFirstImgBox, upperFirstImg,
            upperSecondImgBox, upperSecondImg, lowerTextFir, lowerTextThr,
            firTitle, thrTitleSub;
        let firBox = [], firSub = [];
        const war = prop.as_warranty,
            badge = prop.SPECIALIZEDs,
            counseling = prop.counseling,
            construction = prop.construction,
            img1 = prop.represent_img1,
            img2 = prop.represent_img2,
            comName = prop.name;

        partnerInfoContainer = createEle("a", "partner_info_container");
        partnerInfoBox = createEle("div", "box");
        boxUpper = createEle("div", "box_upper");
        boxLower = createEle("div", "box_lower");
        if(img1 !== 'https://somoonhouse.com/sources/noprofile1.png'){
            upperFirstImgBox = createEle("div", "imgBox");
            upperFirstImg = createEle("img", "yes");
            upperSecondImgBox = createEle("div", "imgBox secondImg");
            upperSecondImg = createEle("img", "yes");
        }
        else{
            upperFirstImgBox = createEle("div", "imgBox");
            upperFirstImg = createEle("img", "non");
            upperSecondImgBox = createEle("div", "imgBox secondImg");
            upperSecondImg = createEle("img", "non");
        }
        lowerTextFir = createEle("div", "txt fir", prop.id);
        lowerTextThr = createEle("div", "txt thr");
        firTitle = createEle("span", "fir_title");
        thrTitleSub = createEle("span", "title_sub");

        let count = 0;
        if(war != null){
            firBox[count] = createEle("div", "fir_box");
            firSub[count] = createEle("span", "fir_sub");
            firSub[count].innerHTML = "A/S " + war + "년";
            count++;
            console.log(count)
        }

        partnerInfoContainer.href = "https://somoonhouse.com/interior_info.jsp?id=" + prop.id;
        console.log("https://somoonhouse.com/interior_info.jsp?id=" + prop.id);
        firTitle.innerHTML = comName;
        thrTitleSub.innerHTML = "상담 " + counseling + "건";
        upperFirstImg.src = img1;
        upperSecondImg.src = img2;

        partnerContainer.appendChild(partnerInfoContainer);
        partnerInfoContainer.appendChild(partnerInfoBox);
        partnerInfoBox.appendChild(boxUpper);
        partnerInfoBox.appendChild(boxLower);
        boxUpper.appendChild(upperFirstImgBox);
        boxUpper.appendChild(upperSecondImgBox);
        upperFirstImgBox.appendChild(upperFirstImg);
        upperSecondImgBox.appendChild(upperSecondImg);
        boxLower.appendChild(lowerTextFir);
        boxLower.appendChild(lowerTextThr);
        lowerTextFir.appendChild(firTitle);
        lowerTextThr.appendChild(thrTitleSub);
        if(count !== 0){
            for(let i = 0; i < count; i++){
                lowerTextFir.appendChild(firBox[i]);
                firBox[i].appendChild(firSub[i]);
            }
        }
    }

    const addBadgeHompageCompanyInfoBox = (prop) => {
        let badgeBox = document.getElementById(prop.id);
        let firBox = [], firSub = [];

        if(badge[0].Ability_num != null){
            for(let i = 0; i < badge.length; i++){
                console.log(badge)
                if(count>=3)break;
                firBox[count] = createEle("div", "fir_box");
                firSub[count] = createEle("span", "fir_sub");
                firSub[count].innerHTML = badge[i].COMPANY_ABILITy.Title;
                count++;
                console.log(count)
                console.log(badge[i].COMPANY_ABILITy.Title)
            }
        }
    }

    let companyData;
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
            companyData = res;
            makeHomepageCompanyInfo();
            // if(history.state !== null){
            //     for(let i = 0; i < history.state.moreBtnClick; i++){
            //         infoBtn.click();
            //     }
            // }
        })
        .catch((err) => {
            console.log(err);
        })
    }

    let companyCount = 0;
    const makeHomepageCompanyInfo = () => {
        for(let i = companyCount; i < companyCount + 8; i++){
            makeHomepageCompanyInfoBox(companyData[i]);
        }
        companyCount += 8;
    }
    getCompanyData();

    // const url = "http://192.168.0.27:8091/somoonhouse_war_exploded/homepage.jsp";
    // const title = '';
    // const state = {'moreBtnClick' : 0};
    // history.pushState(state, title, url);
    //
    // let moreBtnClick = 0;
    // var checkPageShow = false;
    // window.onpageshow = (event) => {
    //     checkPageShow = true;
    //     if(event.persisted || (window.performance && window.performane.navigation.type == 2)){
    //         alert("hi");
    //         if(history.state !== null && history.state.moreBtnClick !== moreBtnClick){
    //             for(let i = 0; i < history.state.moreBtnClick; i++) moreInfo.click();
    //         }
    //     }
    // }
    // window.onpagehide = (event) => {
    //     if((window.performance.navigation.type == 0 || window.performance.navigation.type == 2) && checkPageShow){
    //         alert("bye");
    //     }
    //
    // }

    const makeMoreHomepageCompanyInfo = () => {
        for(let i = companyCount; i < companyCount + 4; i++){
            if(companyData[i] === undefined){
                infoBtn.style.display = "none";
                break;
            }
            makeHomepageCompanyInfoBox(companyData[i]);
        }
        // history.state.moreBtnClick++;
        // moreBtnClick++;
        companyCount += 4;
    }

    const infoBtn = document.getElementById("moreInfo");
    infoBtn.onclick = makeMoreHomepageCompanyInfo;

    if (window.navigator.userAgent.match(/MSIE|Internet Explorer|Trident/i)) {
        alert("Edge 또는 Chrome을 사용해주시기 바랍니다.");
        window.location = "microsoft-edge:" + window.location.href;
    }
    let partner_info_container = document.getElementsByClassName("partner_info_container"),
        partner_info_lower = document.getElementById("partner_info_lower"),
        isForMobile = window.innerWidth > 700 ? false : true;
    window.addEventListener('resize', (event) => {
        isForMobile = event.currentTarget.innerWidth > 700 ? false : true;
    })
    window.onscroll = () => {
        if(!isForMobile && (partner_info_container.length & 1)){
            let div = document.createElement("div");
            div.className = "partner_info_container";
            partner_info_lower.appendChild(div);
        }
    }
</script>
</body>
</html>