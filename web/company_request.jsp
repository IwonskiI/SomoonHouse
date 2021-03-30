<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<!Doctype html>
<html>
<head>
<style>
@import url(https://fonts.googleapis.com/earlyaccess/nanumgothic.css?display=swap);
@font-face{
font-family:'Nanum Gothic',sans-serif;
}
*{
font-family:'Nanum Gothic',sans-serif;
}
body{
text-align:center;
}
#container{
	padding: 10% 0;
	box-sizing: border-box;
	max-width: 1000px;
	display: inline-block;
}
img{
width:30%;
display: inline-block;
}
#container div{
display: inline-block;
font-size: 15pt;
}
span{
color: #4970ff;
}
@media (max-width : 768px){
img{
width:40%;
}
#container div{
font-size: 11pt;
}
}
@media (max-width : 300px){
img{
width:70%;
}
#container div{
font-size: 11pt;
}
}
</style>
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <meta charset="UTF-8">
	<title>소문난집 서버 점검 중입니다.</title>
</head>
<body>
	<div id="container">
	<img src="otherimg/checking/checking.png">
	<div>
	<h2><span>소문난집</span> 서버 점검중 입니다.</h2>
	<p>서버 점검 일시 : 2021년 3월 29일 12:00 ~ 2021년 3월 30일 18:00</p>
	<p>불편을 드려 죄송합니다.</p>
	</div>
	</div>
</body>
</html>