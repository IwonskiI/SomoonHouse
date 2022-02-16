<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<%
/*현재 페이지 저장
String now = "_remodeling_form.jsp";
*/

	//변수 설정
	String[] state = {"회사수락대기","회사거절","상담대기","고객부재중","상담중","미팅 예정","계약진행중","(계약완료)X","계약완료","중단(고객 부재중)","중단", "상담취소"};
	String[] building_types = {"아파트", "빌라", "주택", "원룸"};

//DB에 사용 할 객체들 정의
Connection conn = DBUtil.getMySQLConnection();
PreparedStatement pstmt = null;
Statement stmt = null;
String query = "";
String sql = "";
ResultSet rs = null;

//세션 생성 create session
session.setAttribute("page", "company_request.jsp"); // 현재 페이지 current page
//세션 가져오기 get session
String now = session.getAttribute("page")+""; // 현재 페이지 current page
String s_id = session.getAttribute("s_id")+"";// 현재 사용자 current user
String name = session.getAttribute("name")+"";
String apply_num = s_id.replaceAll("cu", "");

//업체별 신청내용 받아오기. 세션이 있을 경우. 세션이 없는경우는 현재 테스트를 위해 다 보이도록 해두었지만
////////**********추후에 세션이 없는 경우에는 접근 못하도록 수정 해야함 ***********/////////
query = "select * from ASSIGNED";
//out.println("로그인된 아이디는 " + s_id);
if(!s_id.equals("null") && !s_id.equals("NULL") && !s_id.equals("Null") && s_id != null && !s_id.equals("")){
	query += " where Apply_num = " + apply_num;
}
else{
	query += " where Apply_num = -1";
}
pstmt = conn.prepareStatement(query);
rs = pstmt.executeQuery();

ArrayList<HashMap<String, String>> companylist = new ArrayList<HashMap<String, String>>();

while(rs.next()){

	HashMap<String, String> companymap = new HashMap<String, String>();
	String company_num = rs.getString("Company_num");
	String state_eng = rs.getString("State");

	//회사 이름 가져오기
	query = "select * from COMPANY where Id = ?";
	pstmt = conn.prepareStatement(query);
	pstmt.setString(1, company_num);
	ResultSet rs1 = pstmt.executeQuery();
	
	String company_name = "";
	String company_address = "";
	String company_phone = "";
	String company_as_provide = "";
	String company_as_warranty = "";
	while(rs1.next()){
		company_name = rs1.getString("Name");
		company_address = rs1.getString("Address");
		company_phone = rs1.getString("Phone");
		company_as_provide = rs1.getString("As_provide");
		company_as_warranty = rs1.getString("As_warranty");
	}
	

	companymap.put("name", company_name);
	companymap.put("as_provide", company_as_provide);
	companymap.put("as_warranty", company_as_warranty);
	companymap.put("address", company_address);
	companymap.put("phone", company_phone);
	companymap.put("state", state_eng);
	companymap.put("id", company_num);
	companylist.add(companymap);
}


//신청정보 가져오기
HashMap applymap = new HashMap<String, String>();

query = "select * from REMODELING_APPLY where Number = ?";
pstmt = conn.prepareStatement(query);
pstmt.setString(1, apply_num);
rs = pstmt.executeQuery();
while(rs.next()){
	String item_number = rs.getString("Number");
	String item_itemnum = rs.getString("Item_num");
	String item_name = rs.getString("Name");
	String item_phone = rs.getString("Phone");
	String item_address = rs.getString("Address");
	String item_building = rs.getString("Building_type")+"";
	String item_area = rs.getString("Area");
	String item_due = rs.getString("Due");
	String item_budget = rs.getString("Budget");
	String item_applydate = rs.getString("Apply_date");
	String item_calling = rs.getString("Calling");
	//String item_state = rs.getString("State");

	//빌딩타입 한글로 변경
	if(item_building != null && !item_building.equals("null")){
		item_building = building_types[Integer.parseInt(item_building)];
	}
	else {
		item_building = "정보없음";
	}

	applymap.put("number", item_number);
	applymap.put("itemnum", item_itemnum);
	applymap.put("name", item_name);
	applymap.put("phone", item_phone);
	applymap.put("address", item_address);
	applymap.put("building", item_building);
	applymap.put("area", item_area);
	applymap.put("due", item_due);
	applymap.put("budget", item_budget);
	applymap.put("applydate", item_applydate);
	applymap.put("calling", item_calling);
	//applymap.put("state", item_state);
	}

if(s_id.equals("null") || s_id.equals("NULL") || s_id.equals("Null") || s_id == null || s_id.equals("")){
	applymap.put("consulting", -1);
	applymap.put("compare", -1);
}
%>

