<%@ page import="java.net.URLEncoder" %><!-- Java코드내에서 URL인코드 하는 클래스-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><!-- jsp인코딩 설정 charset:웹 브라우저가 받을때 인코딩방식, pageEncoding 쓰여지고 저장할 때 인코딩 방식-->
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<!-- 자바 클래스 import. java.util.* 이런 자바 할때 배웠던 기본 클래스들 넣어준다. 나중에 필요한 거 있으면 여기다가 넣으면 됨.-->
<%@ page language="java" import="myPackage.*" %>
<!-- myPackage 폴더 내의 클래스 사용. 직접 만든 클래스들 사용할 때 여기에 넣으면 된다. 현재는 DBUtil 클래스 사용중(데이터베이스 연결 클래스)-->
<% request.setCharacterEncoding("UTF-8"); %>
<!-- form 데이터 받아올 시 인코딩 방식 -->
<% response.setContentType("text/html; charset=utf-8"); %>
<!-- form 데이터 보낼 시 인코딩 방식 -->
<%
//DB에 사용 할 객체들 정의
Connection conn = DBUtil.getMySQLConnection(); //DB와 연결하는 객체를 만들어준다.
PreparedStatement pstmt = null; //?(물음표)를 채울 수 있는 쿼리, sql을 담는 객체. 아래에 사용례를 보면 이해가능
Statement stmt = null; //쿼리, sql을 담는 객체.
String query = ""; //보통 쿼리는 select문 이고
String sql = ""; //sql은 update, delete 할 때 사용한다.
ResultSet rs = null; //쿼리를 돌린 결과를 담을 수 있는 객체

//세션 생성 create session 세션 페이지 정보가 필요할 시 이용.
session.setAttribute("page", "lisence_check.jsp"); // 현재 페이지 current page
//세션 가져오기 get session. 보통 나는 page, s_id, name 이렇게 세가지 섹션을 이용하는데
//page는 현재 or 넘어온 페이지등을 확인하고 s_id는 로그인된 사용자의 id정보,
//name은 로그인된 사용자의 이름정보를 담아둔다.
String now = session.getAttribute("page")+""; // 현재 페이지 current page
String s_id = session.getAttribute("s_id")+"";// 현재 사용자 current user
String name = session.getAttribute("name")+"";

//쿼리문 작성. Id가 5번 이하인 회사 정보를 알고 싶을 때
query = "SELECT * FROM COMPANY WHERE Id <= ?"; //쿼리작성
query += "order by Name asc"; //이름 오름차순으로 결과 출력
pstmt = conn.prepareStatement(query); //pstmt 객체에 쿼리문을 담아준다.
pstmt.setString(1, "5"); //첫번째 물음표에 "4"라는 글자를 넣는다는 의미이다.
						//pstmt에 담긴 문장 - "SELECT * FROM COMPANY WHERE Id <= 4"
rs = pstmt.executeQuery(); //쿼리를 실행하고, 그 정보가 rs 객체에 담긴다.

//해당 정보들을 담아올 객체를 만든다. 객체를 만들땐 <%!로 시작하는 태그를 사용.%>
<%! public class Company{
	String id;
	String name;
	String address;
	String state;
	String modify_date;
	
	public Company(String id, String name, String address, String state, String modify_date){
		this.id = id;
		this.name = name;
		this.address = address;
		this.state = state;
		this.modify_date = modify_date;
	}
	//getter, setter 설정
	public String getId(){
		return id;
	}
	public String getName(){
		return name;
	}
	public String getAddress(){
		return address;
	}
	public String getState(){
		return state;
	}
	public String getModifyDate(){
		return modify_date;
	}
	public void setName(String name){
		this.name = name;
	}
	public void setId(String id){
		this.id = id;
	}
	public void setAddress(String address){
		this.address = address;
	}
	public void setState(String state){
		this.state = state;
	}
	public void setModifyDate(String modify_date){
		this.modify_date = modify_date;
	}
}
%>
<%
//방금 만든 Company객체의 ArrayList를 만든다.
//배열으로 만들어도 괜찮지만 ArrayList를 사용하면 동적으로 계속 추가 가능.
//순서가 보장되는 LinkedList를 사용해보겠음
LinkedList<Company> company_list = new LinkedList<Company>();
while(rs.next()){
	String c_id = rs.getString("Id");
	String c_name = rs.getString("Name"); //rs로부터 정보를 받아오려면 rs.getString("받아올 컬럼"); 이렇게 사용한다.
	String address = rs.getString("Address");
	String state = rs.getString("State"); //입점 동의 여부  0:비동의 1:동의
	String modify_date = rs.getString("Modify_date"); //마지막으로 로그인 한 날짜
	
	if(state != null && state.equals("1"))
		state = "동의";
	else
		state = "비동의";
	
	if(modify_date == null)
		modify_date = "로그인 기록 없음";
	
	Company company = new Company(c_id, c_name, address, state, modify_date); //결과들을 객체에 담고
	
	company_list.add(company);//객체를 리스트에 담는다.
}
//이제 리스트에 내가 받아오고 싶은 회사 정보를 담았고, 웹 페이지에 뿌려주면 된다.
%>

<!DOCTYPE html>
<html>
<head>
<link rel="SHORTCUT ICON" href="img/favicon.ico" /><!-- 브라우저 탭에 나타나는 아이콘. 우리 아이콘은 파란색 네모안에 소문이라고 적혀있다. -->
<link rel="stylesheet" type="text/css" href="https://pm.pstatic.net/css/webfont_v170623.css"/><!-- 나눔고딕 폰트 -->
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script><!-- jQuery 가져오는 스크립트. javascript를 편하게 쓰기위한 라이브러리 -->
<link rel="stylesheet" type="text/css" href="css/test.css"><!-- 외부 스타일시트 -->
<style type="text/css">
/*내부 스타일 작성하면 됨*/
</style>
<meta charset="UTF-8"><!-- html 인코딩 방식 -->
<!-- 밑에 meta는 휴대폰에서 화면 비율 맞춰주기 위한 태그 -->
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<title>소문난집</title><!-- 브라우저 탭에서 보이는 제목 -->
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
	<div id="container">
		<h2>🏢<br>회사 정보</h2>
		<%for(Company company : company_list){ //company_list안의 Company객체들을 for문을 통해 순서대로 돈다.
			%>
			<div class="company-info" id="com<%=company.getId()%>">
				<div class="company-name"><%=company.getName()%></div>
				<div class="company-address"><%=company.getAddress()%></div>
				<div class="company-modify-date"><%=company.getModifyDate()%></div>
				<div class="company-state" id="<%=company.getState()%>">정보제공<%=company.getState()%></div>
			</div>
			<%
		}
		%>
	</div>
<%
//DB개체 정리
pstmt.close();
rs.close();
query="";
conn.close();
%>
<script>
	//누르면 해당 회사 페이지로 가도록 만들어 보자.
	//회사 페이지 링크는 https://somoonhouse.com/company_home.jsp?company_id=회사번호
	$(".company-info").click(function(){ //company-info 클래스가 클릭 되었을 때,
		var div_id = $(this).attr('id'); //현재 클릭된 객체의 아이디를 받아온다.
		var company_id = div_id.replace("com", ""); //아이디 형식이 com1, com2 .. 이렇게 되어있으므로
													//com을 없앤 숫자만 추출한다.
		location.href = "https://somoonhouse.com/company_home.jsp?company_id="+company_id;
	})
</script>
</body>
</html>