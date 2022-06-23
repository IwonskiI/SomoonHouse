<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<%
  //캐시 설정 - 이미지 캐시 폐기 기간을 늘려서 반응속도를 올림
  response.setHeader("Cache-Control", "no-cache");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 31536000);
%>
<!DOCTYPE html>
<html>
<head>
  <link rel="SHORTCUT ICON" href="https://somoonhouse.com/img/favicon.ico" />
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/newindex.css"/>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/landing.css"/>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
  <title>소문난집 - 랜딩페이지</title>
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
<div class="img_contains">
  <div class="img_contain" id="land_img6-1" onclick="location.href='remodeling_form.jsp?item_num=0'">
    <img src="https://somoonhouse.com/otherimg/랜딩페이지A버튼1-모바일.jpg">
  </div>
<%--  <div class="img_contain" id="land_img7-1" onclick="location.href='homepage.jsp'">--%>
<%--    <img src="https://somoonhouse.com/otherimg/랜딩페이지A버튼2-모바일.jpg">--%>
<%--  </div>--%>
  <div class="img_contain" id="land_img1">
    <img src="https://somoonhouse.com/otherimg/랜딩페이지A-모바일1.jpg">
  </div>
  <div class="img_contain" id="land_img2">
    <img src="https://somoonhouse.com/otherimg/랜딩페이지A-모바일2.jpg">
  </div>
  <div class="img_contain" id="land_img3">
    <img src="https://somoonhouse.com/otherimg/랜딩페이지A-모바일3.jpg">
  </div>
  <div class="img_contain" id="land_img6" onclick="location.href='remodeling_form.jsp?item_num=0'">
    <img src="https://somoonhouse.com/otherimg/랜딩페이지A버튼1-모바일.jpg">
  </div>
<%--  <div class="img_contain" id="land_img7" onclick="location.href='homepage.jsp'">--%>
<%--    <img src="https://somoonhouse.com/otherimg/랜딩페이지A버튼2-모바일.jpg">--%>
<%--  </div>--%>
</div>
<script>
  //새 스크립트 작성
</script>
</body>
</html>