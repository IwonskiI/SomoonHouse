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
    String id = request.getParameter("orderId");
    String pay = request.getParameter("paymentKey");
    String amount = request.getParameter("amount");
    String coupon_id = "";
    String stock = "";

    if(Objects.equals(amount, "99000")) coupon_id = "2";
    else if (Objects.equals(amount, "1300000")) coupon_id = "3";
    else if (Objects.equals(amount, "2600000")) coupon_id = "4";
%>
<script>
    console.log("<%=coupon_id%>")
</script>
<%

    //필요한 변수 선언
    int i, j;
    String mylog = "";

    //DB 관련 객체 선언
    Connection conn = DBUtil.getMySQLConnection();
    ResultSet rs = null;
    PreparedStatement pstmt = null;
    String query = "";
    String sql = "";

    //쿠폰발급하기
    query = "select * from COUPON where Id = ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setString(1, coupon_id);
    rs = pstmt.executeQuery();
    while(rs.next()){
        stock = rs.getString("Quantity");
    }

    sql = "insert into ISSUED_COUPON values(?, ?, ?, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), default)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(s_id));
    pstmt.setInt(2, Integer.parseInt(coupon_id));
    pstmt.setString(3, stock);
    pstmt.executeUpdate();

    pstmt.close();
    rs.close();

%>
<!DOCTYPE html>
<html>
<head>
    <link rel="SHORTCUT ICON" href="https://somoonhouse.com/img/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
    <meta property="og:type" content="website">
    <meta property="og:title" content="소문난집">
    <meta property="og:description" content="믿을 수 있는 대구 리모델링 업체, 견적 플랫폼 소문난집">
    <meta property="og:image" content="https://www.somoonhouse.com/otherimg/assets/thumnail.png">
    <meta property="og:url" content="https://www.somoonhouse.com/">
    <meta name="description" content="믿을 수 있는 대구 리모델링 업체, 견적 플랫폼 소문난집">
    <title>소문난집 - 결제 진행중</title>
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
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
<script>

    const paymentAPIcall = async () => {
        await fetch("https://api.tosspayments.com/v1/payments/confirm", {
            method: "POST",
            headers: {
                "Authorization" : "Basic bGl2ZV9za19vZXFSR2dZTzFyNTBMWm02d01iVlFuTjJFeWF6Og==",
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                orderId: "<%=id%>",
                paymentKey: "<%=pay%>",
                amount: "<%=amount%>",
            }),
        })
            .then((res) => {
                return res.json();
            })
            .then((res) => {
                alert("결제가 완료되었습니다!")
                location.href = "newTestPartnerNew.jsp"
            })
            .catch((err) => {
                console.log(err);
            })
    }

    paymentAPIcall();

</script>
</body>
</html>