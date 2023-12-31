<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<% session.setAttribute("page", "_hit1.jsp"); %>
<% session.setAttribute("prepage", request.getHeader("referer")); %>
<%
	int num = Integer.parseInt(request.getParameter("num"));
	Connection conn = DBUtil.getMySQLConnection();
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	String query = "";

	query = "update REMODELING set Hit = Hit + 1 where Number = ?";
	pstmt = conn.prepareStatement(query);
	pstmt.setInt(1, num);
	pstmt.executeUpdate();

	query = "select * from REMODELING where Number = ?";
	pstmt = conn.prepareStatement(query);
	pstmt.setInt(1, num);
	rs = pstmt.executeQuery();
	String URL = "";

	while(rs.next()){
		URL = rs.getString("URL");
	}
	String url = URL.replace("blog.naver.com", "m.blog.naver.com");
%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
	<title></title>
	<style>
		html{
			height:100%;
		}
		body{
			margin: 0;
			height: 100%;
		}
		.container{
			background: white;
			width: 100%;
			max-width:600px;
			position: relative;
			height: 100%;
			left: 0;
			bottom: 0;
			margin: auto auto;
			box-shadow: 1px -1px 13px 0px #0000002e;
			overflow: scroll;
		}
		#navbar{
			height:49px;
			width: 100%;
			max-width:600px;
			position: fixed;
			top: 0;
			z-index: 12;
			background:white;
			border-bottom: 1px solid #f7f7f7;
		}
		#logo{
			font-size: 33pt;
			position: absolute;
			top: -1%;
			color: #626262;
			background-image: url(img/somunlogo.png);
			margin: auto auto;
			position: relative;
			top: 50%;
			transform: translate(0, -50%);
			background-size: 69px 26px;
			height: 26px;
			width: 69px;
			cursor: pointer;
		}
		#x_btn{
			font-size: 33pt;
			position: absolute;
			top: -1%;
			right: 0;
			color: #626262;
			background-image: url(img/XX.png);
			background-size: 41px 43px;
			height: 41px;
			width: 43px;
			top: 50%;
			transform: translate(0, -50%);
			cursor: pointer;
		}
		#frame_frame{
			position: fixed;
			height: 93%;
			width: 100%;
			max-width: 600px;
			left: 0;
			top: 50px;
			z-index:10;
		}
		iframe{
			width: 100%;
			height: 100%;
			position: absolute;
			border: 0;
		}
		.pink{
			position: relative;
			height: 10000px;
			width: 100%;
			background: none; linear-gradient(45deg, #ff00568f, #00ffd094);
			z-index:10;
		}
		#buttonbar{
			width:100%;
			max-width:600px;
			height: 66px;
			background:white;
			z-index: 12;
			position: fixed;
			bottom: 0;
			border-top: 1px solid #f7f7f7;
		}
		span{
			color: #4578f3;
			font-weight: bold;
		}
		#copywrite{
			display: inline-block;
			width: 54%;
			padding: 16px;
			text-align: center;
			height: fit-content;
			position: relative;
			top: 50%;
			transform: translate(0px, -50%);
			font-size: 8pt;
			z-index: 13;
			color: #454545;
		}
		#rem_req_btn{
			width: 145px;
			height: 56px;
			position: absolute;
			right: 5%;
			top: 50%;
			transform: translate(0, -50%);
			background-image: url(img/reqbtn2.png);
			background-size: 145px 56px;
			cursor: pointer;
			display: inline-block;
		}
		@media(min-width:450px){
			#rem_req_btn{
				width: 184px;
				height: 74px;
				background-size: 184px 74px;
			}
			#buttonbar{
				height: 74px;
			}
		}
	</style>
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
<div class="container">
	<div id="navbar">
		<div id="logo"></div>
		<div id="x_btn"></div>
	</div>
	<div id="frame_frame">
		<iframe name="myframe" src="<%=url%>" scrolling="yes" frameborder="0">
		</iframe>
	</div>
	<div class="pink"></div>
	<div id="buttonbar">
		<div id="copywrite"></div>
		<div id="rem_req_btn"></div>
	</div>
</div>
</body>

<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script>
	$('#logo').click(function(){
		location.href="homepage.jsp";
	})
</script>
<script>
	$('#rem_req_btn').click(function(){
		location.href="remodeling_form.jsp?item_num="+"<%=num%>";
	});

	$('#x_btn').click(function(){
		var hreflink = "<%=session.getAttribute("prepage")%>" + "";
		location.href= hreflink;
		//history.back(-1);
	})

	var mouseon = 0;
	var filter = "win16|win32|win64|mac|macintel";
	function checkMobile(){

		var varUA = navigator.userAgent.toLowerCase(); //userAgent 값 얻기

		if ( varUA.indexOf('android') > -1) {
			//안드로이드
			return "android";
		} else if ( varUA.indexOf("iphone") > -1||varUA.indexOf("ipad") > -1||varUA.indexOf("ipod") > -1 ) {
			//IOS
			return "ios";
		} else {
			//아이폰, 안드로이드 외
			return "other";
		}

	}

	function removepink(){
		/*$('.pink').remove();*/
		var pink = $('.pink');
		pink.css('z-index', '9');
	}
	function appendpink(){
		/*var pink = "<div class=\"pink\"></div>"
        $('.container').append(pink);*/
		var pink = $('.pink');
		pink.css('z-index', '11');
	}

	$('iframe').on('mouseover', function(){
		if(filter.indexOf( navigator.platform.toLowerCase() ) < 0){
			appendpink();
		}
	})
	$('body').on('mouseover', function(){
		if(filter.indexOf( navigator.platform.toLowerCase() ) < 0){
			appendpink();
		}
	})
	$('.container').on('scroll', function(){
		if(filter.indexOf( navigator.platform.toLowerCase() ) < 0){
			removepink();
			setTimeout(function() {
				appendpink();
			}, 2000);
		}
	})

	function frame(){
		var framediv = $('#frame_frame');
		var windowWidth = $( window ).width();
		var divWidth = framediv.width();

		framediv.css('left', (windowWidth-divWidth)/2);
	}

	$(document).ready(function(){
		$('.container').scrollTop(100);
		mouseon = 0;
		frame();
		if(filter.indexOf( navigator.platform.toLowerCase() ) >= 0){
			removepink();
		}
	})

	$(window).resize(function(){
		frame();
	});

</script>
</html>