<!DOCTYPE html>
<html>
<head>
<link rel="SHORTCUT ICON" href="img/favicon.ico" />
<link rel="stylesheet" type="text/css" href="https://pm.pstatic.net/css/webfont_v170623.css"/>
<link rel="stylesheet" type="text/css" href="slick-1.8.1/slick/slick.css"/>
<link rel="stylesheet" type="text/css" href="slick-1.8.1/slick/slick-theme.css"/>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<style type="text/css">
@import url(https://fonts.googleapis.com/earlyaccess/nanumgothic.css);
@font-face{
font-family:'Nanum Gothic',sans-serif;
}
*{
font-family:'Nanum Gothic',sans-serif;
font-size: 11pt;
color: #313131;
-webkit-appearance: none;
-moz-applearance: none;
-webkit-border-radius: 0;
}
input[type="checkbox"] {
    display:none;
}
input[type="checkbox"] + label span {
    display: inline-block;
    width: 24px;
    height: 24px;
    margin: -2px 10px 0 0;
    vertical-align: middle;
    background: url(https://somoonhouse.com/img/checkbox.svg) left top no-repeat;
    cursor: pointer;
    background-size: cover;
}
input[type="checkbox"]:checked + label span {
    background:url(https://somoonhouse.com/img/checkbox.svg)  -26px top no-repeat;
     background-size: cover;
}
#container {
    width: 100%;
    max-width: 700px;
    margin: 0 auto;
    box-shadow: 0px 0px 20px #f4f4f4;
}
#somun_navbar {
    /*border-bottom: 1px solid #c8c8c8;*/
    display: inline-block;
    height: fit-content;
    width: 100%;
    padding: 39px 0 11px;
}
#divider{
	width:100%;
	height:20px;
	border-top: 1px solid black;
	border-radius: 5px;
}
#content{
    margin: 60px auto;
    max-width: 600px;
}
.item {
    width: 43%;
    display: inline-block;
    margin: 1%;
    border-radius: 5px;
    padding: 2%;
    background: #fbfbfb;
    box-shadow: 0px 0px 6px #e2e2e2;
}
.item .no{
	color: #909090;
    font-size: 10pt;
}
.item_wrapper{
	padding:20px;
}
.item_wrapper div.info{
	margin-bottom: 15px;
    padding-bottom: 4px;
    border-bottom: 3px dotted #e5e5e5;
    width: 100%;
}
.item_wrapper span{
	display: block;
	font-size:9pt;
	margin-bottom: 5px;
	color:gray;
}
.state div{
	display: inline-block;
    padding: 0 0 2px 0;
}
.company{
	padding: 10px;
    background: white;
    border-radius: 8px;
    box-shadow: 0px 0px 6px 1px #00000012;
    margin: 14px 0;
}
.company div, .state div{
	line-height:1.4em;
}
#addr, #phone{
	font-size: 10px;
}
.stt{
	color: white;
	font-size: 9pt;
    border-radius: 5px;
    padding: 1px 4px;
    width: fit-content;
	background: #476aba;
}
.submit_btn{
	text-align:center;
	padding:10px;
	
}
.submit_btn input{
	width: 100%;
    border: none;
    border-radius: 5px;
    height: 32px;
    background: #eaeaea;
}
select{
    width: 100%;
    height: 39px;
    padding: 7px;
    border-radius: 10px;
}
.selectbox{
	position:relative;
}
.selectbox:before {
    content: "";
    position: absolute;
    top: 50%;
    right: 15px;
    width: 0;
    height: 0;
    margin-top: -1px;
    border-left: 5px solid transparent;
    border-right: 5px solid transparent;
    border-top: 5px solid #333;
}
.stardiv{
	display:none;
}
.star{
	appearance: none;
	margin:0;
}
.star + label{
    background: url(img/noStar.png);
    display: inline-block;
    width: 20px;
    height: 20px;
    background-size: 20px 20px;
    position: relative;
}
.star + label span{
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	color: white;
	position: absolute;
}
#request_cancel{
	width: 100%;
    background: #aeaeae;
    border-radius: 10px;
    height: 39px;
    color: white;
    text-align: center;
    line-height: 39px;
}
#as{
    font-size: 9pt;
    color: #ffffff;
    background: #466eff;
    border-radius: 3px;
    padding: 1px 4px;
    box-shadow: 0px 0px 5px 3px #cce8ff;
    font-weight: bold;
}
@media (max-width : 530px){
/*반응형*/
	.item {
    	width: 90%;
    	min-width:300px;
	}
}
</style>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<title>소문난집 - 내 신청 정보</title>
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
<div id="container">
	<jsp:include page="/homepage_pc_header.jsp" flush="false" />
	<jsp:include page="/homepage_mob_header.jsp" flush="false" />
<div></div>
<div id="content">
    <div style="width:100%;display:inline-block;border-radius:5px;">
