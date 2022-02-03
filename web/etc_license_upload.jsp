<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.Calendar,java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest,com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page language="java" import="myPackage.DBUtil" %>
<%@ page language="java" import="myPackage.Link" %>
<%@ page language="java" import="myPackage.GetImage" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="css/etc_license_upload.css">
    <title>기타 자격증 등록</title>
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
    <!-- 사용자 행동 정보 수집 코드 끝 - Meta, GA -->
</head>
<body>
<div class="upload-popup-header">
    <h3>기타 자격증 제출</h3>
    <div class="upload-popup-header-desc">
        <span>기타 자격증 파일을 제출해주세요.</span>
        <span class="text-red">이미지(JPEG, PNG) 외의 파일 선택 시 반려될 수 있습니다.</span>
    </div>
</div>
<form name="form" id="form" method="post" enctype="multipart/form-data" action="_etc_license_upload.jsp">
    <div id="etc-license-upload-form" class="etc-license-upload-form" style="margin-top:20px">
        <div style="margin-bottom: 10px;">
            <span class="upload-form-left">자격증 종류</span>
            <select id="type" name="type" class="type">
                <option value="">자격증 종류</option>
                <option value="1">실내건축기능사</option>
                <option value="2">실내건축산업기사</option>
                <option value="3">실내건축기사</option>
                <option value="4">전산응용건축제도기능사</option>
                <option value="0">기타</option>
            </select>
            <input id="type-etc" name="type-etc" class="type-etc" style="display:none; width: 200px;" type="text" placeholder="자격증 이름(종류)을 입력하세요.">
        </div>
        <div style="margin-bottom: 10px;">
            <span class="upload-form-left">자격증 취득 날짜</span>
            <input class="date" name="date" type="date">
        </div>
        <div style="margin-bottom: 30px;">
            <span class="upload-form-left">기타 자격증 파일</span>
            <input class="file" name="file" type="file">
        </div>
    </div>
<%--    <div>--%>
<%--        <input type="button" id="add-license" value="+">--%>
<%--    </div>--%>
    <div>
        <input type="submit" class="submitBtn" value="제출하기">
    </div>
</form>
</body>
</html>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // $("#add-license").click(function() {
    //     // unique 한 Id 생성
    //     let uniqueId = Math.round(new Date().getTime() + (Math.random() * 100));
    //     // append upload-form
    //     $(this).before("<div class=\"etc-license-upload-form\" style=\"margin-top:20px\"><div><span>type</span><select id="+"type-"+uniqueId+" name=\"type\"><option value=\"\">자격증 종류</option><option value=\"1\">실내건축기능사</option><option value=\"2\">실내건축산업기사</option><option value=\"3\">실내건축기사</option><option value=\"4\">전산응용건축제도기능사</option><option value=\"0\">기타</option></select><input class=\"type-etc\" id="+"type-etc-"+uniqueId+" name=\"type-etc\" type=\"text\" style=\"display:none\" placeholder=\"자격증 이름(종류)을 입력하세요.\"></div><div><span>date</span><input class=\"date\" name=\"date\" type=\"date\"></div><div><span>file</span><input class=\"file\" name=\"file\" type=\"file\"></div></div>");
    // })

    $(document).on("change", "select", function() {
        console.log(this.value);
        if(this.value === '0') $(this).siblings("input").css("display", "inline-block");
        else $(this).siblings("input").css("display", "none");
    })
</script>
