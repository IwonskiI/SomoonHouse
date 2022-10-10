<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.Calendar,java.util.Date, java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest,com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page language="java" %>
<%@ page language="java" %>
<%@ page language="java" %>
<%@ page import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setCharacterEncoding("UTF-8"); %>
<%@ page language="java" %>
<%@ page import="myPackage.*" %>
<%@ page import="myPackage.MessageSend3" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<%
	/*로그인된 세션 아이디(추후개발) 가져오기, 현재 페이지 저장
	String id = session.getAttribute("s_id")+"";
	String now = "_remodeling_form.jsp";*/
	
	//DB에 사용 할 객체들 정의
	Connection conn = DBUtil.getMySQLConnection();
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	Statement stmt = null;
	String query = "";
	String sql = "";
	String sql2 = "";
	ResultSet rs = null;
	ResultSet rs2 = null;
	%>
	<%
	//처리에 에러정보가 있으면 롤백
	int error = 0;
	
	//신청폼으로 부터 받은 데이터 불러오기, 필요한 정보 정의
	int num = 0;
	String[] company1 = request.getParameterValues("company");
	String apply_num = request.getParameter("apply_num");
	String memo = request.getParameter("memo");
	String state = "0";
	
	//받을 때 숫자형태가 아닌데 숫자로 입력해야하는경우 변환해주기
	//필드를 다 채웠는지의 여부를 확인해본다. 덜 채웠으면 다시 채우라하기
	if(company1 == null || company1.equals("null")){
	%>
		<script>
		alert('사례를 줄 회사를 1개 이상 선택해주세요');
		</script>
	<%
	error++;
	}

	//
	
	//업데이트하기, company마다 하나씩, 해당 회사에 넘겨준 정보가 있으면 Update문 실행 아니면 Insert문 실행
	for(String company : company1){
		query = "select count(*) from ASSIGNED where Apply_num = ? and Company_num = ?";
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, apply_num);
		pstmt.setString(2, company);
		rs = pstmt.executeQuery();
		int assigned_count = 0;
		while(rs.next()){
			assigned_count = rs.getInt("count(*)");
		}
		if(assigned_count > 0){
			sql = "UPDATE ASSIGNED set State = ? Where Apply_num = ? and Company_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, state);
			pstmt.setString(2, apply_num);
			pstmt.setString(3, company);
		}
		else{
			sql = "INSERT INTO ASSIGNED (Apply_num, Company_num, State, Assigned_id, Memo, Aborted_state) VALUES(?, ?, ?, default, default, default)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, apply_num);
			pstmt.setString(2, company);
			pstmt.setString(3, state);
		}
		//확인
			//out.println(pstmt);

		//특이사항 업데이트
		sql2 = "UPDATE REMODELING_APPLY set remark = ? WHERE Number = ?";
		pstmt2 = conn.prepareStatement(sql2);
		pstmt2.setString(1, memo);
		pstmt2.setString(2,apply_num);

		//실행
		if(error == 0){
			pstmt.executeUpdate();
			pstmt2.executeUpdate();
		}
		else{
			%>
			<script>
			history.back();
			</script>
			<%
		}
	}


	/*처리상태
		0. 미배분
		1. 재배분필요 (시간마감, 일부수락)
		2. 배분중
		3. 전체수락
		4. 고객 취소
		5. 관리자삭제
	 */
				//처리상태 업데이트하기
				sql = "Update REMODELING_APPLY set State=2 where Number = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, apply_num);

				//실행
				if(error == 0){
					pstmt.executeUpdate();
			%>
	<script>
		alert('등록을 완료했습니다.');
		location.href = "manage_request.jsp";
	</script>
	<%
	}
	else{
	%>
	<script>
		history.back();
	</script>
	<%
		}

	//배분시간 업데이트하기
		sql = "Update REMODELING_APPLY set Assigned_time = now() where Number = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, apply_num);


		//실행
		if(error == 0){
			pstmt.executeUpdate();
	%>
	<script>
		alert('등록을 완료했습니다.');
		location.href = "manage_request.jsp";
	</script>
	<%
	}
	else{
	%>
	<script>
		history.back();
	</script>
	<%
		}

		//메세지 전송상태 업데이트
		sql = "Update REMODELING_APPLY set msg_send = false where Number = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, apply_num);


		//실행
		if(error == 0){
			pstmt.executeUpdate();
	%>
	<script>
		alert('등록을 완료했습니다.');
		location.href = "manage_request.jsp";
	</script>
	<%
	}
	else{
	%>
	<script>
		history.back();
	</script>
	<%
		}

	//확인
	//out.println(pstmt);

	// send messages 문자보내기
	String company_id = "";
	String company_name = "";
	String company_phone = "";
	String msg_str = "";
	MessageSend3 msg = new MessageSend3();

	for(String com : company1) {
		sql = "SELECT Name, Phone, Id FROM COMPANY WHERE Id = '" + com +"'";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while(rs.next()) {
			company_id = rs.getString("Id");
			company_name = rs.getString("Name");
			company_phone = rs.getString("Phone");
		}
		msg_str = "[소문난집]\n" + company_name + "님, 신규 상담 신청건이 있습니다. 선착순으로 마감되오니, 빠른 시일 내로 확인 부탁드립니다.\n\nhttps://somoonhouse.com/newTestLogin.jsp?company_num="+company_id;


		// 업체에게 문자 보내기
		 msg.send(company_phone, msg_str, "lms");
	}
	//DB객체 종료
	//stmt.close();
	pstmt.close();
	conn.close();
	%>
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
</body>
</html>