<%
%>
	<!------------ 내용물  --------------->
	<div>
	<%
	//Arraylist- itemlist에 있는 개수만큼 반복하기
	//for(HashMap<String, String> hm : applylist){
	%>
    	<div class="item">
    	<div class="no">no.<%out.println(applymap.get("number"));%></div>
    		<div class="item_wrapper">
    			<div class="info"><span>이름</span> <%out.println(applymap.get("name"));%></div>
    			<div class="info"><span>전화번호</span> <%out.println(applymap.get("phone"));%></div>
    			<div class="info"><span>주소</span> <%out.println(applymap.get("address"));%></div>
				<div class="info"><span>건물종류</span> <%out.println(applymap.get("building"));%></div>
    			<div class="info"><span>평수</span> <%out.println(applymap.get("area"));%></div>
    			<div class="info"><span>예정일</span> <%out.println(applymap.get("due"));%></div>
    			<div class="info"><span>예산</span> <%out.println(applymap.get("budget"));%></div>
    			<div class="info"><span>신청날짜</span> <%out.println(applymap.get("applydate"));%></div>
    			<div class="info"><span>처리상태</span>
    				<%
    				for(HashMap<String, String> hm : companylist){
    					if(hm.get("state").equals("0") || hm.get("state").equals("1"))
    						continue;
    				%>
    				<div class="company" id="<%out.print(hm.get("id"));%>" style="cursor: pointer" onclick="location.href='https://somoonhouse.com/interior_info.jsp?id=<%out.print(hm.get("id"));%>'">
    					<div class="state">
    						<div><%out.print(hm.get("name"));%></div>
    						<%if(hm.get("as_provide").equals("1")){
    							%>
    						<div id="as">A/S <%out.print(hm.get("as_warranty"));%></div><%
    						}%>
							<div class="stt"><%=state[Integer.parseInt(hm.get("state"))]%></div>
    					</div>
    					<div id="addr"><%=hm.get("address")%></div>
    					<div id="phone"><%=hm.get("phone")%></div>
    					<div class="stardiv">
    						<input type="radio" class="<%=hm.get("name")%> star" name="<%=hm.get("name")%> star" id="<%=hm.get("name")%> star1" value="1"><label for="<%=hm.get("name")%> star1"><span></span></label>
							<input type="radio" class="<%=hm.get("name")%> star" name="<%=hm.get("name")%> star" id="<%=hm.get("name")%> star2" value="2"><label for="<%=hm.get("name")%> star2"><span></span></label>
							<input type="radio" class="<%=hm.get("name")%> star" name="<%=hm.get("name")%> star" id="<%=hm.get("name")%> star3" value="3"><label for="<%=hm.get("name")%> star3"><span></span></label>
							<input type="radio" class="<%=hm.get("name")%> star" name="<%=hm.get("name")%> star" id="<%=hm.get("name")%> star4" value="4"><label for="<%=hm.get("name")%> star4"><span></span></label>
							<input type="radio" class="<%=hm.get("name")%> star" name="<%=hm.get("name")%> star" id="<%=hm.get("name")%> star5" value="5"><label for="<%=hm.get("name")%> star5"><span></span></label>
    					</div>
    				</div>
    			<%}%>
    			</div>
    			<div id="request_cancel">상담취소하기</div>
				<!-- div class="info">
					<span>상담 전체 평가하기</span>
					<textarea></textarea>
				</div-->
    			<%// 처리상태 - 상담대기, 상담중, 상담완료, 통화 불가, 계약 대기중, 계약 성사, 계약 불발 %>

   		 	</div>
    	</div>
	</div>
	<a href="_logout.jsp">로그아웃</a>
	<!------------ 내용물  --------------->
	</div>
	</div>
<%
//DB개체 정리
/*
pstmt.close();
rs.close();
query="";
conn.close();
*/
%>
<script>
//별점주기
$('.star').click(function(){
	var starClass = $(this).attr('class');
	var num = $(this).attr('value');
	var numnum = parseInt(num);
	var i;
	for(i=1; i<=numnum; i++){
		var mystar = $('label[for="'+starClass+i+'"]');
		mystar.css('background', 'url("img/onStar.png")');
		mystar.css('background-size', '20px 20px');
	}
	for(i=numnum+1; i<=5; i++){
		var mystar = $('label[for="'+starClass+i+'"]');
		mystar.css('background', 'url("img/noStar.png")');
		mystar.css('background-size', '20px 20px');
	}
})
</script>
<script>
$('#request_cancel').click(function(){
	location.href="_customer_request_state.jsp?apply_num="+"<%=applymap.get("number")%>";
})
$('.company').click(function(){
	//location.href="company_home.jsp?company_id="+$(this).attr('id');
})

window.onload = function(){
	if("<%=s_id%>" == "" || "<%=s_id%>" == "null"){
		alert("유효하지 않은 접근입니다!");
		history.back();
	}
}
</script>
</div>
</body>
</html>